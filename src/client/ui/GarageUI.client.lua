-- =============================================================
-- GAROA CAR CULTURE — GarageUI
-- M007-lite: interface de garagem — abre com G, spawna carro
-- =============================================================
-- Tecla G (fora do veículo) → abre/fecha painel de garagem
-- Painel mostra catálogo de carros do GarageConfig
-- "SPAWNAR" → clona carro na pista e fecha painel
-- "GUARDAR CARRO" → despawna carro atual e fecha painel
-- =============================================================

local Players           = game:GetService("Players")
local UserInputService  = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player    = Players.LocalPlayer
local PlayerGui = player.PlayerGui

-- Aguarda GarageRemotes (criados pelo GarageService no servidor)
local remotesFolder = ReplicatedStorage:WaitForChild("GarageRemotes", 15)
if not remotesFolder then
	warn("[GarageUI] GarageRemotes não encontrado — abortando")
	return
end
local evSpawn   = remotesFolder:WaitForChild("SpawnCar",   10)
local evDespawn = remotesFolder:WaitForChild("DespawnCar", 10)

local GarageConfig = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("config"):WaitForChild("GarageConfig"))

-- ============================================================
-- HELPERS DE ESTADO
-- ============================================================

local function isInVehicle()
	local char = player.Character
	if not char then return false end
	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hum then return false end
	return hum.SeatPart ~= nil
end

-- ============================================================
-- CONSTRUÇÃO DA UI
-- ============================================================

local gui = Instance.new("ScreenGui")
gui.Name             = "GarageHUD"
gui.ResetOnSpawn     = false
gui.DisplayOrder     = 200
gui.Enabled          = false
gui.Parent           = PlayerGui

-- Fundo principal
local bg = Instance.new("Frame")
bg.Name             = "Background"
bg.Size             = UDim2.new(0, 420, 0, 300)
bg.Position         = UDim2.new(0.5, -210, 0.5, -150)
bg.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
bg.BorderSizePixel  = 0
bg.Parent           = gui
Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 10)
local bgStroke = Instance.new("UIStroke", bg)
bgStroke.Color     = Color3.fromRGB(255, 200, 0)
bgStroke.Thickness = 2

-- Título
local title = Instance.new("TextLabel")
title.Size               = UDim2.new(1, -60, 0, 40)
title.Position           = UDim2.new(0, 16, 0, 10)
title.BackgroundTransparency = 1
title.Text               = "⚙  GARAGEM"
title.TextColor3         = Color3.fromRGB(255, 200, 0)
title.TextScaled         = true
title.Font               = Enum.Font.GothamBold
title.TextXAlignment     = Enum.TextXAlignment.Left
title.Parent             = bg

-- Botão fechar
local closeBtn = Instance.new("TextButton")
closeBtn.Size             = UDim2.new(0, 34, 0, 34)
closeBtn.Position         = UDim2.new(1, -44, 0, 8)
closeBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 60)
closeBtn.Text             = "✕"
closeBtn.TextColor3       = Color3.fromRGB(200, 200, 200)
closeBtn.TextScaled       = true
closeBtn.Font             = Enum.Font.GothamBold
closeBtn.Parent           = bg
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

-- Linha separadora
local sep = Instance.new("Frame")
sep.Size             = UDim2.new(1, -32, 0, 1)
sep.Position         = UDim2.new(0, 16, 0, 54)
sep.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
sep.BorderSizePixel  = 0
sep.Parent           = bg

-- Scroll com lista de carros
local listFrame = Instance.new("ScrollingFrame")
listFrame.Size                = UDim2.new(1, -20, 1, -140)
listFrame.Position            = UDim2.new(0, 10, 0, 62)
listFrame.BackgroundTransparency = 1
listFrame.ScrollBarThickness  = 4
listFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 200, 0)
listFrame.CanvasSize          = UDim2.new(0, 0, 0, 0)
listFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
listFrame.Parent              = bg

local listLayout = Instance.new("UIListLayout")
listLayout.Padding   = UDim.new(0, 8)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent    = listFrame

-- ============================================================
-- CARDS DE CARRO
-- ============================================================

