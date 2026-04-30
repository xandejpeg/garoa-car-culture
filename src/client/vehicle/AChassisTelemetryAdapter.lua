-- =============================================================
-- GAROA CAR CULTURE — AChassisTelemetryAdapter
-- Lê estado do carro via A-Chassis Interface + física do veículo
-- =============================================================
-- Fonte de dados:
--   PlayerGui["A-Chassis Interface"].Values.* → RPM, Gear, PBrake
--   carRoot.AssemblyLinearVelocity            → velocidade real
--   carRoot.CFrame                            → orientação para slip lateral
-- =============================================================

local Players = game:GetService("Players")
local player  = Players.LocalPlayer

local AChassisTelemetryAdapter = {}
AChassisTelemetryAdapter.__index = AChassisTelemetryAdapter

local INTERFACE_NAME = "A-Chassis Interface"

-- ============================================================
-- CONSTRUCTOR
-- ============================================================
function AChassisTelemetryAdapter.new(carRoot)
    local self = setmetatable({}, AChassisTelemetryAdapter)
    self._carRoot = carRoot
    self._values  = nil   -- lazy — encontrado na primeira leitura
    return self
end

-- ============================================================
-- INTERNOS
-- ============================================================
local function _findValues()
    local gui = player:FindFirstChild("PlayerGui")
    if not gui then return nil end
    local iface = gui:FindFirstChild(INTERFACE_NAME)
    if not iface then return nil end
    return iface:FindFirstChild("Values")
end

function AChassisTelemetryAdapter:_getValues()
    if not self._values then
        self._values = _findValues()
    end
    return self._values
end

local function _readValue(values, name, default)
    if not values then return default end
    local v = values:FindFirstChild(name)
    return (v and v.Value) or default
end

-- ============================================================
-- API PÚBLICA
-- ============================================================

--- Velocidade escalar do veículo em studs/s
function AChassisTelemetryAdapter:getSpeed()
    local root = self._carRoot
    if not root or not root:IsA("BasePart") then return 0 end
    return root.AssemblyLinearVelocity.Magnitude
end

--- RPM (real se disponível, estimado por velocidade se não)
function AChassisTelemetryAdapter:getRPM()
    local v = self:_getValues()
    local rpm = _readValue(v, "RPM", -1)
    if rpm > 0 then return rpm end
    -- Fallback: estimar por velocidade
    return math.clamp(self:getSpeed() * 40, 800, 8000)
end

--- Marcha atual (número, 0=N, -1=R)
function AChassisTelemetryAdapter:getGear()
    return _readValue(self:_getValues(), "Gear", 0)
end

--- Handbrake ativo
function AChassisTelemetryAdapter:isHandbrakeActive()
    return _readValue(self:_getValues(), "PBrake", false) == true
end

--- Velocidade lateral (slip) em studs/s — mede quanto o carro está derivando
--- Positivo = deriva para a direita, negativo = para a esquerda
function AChassisTelemetryAdapter:getLateralSpeed()
    local root = self._carRoot
    if not root or not root:IsA("BasePart") then return 0 end
    local vel   = root.AssemblyLinearVelocity
    local right = root.CFrame.RightVector
    -- Componente lateral da velocidade
    return math.abs(vel:Dot(right))
end

--- Retorna tabela com todos os dados de uma vez (para uso em loop)
function AChassisTelemetryAdapter:read()
    return {
        speed        = self:getSpeed(),
        rpm          = self:getRPM(),
        gear         = self:getGear(),
        handbrake    = self:isHandbrakeActive(),
        lateralSpeed = self:getLateralSpeed(),
    }
end

--- Limpar referências ao sair do carro
function AChassisTelemetryAdapter:destroy()
    self._carRoot = nil
    self._values  = nil
end

return AChassisTelemetryAdapter
