-- src/server/services/TestTrackBuilder.server.lua
-- M003.5 — Gera pista de teste programaticamente no Workspace
-- Layout: Straight(300) → WideTurn → Link(120) → TightTurn → Return(225) → DriftArea(120×120)
-- Não depende de assets externos. Agrupar em Workspace.TestTrack.

local Workspace = game:GetService("Workspace")

local TRACK_NAME = "TestTrack"

-- Ceder prioridade à Paulista Prototype (M003.6+)
if Workspace:FindFirstChild("PaulistaPrototype") then
	print("[TestTrackBuilder] PaulistaPrototype presente — TestTrack suprimido")
	return
end

-- Evitar duplicata a cada Play
if Workspace:FindFirstChild(TRACK_NAME) then
	warn("[TestTrackBuilder] TestTrack já existe no Workspace — abortando duplicata")
	return
end

print("[TestTrackBuilder] Gerando pista de teste M003.5...")

-- ========================
-- CONSTANTES
-- ========================

local RW = 22       -- largura da pista (studs)
local TH = 1        -- espessura do asfalto
local HY = TH / 2  -- centro Y das peças de pista (superfície no Y=1)

local C_ASPHALT = Color3.fromRGB(55,  55,  55)
local C_LINE    = Color3.fromRGB(220, 220, 220)
local C_GRASS   = Color3.fromRGB(106, 127,  63)
local C_CONE    = Color3.fromRGB(255, 100,  20)
local C_BARRIER = Color3.fromRGB(200, 200, 200)
local C_SPAWN   = Color3.fromRGB(80,  200,  80)
local C_YELLOW  = Color3.fromRGB(255, 200,   0)

-- ========================
-- HELPERS
-- ========================

local track = Instance.new("Model")
track.Name = TRACK_NAME

local function newFolder(name, parent)
	local f = Instance.new("Folder")
	f.Name = name
	f.Parent = parent or track
	return f
end

-- Cria uma Part ancorada
-- pos: Vector3 do centro, yaw: rotação Y em radianos
local function newPart(parent, name, size, pos, yaw, color, material)
	local p           = Instance.new("Part")
	p.Name            = name
	p.Size            = size
	p.CFrame          = CFrame.new(pos.X, pos.Y, pos.Z) * CFrame.Angles(0, yaw or 0, 0)
	p.Anchored        = true
	p.Color           = color
	p.Material        = material or Enum.Material.SmoothPlastic
	p.TopSurface      = Enum.SurfaceType.Smooth
	p.BottomSurface   = Enum.SurfaceType.Smooth
	p.CastShadow      = false
	p.Parent          = parent
	return p
end

-- Constrói arco de curva com segmentos retangulares
-- centerX, centerZ: centro do arco no plano XZ
-- radius: raio do arco
-- startAngle: ângulo inicial do ponto de entrada (radianos, em XZ padrão)
-- arcAngle: ângulo total do arco (π/2 para curva de 90°)
-- segments: número de segmentos retangulares
local function buildArc(parent, namePrefix, centerX, centerZ, radius, startAngle, arcAngle, segments)
	-- Comprimento da corda de cada segmento + pequena sobreposição
	local segChord = 2 * radius * math.sin(arcAngle / (2 * segments)) + 2
	for i = 0, segments - 1 do
		local theta = startAngle - (i + 0.5) * (arcAngle / segments)
		local mx    = centerX + radius * math.cos(theta)
		local mz    = centerZ + radius * math.sin(theta)
		-- Direção tangencial CW: (sin θ, -cos θ); yaw = atan2(sin θ, -cos θ)
		local yaw   = math.atan2(math.sin(theta), -math.cos(theta))
		newPart(parent, namePrefix .. i,
			Vector3.new(RW, TH, segChord),
			Vector3.new(mx, HY, mz),
			yaw, C_ASPHALT)
	end
end

-- ========================
-- BASE (gramado apenas se não houver Baseplate)
-- ========================

local base = newFolder("Base")
if not Workspace:FindFirstChild("Baseplate") then
	newPart(base, "Grass",
		Vector3.new(750, 2, 750),
		Vector3.new(200, -1, 175),
		0, C_GRASS, Enum.Material.Grass)
