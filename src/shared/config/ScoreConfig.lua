-- =============================================================
-- GAROA CAR CULTURE — ScoreConfig
-- Configuração do sistema de score/dinheiro de drift — M008-lite
-- =============================================================

local ScoreConfig = {}

-- ============================================================
-- GERAL
-- ============================================================
ScoreConfig.Enabled = true
ScoreConfig.Debug   = false   -- true → imprime estado no Output por frame

-- ============================================================
-- VELOCIDADE
-- ============================================================
-- Abaixo disso: sem pontuação (~20 km/h)
ScoreConfig.MinSpeedKmh        = 20

-- Abaixo disso: combo reseta (~10 km/h)
ScoreConfig.ComboResetSpeedKmh = 10

-- ============================================================
-- PONTOS
-- ============================================================
-- Pontos base por segundo enquanto em drift
ScoreConfig.BaseDriftPointsPerSecond = 10

-- Multiplicador quando handbrake ativo
ScoreConfig.HandbrakeBonus = 1.25

-- Multiplicador quando slip lateral detectado (além do handbrake)
ScoreConfig.SlipBonusMultiplier = 1.5

-- Velocidade lateral mínima (studs/s) para considerar deriva ativa
-- ~8 studs/s ≈ ~8 km/h de movimento lateral
ScoreConfig.LateralSlipThreshold = 8

-- ============================================================
-- COMBO
-- ============================================================
-- Crescimento do multiplicador por segundo em drift
ScoreConfig.ComboGrowthRate = 0.35

-- Decaimento por segundo quando não está em drift (mas ainda acima do reset)
ScoreConfig.ComboDecayRate  = 1.5

-- Combo máximo (ex: x5.0)
ScoreConfig.MaxCombo = 5.0

-- ============================================================
-- ECONOMIA DE SESSÃO
-- ============================================================
-- R$ por ponto de score
ScoreConfig.MoneyPerPoint = 0.05

return ScoreConfig