local function buildCarCard(carDef, index)
	local card = Instance.new("Frame")
	card.Name             = "Card_" .. carDef.Id
	card.Size             = UDim2.new(1, -8, 0, 80)
	card.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
	card.BorderSizePixel  = 0
	card.LayoutOrder      = index
	card.Parent           = listFrame
	Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)

	-- Linha de cor esquerda
	local accent = Instance.new("Frame")
	accent.Size             = UDim2.new(0, 4, 1, -16)
	accent.Position         = UDim2.new(0, 0, 0, 8)
	accent.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
	accent.BorderSizePixel  = 0
	accent.Parent           = card
	Instance.new("UICorner", accent).CornerRadius = UDim.new(0, 2)

	-- Nome do carro
	local nameLbl = Instance.new("TextLabel")
	nameLbl.Size               = UDim2.new(1, -120, 0, 28)
	nameLbl.Position           = UDim2.new(0, 16, 0, 12)
	nameLbl.BackgroundTransparency = 1
	nameLbl.Text               = carDef.Name
	nameLbl.TextColor3         = Color3.fromRGB(240, 240, 240)
	nameLbl.TextScaled         = true
	nameLbl.Font               = Enum.Font.GothamBold
	nameLbl.TextXAlignment     = Enum.TextXAlignment.Left
	nameLbl.Parent             = card

	-- Descrição
	local descLbl = Instance.new("TextLabel")
	descLbl.Size               = UDim2.new(1, -120, 0, 22)
	descLbl.Position           = UDim2.new(0, 16, 0, 44)
	descLbl.BackgroundTransparency = 1
	descLbl.Text               = carDef.Desc
	descLbl.TextColor3         = Color3.fromRGB(140, 140, 155)
	descLbl.TextScaled         = true
	descLbl.Font               = Enum.Font.Gotham
	descLbl.TextXAlignment     = Enum.TextXAlignment.Left
	descLbl.Parent             = card

	-- Botão SPAWNAR
	local spawnBtn = Instance.new("TextButton")
	spawnBtn.Size             = UDim2.new(0, 100, 0, 38)
	spawnBtn.Position         = UDim2.new(1, -108, 0.5, -19)
	spawnBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
	spawnBtn.Text             = "SPAWNAR"
	spawnBtn.TextColor3       = Color3.fromRGB(10, 10, 10)
	spawnBtn.TextScaled       = true
	spawnBtn.Font             = Enum.Font.GothamBold
	spawnBtn.Parent           = card
	Instance.new("UICorner", spawnBtn).CornerRadius = UDim.new(0, 6)

	spawnBtn.MouseButton1Click:Connect(function()
		evSpawn:FireServer(carDef.Id)
		gui.Enabled = false
		print("[GarageUI] spawnou", carDef.Id)
	end)
end

for i, carDef in ipairs(GarageConfig.Cars) do
	if carDef.Unlocked then
		buildCarCard(carDef, i)
	end
end

-- ============================================================
-- BOTÃO GUARDAR CARRO (despawn)
-- ============================================================

local despawnBtn = Instance.new("TextButton")
despawnBtn.Size             = UDim2.new(1, -20, 0, 36)
despawnBtn.Position         = UDim2.new(0, 10, 1, -46)
despawnBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
despawnBtn.Text             = "GUARDAR CARRO"
despawnBtn.TextColor3       = Color3.fromRGB(170, 170, 180)
despawnBtn.TextScaled       = true
despawnBtn.Font             = Enum.Font.GothamBold
despawnBtn.Parent           = bg
Instance.new("UICorner", despawnBtn).CornerRadius = UDim.new(0, 6)
local despawnStroke = Instance.new("UIStroke", despawnBtn)
despawnStroke.Color = Color3.fromRGB(70, 70, 80)

despawnBtn.MouseButton1Click:Connect(function()
	evDespawn:FireServer()
	gui.Enabled = false
	print("[GarageUI] carro guardado")
end)

-- ============================================================
-- HINT NA TELA (quando garagem fechada)
-- ============================================================

local hint = Instance.new("ScreenGui")
hint.Name         = "GarageHint"
hint.ResetOnSpawn = false
hint.DisplayOrder = 10
hint.Parent       = PlayerGui

local hintLbl = Instance.new("TextLabel")
hintLbl.Size               = UDim2.new(0, 200, 0, 28)
hintLbl.Position           = UDim2.new(0.5, -100, 1, -42)
hintLbl.BackgroundColor3   = Color3.fromRGB(18, 18, 20)
hintLbl.BackgroundTransparency = 0.4
hintLbl.Text               = "[G] Garagem"
hintLbl.TextColor3         = Color3.fromRGB(180, 180, 180)
hintLbl.TextScaled         = true
hintLbl.Font               = Enum.Font.Gotham
hintLbl.Parent             = hint
Instance.new("UICorner", hintLbl).CornerRadius = UDim.new(0, 4)

-- Esconde hint quando está no carro
game:GetService("RunService").Heartbeat:Connect(function()
	hintLbl.Visible = not isInVehicle()
end)

-- ============================================================
-- TOGGLE COM TECLA G
-- ============================================================

closeBtn.MouseButton1Click:Connect(function()
	gui.Enabled = false
end)

UserInputService.InputBegan:Connect(function(input, processed)
	if processed then return end
	if input.KeyCode ~= Enum.KeyCode.G then return end
	if isInVehicle() then return end
	gui.Enabled = not gui.Enabled
end)

print("[GarageUI] M007-lite carregado — [G] abre garagem")
