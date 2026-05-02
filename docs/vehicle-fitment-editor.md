# Vehicle Fitment Editor

## Goal

Create an in-game garage/workshop that turns rough imported 3D models into usable car visuals on top of the A-Chassis template.

This is not a raw FBX/GLB importer. Roblox runtime cannot import arbitrary local 3D files directly. The correct boundary is:

1. Import FBX/GLB in Roblox Studio or via Roblox asset tooling.
2. Put the imported model in `ReplicatedStorage.VehicleAssets` or `Workspace` while testing.
3. Use the in-game/editor garage to align, scale, clean, recolor, and mount that model on a working A-Chassis.
4. Save/export the final fitment data and then bake it into a final `.rbxm/.rbxmx` vehicle template.

## What The Editor Should Do

- Select a source visual model, such as `BMW_M4CSL_BODY_READY_COLORED`.
- Spawn an A-Chassis reference car in an isolated garage bay.
- Clone the visual model as a non-colliding preview on top of the chassis.
- Provide transform controls:
  - position X/Y/Z
  - rotation X/Y/Z
  - uniform scale
  - fine step and coarse step modes
- Provide cleanup controls:
  - hide selected part
  - show hidden parts
  - mark part as glass
  - mark part as body paint
  - mark part as carbon/black trim
  - delete visual wheel meshes when the A-Chassis wheels are used
- Provide wheel alignment helpers:
  - show A-Chassis wheel centers
  - show imported visual bounds
  - optionally place visual wheel markers for FL/FR/RL/RR
- Provide material controls:
  - body color
  - trim color
  - glass transparency
  - neon/headlight color
- Save a `VehicleFitmentConfig` table with:
  - source asset name
  - transform offset from `DriveSeat`
  - scale
  - hidden part paths
  - material overrides
  - wheel visual policy

## Runtime Rules

The final game should not guess scale or orientation every time the player spawns a car. Runtime should only clone a finished car template or apply a saved, reviewed fitment config.

The editor can be messy and interactive. The shipped car must be deterministic.

## Proposed Data Shape

```lua
return {
    Id = "bmw-m4csl",
    DisplayName = "BMW M4 CSL",
    ChassisTemplate = "TestCar",
    VisualAsset = "BMW_M4CSL_BODY_READY_COLORED",
    DriveSeatOffset = {
        Position = { X = 0, Y = 0.35, Z = 0 },
        Rotation = { X = 0, Y = 0, Z = 0 },
        Scale = 1.0,
    },
    HiddenPartPaths = {
        "Wheels",
        "Tires",
    },
    MaterialOverrides = {
        Body = {
            Match = { "body", "paint", "mesh" },
            Color = { R = 235, G = 235, B = 230 },
            Material = "SmoothPlastic",
        },
        Glass = {
            Match = { "glass", "window", "windshield" },
            Color = { R = 30, G = 45, B = 55 },
            Transparency = 0.35,
            Material = "Glass",
        },
        Carbon = {
            Match = { "carbon", "hood", "roof", "trim" },
            Color = { R = 10, G = 10, B = 12 },
            Material = "SmoothPlastic",
        },
    },
    WheelPolicy = "UseChassisWheels",
}
```

## Implementation Plan

### Phase 1: Studio-Assisted Fitment

- Add `VehicleFitmentService` server-side.
- Add `VehicleFitmentEditor` client UI opened from the garage.
- Use sliders/buttons for transform offsets.
- Save current config as printed Lua in Output, so it can be copied into `src/shared/config/VehicleFitmentConfig.lua`.

### Phase 2: Saved Config Application

- Add `VehicleVisualMountService` that applies a saved config to `Workspace.TestCar`.
- Remove experimental runtime guessing from `BmwVisualAttachService` permanently.
- Add one reviewed config for BMW M4 CSL.

### Phase 3: Final Template Baking

- After the fitment is approved, save the assembled model as `.rbxm/.rbxmx`.
- Register it under `assets/vehicles`.
- Change `GarageConfig` so the BMW spawns as a real catalog car instead of a loose test visual.

## Why This Is How Real Teams Do It

Game teams separate asset import, fitment, and runtime spawning:

- Import/conversion is a pipeline problem.
- Fitment is an editor/tooling problem.
- Driving is a gameplay/runtime problem.

Trying to solve all three with one runtime script creates sideways cars, wrong wheels, broken scale, and gray materials. The garage editor turns the ugly imported model into a controlled production asset before players ever see it.
