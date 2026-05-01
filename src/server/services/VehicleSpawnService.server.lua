-- =============================================================
-- GAROA CAR CULTURE — VehicleSpawnService
-- Spawna veículos no mapa
-- =============================================================
-- M003: Suporta modelos A-Chassis em ReplicatedStorage.Vehicles.
--       Fallback para placeholder M002 se A-Chassis não disponível.
--
-- Para ativar A-Chassis:
--   1. Importar modelo A-Chassis no Roblox Studio
--   2. Mover para ReplicatedStorage.Vehicles com nome "TestCar"
--   3. Verificar estrutura: DriveSeat, Wheels, A-Chassis Tune
-- =============================================================

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

-- ============================================================
-- CONFIGURAÇÃO
-- ============================================================

-- M003.6: spawn na faixa direita da Paulista Prototype
-- X = DIVIDER_W/2 + LANE_W*1.5 = 2.5 + 6.75 = 9.25, Z = 35
local SPAWN_CFRAME = CFrame.new(9.25, 3, 35)   -- posição no mapa
local PLAYER_SPAWN_CFRAME = CFrame.new(9.25, 1.3, 20)

-- Pasta que deve conter os modelos de carro em ReplicatedStorage
local VEHICLES_FOLDER_NAME = "Vehicles"
local DEFAULT_VEHICLE_NAME = "TestCar"
local PLACEHOLDER_VEHICLE_NAME = "CarPlaceholder"
local PLAYER_SPAWN_NAME = "GaroaPlayerSpawn"
local VEHICLE_MARKER_NAME = "GaroaVehicleSpawnMarker"

local function ensurePlayerSpawnLocation()
    local existing = Workspace:FindFirstChild(PLAYER_SPAWN_NAME)
    if existing then
        return existing
    end

    local spawnLocation = Instance.new("SpawnLocation")
    spawnLocation.Name = PLAYER_SPAWN_NAME
    spawnLocation.Size = Vector3.new(8, 1, 8)
    spawnLocation.CFrame = PLAYER_SPAWN_CFRAME
    spawnLocation.Anchored = true
    spawnLocation.Neutral = true
    spawnLocation.Duration = 0
    spawnLocation.Color = Color3.fromRGB(80, 220, 120)
    spawnLocation.Material = Enum.Material.Neon
    spawnLocation.TopSurface = Enum.SurfaceType.Smooth
    spawnLocation.BottomSurface = Enum.SurfaceType.Smooth
    spawnLocation.Parent = Workspace

    return spawnLocation
end

local function ensureVehicleSpawnMarker()
    local existing = Workspace:FindFirstChild(VEHICLE_MARKER_NAME)
    if existing then
        return existing
    end

    local marker = Instance.new("Part")
    marker.Name = VEHICLE_MARKER_NAME
    marker.Size = Vector3.new(2, 10, 2)
    marker.CFrame = SPAWN_CFRAME + Vector3.new(0, 6, 0)
    marker.Anchored = true
    marker.CanCollide = false
    marker.Transparency = 0.25
    marker.Color = Color3.fromRGB(255, 220, 40)
    marker.Material = Enum.Material.Neon
    marker.Parent = Workspace

    return marker
end

local function getExistingVehicle()
    return Workspace:FindFirstChild(DEFAULT_VEHICLE_NAME) or Workspace:FindFirstChild(PLACEHOLDER_VEHICLE_NAME)
end

