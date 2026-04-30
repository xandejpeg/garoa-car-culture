-- =============================================================
-- GAROA CAR CULTURE — DriftTuneService
-- M006-lite: ajusta parâmetros do A-Chassis Tune para drift
-- =============================================================
-- Aplica tune de drift após o carro spawnar no workspace.
-- Modifica apenas valores que afetam diretamente o feeling de
-- derrapagem, handbrake e oversteer. Seguro de ajustar em runtime.
--
-- Parâmetros ajustados:
--   FrontGrip / RearGrip  — grip das rodas (menos = mais drift)
--   PBrakeForce           — força do handbrake
--   Steer                 — ângulo máximo de esterço
--   FrontBias / RearBias  — distribuição de torque (RWD feel)
-- =============================================================

local RunService = game:GetService("RunService")

-- ============================================================
-- CONFIGURAÇÃO DE DRIFT
-- ============================================================
-- Valores originais A-Chassis 1.7.2 (padrão):
--   FrontGrip  ≈ 1.0  |  RearGrip  ≈ 1.0
--   PBrakeForce ≈ 1.0  |  Steer ≈ 35
--
-- Drift tune:
--   Reduz grip traseiro → oversteer natural
--   Aumenta PBrakeForce → handbrake mais agressivo
--   Aumenta ângulo de esterço → mais rotação
-- ============================================================

local DRIFT_TUNE = {
    -- Grip (0 = sem grip, 1 = grip total)
    -- Reduz traseiro para oversteer, mantém dianteiro para dirigibilidade
    FrontGrip  = 0.85,   -- era ~1.0 → menos understeer
    RearGrip   = 0.45,   -- era ~1.0 → oversteer fácil (drift)

    -- Handbrake mais agressivo
    PBrakeForce = 3.0,   -- era ~1.0 → trava traseiro com força

    -- Ângulo de esterço maior (mais rotação na curva)
    Steer       = 45,    -- era ~35

    -- Distribuição de torque (bias traseiro para RWD feel)
    -- 0 = só dianteiro, 1 = só traseiro
    FrontBias   = 0.0,   -- sem tração dianteira
    RearBias    = 1.0,   -- tração total no traseiro
}

-- ============================================================
-- FUNÇÃO DE APLICAÇÃO
-- ============================================================

local function applyDriftTune(car)
    local tune = car:FindFirstChild("A-Chassis Tune")
    if not tune then
        warn("[DriftTune] A-Chassis Tune não encontrado em:", car.Name)
        return false
    end

    local applied = {}

    for param, value in pairs(DRIFT_TUNE) do
        local val = tune:FindFirstChild(param)
        if val then
            local old = val.Value
            val.Value = value
            table.insert(applied, param .. ": " .. tostring(old) .. " → " .. tostring(value))
        end
    end

    if #applied > 0 then
        print("[DriftTune] ✓ Tune aplicado em:", car.Name)
        for _, line in ipairs(applied) do
            print("  " .. line)
        end
    else
        warn("[DriftTune] Nenhum parâmetro encontrado — verifique estrutura do Tune")
        warn("[DriftTune] Parâmetros disponíveis:")
        for _, child in ipairs(tune:GetChildren()) do
            warn("  " .. child.Name .. " = " .. tostring(child.Value))
        end
    end

    return #applied > 0
end

-- ============================================================
-- OBSERVAR WORKSPACE PARA NOVOS CARROS
-- ============================================================

local function tryApplyToExisting()
    for _, obj in ipairs(workspace:GetChildren()) do
        if obj:IsA("Model") and obj:FindFirstChild("A-Chassis Tune") then
            applyDriftTune(obj)
        end
    end
end

-- Aplica em carros já presentes
tryApplyToExisting()

-- Aplica em carros que aparecerem depois
workspace.ChildAdded:Connect(function(child)
    if child:IsA("Model") and child:FindFirstChild("A-Chassis Tune") then
        task.wait(0.1) -- aguarda o modelo estar totalmente carregado
        applyDriftTune(child)
    end
end)

print("[DriftTune] M006-lite ativo — aguardando carros com A-Chassis Tune")
