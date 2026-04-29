--[[
	AChassisAdapter
	Adapter concreto para o sistema A-Chassis v1.7.x.

	Injeta input no A-Chassis via VirtualInput BindableEvent.

	ESTRUTURA DO A-CHASSIS (descoberta em Initialize.luau):
	Quando o jogador senta no DriveSeat, o servidor clona "A-Chassis Interface"
	para PlayerGui do jogador:

	  PlayerGui/
	    A-Chassis Interface/
	      Drive (LocalScript) ← VirtualInput (BindableEvent) está AQUI
	      Car (ObjectValue) → referência ao modelo do carro no Workspace
	      Values/ ← estado do carro (RPM, Gear, InputThrottle, etc.)
	      Controls/ ← mapeamento de teclas
	      Mobile/ ← UI mobile
	      IsOn (BoolValue)

	Para injetar input, precisamos:
	  1. Localizar PlayerGui.A-Chassis Interface (aguardar se necessário)
	  2. Obter Drive:FindFirstChild("VirtualInput") — BindableEvent
	  3. Disparar VirtualInput:Fire(inputObject) com InputObject sintético

	ESTRATÉGIA DE INJEÇÃO (baseada em Drive.luau):
	  - Steering:  simular eixo de gamepad — KeyCode.Thumbstick1, Position.X = valor (-1..1)
	  - Throttle:  simular trigger — KeyCode.ButtonR2, Position.Z = valor (0..1)
	  - Brake:     simular trigger — KeyCode.ButtonL2, Position.Z = valor (0..1)
	  - Handbrake: simular botão — KeyCode.ButtonX, Begin/End

	NOTA: O A-Chassis já gerencia WASD e gamepads físicos nativamente.
	      Este adapter é para controle programático e gamepads via nosso sistema.
	      Para M003 (teclado WASD), o A-Chassis funciona sem o adapter.
--]]

local Players = game:GetService("Players")
local VehicleControlAdapter = require(script.Parent.VehicleControlAdapter)

local AChassisAdapter = setmetatable({}, { __index = VehicleControlAdapter })
AChassisAdapter.__index = AChassisAdapter

-- Constantes de controle (correspondem aos defaults do A-Chassis Tune)
local GAMEPAD_TYPE = Enum.UserInputType.Gamepad1
local THUMBSTICK_STEER = Enum.KeyCode.Thumbstick1  -- ContlrSteer (Position.X)
local TRIGGER_THROTTLE = Enum.KeyCode.ButtonR2      -- ContlrThrottle (Position.Z)
local TRIGGER_BRAKE = Enum.KeyCode.ButtonL2         -- ContlrBrake (Position.Z)
local BUTTON_PBRAKE = Enum.KeyCode.ButtonX          -- ContlrPBrake

local INTERFACE_NAME = "A-Chassis Interface"

function AChassisAdapter.new()
	local self = setmetatable(VehicleControlAdapter.new(), AChassisAdapter)
	self._carModel = nil
	self._virtualInput = nil  -- BindableEvent em PlayerGui.A-Chassis Interface.Drive
	return self
end

--[[
	_makeInput(keyCode, userInputType, userInputState, position)
	Cria uma table compatível com InputObject para DealWithInput() do A-Chassis.
	O A-Chassis aceita qualquer table com .KeyCode, .UserInputType,
	.UserInputState e .Position.
--]]
local function _makeInput(keyCode: EnumItem, userInputType: EnumItem, userInputState: EnumItem, position: Vector3?)
	return {
		KeyCode = keyCode,
		UserInputType = userInputType or Enum.UserInputType.Keyboard,
		UserInputState = userInputState or Enum.UserInputState.Begin,
		Position = position or Vector3.new(0, 0, 0),
	}
end

--[[
	_findVirtualInput()
	Busca o VirtualInput BindableEvent em PlayerGui.
	O A-Chassis Interface é clonado para PlayerGui quando o jogador senta.
	Retorna o BindableEvent ou nil.
--]]
local function _findVirtualInput()
	local player = Players.LocalPlayer
	local playerGui = player:FindFirstChild("PlayerGui")
	if not playerGui then return nil end

	local interface = playerGui:FindFirstChild(INTERFACE_NAME)
	if not interface then return nil end

	local driveScript = interface:FindFirstChild("Drive")
	if not driveScript then return nil end

	return driveScript:FindFirstChild("VirtualInput")
end