local function addBmwM4CslVisual(car)
    local driveSeat = car:FindFirstChild("DriveSeat")
    if not driveSeat or not driveSeat:IsA("BasePart") then
        return
    end

    local existing = car:FindFirstChild("BMW_M4CSL_Visual")
    if existing then
        existing:Destroy()
    end

    local misc = car:FindFirstChild("Misc")
    local originalBody = misc and misc:FindFirstChild("Body")
    if originalBody then
        for _, descendant in ipairs(originalBody:GetDescendants()) do
            if descendant:IsA("BasePart") and descendant.Name ~= "Engine" and descendant.Name ~= "Transmission" and descendant.Name ~= "Exhaust" then
                descendant.Transparency = 1
                descendant.CanCollide = false
            end
        end
    end

    local visual = Instance.new("Model")
    visual.Name = "BMW_M4CSL_Visual"
    visual.Parent = car

    local function addPart(name, size, localCFrame, color, material, transparency)
        local part = Instance.new("Part")
        part.Name = name
        part.Size = size
        part.CFrame = driveSeat.CFrame * localCFrame
        part.Anchored = false
        part.CanCollide = false
        part.CanTouch = false
        part.CanQuery = false
        part.Massless = true
        part.Color = color
        part.Material = material or Enum.Material.SmoothPlastic
        part.Transparency = transparency or 0
        part.TopSurface = Enum.SurfaceType.Smooth
        part.BottomSurface = Enum.SurfaceType.Smooth
        part.Parent = visual

        local weld = Instance.new("WeldConstraint")
        weld.Part0 = driveSeat
        weld.Part1 = part
        weld.Parent = part

        return part
    end

    local white = Color3.fromRGB(235, 235, 230)
    local carbon = Color3.fromRGB(14, 15, 17)
    local glass = Color3.fromRGB(38, 55, 70)
    local grille = Color3.fromRGB(5, 5, 6)
    local red = Color3.fromRGB(210, 32, 45)
    local blue = Color3.fromRGB(25, 90, 190)
    local cyan = Color3.fromRGB(70, 190, 255)

    local mainBody = addPart("M4CSL_Body", Vector3.new(7.2, 1.15, 13.8), CFrame.new(0, 0.45, 0.2), white)
    visual.PrimaryPart = mainBody

    addPart("M4CSL_FrontBumper", Vector3.new(7.4, 0.75, 1.2), CFrame.new(0, 0.2, 7.15), white)
    addPart("M4CSL_RearBumper", Vector3.new(7.35, 0.85, 1.1), CFrame.new(0, 0.25, -6.85), white)
    addPart("M4CSL_HoodCarbon", Vector3.new(6.3, 0.18, 3.6), CFrame.new(0, 1.05, 4.05), carbon)
    addPart("M4CSL_RoofCarbon", Vector3.new(5.2, 0.22, 3.6), CFrame.new(0, 2.12, -1.2), carbon)
    addPart("M4CSL_CabinGlass", Vector3.new(4.8, 1.35, 3.9), CFrame.new(0, 1.55, -1.25), glass, Enum.Material.Glass, 0.25)
    addPart("M4CSL_Windshield", Vector3.new(4.9, 0.1, 1.2), CFrame.new(0, 1.55, 1.05) * CFrame.Angles(math.rad(-22), 0, 0), glass, Enum.Material.Glass, 0.2)
    addPart("M4CSL_RearWindow", Vector3.new(4.7, 0.1, 1.05), CFrame.new(0, 1.55, -3.45) * CFrame.Angles(math.rad(24), 0, 0), glass, Enum.Material.Glass, 0.2)
    addPart("M4CSL_KidneyGrilleLeft", Vector3.new(1.15, 0.95, 0.18), CFrame.new(-0.7, 0.42, 7.82), grille)
    addPart("M4CSL_KidneyGrilleRight", Vector3.new(1.15, 0.95, 0.18), CFrame.new(0.7, 0.42, 7.82), grille)
    addPart("M4CSL_HeadlightLeft", Vector3.new(1.55, 0.25, 0.12), CFrame.new(-2.35, 0.68, 7.86), cyan, Enum.Material.Neon)
    addPart("M4CSL_HeadlightRight", Vector3.new(1.55, 0.25, 0.12), CFrame.new(2.35, 0.68, 7.86), cyan, Enum.Material.Neon)
    addPart("M4CSL_TailLightLeft", Vector3.new(1.65, 0.24, 0.12), CFrame.new(-2.2, 0.72, -7.43), red, Enum.Material.Neon)
    addPart("M4CSL_TailLightRight", Vector3.new(1.65, 0.24, 0.12), CFrame.new(2.2, 0.72, -7.43), red, Enum.Material.Neon)
    addPart("M4CSL_FrontSplitter", Vector3.new(7.8, 0.16, 0.85), CFrame.new(0, -0.25, 7.8), carbon)
    addPart("M4CSL_RearWing", Vector3.new(7.2, 0.18, 0.65), CFrame.new(0, 1.5, -7.25), carbon)
    addPart("M4CSL_WingLeftSupport", Vector3.new(0.18, 0.85, 0.18), CFrame.new(-2.35, 1.02, -7.1), carbon)
    addPart("M4CSL_WingRightSupport", Vector3.new(0.18, 0.85, 0.18), CFrame.new(2.35, 1.02, -7.1), carbon)
    addPart("M4CSL_MStripeBlue", Vector3.new(0.28, 0.08, 5.2), CFrame.new(-0.42, 1.18, 3.35), blue, Enum.Material.Neon)
    addPart("M4CSL_MStripeCyan", Vector3.new(0.28, 0.08, 5.2), CFrame.new(0, 1.19, 3.35), cyan, Enum.Material.Neon)
    addPart("M4CSL_MStripeRed", Vector3.new(0.28, 0.08, 5.2), CFrame.new(0.42, 1.18, 3.35), red, Enum.Material.Neon)

    print("[VehicleSpawnService] BMW M4 CSL visual shell attached to A-Chassis")
