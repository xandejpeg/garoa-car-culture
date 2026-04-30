-- =============================================================
-- GAROA CAR CULTURE — DriftScoreController
-- LocalScript — scoring de drift + UI de score — M008-lite
-- =============================================================
-- Autogerenciado via Humanoid.Seated.
-- Não precisa ser required por ninguém.
-- =============================================================

local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")
local RS         = game:GetService("ReplicatedStorage")

local player     = Players.LocalPlayer
local PlayerScripts = player:WaitForChild("PlayerScripts")

-- ============================================================
-- REQUIRES
-- ============================================================
local ScoreConfig = require(RS:WaitForChild("Shared"):WaitForChild("config"):WaitForChild("ScoreConfig"))

-- SessionEconomyController está em PlayerScripts.economy (src/client/economy/)
-- AChassisTelemetryAdapter está em PlayerScripts.vehicle (src/client/vehicle/)
local ok1, Economy = pcall(function()
    local economyFolder = PlayerScripts:WaitForChild("economy", 10)
    if not economyFolder then error("economy folder não encontrada") end
    return require(economyFolder:WaitForChild("SessionEconomyController", 10))
end)
if not ok1 then
    warn("[DriftScore] SessionEconomyController não encontrado:", Economy)
    Economy = nil
end

local ok2, Telemetry = pcall(function()
    local vehicleFolder = PlayerScripts:WaitForChild("vehicle", 10)
    if not vehicleFolder then error("vehicle folder não encontrada") end
    return require(vehicleFolder:WaitForChild("AChassisTelemetryAdapter", 10))
end)
if not ok2 then
    warn("[DriftScore] AChassisTelemetryAdapter não encontrado:", Telemetry)
    Telemetry = nil
end

-- ============================================================
-- UI — Score HUD (bottom-left, não colide com VehicleHUD)
-- ============================================================
local screenGui     = Instance.new("ScreenGui")
screenGui.Name          = "DriftScoreHUD"
screenGui.ResetOnSpawn  = false
screenGui.DisplayOrder  = 99
screenGui.Enabled       = false
screenGui.Parent        = player:WaitForChild("PlayerGui")

local panel = Instance.new("Frame")
panel.Name                   = "Panel"
panel.Size                   = UDim2.new(0, 180, 0, 90)
panel.Position               = UDim2.new(0, 16, 1, -106)
panel.BackgroundColor3       = Color3.fromRGB(10, 10, 12)
panel.BackgroundTransparency = 0.12
panel.BorderSizePixel        = 0
panel.Parent                 = screenGui
Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 8)
local stroke = Instance.new("UIStroke", panel)
stroke.Color       = Color3.fromRGB(50, 50, 55)
stroke.Thickness   = 1
stroke.Transparency = 0.4

-- Score
local scoreLbl = Instance.new("TextLabel")
scoreLbl.Size               = UDim2.new(1, -12, 0, 14)
scoreLbl.Position           = UDim2.new(0, 6, 0, 6)
scoreLbl.BackgroundTransparency = 1
scoreLbl.Text               = "DRIFT"
scoreLbl.Font               = Enum.Font.GothamBold
scoreLbl.TextColor3         = Color3.fromRGB(90, 90, 90)
scoreLbl.TextScaled         = true
scoreLbl.TextXAlignment     = Enum.TextXAlignment.Left
scoreLbl.Parent             = panel

local scoreNum = Instance.new("TextLabel")
scoreNum.Size               = UDim2.new(1, -12, 0, 34)
scoreNum.Position           = UDim2.new(0, 6, 0, 18)
scoreNum.BackgroundTransparency = 1
scoreNum.Text               = "0"
scoreNum.Font               = Enum.Font.GothamBold
scoreNum.TextColor3         = Color3.fromRGB(255, 220, 50)
scoreNum.TextScaled         = true
scoreNum.TextXAlignment     = Enum.TextXAlignment.Left
scoreNum.Parent             = panel

-- Combo + Money (bottom row)
local comboLbl = Instance.new("TextLabel")
comboLbl.Size               = UDim2.new(0.5, -6, 0, 22)
comboLbl.Position           = UDim2.new(0, 6, 1, -28)
comboLbl.BackgroundTransparency = 1
comboLbl.Text               = "x1.0"
comboLbl.Font               = Enum.Font.GothamBold
comboLbl.TextColor3         = Color3.fromRGB(255, 140, 0)
comboLbl.TextScaled         = true
comboLbl.TextXAlignment     = Enum.TextXAlignment.Left
comboLbl.Parent             = panel

