-- =============================================================
-- GAROA CAR CULTURE — InputDeviceMapper (stub)
-- Detecta dispositivo ativo e resolve bindings
-- =============================================================
-- Detecta: Teclado+Mouse / Gamepad Xbox / Gamepad (G29 via x360ce)
-- Resolve bindings de acordo com o dispositivo detectado
--
-- ESTADO ATUAL: stub — estrutura definida, sem lógica ainda.
-- Implementação real na M003 (após M001 validado).
-- =============================================================

local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local InputConfig = require(ReplicatedStorage.Shared.config.InputConfig)

-- ============================================================
-- MÓDULO
-- ============================================================

local InputDeviceMapper = {}

-- Dispositivos suportados
InputDeviceMapper.Device = {
    KeyboardMouse = "KeyboardMouse",  -- base obrigatória
    Gamepad       = "Gamepad",        -- controle Xbox ou equivalente
    Wheel         = "Wheel",          -- G29 via x360ce (= Gamepad no Roblox)
}

local _currentDevice = InputDeviceMapper.Device.KeyboardMouse

-- ============================================================
-- DETECÇÃO (a implementar em M003)
-- ============================================================

-- Detecta se há gamepad conectado e atualiza _currentDevice
function InputDeviceMapper.detectDevice()
    -- TODO M003: verificar UserInputService:GetConnectedGamepads()
    -- Se Gamepad1 conectado → _currentDevice = Gamepad
    -- Se nenhum gamepad → _currentDevice = KeyboardMouse
    -- (G29 via x360ce aparece como Gamepad1 normal)
    return _currentDevice
end

-- Retorna o binding correto para a ação e contexto dados
-- Prioridade: Gamepad > KeyboardMouse
-- Exemplo: getBinding("Throttle", "Vehicle")
function InputDeviceMapper.getBinding(action, context)
    -- TODO M003: retornar binding correto baseado em _currentDevice
    -- Por enquanto retorna sempre o binding de teclado
    return InputConfig.Keyboard[action]
end

-- ============================================================
-- FUNÇÕES PÚBLICAS
-- ============================================================

function InputDeviceMapper.getCurrentDevice()
    return _currentDevice
end

function InputDeviceMapper.isGamepadConnected()
    -- TODO M003: leitura real
    return false
end

function InputDeviceMapper.init()
    -- TODO M003: Detectar dispositivo inicial
    -- TODO M003: Conectar GamepadConnected / GamepadDisconnected
    _currentDevice = InputDeviceMapper.detectDevice()
    print("[InputDeviceMapper] device:", _currentDevice)
end

return InputDeviceMapper
