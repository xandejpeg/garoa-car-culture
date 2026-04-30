-- =============================================================
-- GAROA CAR CULTURE — EffectsConfig
-- Configuração central de efeitos visuais — M006.6
-- =============================================================

local EffectsConfig = {}

-- ============================================================
-- GERAL
-- ============================================================
EffectsConfig.Enabled = true
EffectsConfig.Debug   = false  -- true → imprime estado no Output

-- ============================================================
-- TIRE SMOKE
-- ============================================================
EffectsConfig.TireSmoke = {
    Enabled = true,

    -- Velocidade mínima (studs/s) para fumaça aparecer (~15 km/h)
    MinSpeed = 12,

    -- Taxa de emissão quando handbrake ativo + em movimento
    HandbrakeRate = 45,

    -- Taxa de emissão por slip lateral (deriva sem handbrake)
    SlipRate = 30,

    -- Taxa máxima (clamp)
    MaxRate = 60,

    -- Velocidade lateral mínima (studs/s) para acionar fumaça por deriva
    LateralSlipThreshold = 10,

    -- Partícula
    Lifetime        = NumberRange.new(0.8, 1.6),
    Speed           = NumberRange.new(2, 6),
    Size            = NumberSequence.new({
        NumberSequenceKeypoint.new(0,   0.4),
        NumberSequenceKeypoint.new(0.4, 1.2),
        NumberSequenceKeypoint.new(1,   2.5),
    }),
    Transparency    = NumberSequence.new({
        NumberSequenceKeypoint.new(0,   0.2),
        NumberSequenceKeypoint.new(0.5, 0.5),
        NumberSequenceKeypoint.new(1,   1.0),
    }),
    Color           = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   Color3.fromRGB(200, 200, 200)),
        ColorSequenceKeypoint.new(1,   Color3.fromRGB(160, 160, 160)),
    }),
    SpreadAngle     = Vector2.new(15, 15),
    RotSpeed        = NumberRange.new(-45, 45),
    LightEmission   = 0,

    -- Offset local dos attachments de fumaça (relativo à traseira do carro)
    -- (X = lateral, Y = altura, Z = frente/trás)
    AttachOffsetLeft  = Vector3.new(-1.2,  0.1, -3.0),
    AttachOffsetRight = Vector3.new( 1.2,  0.1, -3.0),
}

return EffectsConfig