end

-- ============================================================
-- SPAWN DE MODELO A-CHASSIS (M003+)
-- ============================================================

local function trySpawnAChassis(spawnCFrame)
    local vehiclesFolder = ReplicatedStorage:FindFirstChild(VEHICLES_FOLDER_NAME)
    if not vehiclesFolder then
        return nil
    end

    local template = vehiclesFolder:FindFirstChild(DEFAULT_VEHICLE_NAME)
    if not template then
        return nil
    end

    -- Validar estrutura mínima do A-Chassis
    local driveSeat = template:FindFirstChild("DriveSeat")
    local wheels = template:FindFirstChild("Wheels")
    local tune = template:FindFirstChild("A-Chassis Tune")

    if not driveSeat or not wheels or not tune then
        warn("[VehicleSpawnService] Modelo A-Chassis inválido — faltam DriveSeat, Wheels ou A-Chassis Tune")
        return nil
    end

    local car = template:Clone()
    car.Name = DEFAULT_VEHICLE_NAME
    addBmwM4CslVisual(car)

    -- Posicionar via PrimaryPart (DriveSeat é a referência de posição do A-Chassis)
    car:PivotTo(spawnCFrame)

    car.Parent = Workspace
    print("[VehicleSpawnService] A-Chassis spawned:", car.Name, "at", spawnCFrame.Position)
    return car
end

-- ============================================================
-- FALLBACK: PLACEHOLDER M002 (sem A-Chassis)
-- ============================================================

local CAR_PLACEHOLDER_CONFIG = {
    BodySize    = Vector3.new(6, 1.5, 12),
    BodyColor   = BrickColor.new("Bright red"),
    WheelRadius = 1.2,
    WheelWidth  = 0.8,
    MaxSpeed    = 60,
    TurnSpeed   = 2,
}

