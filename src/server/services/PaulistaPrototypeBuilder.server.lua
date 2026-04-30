-- src/server/services/PaulistaPrototypeBuilder.server.lua
-- M003.6 — Avenida Paulista Prototype
-- Gera uma avenida urbana simbólica inspirada na Av. Paulista.
-- Totalmente programático, sem assets externos.
-- Não é réplica real — é um protótipo motivacional para testar o carro em contexto urbano.

local Workspace = game:GetService("Workspace")

local ENV_NAME = "PaulistaPrototype"

if Workspace:FindFirstChild(ENV_NAME) then
	warn("[PaulistaBuilder] " .. ENV_NAME .. " já existe — abortando duplicata")
	return
end

print("[PaulistaBuilder] Gerando Avenida Paulista Prototype...")

-- ========================
-- CONSTANTES
-- ========================

local ROAD_LENGTH = 600     -- comprimento da avenida (+Z)
local LANE_W      = 4.5     -- largura de cada faixa
local LANES       = 4       -- faixas por sentido
local ROAD_HALF   = LANES * LANE_W  -- metade da pista (sem canteiro) = 18
local DIVIDER_W   = 5       -- canteiro central
local TOTAL_HALF  = ROAD_HALF + DIVIDER_W / 2  -- borda externa da pista = 20.5
local SIDEWALK_W  = 9       -- largura da calçada
local TH          = 1       -- espessura das peças de piso
local HY          = TH / 2  -- Y do centro das peças de piso

-- Cores
local C_ASPHALT  = Color3.fromRGB(50,  50,  50)
local C_SIDEWALK = Color3.fromRGB(185, 180, 170)
local C_DIVIDER  = Color3.fromRGB(75,  130,  55)
local C_LINE_W   = Color3.fromRGB(220, 220, 220)
local C_LINE_Y   = Color3.fromRGB(255, 200,  20)
local C_CROSS    = Color3.fromRGB(230, 230, 230)
local C_CURB     = Color3.fromRGB(210, 210, 210)
local C_BLDG_A   = Color3.fromRGB(178, 172, 163)  -- concreto
local C_BLDG_B   = Color3.fromRGB(138, 152, 168)  -- cimento azulado
local C_GLASS    = Color3.fromRGB(160, 205, 225)   -- vidro
local C_MASP_RED = Color3.fromRGB(198,  38,  38)
local C_MASP_WH  = Color3.fromRGB(235, 235, 235)
local C_POST     = Color3.fromRGB(75,   75,  85)
local C_LIGHT    = Color3.fromRGB(255, 255, 200)
local C_SPAWN    = Color3.fromRGB(80,  200,  80)
local C_YELLOW   = Color3.fromRGB(255, 200,   0)

-- ========================
-- HELPERS
-- ========================

local root = Instance.new("Model")
root.Name = ENV_NAME

local function newFolder(name, parent)
	local f = Instance.new("Folder")
	f.Name = name
	f.Parent = parent or root
	return f
end

local function newPart(parent, name, size, pos, yaw, color, material)
	local p = Instance.new("Part")
	p.Name            = name
	p.Size            = size
	p.CFrame          = CFrame.new(pos) * CFrame.Angles(0, yaw or 0, 0)
	p.Anchored        = true
	p.Color           = color
	p.Material        = material or Enum.Material.SmoothPlastic
	p.TopSurface      = Enum.SurfaceType.Smooth
	p.BottomSurface   = Enum.SurfaceType.Smooth
	p.CastShadow      = false
	p.Parent          = parent
	return p
end

-- ========================
-- PISO / CALÇADA / CANTEIRO
-- ========================

local road = newFolder("Road")

-- Asfalto lado esquerdo (X negativo)
newPart(road, "AsphaltL",
	Vector3.new(ROAD_HALF, TH, ROAD_LENGTH),
	Vector3.new(-(DIVIDER_W / 2 + ROAD_HALF / 2), HY, ROAD_LENGTH / 2),
	0, C_ASPHALT)

-- Asfalto lado direito (X positivo)
newPart(road, "AsphaltR",
	Vector3.new(ROAD_HALF, TH, ROAD_LENGTH),
	Vector3.new(DIVIDER_W / 2 + ROAD_HALF / 2, HY, ROAD_LENGTH / 2),
	0, C_ASPHALT)

-- Canteiro central
newPart(road, "Divider",
	Vector3.new(DIVIDER_W, TH + 0.4, ROAD_LENGTH),
	Vector3.new(0, HY + 0.4, ROAD_LENGTH / 2),
	0, C_DIVIDER, Enum.Material.Grass)

-- Guias (meio-fio)
newPart(road, "CurbL",
	Vector3.new(0.8, TH + 0.35, ROAD_LENGTH),
	Vector3.new(-(TOTAL_HALF + 0.4), HY + 0.35, ROAD_LENGTH / 2),
	0, C_CURB)
newPart(road, "CurbR",
	Vector3.new(0.8, TH + 0.35, ROAD_LENGTH),
	Vector3.new(TOTAL_HALF + 0.4, HY + 0.35, ROAD_LENGTH / 2),
	0, C_CURB)