function AChassisAdapter:enable(carModel: Model)
	assert(carModel, "AChassisAdapter:enable() — carModel é obrigatório")
	self._carModel = carModel

	-- O A-Chassis Interface pode não estar em PlayerGui ainda se o seat
	-- foi criado muito recentemente. Tentamos agora e toleramos nil.
	local virtualInput = _findVirtualInput()
	if virtualInput then
		self._virtualInput = virtualInput
		self._enabled = true
		return
	end

	-- Aguarda o A-Chassis Interface aparecer no PlayerGui (máx 5s)
	task.spawn(function()
		local deadline = tick() + 5
		while tick() < deadline do
			local vi = _findVirtualInput()
			if vi then
				self._virtualInput = vi
				self._enabled = true
				return
			end
			task.wait(0.1)
		end
		warn("[AChassisAdapter] VirtualInput não encontrado após 5s — A-Chassis v1.7+ requerido")
	end)
end

function AChassisAdapter:disable()
	-- Zera todos os inputs antes de desativar
	if self._virtualInput and self._enabled then
		self._virtualInput:Fire(_makeInput(TRIGGER_THROTTLE, GAMEPAD_TYPE, Enum.UserInputState.End, Vector3.new(0, 0, 0)))
		self._virtualInput:Fire(_makeInput(TRIGGER_BRAKE, GAMEPAD_TYPE, Enum.UserInputState.End, Vector3.new(0, 0, 0)))
		self._virtualInput:Fire(_makeInput(THUMBSTICK_STEER, GAMEPAD_TYPE, Enum.UserInputState.End, Vector3.new(0, 0, 0)))
	end

	self._carModel = nil
	self._virtualInput = nil
	VehicleControlAdapter.disable(self)
end

--[[
	setThrottle(value: number)
	Injeta throttle analógico via eixo de gamepad (Position.Z).
	A-Chassis usa: _IThrot = math.max(0, input.Position.Z) para ContlrThrottle
--]]
function AChassisAdapter:setThrottle(value: number)
	if not self._enabled or not self._virtualInput then return end
	value = math.clamp(value, 0, 1)
	self._virtualInput:Fire(_makeInput(
		TRIGGER_THROTTLE,
		GAMEPAD_TYPE,
		Enum.UserInputState.Change,
		Vector3.new(0, 0, value)
	))
end

--[[
	setBrake(value: number)
	Injeta brake analógico via eixo de gamepad (Position.Z).
	A-Chassis usa: _IBrake = input.Position.Z para ContlrBrake
--]]
function AChassisAdapter:setBrake(value: number)
	if not self._enabled or not self._virtualInput then return end
	value = math.clamp(value, 0, 1)
	self._virtualInput:Fire(_makeInput(
		TRIGGER_BRAKE,
		GAMEPAD_TYPE,
		Enum.UserInputState.Change,
		Vector3.new(0, 0, value)
	))
end

--[[
	setSteering(value: number)
	Injeta steering analógico via eixo de gamepad (Position.X).
	A-Chassis usa: _GSteerT = (input.Position.X - deadzone) / (1 - deadzone) para ContlrSteer
	Positivo = direita, negativo = esquerda.
--]]
function AChassisAdapter:setSteering(value: number)
	if not self._enabled or not self._virtualInput then return end
	value = math.clamp(value, -1, 1)
	self._virtualInput:Fire(_makeInput(
		THUMBSTICK_STEER,
		GAMEPAD_TYPE,
		Enum.UserInputState.Change,
		Vector3.new(value, 0, 0)
	))
end

--[[
	setHandbrake(active: boolean)
	Toggle do freio de mão. A-Chassis usa Begin = toggle, End = libera se em movimento.
--]]
function AChassisAdapter:setHandbrake(active: boolean)
	if not self._enabled or not self._virtualInput then return end
	self._virtualInput:Fire(_makeInput(
		BUTTON_PBRAKE,
		GAMEPAD_TYPE,
		active and Enum.UserInputState.Begin or Enum.UserInputState.End,
		Vector3.new(0, 0, 0)
	))
end

--[[
	shiftUp()
	Sobe uma marcha. Usa ContlrShiftUp (ButtonR1) via VirtualInput.
	A-Chassis só reage ao Begin — não precisa End.
--]]
function AChassisAdapter:shiftUp()
	if not self._enabled or not self._virtualInput then return end
	self._virtualInput:Fire(_makeInput(
		Enum.KeyCode.ButtonR1,
		GAMEPAD_TYPE,
		Enum.UserInputState.Begin,
		Vector3.new(0, 0, 0)
	))
end

--[[
	shiftDown()
	Desce uma marcha. Usa ContlrShiftDown (ButtonL1) via VirtualInput.
--]]
function AChassisAdapter:shiftDown()
	if not self._enabled or not self._virtualInput then return end
	self._virtualInput:Fire(_makeInput(
		Enum.KeyCode.ButtonL1,
		GAMEPAD_TYPE,
		Enum.UserInputState.Begin,
		Vector3.new(0, 0, 0)
	))
end

return AChassisAdapter
