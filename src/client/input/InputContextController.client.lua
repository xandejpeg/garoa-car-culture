-- =============================================================
-- GAROA CAR CULTURE — InputContextController
-- Orquestrador de contexto de input — M002
-- =============================================================
-- Gerencia a troca entre contextos:
--   OnFoot  → personagem a pé
--   Vehicle → dentro do carro
--
-- Fluxo M002:
--   Player spawna → OnFoot ativado
--   Player pressiona E perto do carro → switchToVehicle
--   Player pressiona E dentro do carro → switchToOnFoot
-- =============================================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContextActionService = game:GetService("ContextActionService")

local InputConfig           = require(ReplicatedStorage.Shared.config.InputConfig)
local OnFootInputController = require(script.Parent.OnFootInputController)
local VehicleInputController = require(script.Parent.VehicleInputController)
local AChassisAdapter       = require(script.Parent.Parent.vehicle.AChassisAdapter)

-- CameraController é opcional — carrega só se existir
local CameraController = nil
local ok, result = pcall(function()
    return require(script.Parent.Parent.camera.CameraController)
end)
if ok then
    CameraController = result
end

-- ============================================================
-- ESTADO
-- ============================================================

local currentContext = InputConfig.Context.OnFoot
local player = Players.LocalPlayer
local _activeAdapter = nil  -- adapter atual, acessível pelo callback do CAS

-- ============================================================
-- TROCA DE CONTEXTO
-- ============================================================

local function switchToVehicle(seat)
    if currentContext == InputConfig.Context.Vehicle then return end
    currentContext = InputConfig.Context.Vehicle

    OnFootInputController.disable()

    -- Cria e ativa o adapter
    local carModel = seat and seat.Parent
    local adapter = AChassisAdapter.new()
    if carModel then
        adapter:enable(carModel)
    end
    _activeAdapter = adapter

    -- Senta o player no VehicleSeat
    if seat then
        local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
        seat:Sit(humanoid)
    end

    -- Bind Space com prioridade ALTA: intercepta antes dos scripts de personagem e do VehicleSeat.
    -- Handbrake é ativado aqui diretamente. Input é sunk → nada mais recebe o Space.
    ContextActionService:BindActionAtPriority(
        "GCC_SpaceInVehicle",
        function(_, state, _)
            if state == Enum.UserInputState.Begin then
                if _activeAdapter then _activeAdapter:setHandbrake(true) end
            elseif state == Enum.UserInputState.End then
                if _activeAdapter then _activeAdapter:setHandbrake(false) end
            end
            return Enum.ContextActionResult.Sink
        end,
        false,
        Enum.ContextActionPriority.High.Value,
        Enum.KeyCode.Space
    )

    VehicleInputController.enable(seat, adapter)

    if CameraController then
        -- Passa o PrimaryPart/HumanoidRootPart do carro para a chase camera
        local carRoot = seat and seat.Parent and seat.Parent.PrimaryPart
        CameraController.setMode("chase", carRoot or seat)
    end

    print("[InputContextController] → Vehicle")
end

local function switchToOnFoot()
    if currentContext == InputConfig.Context.OnFoot then return end
    currentContext = InputConfig.Context.OnFoot

    -- Capturar referência do seat ANTES de disable() (que limpa _currentSeat)
    local seat = VehicleInputController.getCurrentSeat()

    VehicleInputController.disable()
    _activeAdapter = nil

    ContextActionService:UnbindAction("GCC_SpaceInVehicle")

    -- Levanta o player do seat
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)  -- restaura pulo
            humanoid.Sit = false
        end

        -- Offset seguro: posiciona o personagem ao lado do carro, ligeiramente acima
        -- Evita spawn embaixo do carro, dentro das rodas ou em queda livre
        if seat and seat.Parent then
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            if rootPart then
                task.wait() -- aguarda 1 frame para o unseat processar
                if rootPart.Parent then
                    rootPart.CFrame = seat.CFrame
                        + seat.CFrame.RightVector * 5
                        + Vector3.new(0, 2, 0)
                end
            end
        end
    end

    if CameraController then
        CameraController.setMode("default")
    end

    OnFootInputController.enable()

    print("[InputContextController] → OnFoot")
end

-- ============================================================
-- CALLBACKS
-- ============================================================

-- OnFootInputController chama isso quando detecta E perto do carro
OnFootInputController.setEnterVehicleCallback(function(seat)
    switchToVehicle(seat)
end)

-- VehicleInputController chama isso quando detecta E dentro do carro
VehicleInputController.setExitVehicleCallback(function()
    switchToOnFoot()
end)

-- ============================================================
-- INICIALIZAÇÃO
-- ============================================================

-- Aguardar personagem estar pronto antes de ativar
local function init()
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid", 10)
    if not humanoid then
        warn("[InputContextController] Humanoid não encontrado!")
        return
    end

    -- Detectar se o personagem foi parar num VehicleSeat por outro meio
    humanoid.Seated:Connect(function(isSeated, seat)
        if isSeated and seat then
            if currentContext ~= InputConfig.Context.Vehicle then
                switchToVehicle(seat)
            end
        else
            if currentContext ~= InputConfig.Context.OnFoot then
                switchToOnFoot()
            end
        end
    end)

    -- Começa no contexto OnFoot
    OnFootInputController.enable()
    print("[InputContextController] initialized — context: OnFoot")
end

-- Re-inicializar a cada respawn
player.CharacterAdded:Connect(function()
    -- Pequena espera para o personagem carregar
    task.wait(0.5)
    init()
end)

-- Inicializar agora se já tiver personagem
if player.Character then
    task.wait(0.5)
    init()
end

