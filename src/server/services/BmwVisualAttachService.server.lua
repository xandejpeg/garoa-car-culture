-- =============================================================
-- GAROA CAR CULTURE - BmwVisualAttachService
-- Prototipo desativado: montagem final de carro deve ser feita como asset no Studio.
-- =============================================================

local ENABLE_EXPERIMENTAL_RUNTIME_MOUNT = false

if not ENABLE_EXPERIMENTAL_RUNTIME_MOUNT then
    print("[BmwVisualAttachService] Runtime BMW mount disabled. Use final Studio-built vehicle asset instead.")
    return
end

local Workspace = game:GetService("Workspace")

local DEFAULT_VEHICLE_NAME = "TestCar"
local VISUAL_NAME = "BMW_M4CSL_Visual"
local IMPORTED_VISUAL_NAME = "BMW_M4CSL_MESHY_Visual"
local IMPORTED_SOURCE_PATTERNS = {
    "BMW_M4CSL_MESH",
    "BMW_M4CSL_MESHY_IMPORTAR",
    "BMW_M4CSL",
}
local IMPORTED_VISUAL_OFFSET = CFrame.new(0, 0.35, 0) * CFrame.Angles(0, math.rad(90), 0)

local function findDriveSeat(car)
    local direct = car:FindFirstChild("DriveSeat")
    if direct and direct:IsA("BasePart") then
        return direct
    end

    for _, descendant in ipairs(car:GetDescendants()) do
        if descendant.Name == "DriveSeat" and descendant:IsA("BasePart") then
            return descendant
        end
    end

    return nil
end

local function hideOldBody(car)
    local misc = car:FindFirstChild("Misc")
    local body = misc and misc:FindFirstChild("Body")
    if not body then
        return
    end

    for _, descendant in ipairs(body:GetDescendants()) do
        if descendant:IsA("BasePart") and descendant.Name ~= "Engine" and descendant.Name ~= "Transmission" and descendant.Name ~= "Exhaust" then
            descendant.Transparency = 1
            descendant.CanCollide = false
        end
    end
end

local function isImportedWheelPart(part)
    local lowerName = string.lower(part.Name)
    if string.find(lowerName, "wheel", 1, true) or string.find(lowerName, "tire", 1, true) or string.find(lowerName, "tyre", 1, true) then
        return true
    end

    local parent = part.Parent
    while parent do
        local parentName = string.lower(parent.Name)
        if string.find(parentName, "wheel", 1, true) or string.find(parentName, "tire", 1, true) or string.find(parentName, "tyre", 1, true) then
            return true
        end

        parent = parent.Parent
    end

    return false
end

