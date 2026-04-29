-- =============================================================
-- GAROA CAR CULTURE — InputConfig
-- Configuração central de input — V5
-- =============================================================
-- Arquitetura de input por contexto (MD Master V5, Seção 7):
--
--   OnFootInput   → personagem a pé (WASD + mouse)
--   VehicleInput  → carro (teclado base / gamepad / volante)
--   GarageInput   → UI / garagem / oficina
--   DeviceMapper  → detecta dispositivo ativo
--
-- BASE OBRIGATÓRIA: teclado + mouse.
-- CAMADA AVANÇADA: controle/gamepad e volante G29 via x360ce.
--
-- Os mapeamentos de gamepad/volante DEVEM ser validados no
-- InputTestHUD (M001) antes de usar no sistema de veículo.
-- =============================================================

local InputConfig = {}

-- ============================================================
-- MAPEAMENTO DE EIXOS (G29 via x360ce → XInput → Roblox)
-- ============================================================
-- Valores são KeyCode do Roblox + componente do Vector3 (X, Y, Z)

InputConfig.Axes = {
    -- Volante: Thumbstick1.X é o eixo mais comum para direção
    -- Confirmar no InputTestHUD se está chegando aqui
    Steering = {
        KeyCode   = Enum.KeyCode.Thumbstick1,
        Component = "X",
        -- Inverter se o volante girar ao contrário
        Invert    = false,
        -- Deadzone: ignorar valores menores que isso (0.0 a 1.0)
        Deadzone  = 0.05,
    },

    -- Acelerador: gatilho direito (R2/RT) por padrão via x360ce
    Throttle = {
        KeyCode   = Enum.KeyCode.ButtonR2,
        Component = "Z",
        Invert    = false,
        Deadzone  = 0.02,
    },

    -- Freio: gatilho esquerdo (L2/LT) por padrão via x360ce
    Brake = {
        KeyCode   = Enum.KeyCode.ButtonL2,
        Component = "Z",
        Invert    = false,
        Deadzone  = 0.02,
    },

    -- Embreagem: pode vir como Thumbstick2.Y ou outro eixo
    -- Depende do mapeamento no x360ce — confirmar no teste
    Clutch = {
        KeyCode   = Enum.KeyCode.Thumbstick2,
        Component = "Y",
        Invert    = false,
        Deadzone  = 0.05,
    },
}

-- ============================================================
-- CONTEXTOS DE INPUT (V5)
-- ============================================================
-- O InputContextController usa estes identificadores para
-- saber qual handler deve processar o input no momento.

InputConfig.Context = {
    OnFoot  = "OnFoot",
    Vehicle = "Vehicle",
    Garage  = "Garage",
}

-- ============================================================
-- MAPEAMENTO DE BOTÕES DE GAMEPAD (camada intermediária)
-- ============================================================
-- G29 via x360ce chega ao Roblox como controle Xbox.
-- Estes são os botões esperados para VehicleInput.

InputConfig.Buttons = {
    -- Freio de mão
    Handbrake      = Enum.KeyCode.ButtonA,
    -- Trocar câmera
    CameraSwitch   = Enum.KeyCode.ButtonY,
    -- Entrar/Sair do carro
    ExitVehicle    = Enum.KeyCode.ButtonX,
    -- Buzina
    Horn           = Enum.KeyCode.ButtonL3,
    -- Abrir mapa (futuro)
    Map            = Enum.KeyCode.ButtonStart,
    -- Shift up (câmbio sequencial futuro)
    ShiftUp        = Enum.KeyCode.ButtonR1,
    -- Shift down
    ShiftDown      = Enum.KeyCode.ButtonL1,
    -- Interagir (on-foot)
    Interact       = Enum.KeyCode.ButtonX,
    -- Pular (on-foot)
    Jump           = Enum.KeyCode.ButtonA,
}

-- ============================================================
-- MAPEAMENTO DE TECLADO — BASE OBRIGATÓRIA (V5)
-- ============================================================
-- O jogo precisa funcionar completo com teclado.
-- Todos os sistemas devem ter fallback de teclado.

InputConfig.Keyboard = {
    -- VehicleInput
    Throttle    = Enum.KeyCode.W,
    Brake       = Enum.KeyCode.S,
    SteerLeft   = Enum.KeyCode.A,
    SteerRight  = Enum.KeyCode.D,
    Handbrake   = Enum.KeyCode.Space,
    ExitVehicle = Enum.KeyCode.F,
    CameraSwitch = Enum.KeyCode.C,
    CameraSwitchAlt = Enum.KeyCode.V,
    -- Câmbio sequencial
    ShiftUp     = Enum.KeyCode.Q,
    ShiftUpAlt  = Enum.KeyCode.R,
    ShiftDown   = Enum.KeyCode.Z,

    -- OnFootInput
    MoveForward  = Enum.KeyCode.W,
    MoveBackward = Enum.KeyCode.S,
    MoveLeft     = Enum.KeyCode.A,
    MoveRight    = Enum.KeyCode.D,
    Jump         = Enum.KeyCode.Space,
    Sprint       = Enum.KeyCode.LeftShift,
    Interact     = Enum.KeyCode.E,  -- entrar no carro / interagir
    ExitVehicleOnFoot = Enum.KeyCode.F, -- sair do carro (mesma tecla que ExitVehicle)

    -- GarageInput / UI
    Confirm      = Enum.KeyCode.Return,
    Cancel       = Enum.KeyCode.Escape,
    Inspect      = Enum.KeyCode.F,
}

-- ============================================================
-- CURVAS DE RESPOSTA
-- ============================================================
-- Expoente de curva: 1.0 = linear, >1.0 = mais suave no centro
-- Útil para reduzir sensibilidade no centro do volante

InputConfig.Curves = {
    -- Expoente para o eixo de direção
    SteeringExponent = 1.5,
    -- Expoente para o acelerador
    ThrottleExponent = 1.2,
    -- Expoente para o freio
    BrakeExponent    = 1.2,
}

-- ============================================================
-- CONFIGURAÇÃO GERAL
-- ============================================================

InputConfig.Settings = {
    -- Qual gamepad usar (1 = primeiro detectado)
    GamepadPriority = Enum.UserInputType.Gamepad1,
    -- Suavização de direção (0.0 a 1.0, onde 1.0 = sem suavização)
    SteeringSmoothFactor = 0.25,
    -- Sensibilidade geral do volante (multiplicador)
    SteeringSensitivity  = 1.0,
}

return InputConfig
