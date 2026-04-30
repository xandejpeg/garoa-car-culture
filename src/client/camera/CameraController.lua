-- =============================================================
-- GAROA CAR CULTURE — CameraController
-- Chase Camera — M003.7
-- =============================================================
-- Modos disponíveis:
--   "default" → câmera padrão Roblox (personagem a pé)
--   "chase"   → chase camera com suavização + FOV/distância dinâmicos
--
-- API:
--   CameraController.setMode("default")
--   CameraController.setMode("chase", carRootPart)
--   CameraController.getMode()
-- =============================================================

local Players   = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CameraConfig = require(ReplicatedStorage.Shared.config.CameraConfig)

-- ============================================================
-- MÓDULO
-- ============================================================

local CameraController = {}

local camera = workspace.CurrentCamera
local _mode       = "default"
local _connection = nil
local _carRoot    = nil  -- BasePart passada ao entrar no carro

-- ============================================================
-- MODO PADRÃO (on-foot)
-- ============================================================

local function setDefaultCamera()
    if _connection then
        _connection:Disconnect()
        _connection = nil
    end
    _carRoot = nil
    camera.CameraType    = Enum.CameraType.Custom
    camera.FieldOfView   = CameraConfig.BaseFOV
end

-- ============================================================
-- MODO CHASE
-- ============================================================

local function setChaseCamera(carRoot)
    _carRoot = carRoot

    if _connection then
        _connection:Disconnect()
        _connection = nil
    end

    camera.CameraType = Enum.CameraType.Scriptable

    _connection = RunService.RenderStepped:Connect(function()
        if not _carRoot or not _carRoot.Parent then
            setDefaultCamera()
            return
        end

        local cfg = CameraConfig
        local carCF  = _carRoot.CFrame
        local speed  = _carRoot.AssemblyLinearVelocity.Magnitude

        -- Distância e FOV dinâmicos por velocidade
        local dist = math.clamp(
            cfg.BaseDistance + speed * cfg.SpeedDistanceMultiplier,
            cfg.BaseDistance, cfg.MaxDistance
        )
        local fov = math.clamp(
            cfg.BaseFOV + speed * cfg.FOVSpeedMultiplier,
            cfg.BaseFOV, cfg.MaxFOV
        )

        -- Posição desejada: atrás e acima do carro (espaço local → mundo)
        local desiredPos = carCF.Position
            - carCF.LookVector * dist
            + Vector3.new(0, cfg.BaseHeight, 0)

        -- Suavização da posição
        local smoothPos = camera.CFrame.Position:Lerp(desiredPos, cfg.Smoothness)

        -- Look-at: frente do carro com look-ahead
        local lookAt = carCF.Position + carCF.LookVector * cfg.LookAheadDistance

        camera.CFrame      = CFrame.lookAt(smoothPos, lookAt)
        camera.FieldOfView = fov
    end)
end

-- ============================================================
-- FUNÇÕES PÚBLICAS
-- ============================================================

function CameraController.setMode(mode, carRoot)
    _mode = mode

    if mode == "chase" and carRoot then
        setChaseCamera(carRoot)
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
