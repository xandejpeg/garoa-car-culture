-- =============================================================
-- GAROA CAR CULTURE — GarageService
-- M007-lite: spawna/despawna carro do jogador via RemoteEvents
-- =============================================================
-- Fluxo:
--   1. Cliente abre GarageUI (tecla G)
--   2. Jogador clica "SPAWNAR" → FireServer("SpawnCar", carId)
--   3. Este serviço clona o template de ReplicatedStorage.Vehicles,
--      posiciona na pista e guarda referência por jogador
--   4. Jogador clica "GUARDAR" → FireServer("DespawnCar")
--      → modelo destruído
--   5. PlayerRemoving: cleanup automático
-- =============================================================

local Players          = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace        = game:GetService("Workspace")

local GarageConfig = require(ReplicatedStorage.Shared.config.GarageConfig)

-- ============================================================
-- REMOTE EVENTS — criados dinamicamente para não precisar
-- de entrada extra no default.project.json
-- ============================================================

local remotesFolder = Instance.new("Folder")
remotesFolder.Name   = "GarageRemotes"
remotesFolder.Parent = ReplicatedStorage

local evSpawn = Instance.new("RemoteEvent")
evSpawn.Name   = "SpawnCar"
evSpawn.Parent = remotesFolder

local evDespawn = Instance.new("RemoteEvent")
evDespawn.Name   = "DespawnCar"
evDespawn.Parent = remotesFolder

-- ============================================================
-- ESTADO
-- ============================================================

local playerCars = {}  -- [userId] = Model | nil

-- ============================================================
-- HELPERS
-- ============================================================

local function getTemplate(carId)
	local vehicles = ReplicatedStorage:FindFirstChild("Vehicles")
	if not vehicles then
		warn("[GarageService] ReplicatedStorage.Vehicles não encontrado")
		return nil
	end
	local tmpl = vehicles:FindFirstChild(carId)
	if not tmpl then
		warn("[GarageService] template não encontrado:", carId)
	end
	return tmpl
end

local function getVehiclesFolder()
	local f = Workspace:FindFirstChild("Vehicles")
	if not f then
		f = Instance.new("Folder")
		f.Name   = "Vehicles"
		f.Parent = Workspace
	end
	return f
end

local function despawnCar(player)
	local userId = player.UserId
	local car = playerCars[userId]
	if car and car.Parent then
		car:Destroy()
		print("[GarageService]", player.Name, "carro despawnado")
	end
	playerCars[userId] = nil
end

local function spawnCar(player, carId)
	-- Valida carId contra catálogo
	local carDef = nil
	for _, c in ipairs(GarageConfig.Cars) do
		if c.Id == carId then
			carDef = c
			break
		end
	end
	if not carDef then
		warn("[GarageService] carId inválido:", carId, "— player:", player.Name)
		return
	end
	if not carDef.Unlocked then
		warn("[GarageService] carro bloqueado:", carId)
		return
	end

	local template = getTemplate(carDef.Id)
	if not template then return end

	-- Despawna carro anterior (se houver)
	despawnCar(player)

	-- Clona e posiciona
	local car  = template:Clone()
	car.Name   = "Car_" .. player.UserId

	-- PivotTo funciona independente de PrimaryPart estar definido
	car:PivotTo(GarageConfig.SpawnCFrame)
	car.Parent = getVehiclesFolder()

	playerCars[player.UserId] = car
	print("[GarageService]", player.Name, "spawnou", carId)
end

-- ============================================================
-- HANDLERS
-- ============================================================

evSpawn.OnServerEvent:Connect(function(player, carId)
	-- Sanitiza input: carId deve ser string
	if type(carId) ~= "string" then
		warn("[GarageService] carId não é string — ignorado")
		return
	end
	spawnCar(player, carId)
end)

evDespawn.OnServerEvent:Connect(function(player)
	despawnCar(player)
end)

Players.PlayerRemoving:Connect(function(player)
	despawnCar(player)
	playerCars[player.UserId] = nil
end)

print("[GarageService] M007-lite carregado")
