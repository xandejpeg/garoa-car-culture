-- =============================================================
-- GAROA CAR CULTURE — GarageInputController (stub)
-- Controle de input quando UI de garagem/oficina está aberta
-- =============================================================
-- Gerencia: Confirmar, Cancelar, Navegar menus, Inspecionar
--           Funciona com teclado, gamepad e mouse
--
-- ESTADO ATUAL: stub — estrutura definida, sem lógica ainda.
-- Implementação real na M006 (Garagem/Customização).
-- =============================================================

local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local InputConfig = require(ReplicatedStorage.Shared.config.InputConfig)

-- ============================================================
-- MÓDULO
-- ============================================================

local GarageInputController = {}

local _enabled = false
local _connections = {}

-- ============================================================
-- FUNÇÕES PÚBLICAS
-- ============================================================

function GarageInputController.enable()
    if _enabled then return end
    _enabled = true

    -- TODO M006: Conectar inputs de UI
    -- TODO M006: Desabilitar mouse lock
    -- TODO M006: Mostrar cursor

    print("[GarageInputController] enabled")
end

function GarageInputController.disable()
    if not _enabled then return end
    _enabled = false

    for _, conn in pairs(_connections) do
        conn:Disconnect()
    end
    _connections = {}

    print("[GarageInputController] disabled")
end

function GarageInputController.isEnabled()
    return _enabled
end

return GarageInputController
