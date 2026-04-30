-- =============================================================
-- GAROA CAR CULTURE — VehicleHUD
-- Display estilo Fuel Tech FT700 — M003.8
-- =============================================================
-- Layout:
--   [barra de RPM segmentada no topo]
--   [GEAR]   [VELOCIDADE km/h]
--   [labels]         [HB]
-- =============================================================

local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local VehicleHUD = {}

local player    = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local _visible    = false
local _carRoot    = nil
local _connection = nil
local _valuesFolder = nil

-- ============================================================
-- CORES (FT700 aesthetic)
-- ============================================================
local C_BG       = Color3.fromRGB(10,  10,  12)   -- preto quase total
local C_AMBER    = Color3.fromRGB(255, 140,  0)   -- laranja âmbar — velocidade
local C_GEAR     = Color3.fromRGB(220, 220, 220)  -- branco frio — marcha
local C_LABEL    = Color3.fromRGB(90,  90,  90)   -- cinza dim
local C_HB       = Color3.fromRGB(255,  40,  40)  -- vermelho — handbrake
local C_SEG_OFF  = Color3.fromRGB(25,  25,  28)   -- segmento apagado
local C_SEG_G    = Color3.fromRGB(0,   200,  80)  -- verde (baixo RPM)
local C_SEG_Y    = Color3.fromRGB(220, 200,   0)  -- amarelo (médio)
local C_SEG_R    = Color3.fromRGB(255,  30,  30)  -- vermelho (alto)

local NUM_SEGS   = 20   -- segmentos na barra

-- ============================================================
-- CONSTRUÇÃO DA UI
-- ============================================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name          = "VehicleHUD"
screenGui.ResetOnSpawn  = false
screenGui.DisplayOrder  = 10
screenGui.Enabled       = false
screenGui.Parent        = playerGui

-- Painel principal
local panel = Instance.new("Frame")
panel.Name                   = "Panel"
panel.Size                   = UDim2.new(0, 300, 0, 110)
panel.Position               = UDim2.new(1, -316, 1, -126)
panel.BackgroundColor3       = C_BG
panel.BackgroundTransparency = 0.08
panel.BorderSizePixel        = 0
panel.Parent                 = screenGui
Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 8)

-- Borda sutil
local stroke = Instance.new("UIStroke", panel)
stroke.Color       = Color3.fromRGB(50, 50, 55)
stroke.Thickness   = 1
stroke.Transparency = 0.5

-- ============================================================
-- BARRA DE RPM (segmentos)
-- ============================================================
local barContainer = Instance.new("Frame")
barContainer.Name                  = "RPMBar"
barContainer.Size                  = UDim2.new(1, -16, 0, 10)
barContainer.Position              = UDim2.new(0, 8, 0, 7)
barContainer.BackgroundTransparency = 1
barContainer.Parent                = panel

local segments = {}
local segW = (300 - 16 - (NUM_SEGS - 1) * 2) / NUM_SEGS
for i = 1, NUM_SEGS do
    local seg = Instance.new("Frame")
    seg.Size             = UDim2.new(0, segW, 1, 0)
    seg.Position         = UDim2.new(0, (i-1) * (segW + 2), 0, 0)
    seg.BackgroundColor3 = C_SEG_OFF
    seg.BorderSizePixel  = 0
    seg.Parent           = barContainer
    Instance.new("UICorner", seg).CornerRadius = UDim.new(0, 2)
    segments[i] = seg
end

-- ============================================================
-- SEPARADOR
-- ============================================================
local sep = Instance.new("Frame")
sep.Size             = UDim2.new(1, -16, 0, 1)
sep.Position         = UDim2.new(0, 8, 0, 21)
sep.BackgroundColor3 = Color3.fromRGB(40, 40, 44)
sep.BorderSizePixel  = 0
sep.Parent           = panel

-- ============================================================
-- MARCHA (esquerda, grande)
-- ============================================================
local gearNum = Instance.new("TextLabel")
gearNum.Name               = "GearNum"
gearNum.Size               = UDim2.new(0, 68, 0, 62)
gearNum.Position           = UDim2.new(0, 8, 0, 25)
gearNum.BackgroundTransparency = 1
gearNum.Text               = "N"
gearNum.Font               = Enum.Font.GothamBold
gearNum.TextColor3         = C_GEAR
gearNum.TextScaled         = true
gearNum.Parent             = panel

local gearLbl = Instance.new("TextLabel")
gearLbl.Size               = UDim2.new(0, 68, 0, 16)
gearLbl.Position           = UDim2.new(0, 8, 0, 87)
gearLbl.BackgroundTransparency = 1
gearLbl.Text               = "GEAR"
gearLbl.Font               = Enum.Font.GothamBold
gearLbl.TextColor3         = C_LABEL
gearLbl.TextScaled         = true
gearLbl.Parent             = panel

-- Divisor vertical
local vdiv = Instance.new("Frame")
vdiv.Size             = UDim2.new(0, 1, 0, 72)
vdiv.Position         = UDim2.new(0, 82, 0, 25)
vdiv.BackgroundColor3 = Color3.fromRGB(40, 40, 44)
vdiv.BorderSizePixel  = 0
vdiv.Parent           = panel

