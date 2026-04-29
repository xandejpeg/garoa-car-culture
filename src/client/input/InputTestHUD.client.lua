-- =============================================================
-- GAROA CAR CULTURE — INPUT TEST HUD
-- Milestone 001: Validação de input via x360ce / XInput / G29
-- =============================================================
-- FERRAMENTA DE DIAGNÓSTICO — não é parte do jogo final.
-- Controlado por DebugConfig.ShowInputHUD.
-- =============================================================

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Respeitar flag de debug
local DebugConfig = require(ReplicatedStorage.Shared.config.DebugConfig)
if not DebugConfig.ShowInputHUD then
    -- HUD desabilitado — não fazer nada
    return
end

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ============================================================
-- CRIAÇÃO DA GUI
-- ============================================================

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "InputTestHUD"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- Painel principal
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 440, 0, 620)
mainFrame.Position = UDim2.new(0, 12, 0, 12)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainFrame

-- Barra de título
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 42)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = titleBar

-- Fix corners only rounding top
local titleFix = Instance.new("Frame")
titleFix.Size = UDim2.new(1, 0, 0.5, 0)
titleFix.Position = UDim2.new(0, 0, 0.5, 0)
titleFix.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
titleFix.BorderSizePixel = 0
titleFix.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, -10, 1, 0)
titleLabel.Position = UDim2.new(0, 8, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "GAROA CAR CULTURE — INPUT TEST [M001]"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- Área de conteúdo
local contentLabel = Instance.new("TextLabel")
contentLabel.Name = "Content"
contentLabel.Size = UDim2.new(1, -16, 1, -52)
contentLabel.Position = UDim2.new(0, 8, 0, 48)
contentLabel.BackgroundTransparency = 1
contentLabel.TextColor3 = Color3.fromRGB(210, 255, 210)
contentLabel.TextScaled = false
contentLabel.TextSize = 13
contentLabel.Font = Enum.Font.Code
contentLabel.TextXAlignment = Enum.TextXAlignment.Left
contentLabel.TextYAlignment = Enum.TextYAlignment.Top
contentLabel.TextWrapped = true
contentLabel.RichText = true
contentLabel.Parent = mainFrame

-- ============================================================
-- MAPEAMENTO DE BOTÕES XInput
-- G29 via x360ce envia como controle Xbox — esses são os nomes
-- que o Roblox UserInputService reconhece
-- ============================================================

local BUTTON_DISPLAY = {
    [Enum.KeyCode.ButtonA]      = "A (Btn1)",
    [Enum.KeyCode.ButtonB]      = "B (Btn2)",
    [Enum.KeyCode.ButtonX]      = "X (Btn3)",
    [Enum.KeyCode.ButtonY]      = "Y (Btn4)",
    [Enum.KeyCode.ButtonL1]     = "L1 / LB",
    [Enum.KeyCode.ButtonR1]     = "R1 / RB",
    [Enum.KeyCode.ButtonL3]     = "L3 (LS Click)",
    [Enum.KeyCode.ButtonR3]     = "R3 (RS Click)",
    [Enum.KeyCode.ButtonStart]  = "Start",
    [Enum.KeyCode.ButtonSelect] = "Select / Back",
    [Enum.KeyCode.DPadUp]       = "DPad Cima",
    [Enum.KeyCode.DPadDown]     = "DPad Baixo",
    [Enum.KeyCode.DPadLeft]     = "DPad Esquerda",
    [Enum.KeyCode.DPadRight]    = "DPad Direita",
}

-- ============================================================
-- ESTADO
-- ============================================================

local lastInputType = "Nenhum detectado ainda"
local pressedButtons = {}
local frameCount = 0

-- Rastrear último tipo de input
UserInputService.LastInputTypeChanged:Connect(function(inputType)
    lastInputType = tostring(inputType)
end)

-- Rastrear botões pressionados
UserInputService.InputBegan:Connect(function(input, _processed)
    if input.UserInputType == Enum.UserInputType.Gamepad1 then
        local name = BUTTON_DISPLAY[input.KeyCode]
        if name then
            pressedButtons[name] = true
        end
    end
end)

UserInputService.InputEnded:Connect(function(input, _processed)
    if input.UserInputType == Enum.UserInputType.Gamepad1 then
        local name = BUTTON_DISPLAY[input.KeyCode]
        if name then
            pressedButtons[name] = nil
        end
    end
end)

-- ============================================================
-- ATUALIZAÇÃO DO PAINEL (todo frame)
-- ============================================================

RunService.Heartbeat:Connect(function()
    frameCount = frameCount + 1

    local lines = {}
    local gamepads = UserInputService:GetConnectedGamepads()
    local gamepadCount = #gamepads

    -- STATUS DO DISPOSITIVO
    if gamepadCount > 0 then
        table.insert(lines, string.format(
            "<font color='#00ff88'>GAMEPAD CONECTADO — %d dispositivo(s)</font>",
            gamepadCount
        ))
    else
        table.insert(lines, "<font color='#ff4444'>NENHUM GAMEPAD DETECTADO</font>")
    end

    table.insert(lines, "Ultimo tipo de input: <font color='#ffcc00'>" .. lastInputType .. "</font>")
    table.insert(lines, string.format("Frame: %d", frameCount))
    table.insert(lines, "")

    if gamepadCount > 0 then
        local gamepadEnum = gamepads[1]
        local stateList = UserInputService:GetGamepadState(gamepadEnum)

        -- EIXOS PRINCIPAIS (direção, pedais)
        table.insert(lines, "<font color='#ffcc00'>══ EIXOS ANALÓGICOS ══</font>")

        local axisFound = {}
        for _, obj in ipairs(stateList) do
            local kc = obj.KeyCode
            local pos = obj.Position

            if kc == Enum.KeyCode.Thumbstick1 then
                -- Thumbstick1 = provável eixo do volante mapeado pelo x360ce
                table.insert(lines, string.format(
                    "Thumbstick1.X <font color='#ffffff'>[DIRECAO?]</font>: <font color='#88ffff'>%.4f</font>",
                    pos.X
                ))
                table.insert(lines, string.format(
                    "Thumbstick1.Y                  : <font color='#88ffff'>%.4f</font>",
                    pos.Y
                ))
                axisFound["TS1"] = true

            elseif kc == Enum.KeyCode.Thumbstick2 then
                table.insert(lines, string.format(
                    "Thumbstick2.X <font color='#ffffff'>[DIRECAO?]</font>: <font color='#88ffff'>%.4f</font>",
                    pos.X
                ))
                table.insert(lines, string.format(
                    "Thumbstick2.Y                  : <font color='#88ffff'>%.4f</font>",
                    pos.Y
                ))
                axisFound["TS2"] = true

            elseif kc == Enum.KeyCode.ButtonR2 then
                -- Gatilho direito = acelerador provável
                table.insert(lines, string.format(
                    "R2/RT <font color='#ffffff'>[ACELERADOR?]</font>       : <font color='#00ff88'>%.4f</font>",
                    pos.Z
                ))
                axisFound["R2"] = true

            elseif kc == Enum.KeyCode.ButtonL2 then
                -- Gatilho esquerdo = freio provável
                table.insert(lines, string.format(
                    "L2/LT <font color='#ffffff'>[FREIO?]</font>            : <font color='#ff8844'>%.4f</font>",
                    pos.Z
                ))
                axisFound["L2"] = true
            end
        end

        if not next(axisFound) then
            table.insert(lines, "<font color='#888888'>(mexa no volante/pedais para ver valores)</font>")
        end

        -- BOTÕES ATIVOS
        table.insert(lines, "")
        table.insert(lines, "<font color='#ffcc00'>══ BOTÕES PRESSIONADOS ══</font>")

        local btnList = {}
        for btn, _ in pairs(pressedButtons) do
            table.insert(btnList, btn)
        end

        if #btnList > 0 then
            table.insert(lines, "<font color='#ffff44'>" .. table.concat(btnList, "  ·  ") .. "</font>")
        else
            table.insert(lines, "<font color='#555555'>(nenhum)</font>")
        end

        -- DEBUG COMPLETO: todos os eixos com valor diferente de zero
        table.insert(lines, "")
        table.insert(lines, "<font color='#ffcc00'>══ DEBUG: TODOS EIXOS ATIVOS ══</font>")

        local anyActive = false
        for _, obj in ipairs(stateList) do
            local pos = obj.Position
            local hasValue = math.abs(pos.X) > 0.005
                or math.abs(pos.Y) > 0.005
                or math.abs(pos.Z) > 0.005

            if hasValue then
                anyActive = true
                table.insert(lines, string.format(
                    "<font color='#aaaaaa'>%s</font>: X=<font color='#ffffff'>%.3f</font> Y=<font color='#ffffff'>%.3f</font> Z=<font color='#ffffff'>%.3f</font>",
                    tostring(obj.KeyCode),
                    pos.X, pos.Y, pos.Z
                ))
            end
        end

        if not anyActive then
            table.insert(lines, "<font color='#555555'>(nenhum eixo ativo no momento)</font>")
        end

    else
        -- Sem gamepad: mostrar instruções
        table.insert(lines, "<font color='#ffcc00'>══ INSTRUÇÕES DE SETUP ══</font>")
        table.insert(lines, "1. Instale o x360ce (x64)")
        table.insert(lines, "2. Abra o x360ce e configure o G29")
        table.insert(lines, "   - Volante  → Thumbstick1 X (ou outro eixo)")
        table.insert(lines, "   - Acelerador → Axis R2/RT")
        table.insert(lines, "   - Freio    → Axis L2/LT")
        table.insert(lines, "3. Copie xinput1_3.dll para a pasta do Roblox")
        table.insert(lines, "   (geralmente: C:\\Program Files (x86)\\Roblox\\...)")
        table.insert(lines, "4. Reinicie o Roblox Studio / Player")
        table.insert(lines, "5. Os valores aparecem aqui em tempo real")
        table.insert(lines, "")
        table.insert(lines, "<font color='#888888'>Testando teclado? Não aparece aqui.</font>")
        table.insert(lines, "<font color='#888888'>Este HUD é apenas para gamepad/XInput.</font>")
    end

    contentLabel.Text = table.concat(lines, "\n")
end)