end

-- ========================
-- RETA PRINCIPAL (Z: 0 → 300, X = 0)
-- ========================

local straight = newFolder("StraightSection")

-- Asfalto
newPart(straight, "Road",
	Vector3.new(RW, TH, 300),
	Vector3.new(0, HY, 150),
	0, C_ASPHALT)

-- Linha central tracejada (a cada 20 studs)
for i = 0, 13 do
	newPart(straight, "Dash" .. i,
		Vector3.new(0.4, TH + 0.02, 10),
		Vector3.new(0, HY + 0.02, 10 + i * 20),
		0, C_LINE)
end

-- Bordas laterais
newPart(straight, "EdgeL",
	Vector3.new(0.3, TH + 0.02, 300),
	Vector3.new(-(RW / 2 - 0.8), HY + 0.02, 150),
	0, C_LINE)
newPart(straight, "EdgeR",
	Vector3.new(0.3, TH + 0.02, 300),
	Vector3.new(RW / 2 - 0.8, HY + 0.02, 150),
	0, C_LINE)

-- Barreiras laterais (peças longas únicas)
newPart(straight, "BarrierL",
	Vector3.new(1.5, 3, 300),
	Vector3.new(-(RW / 2 + 1.5), 1.5, 150),
	0, C_BARRIER)
newPart(straight, "BarrierR",
	Vector3.new(1.5, 3, 300),
	Vector3.new(RW / 2 + 1.5, 1.5, 150),
	0, C_BARRIER)

-- ========================
-- ZONA DE FRENAGEM (Z: 245 → 295)
-- ========================

local brakeZone = newFolder("BrakeZone")
brakeZone.Parent = track

for i = 0, 4 do
	newPart(brakeZone, "Mark" .. i,
		Vector3.new(RW, TH + 0.02, 2),
		Vector3.new(0, HY + 0.02, 245 + i * 10),
		0, C_LINE)
end

-- ========================
-- CURVA AMPLA DIREITA
-- Entrada: (0, 300) dir +Z → Saída: (50, 350) dir +X
-- Centro: (50, 300), R=50, 4 segmentos
-- ========================

local wideTurn = newFolder("WideTurn")
wideTurn.Parent = track

buildArc(wideTurn, "Seg", 50, 300, 50, math.pi, math.pi / 2, 4)

-- ========================
-- RETA DE LIGAÇÃO
-- Entrada: X=50 Z=350 dir +X → Saída: X=170 Z=350
-- ========================

local link = newFolder("LinkStraight")
link.Parent = track

newPart(link, "Road",
	Vector3.new(RW, TH, 120),
	Vector3.new(110, HY, 350),
	math.pi / 2, C_ASPHALT)

-- Linha central da reta de ligação (eixo X)
for i = 0, 5 do
	newPart(link, "Dash" .. i,
		Vector3.new(0.4, TH + 0.02, 10),
		Vector3.new(60 + i * 20, HY + 0.02, 350),
		math.pi / 2, C_LINE)
end

-- ========================
-- CURVA FECHADA DIREITA
-- Entrada: (170, 350) dir +X → Saída: (195, 325) dir -Z
-- Centro: (170, 325), R=25, 3 segmentos
-- ========================

local tightTurn = newFolder("TightTurn")
tightTurn.Parent = track

buildArc(tightTurn, "Seg", 170, 325, 25, math.pi / 2, math.pi / 2, 3)

-- ========================
-- RETA DE RETORNO
-- Entrada: X=195 Z=325 dir -Z → Saída: X=195 Z=100
-- ========================

local ret = newFolder("ReturnStraight")
ret.Parent = track

newPart(ret, "Road",
	Vector3.new(RW, TH, 225),
	Vector3.new(195, HY, 212.5),
	0, C_ASPHALT)

for i = 0, 10 do
	newPart(ret, "Dash" .. i,
		Vector3.new(0.4, TH + 0.02, 10),
		Vector3.new(195, HY + 0.02, 315 - i * 20),
		0, C_LINE)
end

-- ========================
-- CONECTOR (X: 195 → 310, Z=100) → entrada da área de drift
-- ========================