-- Calçadas
local swXL = -(TOTAL_HALF + 0.8 + SIDEWALK_W / 2)
local swXR =   TOTAL_HALF + 0.8 + SIDEWALK_W / 2
newPart(road, "SidewalkL",
	Vector3.new(SIDEWALK_W, TH + 0.2, ROAD_LENGTH),
	Vector3.new(swXL, HY + 0.2, ROAD_LENGTH / 2),
	0, C_SIDEWALK)
newPart(road, "SidewalkR",
	Vector3.new(SIDEWALK_W, TH + 0.2, ROAD_LENGTH),
	Vector3.new(swXR, HY + 0.2, ROAD_LENGTH / 2),
	0, C_SIDEWALK)

-- ========================
-- FAIXAS DE PISTA
-- ========================

local lines = newFolder("Lines")
lines.Parent = root

-- Linhas tracejadas entre faixas (3 tracejados por sentido)
for lane = 1, LANES - 1 do
	local xL = -(DIVIDER_W / 2 + lane * LANE_W)
	local xR =   DIVIDER_W / 2 + lane * LANE_W
	for seg = 0, 14 do
		local z = 15 + seg * 40
		newPart(lines, "DL" .. lane .. "_" .. seg,
			Vector3.new(0.3, TH + 0.02, 12),
			Vector3.new(xL, HY + 0.02, z),
			0, C_LINE_W)
		newPart(lines, "DR" .. lane .. "_" .. seg,
			Vector3.new(0.3, TH + 0.02, 12),
			Vector3.new(xR, HY + 0.02, z),
			0, C_LINE_W)
	end
end

-- Linhas amarelas na borda do canteiro central
for seg = 0, 29 do
	local z = 10 + seg * 20
	newPart(lines, "CtrL" .. seg,
		Vector3.new(0.3, TH + 0.02, 14),
		Vector3.new(-(DIVIDER_W / 2 + 0.5), HY + 0.02, z),
		0, C_LINE_Y)
	newPart(lines, "CtrR" .. seg,
		Vector3.new(0.3, TH + 0.02, 14),
		Vector3.new(DIVIDER_W / 2 + 0.5, HY + 0.02, z),
		0, C_LINE_Y)
end

-- ========================
-- CRUZAMENTOS FALSOS (faixa de pedestre)
-- ========================

local crossings = newFolder("Crossings")
crossings.Parent = root

for i, zC in ipairs({ 150, 300, 450 }) do
	for stripe = -3, 3 do
		local zPos = zC + stripe * 2.5
		-- faixa lado esquerdo
		newPart(crossings, "CL" .. i .. "_" .. stripe,
			Vector3.new(ROAD_HALF + 1, TH + 0.02, 1.5),
			Vector3.new(-(DIVIDER_W / 2 + ROAD_HALF / 2), HY + 0.02, zPos),
			0, C_CROSS)
		-- faixa lado direito
		newPart(crossings, "CR" .. i .. "_" .. stripe,
			Vector3.new(ROAD_HALF + 1, TH + 0.02, 1.5),
			Vector3.new(DIVIDER_W / 2 + ROAD_HALF / 2, HY + 0.02, zPos),
			0, C_CROSS)
	end
end

-- ========================
-- POSTES DE ILUMINAÇÃO (a cada 30 studs, lados alternados)
-- ========================

local lighting = newFolder("StreetLights")
lighting.Parent = root

local postH = 18
for i = 0, 19 do
	local z    = 20 + i * 30
	local side = (i % 2 == 0) and swXL or swXR
	local armDir = (side < 0) and 1 or -1  -- braço aponta para dentro da pista

	-- Poste
	newPart(lighting, "Post" .. i,
		Vector3.new(0.6, postH, 0.6),
		Vector3.new(side, postH / 2 + TH + 0.2, z),
		0, C_POST)
	-- Braço
	newPart(lighting, "Arm" .. i,
		Vector3.new(5, 0.5, 0.5),
		Vector3.new(side + armDir * 2.5, postH + TH + 0.2, z),
		0, C_POST)
	-- Luminária
	newPart(lighting, "Bulb" .. i,
		Vector3.new(1.8, 0.8, 1.8),
		Vector3.new(side + armDir * 5, postH - 0.4 + TH + 0.2, z),
		0, C_LIGHT, Enum.Material.Neon)
end

-- ========================
-- PRÉDIOS
-- ========================

local buildings = newFolder("Buildings")
buildings.Parent = root

-- Offset X: borda externa da calçada + recuo
local bOffL = swXL - SIDEWALK_W / 2 - 1  -- borda externa calçada esquerda
local bOffR = swXR + SIDEWALK_W / 2 + 1  -- borda externa calçada direita

