-- =============================================================
-- GAROA CAR CULTURE — VehicleInputController
-- Controle de input quando personagem está no carro
-- =============================================================
-- M003: Usa VehicleControlAdapter para injetar input no sistema
--       de física (A-Chassis ou outro backend).
--       Para M003 (teclado WASD), o A-Chassis já gerencia WASD
--       nativamente — o adapter é usado para entrada/saída e,
--       no futuro (M004), para input analógico de gamepad.
-- =============================================================

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local InputConfig = require(ReplicatedStorage.Shared.config.InputConfig)

-- ============================================================
-- MÓDULO
-- ============================================================

local VehicleInputController = {}

local _enabled = false
local _connections = {}
local _currentSeat = nil
local _adapter = nil  -- VehicleControlAdapter (AChassisAdapter ou outro)

-- Callback para quando o jogador pede para sair do carro
local _onExitVehicleRequest = nil

-- ============================================================
-- LEITURA DE EIXOS (para uso externo: câmera, HUD, etc.)
-- ============================================================

local function getSteerAxis()
    local left  = UserInputService:IsKeyDown(InputConfig.Keyboard.SteerLeft)  and -1 or 0
    local right = UserInputService:IsKeyDown(InputConfig.Keyboard.SteerRight) and  1 or 0
    return left + right
end

local function getThrottleAxis()
    return UserInputService:IsKeyDown(InputConfig.Keyboard.Throttle) and 1 or 0
end

local function getBrakeAxis()
    return UserInputService:IsKeyDown(InputConfig.Keyboard.Brake) and 1 or 0
end

-- ============================================================
-- LOOP DE INPUT (só necessário quando usando adapter programático)
-- ============================================================

-- Quando o adapter está presente, injeta input analógico a cada frame.
-- Para M003 com A-Chassis + teclado WASD, o A-Chassis já gerencia seu
-- próprio input via UserInputService — este loop não duplica porque
-- o A-Chassis usa suas próprias teclas configuradas no Tune.
-- O loop aqui é preparação para M004 (gamepad analógico via adapter).
local function inputLoop()
    if not _adapter or not _adapter:isEnabled() then return end

    -- TODO M004: ler eixos do gamepad (Thumbstick, Triggers) e injetar
    -- _adapter:setSteering(gamepadSteer)
    -- _adapter:setThrottle(gamepadThrottle)
    -- _adapter:setBrake(gamepadBrake)
end

-- ============================================================
-- FUNÇÕES PÚBLICAS
-- ============================================================

function VehicleInputController.setExitVehicleCallback(callback)
    _onExitVehicleRequest = callback
end

--[[
    enable(seat, adapter?)
    Ativa o contexto Vehicle.
    seat: VehicleSeat (o DriveSeat do carro A-Chassis)
    adapter: VehicleControlAdapter (opcional, para controle programático)
             Se nil, o A-Chassis gerencia input nativamente via WASD.
--]]
function VehicleInputController.enable(seat, adapter)
    if _enabled then return end
    _enabled = true
    _currentSeat = seat
    _adapter = adapter or nil

    -- Loop de input (para gamepad analógico em M004)
    _connections.heartbeat = RunService.Heartbeat:Connect(inputLoop)

    -- Detectar teclas de ação no carro
    _connections.inputBegan = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == InputConfig.Keyboard.ExitVehicle then
            if _onExitVehicleRequest then _onExitVehicleRequest() end
        elseif input.KeyCode == InputConfig.Keyboard.ShiftUp or input.KeyCode == InputConfig.Keyboard.ShiftUpAlt then
            if _adapter then _adapter:shiftUp() end
        elseif input.KeyCode == InputConfig.Keyboard.ShiftDown then
            if _adapter then _adapter:shiftDown() end
        end
    end)
    -- Space/Handbrake é tratado diretamente no InputContextController via ContextActionService

    print("[VehicleInputController] enabled — seat:", seat and seat:GetFullName() or "nil")
    if adapter then
        print("[VehicleInputController] adapter:", tostring(adapter))
    else
        print("[VehicleInputController] sem adapter — A-Chassis gerencia WASD nativamente")
    end
end

function VehicleInputController.disable()
    if not _enabled then return end
    _enabled = false

    -- Desativar adapter se presente
    if _adapter then
        _adapter:disable()
        _adapter = nil
    end

    _currentSeat = nil

    for _, conn in pairs(_connections) do
        conn:Disconnect()
    end
    _connections = {}

    print("[VehicleInputController] disabled")
end

function VehicleInputController.isEnabled()
    return _enabled
end

function VehicleInputController.getCurrentSeat()
    return _currentSeat
end

function VehicleInputController.getAdapter()
    return _adapter
end

-- Leitura de eixos para uso externo (CameraController, HUD, etc.)
function VehicleInputController.getSteer()
    return getSteerAxis()
end

function VehicleInputController.getThrottle()
    return getThrottleAxis()
end

function VehicleInputController.getBrake()
    return getBrakeAxis()
end

return VehicleInputController

