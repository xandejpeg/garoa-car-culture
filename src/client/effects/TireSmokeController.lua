-- =============================================================
-- GAROA CAR CULTURE — TireSmokeController
-- Gerencia os ParticleEmitters de fumaça de pneu — M006.6
-- =============================================================
-- Cria dois attachments na traseira do carro (roda esquerda e
-- direita). Controla EmissionRate via telemetria.
-- =============================================================

local RS            = game:GetService("ReplicatedStorage")
local EffectsConfig = require(RS:WaitForChild("Shared"):WaitForChild("config"):WaitForChild("EffectsConfig"))

local TireSmokeController = {}
TireSmokeController.__index = TireSmokeController

local CFG = EffectsConfig.TireSmoke

-- ============================================================
-- HELPERS
-- ============================================================
local function _makeEmitter(attachment)
    local p = Instance.new("ParticleEmitter")
    p.Name          = "GCC_TireSmoke"
    p.Enabled       = false
    p.EmissionRate  = 0
    p.Lifetime      = CFG.Lifetime
    p.Speed         = CFG.Speed
    p.Size          = CFG.Size
    p.Transparency  = CFG.Transparency
    p.Color         = CFG.Color
    p.SpreadAngle   = CFG.SpreadAngle
    p.RotSpeed      = CFG.RotSpeed
    p.LightEmission = CFG.LightEmission
    p.LockedToPart  = false
    p.Parent        = attachment
    return p
end

local function _makeAttachment(parent, offset)
    local a = Instance.new("Attachment")
    a.Name           = "GCC_SmokeAttach"
    a.Position       = offset
    a.Parent         = parent
    return a
end

--- Encontra a BasePart principal do carro para ancorar os attachments.
--- Tenta PrimaryPart, depois DriveSeat, depois primeiro BasePart.
local function _findCarBase(carRoot)
    if carRoot:IsA("BasePart") then return carRoot end
    local model = carRoot:IsA("Model") and carRoot or carRoot.Parent
    if not model then return nil end
    if model.PrimaryPart then return model.PrimaryPart end
    local ds = model:FindFirstChildWhichIsA("VehicleSeat")
    if ds then return ds end
    return model:FindFirstChildWhichIsA("BasePart")
end

-- ============================================================
-- CONSTRUCTOR
-- ============================================================
function TireSmokeController.new(carRoot)
    local self      = setmetatable({}, TireSmokeController)
    self._carRoot   = carRoot
    self._attachL   = nil
    self._attachR   = nil
    self._emitterL  = nil
    self._emitterR  = nil
    self._active    = false

    local base = _findCarBase(carRoot)
    if not base then
        warn("[TireSmokeController] Não encontrou BasePart no carro — sem fumaça")
        return self
    end

    self._attachL  = _makeAttachment(base, CFG.AttachOffsetLeft)
    self._attachR  = _makeAttachment(base, CFG.AttachOffsetRight)
    self._emitterL = _makeEmitter(self._attachL)
    self._emitterR = _makeEmitter(self._attachR)
    self._active   = true

    return self
end

-- ============================================================
-- API PÚBLICA
-- ============================================================

--- Atualiza a emissão com base na telemetria.
--- @param telem table — saída de AChassisTelemetryAdapter:read()
function TireSmokeController:update(telem)
    if not self._active then return end

    local rate = 0

    if telem.speed >= CFG.MinSpeed then
        if telem.handbrake then
            rate = CFG.HandbrakeRate
        elseif telem.lateralSpeed >= CFG.LateralSlipThreshold then
            -- Escala a taxa pelo slip além do threshold
            local excess = telem.lateralSpeed - CFG.LateralSlipThreshold
            rate = math.clamp(CFG.SlipRate * (excess / 10), CFG.SlipRate * 0.3, CFG.SlipRate)
        end
    end

    rate = math.min(rate, CFG.MaxRate)

    local enabled = rate > 0
    self._emitterL.Enabled      = enabled
    self._emitterR.Enabled      = enabled
    self._emitterL.EmissionRate = rate
    self._emitterR.EmissionRate = rate
end

--- Para fumaça imediatamente.
function TireSmokeController:stop()
    if not self._active then return end
    self._emitterL.Enabled      = false
    self._emitterR.Enabled      = false
    self._emitterL.EmissionRate = 0
    self._emitterR.EmissionRate = 0
end

--- Remove attachments e emitters do workspace.
function TireSmokeController:destroy()
    self:stop()
    if self._attachL then self._attachL:Destroy() end
    if self._attachR then self._attachR:Destroy() end
    self._attachL  = nil
    self._attachR  = nil
    self._emitterL = nil
    self._emitterR = nil
    self._active   = false
end

return TireSmokeController