-- {lado, zInício, largura (+Z), profundidade (+X abs), altura, colorIdx}
-- colorIdx: 1=concreto, 2=cimento, 3=vidro
local bDefs = {
	-- ESQUERDA (X negativo, profundidade vai em -X)
	{-1,   0, 35, 40,  60, 1},
	{-1,  40, 25, 35,  90, 2},
	{-1,  70, 38, 42,  45, 1},
	{-1, 115, 28, 38, 115, 3},
	{-1, 150, 33, 40,  70, 2},
	{-1, 190, 26, 35,  55, 1},
	{-1, 225, 44, 50, 135, 3},
	{-1, 280, 30, 38,  65, 2},
	{-1, 320, 34, 40,  80, 1},
	{-1, 365, 28, 35,  50, 2},
	{-1, 400, 38, 44,  95, 3},
	{-1, 450, 34, 40,  60, 1},
	{-1, 495, 28, 35,  75, 2},
	{-1, 532, 40, 42,  50, 1},
	-- DIREITA (X positivo, profundidade vai em +X)
	{ 1,   0, 38, 42,  80, 2},
	{ 1,  45, 28, 38,  55, 1},
	{ 1,  82, 34, 40, 100, 3},
	{ 1, 125, 28, 35,  70, 1},
	{ 1, 165, 44, 48, 125, 2},
	{ 1, 220, 28, 38,  60, 3},
	{ 1, 260, 33, 40,  75, 1},
	{ 1, 308, 26, 35, 145, 2},
	{ 1, 345, 38, 44,  65, 3},
	{ 1, 398, 28, 38,  85, 1},
	{ 1, 440, 33, 40,  50, 2},
	{ 1, 485, 30, 38,  75, 3},
	{ 1, 530, 40, 44,  60, 1},
}

local colorMap = { C_BLDG_A, C_BLDG_B, C_GLASS }
local matMap   = {
	Enum.Material.SmoothPlastic,
	Enum.Material.SmoothPlastic,
	Enum.Material.Glass,
}

for i, b in ipairs(bDefs) do
	local side, zStart, lenZ, depX, h, ci = b[1], b[2], b[3], b[4], b[5], b[6]
	local xCenter = (side < 0)
		and (bOffL - depX / 2)
		or  (bOffR + depX / 2)
	newPart(buildings, "B" .. i,
		Vector3.new(depX, h, lenZ),
		Vector3.new(xCenter, h / 2 + TH, zStart + lenZ / 2),
		0, colorMap[ci], matMap[ci])
end

-- ========================
-- ESTRUTURA SIMBÓLICA TIPO MASP (Z ≈ 200, lado esquerdo)
-- Dois pilares vermelhos + bloco suspenso
-- Puramente simbólico — não é réplica
-- ========================

local masp = newFolder("MaspLike")
masp.Parent = root

local mCX  = bOffL - 10   -- centro X dos pilares
local mZ   = 205           -- posição Z
local mSpan = 55           -- distância entre os pilares (+Z)
local mVH  = 24            -- altura do vão (onde ficam os pilares)
local mBH  = 9             -- altura do bloco suspenso
local mBD  = 18            -- profundidade do bloco

-- Pilar norte
newPart(masp, "PillarN",
	Vector3.new(5, mVH, 5),
	Vector3.new(mCX, mVH / 2, mZ - mSpan / 2),
	0, C_MASP_RED)
-- Pilar sul
newPart(masp, "PillarS",
	Vector3.new(5, mVH, 5),
	Vector3.new(mCX, mVH / 2, mZ + mSpan / 2),
	0, C_MASP_RED)
-- Bloco suspenso
newPart(masp, "Block",
	Vector3.new(math.abs(bOffL) * 0.7, mBH, mSpan + 8),
	Vector3.new(mCX, mVH + mBH / 2, mZ),
	0, C_MASP_WH)

-- ========================
-- SPAWNS
-- ========================

local spawns = newFolder("SpawnMarkers")
spawns.Parent = root

-- Marcador amarelo: posição do carro (faixa direita, próximo ao início)
newPart(spawns, "CarSpawn",
	Vector3.new(10, TH + 0.02, 14),
	Vector3.new(DIVIDER_W / 2 + LANE_W * 1.5, HY + 0.02, 35),
	0, C_YELLOW)

-- Marcador verde: posição do player (calçada direita)
newPart(spawns, "PlayerSpawn",
	Vector3.new(5, TH + 0.02, 7),
	Vector3.new(swXR - 1, HY + 0.02, 20),
	0, C_SPAWN)

-- ========================
-- FINALIZAÇÃO
-- ========================

root.Parent = Workspace

print("[PaulistaBuilder] ✓ Avenida Paulista Prototype gerada!")
print("[PaulistaBuilder]   Comprimento: " .. ROAD_LENGTH .. " studs")
print("[PaulistaBuilder]   Faixas: " .. LANES .. " por sentido  |  Canteiro central: " .. DIVIDER_W .. " studs")
print("[PaulistaBuilder]   Prédios: " .. #bDefs .. "  |  Postes: 20")
print("[PaulistaBuilder]   Estrutura MASP simbólica em Z=" .. mZ)
print("[PaulistaBuilder]   Spawn carro: X=" .. (DIVIDER_W / 2 + LANE_W * 1.5) .. " Z=35")