local function buildPlaceholderCar(position)
    local carModel = Instance.new("Model")
    carModel.Name = PLACEHOLDER_VEHICLE_NAME

    local body = Instance.new("Part")
    body.Name = "Body"
    body.Size = CAR_PLACEHOLDER_CONFIG.BodySize
    body.BrickColor = CAR_PLACEHOLDER_CONFIG.BodyColor
    body.Material = Enum.Material.SmoothPlastic
    body.CFrame = CFrame.new(position)
    body.Parent = carModel

    local seat = Instance.new("VehicleSeat")
    seat.Name = "VehicleSeat"
    seat.Size = Vector3.new(2, 0.5, 2)
    seat.BrickColor = BrickColor.new("Dark stone grey")
    seat.Material = Enum.Material.SmoothPlastic
    seat.CFrame = CFrame.new(position + Vector3.new(0, CAR_PLACEHOLDER_CONFIG.BodySize.Y / 2 + 0.25, 0))
    seat.MaxSpeed = CAR_PLACEHOLDER_CONFIG.MaxSpeed
    seat.TurnSpeed = CAR_PLACEHOLDER_CONFIG.TurnSpeed
    seat.Torque = 500
    seat.Parent = carModel

    local seatWeld = Instance.new("WeldConstraint")
    seatWeld.Part0 = body
    seatWeld.Part1 = seat
    seatWeld.Parent = body

    local wheelPositions = {
        Vector3.new(-CAR_PLACEHOLDER_CONFIG.BodySize.X / 2 - CAR_PLACEHOLDER_CONFIG.WheelWidth / 2, 0,  CAR_PLACEHOLDER_CONFIG.BodySize.Z * 0.3),
        Vector3.new( CAR_PLACEHOLDER_CONFIG.BodySize.X / 2 + CAR_PLACEHOLDER_CONFIG.WheelWidth / 2, 0,  CAR_PLACEHOLDER_CONFIG.BodySize.Z * 0.3),
        Vector3.new(-CAR_PLACEHOLDER_CONFIG.BodySize.X / 2 - CAR_PLACEHOLDER_CONFIG.WheelWidth / 2, 0, -CAR_PLACEHOLDER_CONFIG.BodySize.Z * 0.3),
        Vector3.new( CAR_PLACEHOLDER_CONFIG.BodySize.X / 2 + CAR_PLACEHOLDER_CONFIG.WheelWidth / 2, 0, -CAR_PLACEHOLDER_CONFIG.BodySize.Z * 0.3),
    }

    for i, offset in ipairs(wheelPositions) do
        local wheel = Instance.new("Part")
        wheel.Name = "Wheel" .. i
        wheel.Shape = Enum.PartType.Cylinder
        wheel.Size = Vector3.new(CAR_PLACEHOLDER_CONFIG.WheelWidth, CAR_PLACEHOLDER_CONFIG.WheelRadius * 2, CAR_PLACEHOLDER_CONFIG.WheelRadius * 2)
        wheel.BrickColor = BrickColor.new("Really black")
        wheel.Material = Enum.Material.SmoothPlastic
        wheel.CFrame = CFrame.new(position + offset)
        wheel.Parent = carModel

        local weld = Instance.new("WeldConstraint")
        weld.Part0 = body
        weld.Part1 = wheel
        weld.Parent = body
    end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "InteractPrompt"
    billboard.Adornee = seat
    billboard.Size = UDim2.new(0, 120, 0, 40)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = false
    billboard.Enabled = false
    billboard.Parent = seat

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    label.BackgroundTransparency = 0.4
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.Text = "[E] Entrar"
    label.Parent = billboard

    carModel.PrimaryPart = body
    return carModel
end

local function spawnPlaceholderCar()
    local existing = Workspace:FindFirstChild(PLACEHOLDER_VEHICLE_NAME)
    if existing then existing:Destroy() end

    local car = buildPlaceholderCar(SPAWN_CFRAME.Position)
    car.Parent = Workspace
    print("[VehicleSpawnService] CarPlaceholder (fallback M002) spawned")
    return car
end

-- ============================================================
-- SPAWN PRINCIPAL
-- ============================================================

local function spawnDefaultCar(reason)
    ensurePlayerSpawnLocation()
    ensureVehicleSpawnMarker()

    -- Remover instâncias anteriores
    local existing = Workspace:FindFirstChild(DEFAULT_VEHICLE_NAME)
    if existing then existing:Destroy() end
    local existingPlaceholder = Workspace:FindFirstChild(PLACEHOLDER_VEHICLE_NAME)
    if existingPlaceholder then existingPlaceholder:Destroy() end

    print("[VehicleSpawnService] Spawning default car", reason or "startup")

    -- Tentar A-Chassis primeiro
    local car = trySpawnAChassis(SPAWN_CFRAME)
    if car then
        return car
    end

    -- Fallback: placeholder M002
    warn("[VehicleSpawnService] ReplicatedStorage.Vehicles.TestCar não encontrado")
    warn("[VehicleSpawnService] Usando placeholder M002. Para M003: importar modelo A-Chassis.")
    return spawnPlaceholderCar()
end

-- Spawna ao iniciar o servidor
spawnDefaultCar("startup")

-- Em sessões com Rojo, o servidor pode começar antes de tudo estar sincronizado.
-- Esses retries tornam o carro visível mesmo quando o usuário conecta Rojo e aperta Play em seguida.
task.delay(2, function()
    if not getExistingVehicle() then
        spawnDefaultCar("delayed-retry")
    end
end)

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.delay(1, function()
            if not getExistingVehicle() then
                spawnDefaultCar("player-joined")
            end
        end)
    end)
end)

for _, player in ipairs(Players:GetPlayers()) do
    if player.Character then
        task.delay(1, function()
            if not getExistingVehicle() then
                spawnDefaultCar("existing-player")
            end
        end)
    end
end