local moneyLbl = Instance.new("TextLabel")
moneyLbl.Size               = UDim2.new(0.5, -6, 0, 22)
moneyLbl.Position           = UDim2.new(0.5, 0, 1, -28)
moneyLbl.BackgroundTransparency = 1
moneyLbl.Text               = "R$0"
moneyLbl.Font               = Enum.Font.GothamBold
moneyLbl.TextColor3         = Color3.fromRGB(80, 220, 80)
moneyLbl.TextScaled         = true
moneyLbl.TextXAlignment     = Enum.TextXAlignment.Right
moneyLbl.Parent             = panel

-- ============================================================
-- HELPERS
-- ============================================================
local function kmhFromStuds(studs)
    return studs * 3.6 * 0.28
end

local function formatScore(n)
    -- Formata com separador de milhar
    local s = tostring(math.floor(n))
    local result = ""
    local count  = 0
    for i = #s, 1, -1 do
        if count > 0 and count % 3 == 0 then result = "," .. result end
        result = s:sub(i, i) .. result
        count  = count + 1
    end
    return result
end

local function formatMoney(n)
    return string.format("R$%d", math.floor(n))
end

-- ============================================================
-- ESTADO
-- ============================================================
local _telem   = nil
local _loop    = nil
local _combo   = 1.0
local _driftOn = false
local _driftTimer = 0   -- tempo sem drift para decaimento de combo

local function stopScoring()
    if _loop then _loop:Disconnect() ; _loop = nil end
    if _telem then _telem:destroy() ; _telem = nil end
    if Economy then Economy.resetCombo() end
    _combo      = 1.0
    _driftOn    = false
    _driftTimer = 0
    screenGui.Enabled = false
    print("[DriftScore] scoring parado")
end

local function startScoring(carRoot)
    stopScoring()

    if not ScoreConfig.Enabled then return end
    if not Economy or not Telemetry then return end

    _telem = Telemetry.new(carRoot)
    screenGui.Enabled = true

    _loop = RunService.Heartbeat:Connect(function(dt)
        local t    = _telem:read()
        local kmh  = kmhFromStuds(t.speed)
        local cfg  = ScoreConfig

        -- ── Detectar drift ──────────────────────────────────
        local isDrift = false
        if kmh >= cfg.MinSpeedKmh then
            if t.handbrake then
                isDrift = true
            elseif t.lateralSpeed >= cfg.LateralSlipThreshold then
                isDrift = true
            end
        end

        -- ── Combo ────────────────────────────────────────────
        if isDrift then
            _driftTimer = 0
            _combo = math.min(_combo + cfg.ComboGrowthRate * dt, cfg.MaxCombo)
        else
            _driftTimer = _driftTimer + dt
            if kmh < cfg.ComboResetSpeedKmh or _driftTimer > 1.5 then
                _combo = math.max(_combo - cfg.ComboDecayRate * dt, 1.0)
            end
        end

        Economy.setCombo(_combo)

        -- ── Score ─────────────────────────────────────────────
        if isDrift then
            local pts = cfg.BaseDriftPointsPerSecond * dt
            if t.handbrake then
                pts = pts * cfg.HandbrakeBonus
            end
            if t.lateralSpeed >= cfg.LateralSlipThreshold then
                pts = pts * cfg.SlipBonusMultiplier
            end
            Economy.addPoints(pts, _combo, cfg.MoneyPerPoint)
        end

        -- ── UI ───────────────────────────────────────────────
        local state = Economy.getState()
        scoreNum.Text = formatScore(state.score)
        comboLbl.Text = string.format("x%.1f", _combo)
        moneyLbl.Text = formatMoney(state.money)

        -- Cor do combo: cinza=1x, âmbar=ativo, laranja-vivo=alto
        if _combo >= 2.0 then
            comboLbl.TextColor3 = Color3.fromRGB(255, 80, 30)
        elseif isDrift then
            comboLbl.TextColor3 = Color3.fromRGB(255, 140, 0)
        else
            comboLbl.TextColor3 = Color3.fromRGB(100, 100, 100)
        end

        if cfg.Debug then
            print(string.format(
                "[DriftScore] kmh=%.1f drift=%s combo=%.2f score=%.0f money=%.2f",
                kmh, tostring(isDrift), _combo, state.score, state.money
            ))
        end
    end)

    print("[DriftScore] scoring iniciado — carRoot:", carRoot.Name)
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
            task.wait(0.3)
            local car  = seat.Parent
            local root = car and (car.PrimaryPart or car:FindFirstChildWhichIsA("BasePart"))
            startScoring(root or seat)
        else
            stopScoring()
        end
    end)
end

player.CharacterAdded:Connect(function()
    task.wait(0.5)
    init()
end)

task.spawn(init)

print("[DriftScore] LocalScript carregado")
