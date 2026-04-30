-- =============================================================
-- GAROA CAR CULTURE — VehicleHUD Runner
-- LocalScript independente — M003.8-fix
-- =============================================================
-- Autogerenciado via Humanoid.Seated.
-- Não precisa ser required por ninguém.
-- =============================================================

local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")

local player    = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ============================================================
-- CORES (FT700 aesthetic)
-- ============================================================
local C_BG      = Color3.fromRGB(10,  10,  12)
local C_AMBER   = Color3.fromRGB(255, 140,   0)
local C_GEAR    = Color3.fromRGB(220, 220, 220)
local C_LABEL   = Color3.fromRGB(90,  90,  90)
local C_HB      = Color3.fromRGB(255,  40,  40)
local C_SEG_OFF = Color3.fromRGB(25,  25,  28)
local C_SEG_G   = Color3.fromRGB(0,  200,  80)
local C_SEG_Y   = Color3.fromRGB(220, 200,   0)
local C_SEG_R   = Color3.fromRGB(255,  30,  30)

local NUM_SEGS  = 20
local REDLINE   = 8000

-- ============================================================
-- BUILD UI
-- ============================================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name          = "VehicleHUD"
screenGui.ResetOnSpawn  = false
screenGui.DisplayOrder  = 100
screenGui.Enabled       = false
screenGui.Parent        = playerGui

local panel = Instance.new("Frame")
panel.Name                   = "Panel"
panel.Size                   = UDim2.new(0, 300, 0, 110)
panel.Position               = UDim2.new(1, -316, 1, -126)
panel.BackgroundColor3       = C_BG
panel.BackgroundTransparency = 0.08
panel.BorderSizePixel        = 0
panel.Parent                 = screenGui
Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 8)

local stroke = Instance.new("UIStroke", panel)
stroke.Color        = Color3.fromRGB(50, 50, 55)
stroke.Thickness    = 1
stroke.Transparency = 0.5

-- RPM bar
local barContainer = Instance.new("Frame")
barContainer.Name                   = "RPMBar"
barContainer.Size                   = UDim2.new(1, -16, 0, 10)
barContainer.Position               = UDim2.new(0, 8, 0, 7)
barContainer.BackgroundTransparency = 1
barContainer.Parent                 = panel

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

-- Separator
local sep = Instance.new("Frame")
sep.Size             = UDim2.new(1, -16, 0, 1)
sep.Position         = UDim2.new(0, 8, 0, 21)
sep.BackgroundColor3 = Color3.fromRGB(40, 40, 44)
sep.BorderSizePixel  = 0
sep.Parent           = panel

-- Gear
local gearNum = Instance.new("TextLabel")
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

-- Vertical divider
local vdiv = Instance.new("Frame")
vdiv.Size             = UDim2.new(0, 1, 0, 72)
vdiv.Position         = UDim2.new(0, 82, 0, 25)
vdiv.BackgroundColor3 = Color3.fromRGB(40, 40, 44)
vdiv.BorderSizePixel  = 0
vdiv.Parent           = panel

-- Speed
local speedNum = Instance.new("TextLabel")
speedNum.Size               = UDim2.new(0, 196, 0, 62)
speedNum.Position           = UDim2.new(0, 90, 0, 25)
speedNum.BackgroundTransparency = 1
speedNum.Text               = "0"
speedNum.Font               = Enum.Font.GothamBold
speedNum.TextColor3         = C_AMBER
speedNum.TextScaled         = true
speedNum.TextXAlignment     = Enum.TextXAlignment.Right
speedNum.Parent             = panel

local speedLbl = Instance.new("TextLabel")
speedLbl.Size               = UDim2.new(0, 100, 0, 16)
speedLbl.Position           = UDim2.new(0, 90, 0, 87)
speedLbl.BackgroundTransparency = 1
speedLbl.Text               = "km/h"
speedLbl.Font               = Enum.Font.GothamBold
speedLbl.TextColor3         = C_LABEL
speedLbl.TextScaled         = true
speedLbl.Parent             = panel

-- Handbrake indicator
local hbLabel = Instance.new("TextLabel")
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
-- HELPERS
-- ============================================================
local function findValues()
    local iface = playerGui:FindFirstChild("A-Chassis Interface")
    if not iface then return nil end
    return iface:FindFirstChild("Values")
end

local function gearText(values)
    if not values then return "N" end
    local gv = values:FindFirstChild("Gear")
    if not gv then return "N" end
    local g = gv.Value
    if g == 0 then return "N" elseif g == -1 then return "R" else return tostring(g) end
end

local function rpmRatio(values)
    if not values then return 0 end
    local rv = values:FindFirstChild("RPM")
    if not rv then return 0 end
    return math.clamp(rv.Value / REDLINE, 0, 1)
end

local function isHBOn(values)
    if not values then return false end
    local hb = values:FindFirstChild("PBrake")
    return hb and hb.Value == true
end

local function updateBar(ratio)
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
-- STATE
-- ============================================================
local _carRoot   = nil
local _values    = nil
local _conn      = nil

local function startHUD(carRoot)
    _carRoot = carRoot
    _values  = nil
    screenGui.Enabled = true
    print("[VehicleHUD] show — carRoot:", carRoot and carRoot:GetFullName() or "nil")

    if _conn then _conn:Disconnect() end
    _conn = RunService.RenderStepped:Connect(function()
        if not _carRoot or not _carRoot.Parent then
            screenGui.Enabled = false
            _conn:Disconnect()
            _conn = nil
            return
        end

        local studs = _carRoot.AssemblyLinearVelocity.Magnitude
        local kmh   = math.floor(studs * 3.6 * 0.28)
        speedNum.Text = tostring(kmh)

        if not _values then _values = findValues() end

        gearNum.Text = gearText(_values)

        local ratio = rpmRatio(_values)
        if ratio == 0 and studs > 1 then
            ratio = math.clamp(studs / 120, 0, 1)
        end
        updateBar(ratio)

        hbLabel.Text = isHBOn(_values) and "■ HB" or ""
    end)
end

local function stopHUD()
    if _conn then _conn:Disconnect() ; _conn = nil end
    _carRoot = nil
    _values  = nil
    screenGui.Enabled = false
    print("[VehicleHUD] hide")
end

-- ============================================================
-- AUTO-DETECT via Humanoid.Seated
-- ============================================================
local function init()
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid  = character:WaitForChild("Humanoid", 10)
    if not humanoid then return end

    humanoid.Seated:Connect(function(isSeated, seat)
        if isSeated and seat then
            local car = seat.Parent
            local root = car and (car.PrimaryPart or car:FindFirstChildWhichIsA("BasePart"))
            task.wait(0.2)
            startHUD(root or seat)
        else
            stopHUD()
        end
    end)
end

player.CharacterAdded:Connect(function()
    task.wait(0.5)
    init()
end)

task.spawn(init)

print("[VehicleHUD] LocalScript carregado")