-- ============================================================
-- VELOCIDADE (direita, destaque)
-- ============================================================
local speedNum = Instance.new("TextLabel")
speedNum.Name              = "SpeedNum"
speedNum.Size              = UDim2.new(0, 196, 0, 62)
speedNum.Position          = UDim2.new(0, 90, 0, 25)
speedNum.BackgroundTransparency = 1
speedNum.Text              = "0"
speedNum.Font              = Enum.Font.GothamBold
speedNum.TextColor3        = C_AMBER
speedNum.TextScaled        = true
speedNum.TextXAlignment    = Enum.TextXAlignment.Right
speedNum.Parent            = panel

local speedLbl = Instance.new("TextLabel")
speedLbl.Size              = UDim2.new(0, 100, 0, 16)
speedLbl.Position          = UDim2.new(0, 90, 0, 87)
speedLbl.BackgroundTransparency = 1
speedLbl.Text              = "km/h"
speedLbl.Font              = Enum.Font.GothamBold
speedLbl.TextColor3        = C_LABEL
speedLbl.TextScaled        = true
speedLbl.Parent            = panel

-- Handbrake (canto inferior direito)
local hbLabel = Instance.new("TextLabel")
hbLabel.Name               = "HBLabel"
hbLabel.Size               = UDim2.new(0, 72, 0, 16)
hbLabel.Position           = UDim2.new(0, 216, 0, 87)
hbLabel.BackgroundTransparency = 1
hbLabel.Text               = ""
hbLabel.Font               = Enum.Font.GothamBold
hbLabel.TextColor3         = C_HB
hbLabel.TextScaled         = true
hbLabel.TextXAlignment     = Enum.TextXAlignment.Right
hbLabel.Parent             = panel

-- ============================================================
-- LEITURA DE VALORES A-CHASSIS
-- ============================================================
local function findAChassisValues()
    local interface = playerGui:FindFirstChild("A-Chassis Interface")
    if not interface then return nil end
    return interface:FindFirstChild("Values")
end

local function getGearText(values)
    if not values then return "?" end
    local gv = values:FindFirstChild("Gear")
    if not gv then return "?" end
    local g = gv.Value
    if     g ==  0 then return "N"
    elseif g == -1 then return "R"
    else                 return tostring(g) end
end

-- A-Chassis não expõe MaxRPM como Value — usa Tune.Redline internamente.
-- Default A-Chassis v1.7.x: redline ~8000 RPM.
local REDLINE = 8000

local function getRPMRatio(values)
    if not values then return 0 end
    local rv = values:FindFirstChild("RPM")
    if not rv or REDLINE == 0 then return 0 end
    return math.clamp(rv.Value / REDLINE, 0, 1)
end

local function isHandbrakeOn(values)
    if not values then return false end
    local hb = values:FindFirstChild("PBrake")
    return hb and hb.Value == true
end

-- ============================================================
-- ATUALIZAÇÃO DA BARRA DE RPM
-- ============================================================
local function updateRPMBar(ratio)
    local lit = math.floor(ratio * NUM_SEGS)
    for i = 1, NUM_SEGS do
        if i <= lit then
            if     i <= 12 then segments[i].BackgroundColor3 = C_SEG_G
            elseif i <= 16 then segments[i].BackgroundColor3 = C_SEG_Y
            else                segments[i].BackgroundColor3 = C_SEG_R end
        else
            segments[i].BackgroundColor3 = C_SEG_OFF
        end
    end
end

-- ============================================================
-- LOOP DE ATUALIZAÇÃO
-- ============================================================
local function startLoop()
    if _connection then _connection:Disconnect() end
    _connection = RunService.RenderStepped:Connect(function()
        if not _carRoot or not _carRoot.Parent then
            VehicleHUD.hide()
            return
        end

        -- Velocidade
        local studs = _carRoot.AssemblyLinearVelocity.Magnitude
        local kmh   = math.floor(studs * 3.6 * 0.28)
        speedNum.Text = tostring(kmh)

        -- A-Chassis values
        if not _valuesFolder then
            _valuesFolder = findAChassisValues()
        end

        -- Marcha
        gearNum.Text = getGearText(_valuesFolder)

        -- Barra de RPM
        local rpmRatio = getRPMRatio(_valuesFolder)
        -- fallback: simula RPM via velocidade quando Values não disponível
        if rpmRatio == 0 and studs > 1 then
            rpmRatio = math.clamp(studs / 120, 0, 1)
        end
        updateRPMBar(rpmRatio)

        -- Handbrake
        hbLabel.Text = isHandbrakeOn(_valuesFolder) and "■ HB" or ""
    end)
end

-- ============================================================
-- API PÚBLICA
-- ============================================================
function VehicleHUD.show(carRoot)
    _carRoot      = carRoot
    _valuesFolder = nil
    screenGui.Enabled = true
    _visible      = true
    startLoop()
end

function VehicleHUD.hide()
    if _connection then _connection:Disconnect() ; _connection = nil end
    _carRoot      = nil
    _valuesFolder = nil
    screenGui.Enabled = false
    _visible      = false
