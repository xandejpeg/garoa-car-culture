-- =============================================================
-- GAROA CAR CULTURE — VehicleEffectsController
-- LocalScript — orquestra efeitos visuais do veículo — M006.6
-- =============================================================
-- Autogerenciado via Humanoid.Seated.
-- Não precisa ser required por ninguém.
-- =============================================================

local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")

local player     = Players.LocalPlayer
local RS         = game:GetService("ReplicatedStorage")

local EffectsConfig = require(RS:WaitForChild("Shared"):WaitForChild("config"):WaitForChild("EffectsConfig"))

-- src/client/effects/ → StarterPlayerScripts.effects
-- src/client/vehicle/ → StarterPlayerScripts.vehicle
local PlayerScripts = player:WaitForChild("PlayerScripts")

local ok1, TireSmokeController = pcall(function()
    return require(script.Parent:WaitForChild("TireSmokeController"))
end)
if not ok1 then
    warn("[VehicleEffects] TireSmokeController não encontrado:", TireSmokeController)
    TireSmokeController = nil
end

local ok2, AChassisTelemetryAdapter = pcall(function()
    local vehicleFolder = PlayerScripts:WaitForChild("vehicle", 10)
    return require(vehicleFolder:WaitForChild("AChassisTelemetryAdapter"))
end)
if not ok2 then
    warn("[VehicleEffects] AChassisTelemetryAdapter não encontrado:", AChassisTelemetryAdapter)
    AChassisTelemetryAdapter = nil
end

-- ============================================================
-- ESTADO
-- ============================================================
local _smoke   = nil   -- TireSmokeController
local _telem   = nil   -- AChassisTelemetryAdapter
local _loop    = nil   -- RenderStepped connection

local function stopEffects()
    if _loop then _loop:Disconnect() ; _loop = nil end
    if _smoke then _smoke:destroy() ; _smoke = nil end
    if _telem then _telem:destroy() ; _telem = nil end
    print("[VehicleEffects] efeitos parados")
end

local function startEffects(carRoot)
    stopEffects()  -- garante limpeza antes de criar novos

    if not EffectsConfig.Enabled then return end
    if not TireSmokeController then return end
    if not AChassisTelemetryAdapter then return end

    _telem = AChassisTelemetryAdapter.new(carRoot)
    _smoke = TireSmokeController.new(carRoot)

    _loop = RunService.RenderStepped:Connect(function()
        local telem = _telem:read()

        if EffectsConfig.Debug then
            print(string.format(
                "[VehicleEffects] spd=%.1f lat=%.1f hb=%s",
                telem.speed, telem.lateralSpeed, tostring(telem.handbrake)
            ))
        end

        if _smoke then
            _smoke:update(telem)
        end
    end)

    print("[VehicleEffects] efeitos iniciados — carRoot:", carRoot.Name)
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
            -- Pequeno delay para o carro estar estável no workspace
            task.wait(0.3)
            local car  = seat.Parent
            local root = car and (car.PrimaryPart or car:FindFirstChildWhichIsA("BasePart"))
            startEffects(root or seat)
        else
            stopEffects()
        end
    end)
end

player.CharacterAdded:Connect(function()
    task.wait(0.5)
    init()
end)

task.spawn(init)

print("[VehicleEffects] LocalScript carregado")
