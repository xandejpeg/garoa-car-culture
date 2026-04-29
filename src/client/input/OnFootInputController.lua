-- =============================================================
-- GAROA CAR CULTURE — OnFootInputController
-- Controle de input quando personagem está a pé
-- =============================================================
-- Gerencia: WASD (via Character nativo Roblox), Espaço (pulo),
--           E (interagir / entrar no carro)
--
-- M002: detecção de proximidade ao CarPlaceholder + entrada via E.
-- =============================================================

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local InputConfig = require(ReplicatedStorage.Shared.config.InputConfig)

-- ============================================================
-- MÓDULO
-- ============================================================

local OnFootInputController = {}

local _enabled = false
local _connections = {}

-- Callback para quando o jogador pede para entrar no carro
-- Definido pelo InputContextController
local _onEnterVehicleRequest = nil

-- Distância máxima para entrar no carro
local ENTER_DISTANCE = 8

-- ============================================================
-- FUNÇÕES INTERNAS
-- ============================================================

-- Procura o carro placeholder mais próximo dentro da distância
local function findNearbyVehicle()
    local player = Players.LocalPlayer
    local character = player.Character
    if not character then return nil end

    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return nil end

    local car = workspace:FindFirstChild("CarPlaceholder")
    if not car then return nil end

    local seat = car:FindFirstChild("VehicleSeat")
    if not seat then return nil end

    -- Já tem alguém sentado?
    if seat.Occupant then return nil end

    local distance = (rootPart.Position - seat.Position).Magnitude
    if distance <= ENTER_DISTANCE then
        return seat
    end

    return nil
end

-- Atualiza o prompt visual de interação
local function updatePromptVisibility()
    local car = workspace:FindFirstChild("CarPlaceholder")
    if not car then return end

    local seat = car:FindFirstChild("VehicleSeat")
    if not seat then return end

    local prompt = seat:FindFirstChild("InteractPrompt")
    if not prompt then return end

    local nearby = findNearbyVehicle()
    prompt.Enabled = nearby ~= nil and _enabled
end

-- ============================================================
-- FUNÇÕES PÚBLICAS
-- ============================================================

function OnFootInputController.setEnterVehicleCallback(callback)
    _onEnterVehicleRequest = callback
end

function OnFootInputController.enable()
    if _enabled then return end
    _enabled = true

    -- Detectar E para entrar no carro
    _connections.interact = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode ~= InputConfig.Keyboard.Interact then return end

        local seat = findNearbyVehicle()
        if seat and _onEnterVehicleRequest then
            _onEnterVehicleRequest(seat)
        end
    end)

    -- Atualizar prompt de proximidade a cada frame
    _connections.heartbeat = RunService.Heartbeat:Connect(function()
        updatePromptVisibility()
    end)

    print("[OnFootInputController] enabled")
end

function OnFootInputController.disable()
    if not _enabled then return end
    _enabled = false

    -- Esconder prompt ao desativar
    local car = workspace:FindFirstChild("CarPlaceholder")
    if car then
        local seat = car:FindFirstChild("VehicleSeat")
        if seat then
            local prompt = seat:FindFirstChild("InteractPrompt")
            if prompt then
                prompt.Enabled = false
            end
        end
    end

    for _, conn in pairs(_connections) do
        conn:Disconnect()
    end
    _connections = {}

    print("[OnFootInputController] disabled")
end

function OnFootInputController.isEnabled()
    return _enabled
end

return OnFootInputController

