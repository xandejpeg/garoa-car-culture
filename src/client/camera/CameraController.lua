-- =============================================================
-- GAROA CAR CULTURE — CameraController
-- Câmera básica para M002
-- =============================================================
-- Modos disponíveis:
--   "default" → câmera padrão Roblox (personagem a pé)
--   "follow"  → câmera segue o carro (terceira pessoa)
--
-- M002: só precisa que câmera siga o carro ao entrar.
-- Câmeras avançadas (cockpit, cinemática) → milestones futuras.
-- =============================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- ============================================================
-- MÓDULO
-- ============================================================

local CameraController = {}

local camera = workspace.CurrentCamera
local player = Players.LocalPlayer

local _mode = "default"
local _connection = nil

-- Configuração da câmera "follow"
local FOLLOW_DISTANCE = 20    -- distância atrás do carro
local FOLLOW_HEIGHT   = 8     -- altura acima do carro
local FOLLOW_SMOOTHING = 0.1  -- lerp factor (0 = imediato, 1 = muito suave)

-- ============================================================
-- MODOS
-- ============================================================

local function setDefaultCamera()
    camera.CameraType = Enum.CameraType.Custom
    -- Roblox restaura automaticamente o follow do personagem
    -- quando CameraType = Custom e há personagem vivo
    if _connection then
        _connection:Disconnect()
        _connection = nil
    end
end

local function setFollowCamera()
    camera.CameraType = Enum.CameraType.Scriptable

    if _connection then
        _connection:Disconnect()
        _connection = nil
    end

    _connection = RunService.RenderStepped:Connect(function()
        local car = workspace:FindFirstChild("CarPlaceholder")
        if not car then
            -- Se o carro sumiu, volta para câmera padrão
            setDefaultCamera()
            return
        end

        local body = car:FindFirstChild("Body")
        if not body then return end

        local carCFrame = body.CFrame

        -- Calcula posição desejada: atrás e acima do carro
        local targetPosition = carCFrame.Position
            - carCFrame.LookVector * FOLLOW_DISTANCE
            + Vector3.new(0, FOLLOW_HEIGHT, 0)

        -- Lerp suave da posição atual para a desejada
        local currentPosition = camera.CFrame.Position
        local smoothedPosition = currentPosition:Lerp(targetPosition, FOLLOW_SMOOTHING)

        -- Câmera olha para o carro
        camera.CFrame = CFrame.lookAt(smoothedPosition, carCFrame.Position + Vector3.new(0, 1, 0))
    end)
end

-- ============================================================
-- FUNÇÕES PÚBLICAS
-- ============================================================

function CameraController.setMode(mode)
    _mode = mode

    if mode == "follow" then
        setFollowCamera()
    else
        setDefaultCamera()
    end

    print("[CameraController] mode →", mode)
end

function CameraController.getMode()
    return _mode
end

-- Inicialização
setDefaultCamera()

return CameraController
