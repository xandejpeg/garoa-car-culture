--[[
	VehicleControlAdapter
	Interface genérica de controle de veículo.

	Qualquer sistema de física de veículo (A-Chassis, VehicleSeat, NGChassis...)
	pode ser envolto em um adapter que implementa esta interface.

	Uso:
		local adapter = AChassisAdapter.new(carModel)
		adapter:enable()
		adapter:setThrottle(0.8)
		adapter:setSteering(-0.5)
		adapter:setBrake(0)
		adapter:setHandbrake(false)
		adapter:disable()
--]]

local VehicleControlAdapter = {}
VehicleControlAdapter.__index = VehicleControlAdapter

function VehicleControlAdapter.new()
	local self = setmetatable({}, VehicleControlAdapter)
	self._enabled = false
	return self
end

--[[
	enable(carModel: Model)
	Ativa o adapter para o modelo de carro especificado.
	Deve ser chamado quando o jogador entra no carro.
--]]
function VehicleControlAdapter:enable(carModel: Model)
	error("VehicleControlAdapter:enable() não implementado — use um adapter concreto")
end

--[[
	disable()
	Desativa o adapter. Chamado quando o jogador sai do carro.
--]]
function VehicleControlAdapter:disable()
	self._enabled = false
end

--[[
	setThrottle(value: number)
	value: 0.0 (sem gás) a 1.0 (gás máximo)
--]]
function VehicleControlAdapter:setThrottle(value: number)
	error("VehicleControlAdapter:setThrottle() não implementado")
end

--[[
	setBrake(value: number)
	value: 0.0 (sem freio) a 1.0 (freio máximo)
--]]
function VehicleControlAdapter:setBrake(value: number)
	error("VehicleControlAdapter:setBrake() não implementado")
end

--[[
	setSteering(value: number)
	value: -1.0 (máx esquerda) a 1.0 (máx direita)
--]]
function VehicleControlAdapter:setSteering(value: number)
	error("VehicleControlAdapter:setSteering() não implementado")
end

--[[
	setHandbrake(active: boolean)
	true = freio de mão ativado
--]]
function VehicleControlAdapter:setHandbrake(active: boolean)
	error("VehicleControlAdapter:setHandbrake() não implementado")
end

--[[
	shiftUp()
	Sobe uma marcha (transmissão manual/semi).
--]]
function VehicleControlAdapter:shiftUp()
	-- Opcional — implementações que não suportam shift podem ignorar
end

--[[
	shiftDown()
	Desce uma marcha (transmissão manual/semi).
--]]
function VehicleControlAdapter:shiftDown()
	-- Opcional
end

--[[
	isEnabled() → boolean
	Retorna se o adapter está ativo.
--]]
function VehicleControlAdapter:isEnabled(): boolean
	return self._enabled
end

return VehicleControlAdapter
