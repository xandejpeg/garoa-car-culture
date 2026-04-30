-- =============================================================
-- GAROA CAR CULTURE — AudioConfig
-- Configuração de áudio veicular — reservado para uso futuro
-- =============================================================
-- NOTA (M006.5 cancelado — 29/04/2026):
-- O áudio principal do carro vem do sistema interno do A-Chassis v1.7.2.
-- O A-Chassis já possui: ENG_Engine, TRA_Transmission, UR_Turbo,
-- SUP_Supercharger, BOV_BOV, Exhaust, Starter e sons de superfície.
-- Este arquivo está reservado para futura customização própria do Garoa:
-- - trocar SoundIds por sons próprios
-- - ajustar volume/pitch por carro
-- - turbo/BOV/backfire custom
-- - sons de colisão e escapamento personalizado
-- NÃO está conectado ao runtime atualmente.
-- =============================================================

local AudioConfig = {}

-- ============================================================
-- GERAL
-- ============================================================
AudioConfig.Enabled       = true
AudioConfig.MasterVolume  = 1.0   -- 0.0 a 1.0
AudioConfig.DebugAudio    = false -- true → imprime telemetria no Output

-- ============================================================
-- SOUND IDs
-- ============================================================
-- TEMP: sons livres do Roblox — substituir por uploads próprios
AudioConfig.EngineIdleSoundId = "rbxassetid://276855135"   -- TEMP: idle leve
AudioConfig.EngineLoopSoundId = "rbxassetid://276855135"   -- TEMP: loop de motor (mesmo idle escalado)
AudioConfig.TireSkidSoundId   = "rbxassetid://262491951"   -- TEMP: chiado de pneu

-- ============================================================
-- MOTOR — PITCH / VOLUME
-- ============================================================
-- RPM de referência
AudioConfig.MinRPM = 800    -- idle
AudioConfig.MaxRPM = 8000   -- redline

-- Pitch mínimo (idle) e máximo (redline)
AudioConfig.MinPitch = 0.6
AudioConfig.MaxPitch = 2.4

-- Volume do motor
AudioConfig.EngineMinVolume = 0.35   -- volume no idle
AudioConfig.EngineMaxVolume = 0.85   -- volume na potência máxima

-- Se RPM não estiver disponível, estimar via velocidade
-- (rpm_estimado = velocidade_studs_por_segundo * RPM_PER_STUD)
AudioConfig.RpmPerStud = 40   -- fator de estimativa (ajustar se pitch parecer errado)

-- ============================================================
-- SKID / DRIFT
-- ============================================================
-- Velocidade mínima (studs/s) para o skid aparecer
AudioConfig.SkidMinSpeed  = 15     -- ~20 km/h
AudioConfig.SkidVolume    = 0.75   -- volume máximo do skid
AudioConfig.SkidFadeSpeed = 6      -- quanto mais alto, mais rápido o fade (por segundo)

-- Velocidade lateral mínima (studs/s) para ativar skid por deriva
-- Se não disponível, usa apenas handbrake como gatilho
AudioConfig.SkidLateralThreshold = 8

-- ============================================================
-- TRANSIÇÕES
-- ============================================================
-- Velocidade de fade ao sair do carro (por segundo)
AudioConfig.StopFadeSpeed = 4

return AudioConfig
