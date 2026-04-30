-- =============================================================
-- GAROA CAR CULTURE — CameraConfig
-- Configuração da Chase Camera (M003.7)
-- =============================================================
-- Ajuste estes valores durante o Play Test para calibrar feeling.
-- Todos os campos são usados pelo CameraController no modo "chase".
-- =============================================================

return {
    -- Distância base do carro (studs atrás)
    BaseDistance = 22,

    -- Distância máxima em alta velocidade
    MaxDistance = 32,

    -- Altura base acima do carro
    BaseHeight = 8,

    -- Quanto a distância cresce por (studs/s) de velocidade
    -- Exemplo: velocidade 80 → distância extra = 80 * 0.04 = 3.2
    SpeedDistanceMultiplier = 0.04,

    -- FOV base (graus)
    BaseFOV = 70,

    -- FOV máximo em alta velocidade
    MaxFOV = 90,

    -- Quanto o FOV cresce por (studs/s) de velocidade
    FOVSpeedMultiplier = 0.12,

    -- Suavização da câmera (0 = instantâneo, 1 = nunca chega)
    -- Valores bons: 0.05 (rígida) → 0.15 (fluida) → 0.25 (muito suave)
    Smoothness = 0.10,

    -- Quanto a câmera "olha à frente" do carro (para antecipar curvas)
    LookAheadDistance = 4,

    -- Ativar/desativar chase camera (false = câmera padrão Roblox)
    Enabled = true,
}
