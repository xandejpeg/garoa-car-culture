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

-- ============================================================
-- CONFIGURAÇÃO
-- ============================================================

local SPAWN_CFRAME = CFrame.new(0, 3, 20)   -- posição no mapa

-- Pasta que deve conter os modelos de carro em ReplicatedStorage
local VEHICLES_FOLDER_NAME = "Vehicles"
local DEFAULT_VEHICLE_NAME = "TestCar"

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

    -- Posicionar via PrimaryPart (DriveSeat é a referência de posição do A-Chassis)
    car:PivotTo(spawnCFrame)

    car.Parent = workspace
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
    carModel.Name = "CarPlaceholder"

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
    local existing = workspace:FindFirstChild("CarPlaceholder")
    if existing then existing:Destroy() end

    local car = buildPlaceholderCar(SPAWN_CFRAME.Position)
    car.Parent = workspace
    print("[VehicleSpawnService] CarPlaceholder (fallback M002) spawned")
    return car
end

-- ============================================================
-- SPAWN PRINCIPAL
-- ============================================================

local function spawnDefaultCar()
    -- Remover instâncias anteriores
    local existing = workspace:FindFirstChild(DEFAULT_VEHICLE_NAME)
    if existing then existing:Destroy() end
    local existingPlaceholder = workspace:FindFirstChild("CarPlaceholder")
    if existingPlaceholder then existingPlaceholder:Destroy() end

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
spawnDefaultCar()

