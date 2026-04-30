-- =============================================================
-- GAROA CAR CULTURE — UIConfig
-- Configuração do HUD de veículo (M003.8)
-- =============================================================

return {
    -- Posição do HUD (canto inferior direito)
    HUDPositionX = UDim2.new(1, -220, 1, -140),
    HUDSize      = UDim2.new(0, 210, 0, 130),

    -- Cores
    ColorBackground  = Color3.fromRGB(0, 0, 0),
    ColorSpeed       = Color3.fromRGB(255, 255, 255),
    ColorGear        = Color3.fromRGB(255, 220, 50),
    ColorHandbrake   = Color3.fromRGB(255, 60, 60),
    ColorLabel       = Color3.fromRGB(160, 160, 160),

    -- Transparência do painel (0 = opaco, 1 = invisível)
    BackgroundTransparency = 0.35,

    -- Conversão de velocidade: studs/s → km/h
    -- 1 stud ≈ 0.28m, então studs/s * 3.6 * 0.28 ≈ studs/s * 1.008
    SpeedMultiplier = 1.0,  -- ajustar se a escala do carro for diferente

    -- Mostrar/ocultar elementos
    ShowGear      = true,
    ShowHandbrake = true,
    ShowVehicleName = false,
}
