-- =============================================================
-- GAROA CAR CULTURE — SessionEconomyController
-- Estado de score/dinheiro da sessão atual — M008-lite
-- =============================================================
-- Client-side, sem DataStore. Reseta ao sair do Play.
-- TODO futuro: mover validação para servidor com DataStore.
-- =============================================================

local SessionEconomyController = {}

-- ============================================================
-- ESTADO INTERNO
-- ============================================================
local _score = 0
local _money = 0.0
local _combo = 1.0

-- ============================================================
-- API PÚBLICA
-- ============================================================

--- Adiciona pontos de drift e atualiza dinheiro de sessão.
--- @param pts    number — pontos a adicionar
--- @param combo  number — multiplicador de combo atual
--- @param mpp    number — R$ por ponto (de ScoreConfig)
function SessionEconomyController.addPoints(pts, combo, mpp)
    local gained = pts * combo
    _score = _score + gained
    _money = _money + gained * mpp
end

--- Atualiza o valor do combo (chamado por frame).
function SessionEconomyController.setCombo(combo)
    _combo = combo
end

--- Retorna uma cópia do estado atual.
function SessionEconomyController.getState()
    return {
        score = _score,
        money = _money,
        combo = _combo,
    }
end

--- Reseta combo ao sair do carro ou parar.
function SessionEconomyController.resetCombo()
    _combo = 1.0
end

--- Reseta sessão inteira (ex: ao morrer / respawn).
function SessionEconomyController.resetSession()
    _score = 0
    _money = 0.0
    _combo = 1.0
end

return SessionEconomyController
