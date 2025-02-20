# dumpcast

custom raycast types & raycast visualization for roblox.

## installation

get the latest release from:
- [github releases](https://github.com/dumpstring/dumpcast/releases/latest)
- build it yourself using rojo: `rojo build -o dumpcast.rbxm`

& add it to your game via roblox studio drag & drop.

## usage

note: raycast visualizations on on server are not replicated to client.

```lua
local dumpcast = require(path.to.dumpcast)
local Caster = dumpcast.new(workspace)
```

you can replace any existing casts in your scripts to use the caster instance provided by dumpcast, as its backwards-compatible with the existing worldroot cast functions.

## configuration options

these config options are not required, however visualization of casts is enabled by default.
if you wish to disable visualization, you can create a caster instance with VisualizeCast set to false:
```lua
local Caster = dumpcast.new(workspace, {VisualizeCast = false})
```

```lua
type config = {
    VisualizeCast: boolean,     -- enable/disable cast visualization
    VisLifetime: number,        --[[ visualization duration
    (measured in steps, uses dumpcast.StepSignal connection for each step.) ]]
    VisAlwaysOnTop: boolean,    -- render visualization above other objects
    VisArrowSize: number,       -- size of visualization arrow
    VisShapeQuality: number,    -- detail level of visualization (arrow, capsule, etc.)
    VisNormalPlaneSize: number, -- size of normal plane visualization
    
    VisRenderSignal: RBXScriptSignal --[[ the signal which is used for rendering visuals.
    (default: client > RenderStepped, server > Heartbeat)]]

    FailColor: Color3,          -- color for failed casts
    SuccessColor: Color3        -- color for successful casts
}
```

`dumpcast.StepSignal` - A property from dumpcast-1.1.0 - dumpcast 1.2.2

## caster methods

### Raycast

```lua
function Caster:Raycast(
    origin: Vector3, 
    direction: Vector3, 
    rayparams: RaycastParams, 
    overrideconfig?: config
): RaycastResult?
```

### Spherecast

```lua
function Caster:Spherecast(
    origin: Vector3, 
    radius: number, 
    direction: Vector3, 
    rayparams: RaycastParams, 
    overrideconfig?: config
): RaycastResult?
```

### Shapecast

```lua
function Caster:Shapecast(
    part: BasePart, 
    direction: Vector3, 
    rayparams: RaycastParams, 
    overrideconfig?: config
): RaycastResult?
```

### Blockcast

```lua
function Caster:Blockcast(
    transform: CFrame, 
    size: Vector3, 
    direction: Vector3, 
    rayparams: RaycastParams, 
    overrideconfig?: config
): RaycastResult?
```

### Circlecast

```lua
function Caster:Circlecast(
    origin: Vector3, 
    radius: number, 
    points: number, 
    direction: Vector3, 
    rayparams: RaycastParams, 
    overrideconfig?: config
): RaycastResult?
```

### Cylindercast

```lua
function Caster:Cylindercast(
    transform: CFrame, 
    height: number, 
    radius: number, 
    direction: Vector3, 
    rayparams: RaycastParams, 
    overrideconfig?: config
): RaycastResult?
```

### Capsulecast

```lua
function Caster:Capsulecast(
    transform: CFrame, 
    height: number, 
    radius: number, 
    direction: Vector3, 
    rayparams: RaycastParams, 
    overrideconfig?: config
): RaycastResult?
```
note: the height for the capsule is not the same as the height of the capsule used in the cast. it is actually the `height + 2 * radius` 

# [LICENSE](https://github.com/dumpstring/dumpcast/blob/main/LICENSE)