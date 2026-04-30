-- =============================================================
-- GAROA CAR CULTURE — GarageConfig
-- M007-lite: catálogo de carros e configuração da garagem
-- =============================================================

return {
	-- Posição de spawn do carro na Paulista
	-- A pista fica em Y≈1 (superfície). Spawnar em Y=6 → carro
	-- cai levemente até assentar na pista.
	SpawnCFrame = CFrame.new(8, 6, -60),

	-- Catálogo de carros disponíveis no M007-lite
	-- (apenas TestCar por enquanto — mais carros em M007.1+)
	Cars = {
		{
			Id       = "TestCar",          -- nome em ReplicatedStorage.Vehicles
			Name     = "Projeto Alfa",     -- nome exibido na garagem
			Desc     = "RWD · Turbo · A-Chassis",
			Unlocked = true,
		},
	},
}