end

function VehicleHUD.isVisible()
    return _visible
end

return VehicleHUD

panel.BorderSizePixel       = 0
panel.Parent                = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = panel

-- Velocidade (número grande)
local speedLabel = Instance.new("TextLabel")
speedLabel.Name            = "SpeedLabel"
speedLabel.Size            = UDim2.new(1, 0, 0.5, 0)
speedLabel.Position        = UDim2.new(0, 0, 0, 0)
speedLabel.BackgroundTransparency = 1
speedLabel.TextColor3      = UIConfig.ColorSpeed
speedLabel.Font            = Enum.Font.GothamBold
speedLabel.TextScaled      = true
speedLabel.Text            = "0"
speedLabel.Parent          = panel

-- Label "km/h"
local unitLabel = Instance.new("TextLabel")
unitLabel.Name             = "UnitLabel"
unitLabel.Size             = UDim2.new(1, 0, 0.2, 0)
unitLabel.Position         = UDim2.new(0, 0, 0.5, 0)
unitLabel.BackgroundTransparency = 1
unitLabel.TextColor3       = UIConfig.ColorLabel
unitLabel.Font             = Enum.Font.Gotham
unitLabel.TextScaled       = true
unitLabel.Text             = "km/h"
unitLabel.Parent           = panel

-- Marcha
local gearLabel = Instance.new("TextLabel")
gearLabel.Name             = "GearLabel"
gearLabel.Size             = UDim2.new(0.4, 0, 0.28, 0)
gearLabel.Position         = UDim2.new(0, 8, 0.7, 0)
gearLabel.BackgroundTransparency = 1
gearLabel.TextColor3       = UIConfig.ColorGear
gearLabel.Font             = Enum.Font.GothamBold
gearLabel.TextScaled       = true
gearLabel.Text             = "N"
gearLabel.TextXAlignment   = Enum.TextXAlignment.Left
gearLabel.Parent           = panel
gearLabel.Visible          = UIConfig.ShowGear

-- Handbrake indicator
local hbLabel = Instance.new("TextLabel")
hbLabel.Name               = "HandbrakeLabel"
hbLabel.Size               = UDim2.new(0.55, 0, 0.28, 0)
hbLabel.Position           = UDim2.new(0.45, 0, 0.7, 0)
hbLabel.BackgroundTransparency = 1
hbLabel.TextColor3         = UIConfig.ColorHandbrake
hbLabel.Font               = Enum.Font.GothamBold
hbLabel.TextScaled         = true
hbLabel.Text               = ""
hbLabel.TextXAlignment     = Enum.TextXAlignment.Right
hbLabel.Parent             = panel
hbLabel.Visible            = UIConfig.ShowHandbrake

-- ============================================================
-- LEITURA DO ESTADO A-CHASSIS
-- ============================================================

local function findAChassisValues()
    local interface = playerGui:FindFirstChild("A-Chassis Interface")
    if not interface then return nil end
    return interface:FindFirstChild("Values")
end

local function getGearText(values)
    if not values then return "?" end
    local gearVal = values:FindFirstChild("Gear")
    if not gearVal then return "?" end
    local g = gearVal.Value
    if g == 0 then return "N"
    elseif g == -1 then return "R"
    else return tostring(g) end
end

local function isHandbrakeOn(values)
    if not values then return false end
    local hb = values:FindFirstChild("PBrake")
    return hb and hb.Value == true
end

-- ============================================================
-- LOOP DE ATUALIZAÇÃO
-- ============================================================

local function startLoop()
    if _connection then _connection:Disconnect() end

    _connection = RunService.RenderStepped:Connect(function()
        if not _carRoot or not _carRoot.Parent then
            VehicleHUD.hide()
            return
        end

        -- Velocidade: studs/s → km/h (1 stud ≈ 0.28 m, ×3.6 = km/h)
        local studsPerSec = _carRoot.AssemblyLinearVelocity.Magnitude
        local kmh = math.floor(studsPerSec * UIConfig.SpeedMultiplier * 3.6 * 0.28)
        speedLabel.Text = tostring(kmh)

        -- Tentar ler valores do A-Chassis
        if not _valuesFolder then
            _valuesFolder = findAChassisValues()
        end

        -- Marcha
        if UIConfig.ShowGear then
            gearLabel.Text = getGearText(_valuesFolder)
        end

        -- Handbrake
        if UIConfig.ShowHandbrake then
            hbLabel.Text = isHandbrakeOn(_valuesFolder) and "HB" or ""
        end
    end)
end

-- ============================================================
-- FUNÇÕES PÚBLICAS
-- ============================================================

function VehicleHUD.show(carRoot)
    _carRoot = carRoot
    _valuesFolder = nil  -- vai buscar de novo
    screenGui.Enabled = true
    _visible = true
    startLoop()
    print("[VehicleHUD] visível")
end

function VehicleHUD.hide()
    if _connection then
        _connection:Disconnect()
        _connection = nil
    end
    _carRoot = nil
    _valuesFolder = nil
    screenGui.Enabled = false
    _visible = false
end

function VehicleHUD.isVisible()
    return _visible
end

return VehicleHUD
