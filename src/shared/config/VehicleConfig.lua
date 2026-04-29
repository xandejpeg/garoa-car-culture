--[[
	VehicleConfig
	Configuração dos veículos disponíveis no Garoa Car Culture.

	Para cada veículo, define:
	  - type: "AChassis" | "Legacy" (VehicleSeat) — tipo de sistema de física
	  - modelPath: caminho do modelo em ReplicatedStorage.Vehicles
	  - spawnOffset: offset CFrame relativo ao SpawnPoint do veículo

	Para M003: apenas um carro A-Chassis de teste ("TestCar").
	Para M004+: múltiplos carros com diferentes configs de tune.

	REQUISITO: Os modelos de carro A-Chassis devem estar em:
	  ReplicatedStorage.Vehicles.<nome>

	ESTRUTURA ESPERADA DO MODELO A-CHASSIS:
	  <CarName> (Model)
	    DriveSeat (VehicleSeat)
	    Body/
	      #Weight (Part) — criado pelo Initialize ao spawnar
	    Wheels/ (FL, FR, RL, RR ou F, R)
	    A-Chassis Tune (ModuleScript com tune values)
	      README (ModuleScript)
	        Units (ModuleScript)
	      Initialize (Script — server, dentro do Tune)

	NOTA SOBRE INSTALAÇÃO DO A-CHASSIS:
	  1. Baixar modelo do Toolbox: ID 13999609938 (A-Chassis v1.7.2)
	     OU baixar .rbxm em github.com/lisphm/A-Chassis/releases/tag/v1.7.2-stable
	  2. Importar no Roblox Studio
	  3. Mover o modelo para ReplicatedStorage.Vehicles
	  4. Verificar estrutura DriveSeat, Wheels, A-Chassis Tune
	  5. Aplicar fix de levitação se necessário (ver docs/a-chassis-integration-plan.md)
--]]

local VehicleConfig = {}

--[[
	Lista de veículos disponíveis.
	key = ID interno usado no jogo
--]]
VehicleConfig.Vehicles = {
	-- Veículo de teste M003 — A-Chassis padrão
	TestCar = {
		type = "AChassis",
		modelName = "TestCar",           -- nome do modelo em ReplicatedStorage.Vehicles
		displayName = "Test Car",
		spawnOffset = CFrame.new(0, 2, 0),  -- 2 studs acima do ponto de spawn
	},
}

--[[
	Veículo padrão que spawna quando o jogador entra no jogo.
--]]
VehicleConfig.DefaultVehicle = "TestCar"

--[[
	Ponto de spawn padrão no mapa (será sobrescrito pelo SpawnService).
	CFrame no Workspace onde o carro aparece.
--]]
VehicleConfig.DefaultSpawnCFrame = CFrame.new(0, 5, 0)

return VehicleConfig