local function setModelVisualProperties(model, anchored, hideWheels)
    for _, descendant in ipairs(model:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.Anchored = anchored
            descendant.CanCollide = false
            descendant.CanTouch = false
            descendant.CanQuery = false
            descendant.Massless = true

            if hideWheels and isImportedWheelPart(descendant) then
                descendant.Transparency = 1
            end
        end
    end
end

local function findImportedBmwSource()
    for _, child in ipairs(Workspace:GetChildren()) do
        if child:IsA("Model") and child.Name ~= DEFAULT_VEHICLE_NAME and child.Name ~= IMPORTED_VISUAL_NAME and child.Name ~= VISUAL_NAME then
            local upperName = string.upper(child.Name)
            for _, pattern in ipairs(IMPORTED_SOURCE_PATTERNS) do
                if string.find(upperName, pattern, 1, true) then
                    return child
                end
            end
        end
    end

    return nil
end

local function attachImportedBmwVisual(car, driveSeat)
    local source = findImportedBmwSource()
    if not source then
        return false
    end

    local existingPartsVisual = car:FindFirstChild(VISUAL_NAME)
    if existingPartsVisual then
        existingPartsVisual:Destroy()
    end

    local existingImportedVisual = car:FindFirstChild(IMPORTED_VISUAL_NAME)
    if existingImportedVisual then
        return true
    end

    hideOldBody(car)

    local visual = source:Clone()
    visual.Name = IMPORTED_VISUAL_NAME
    visual.Parent = car
    setModelVisualProperties(visual, false, true)

    local _, size = visual:GetBoundingBox()
    local longestAxis = math.max(size.X, size.Z)
    if longestAxis > 0 then
        local targetLength = 12.8
        local scale = math.clamp(targetLength / longestAxis, 0.05, 8)
        pcall(function()
            visual:ScaleTo(scale)
        end)
    end

    visual:PivotTo(driveSeat.CFrame * IMPORTED_VISUAL_OFFSET)

    for _, descendant in ipairs(visual:GetDescendants()) do
        if descendant:IsA("BasePart") then
            local weld = Instance.new("WeldConstraint")
            weld.Part0 = driveSeat
            weld.Part1 = descendant
            weld.Parent = descendant
        end
    end

    setModelVisualProperties(source, true, false)
    for _, descendant in ipairs(source:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.Transparency = 1
        end
    end

    print("[BmwVisualAttachService] BMW M4 CSL importado do Meshy anexado ao TestCar:", source.Name)
    return true
end

local function attachPart(visual, driveSeat, name, size, localCFrame, color, material, transparency)
    local part = Instance.new("Part")
    part.Name = name
    part.Size = size
    part.CFrame = driveSeat.CFrame * localCFrame
    part.Anchored = false
    part.CanCollide = false
    part.CanTouch = false
    part.CanQuery = false
    part.Massless = true
    part.Color = color
    part.Material = material or Enum.Material.SmoothPlastic
    part.Transparency = transparency or 0
    part.TopSurface = Enum.SurfaceType.Smooth
    part.BottomSurface = Enum.SurfaceType.Smooth
    part.Parent = visual

    local weld = Instance.new("WeldConstraint")
    weld.Part0 = driveSeat
    weld.Part1 = part
    weld.Parent = part

    return part
end

local function attachBmwVisual(car)
    if not car or not car:IsA("Model") then
        return false
    end

    local driveSeat = findDriveSeat(car)
    if not driveSeat then
        warn("[BmwVisualAttachService] TestCar sem DriveSeat; nao foi possivel anexar visual BMW")
        return false
    end

    if attachImportedBmwVisual(car, driveSeat) then
        return true
    end

    if car:FindFirstChild(VISUAL_NAME) then
        return true
    end

    hideOldBody(car)

    local visual = Instance.new("Model")
    visual.Name = VISUAL_NAME
    visual.Parent = car

    local white = Color3.fromRGB(238, 238, 234)
    local carbon = Color3.fromRGB(10, 11, 13)
    local glass = Color3.fromRGB(28, 48, 64)
    local grille = Color3.fromRGB(2, 2, 3)
    local red = Color3.fromRGB(220, 28, 42)
    local blue = Color3.fromRGB(20, 75, 180)
    local cyan = Color3.fromRGB(70, 205, 255)

    local body = attachPart(visual, driveSeat, "Huge_White_BMW_M4CSL_Body", Vector3.new(8.8, 1.5, 16.2), CFrame.new(0, 1.1, 0.1), white)
    visual.PrimaryPart = body

    attachPart(visual, driveSeat, "Black_Carbon_Hood", Vector3.new(7.1, 0.22, 4.2), CFrame.new(0, 1.92, 4.7), carbon)
    attachPart(visual, driveSeat, "Black_Carbon_Roof", Vector3.new(5.8, 0.25, 4), CFrame.new(0, 3.05, -1.35), carbon)
    attachPart(visual, driveSeat, "Dark_Glass_Cabin", Vector3.new(5.4, 1.65, 4.4), CFrame.new(0, 2.35, -1.35), glass, Enum.Material.Glass, 0.18)
    attachPart(visual, driveSeat, "BMW_Kidney_Grille_Left", Vector3.new(1.4, 1.15, 0.25), CFrame.new(-0.82, 1.08, 8.32), grille)
    attachPart(visual, driveSeat, "BMW_Kidney_Grille_Right", Vector3.new(1.4, 1.15, 0.25), CFrame.new(0.82, 1.08, 8.32), grille)
    attachPart(visual, driveSeat, "Bright_Blue_Headlight_Left", Vector3.new(1.9, 0.32, 0.18), CFrame.new(-2.8, 1.32, 8.42), cyan, Enum.Material.Neon)
    attachPart(visual, driveSeat, "Bright_Blue_Headlight_Right", Vector3.new(1.9, 0.32, 0.18), CFrame.new(2.8, 1.32, 8.42), cyan, Enum.Material.Neon)
    attachPart(visual, driveSeat, "Red_Taillight_Left", Vector3.new(2, 0.32, 0.18), CFrame.new(-2.65, 1.32, -8.2), red, Enum.Material.Neon)
    attachPart(visual, driveSeat, "Red_Taillight_Right", Vector3.new(2, 0.32, 0.18), CFrame.new(2.65, 1.32, -8.2), red, Enum.Material.Neon)
    attachPart(visual, driveSeat, "Carbon_Front_Splitter", Vector3.new(9.4, 0.2, 1), CFrame.new(0, 0.45, 8.45), carbon)
    attachPart(visual, driveSeat, "Big_Carbon_Rear_Wing", Vector3.new(8.8, 0.22, 0.8), CFrame.new(0, 2.55, -8.3), carbon)
    attachPart(visual, driveSeat, "M_Stripe_Blue", Vector3.new(0.35, 0.12, 6.4), CFrame.new(-0.52, 2.08, 3.95), blue, Enum.Material.Neon)
    attachPart(visual, driveSeat, "M_Stripe_Cyan", Vector3.new(0.35, 0.12, 6.4), CFrame.new(0, 2.1, 3.95), cyan, Enum.Material.Neon)
    attachPart(visual, driveSeat, "M_Stripe_Red", Vector3.new(0.35, 0.12, 6.4), CFrame.new(0.52, 2.08, 3.95), red, Enum.Material.Neon)

    print("[BmwVisualAttachService] BMW M4 CSL visual anexado ao TestCar")
    return true
end

local function tryAttachExisting()
    local car = Workspace:FindFirstChild(DEFAULT_VEHICLE_NAME)
    if car then
        attachBmwVisual(car)
    end
end

Workspace.ChildAdded:Connect(function(child)
    if child.Name == DEFAULT_VEHICLE_NAME then
        task.defer(function()
            attachBmwVisual(child)
        end)
    elseif child:IsA("Model") and findImportedBmwSource() == child then
        task.defer(tryAttachExisting)
    end
end)

tryAttachExisting()

task.spawn(function()
    while true do
        task.wait(2)
        tryAttachExisting()
    end
end)
