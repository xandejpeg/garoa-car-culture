-- Paste this in Roblox Studio's Command Bar after importing the BMW mesh.
-- It creates a one-time mounted preview under Workspace.TestCar.

local Workspace = game:GetService("Workspace")

local car = Workspace:FindFirstChild("TestCar")
assert(car, "Workspace.TestCar not found. Press Play or spawn the A-Chassis first.")

local driveSeat = car:FindFirstChild("DriveSeat", true)
assert(driveSeat and driveSeat:IsA("BasePart"), "DriveSeat not found in TestCar")

local source
for _, child in ipairs(Workspace:GetChildren()) do
    local name = string.upper(child.Name)
    if child:IsA("Model") and child ~= car and string.find(name, "BMW", 1, true) then
        source = child
        break
    end
end
assert(source, "Imported BMW model not found in Workspace. Import it first and keep BMW in the name.")

local old = car:FindFirstChild("BMW_M4CSL_MESHY_Visual") or car:FindFirstChild("BMW_M4CSL_Visual")
if old then
    old:Destroy()
end

local visual = source:Clone()
visual.Name = "BMW_M4CSL_MESHY_Visual"
visual.Parent = car

for _, descendant in ipairs(visual:GetDescendants()) do
    if descendant:IsA("BasePart") then
        descendant.Anchored = false
        descendant.CanCollide = false
        descendant.CanTouch = false
        descendant.CanQuery = false
        descendant.Massless = true
    end
end

visual:PivotTo(driveSeat.CFrame * CFrame.new(0, 0.35, 0))

for _, descendant in ipairs(visual:GetDescendants()) do
    if descendant:IsA("BasePart") then
        local weld = Instance.new("WeldConstraint")
        weld.Part0 = driveSeat
        weld.Part1 = descendant
        weld.Parent = descendant
    end
end

print("Mounted imported BMW visual onto TestCar. Tune position/orientation manually in Studio, then Save to File as final .rbxm.")