local connector = newFolder("Connector")
connector.Parent = track

newPart(connector, "Road",
	Vector3.new(RW, TH, 115),
	Vector3.new(252.5, HY, 100),
	math.pi / 2, C_ASPHALT)

-- ========================
-- ÁREA DE DRIFT (centro: X=370, Z=100, 120×120)
-- ========================

local driftArea = newFolder("DriftArea")
driftArea.Parent = track

local dCX, dCZ = 370, 100
local dSZ      = 120

-- Piso de asfalto
newPart(driftArea, "Floor",
	Vector3.new(dSZ, TH, dSZ),
	Vector3.new(dCX, HY, dCZ),
	0, C_ASPHALT)

-- Linhas de borda amarelas
newPart(driftArea, "RingN",
	Vector3.new(dSZ, TH + 0.02, 1),
	Vector3.new(dCX, HY + 0.02, dCZ - dSZ / 2),
	0, C_YELLOW)
newPart(driftArea, "RingS",
	Vector3.new(dSZ, TH + 0.02, 1),
	Vector3.new(dCX, HY + 0.02, dCZ + dSZ / 2),
	0, C_YELLOW)
newPart(driftArea, "RingE",
	Vector3.new(1, TH + 0.02, dSZ),
	Vector3.new(dCX + dSZ / 2, HY + 0.02, dCZ),
	0, C_YELLOW)
newPart(driftArea, "RingW",
	Vector3.new(1, TH + 0.02, dSZ),
	Vector3.new(dCX - dSZ / 2, HY + 0.02, dCZ),
	0, C_YELLOW)

-- Barreiras baixas ao redor
newPart(driftArea, "BarrierN",
	Vector3.new(dSZ + 4, 2, 1.5),
	Vector3.new(dCX, 1.5, dCZ - dSZ / 2 - 1),
	0, C_BARRIER)
newPart(driftArea, "BarrierS",
	Vector3.new(dSZ + 4, 2, 1.5),
	Vector3.new(dCX, 1.5, dCZ + dSZ / 2 + 1),
	0, C_BARRIER)
newPart(driftArea, "BarrierE",
	Vector3.new(1.5, 2, dSZ + 4),
	Vector3.new(dCX + dSZ / 2 + 1, 1.5, dCZ),
	0, C_BARRIER)
newPart(driftArea, "BarrierW",
	Vector3.new(1.5, 2, dSZ + 4),
	Vector3.new(dCX - dSZ / 2 - 1, 1.5, dCZ),
	0, C_BARRIER)

-- Anel de cones (raio 35 studs, 8 cones)
local cones = newFolder("Cones")
cones.Parent = track

for i = 0, 7 do
	local a = (i / 8) * math.pi * 2
	newPart(cones, "Cone" .. i,
		Vector3.new(1.5, 3.5, 1.5),
		Vector3.new(dCX + 35 * math.cos(a), 1.75, dCZ + 35 * math.sin(a)),
		0, C_CONE)
end

-- ========================
-- MARCADORES DE SPAWN
-- ========================

local spawnMarkers = newFolder("SpawnMarkers")
spawnMarkers.Parent = track

-- Piso verde: posição do player (ao lado da pista, início da reta)
newPart(spawnMarkers, "PlayerSpawn",
	Vector3.new(6, TH + 0.02, 8),
	Vector3.new(-16, HY + 0.02, 20),
	0, C_SPAWN)

-- Piso amarelo: posição do carro (alinhado com VehicleSpawnService: X=0, Z=20)
newPart(spawnMarkers, "CarSpawn",
	Vector3.new(10, TH + 0.02, 14),
	Vector3.new(0, HY + 0.02, 30),
	0, C_YELLOW)

-- ========================
-- FINALIZAÇÃO
-- ========================

track.Parent = Workspace

print("[TestTrackBuilder] ✓ Pista gerada com sucesso!")
print("[TestTrackBuilder]   Seções: Straight(300) → WideTurn → Link(120) → TightTurn → Return(225) → Connector → DriftArea(120×120)")
print("[TestTrackBuilder]   Carro spawna em (0, 3, 20) — início da reta principal")
print("[TestTrackBuilder]   Drift area em X=370, Z=100")
