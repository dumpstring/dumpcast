--!native

local Ceive = require(script.Ceive)

local rendering : {{
	type: "raycast" | "spherecast" | "capsulecast" | "shapecast" | "boxcast" | "circlecast" | "cylindercast",
	origin: Vector3,
	direction: Vector3,
	result: RaycastResult?,
	radius: number?,
	framesrendered: number,
	height: number?,
	transform: CFrame?,
	shapesize: Vector3?,
	points: number?,
	config: config,
}} = {}

export type config = {
	VisualizeCast: boolean,
	VisLifetime: number,
	VisAlwaysOnTop: boolean,
	VisArrowSize: number,
	VisShapeQuality: number,
	VisNormalPlaneSize: number,

	FailColor: Color3,
	SuccessColor: Color3,
}

local configbase = {
	VisualizeCast = true,
	VisLifetime = 1,
	VisAlwaysOnTop = true,

	VisArrowSize = 0.25,
	VisShapeQuality = 12,
	VisNormalPlaneSize = 1,

	FailColor = Color3.new(1, 0, 0),
	SuccessColor = Color3.new(0, 1, 0)
}


local function render()
	for i, v in ipairs(rendering) do
		if v.framesrendered > v.config.VisLifetime then
			table.remove(rendering, table.find(rendering, v))
			continue
		end

		Ceive.PushProperty("VisAlwaysOnTop", v.config.VisAlwaysOnTop)
		if v.type == "raycast" then
			local hitLength = v.direction.Magnitude
			if v.result then
				Ceive.PushProperty("Color3", v.config.SuccessColor)
				hitLength = (v.origin - v.result.Position).Magnitude

				Ceive.Plane:Draw(v.result.Position, v.result.Normal, Vector3.new(v.config.VisNormalPlaneSize, v.config.VisNormalPlaneSize, 0))
				Ceive.Arrow:Draw(v.origin, v.origin + (v.direction.Unit * hitLength), v.config.VisArrowSize, v.config.VisArrowSize, v.config.VisShapeQuality)
			else
				Ceive.PushProperty("Color3", v.config.FailColor)
				Ceive.Arrow:Draw(v.origin, v.origin + (v.direction.Unit * hitLength), v.config.VisArrowSize, v.config.VisArrowSize, v.config.VisShapeQuality)
			end
		end
		if v.type == "spherecast" then
			local hitLength = v.direction.Magnitude
			if v.result then
				Ceive.PushProperty("Color3", v.config.SuccessColor)
				hitLength = v.result.Distance + v.radius

				Ceive.Arrow:Draw(v.origin, v.direction.Unit * hitLength + v.origin, v.config.VisArrowSize, v.config.VisArrowSize, v.config.VisShapeQuality)
				Ceive.Capsule:Draw(CFrame.new(v.origin + v.direction.Unit * (hitLength - v.radius)), v.radius, 0, v.config.VisShapeQuality, 360)
				Ceive.Plane:Draw(v.result.Position, v.result.Normal, Vector3.new(v.config.VisNormalPlaneSize, v.config.VisNormalPlaneSize, 0))
			else
				Ceive.PushProperty("Color3", v.config.FailColor)

				Ceive.Arrow:Draw(v.origin, v.direction + v.origin, v.config.VisArrowSize, v.config.VisArrowSize, v.config.VisShapeQuality)
				Ceive.Capsule:Draw(CFrame.new(v.origin + v.direction.Unit * hitLength), v.radius, 0, v.config.VisShapeQuality, 360)
			end
		end
		if v.type == "capsulecast" then
			local hitLength = v.direction.Magnitude

			if v.result then
				Ceive.PushProperty("Color3", v.config.SuccessColor)
				hitLength = v.result.Distance

				Ceive.Arrow:Draw(v.transform.Position, v.direction.Unit * hitLength + v.transform.Position, v.config.VisArrowSize, v.config.VisArrowSize, v.config.VisShapeQuality)
				Ceive.Capsule:Draw(v.transform + v.direction.Unit * hitLength, v.radius, v.height, v.config.VisShapeQuality)
				Ceive.Plane:Draw(v.result.Position, v.result.Normal, Vector3.new(v.config.VisNormalPlaneSize, v.config.VisNormalPlaneSize, 0))
			else
				Ceive.PushProperty("Color3", v.config.FailColor)

				Ceive.Arrow:Draw(v.transform.Position, v.direction.Unit * hitLength + v.transform.Position, v.config.VisArrowSize, v.config.VisArrowSize, v.config.VisShapeQuality)
				Ceive.Capsule:Draw(v.transform + v.direction.Unit * hitLength, v.radius, v.height, v.config.VisShapeQuality)
			end

		end
		if v.type == "shapecast" or v.type == "boxcast" then
			local hitLength = v.direction.Magnitude

			if v.result then
				Ceive.PushProperty("Color3", v.config.SuccessColor)
				hitLength = v.result.Distance

				Ceive.Arrow:Draw(v.transform.Position, v.direction.Unit * hitLength + v.transform.Position, v.config.VisArrowSize, v.config.VisArrowSize, v.config.VisShapeQuality)
				Ceive.Box:Draw(v.transform + v.direction.Unit * hitLength, v.shapesize, false)
				Ceive.Text:Draw(v.transform.Position + v.direction.Unit * hitLength, v.type, 10)
				Ceive.Plane:Draw(v.result.Position, v.result.Normal, Vector3.new(v.config.VisNormalPlaneSize, v.config.VisNormalPlaneSize, 0))
			else
				Ceive.PushProperty("Color3", v.config.FailColor)

				Ceive.Arrow:Draw(v.transform.Position, v.direction.Unit * hitLength + v.transform.Position, v.config.VisArrowSize, v.config.VisArrowSize, v.config.VisShapeQuality)
				Ceive.Box:Draw(v.transform + v.direction.Unit * hitLength, v.shapesize, false)
				Ceive.Text:Draw(v.transform.Position + v.direction.Unit * hitLength, v.type, 10)
			end
		end
		if v.type == "circlecast" then
			local hitLength = v.direction.Magnitude

			if v.result then
				Ceive.PushProperty("Color3", v.config.SuccessColor)
				hitLength = v.result.Distance

				Ceive.Arrow:Draw(v.origin, v.direction.Unit * hitLength + v.origin , v.config.VisArrowSize, v.config.VisArrowSize, v.config.VisShapeQuality)
				Ceive.Circle:Draw(CFrame.new(v.origin, v.origin + v.direction) + v.direction.Unit * hitLength, v.radius, v.points - 0.5, 360)
				Ceive.Plane:Draw(v.result.Position, v.result.Normal, Vector3.new(v.config.VisNormalPlaneSize, v.config.VisNormalPlaneSize, 0))
			else
				Ceive.PushProperty("Color3", v.config.FailColor)

				Ceive.Circle:Draw(CFrame.new(v.origin, v.origin + v.direction.Unit) + v.direction.Unit * hitLength, v.radius, v.points - 0.5, 360)
				Ceive.Arrow:Draw(v.origin, v.direction.Unit * hitLength + v.origin , v.config.VisArrowSize, v.config.VisArrowSize, v.config.VisShapeQuality)
			end
		end

		if v.type == "cylindercast" then
			local hitLength = v.direction.Magnitude

			if v.result then
				Ceive.PushProperty("Color3", v.config.SuccessColor)
				hitLength = v.result.Distance

				Ceive.Arrow:Draw(v.transform.Position, v.direction.Unit * hitLength + v.transform.Position, v.config.VisArrowSize, v.config.VisArrowSize, v.config.VisShapeQuality)
				Ceive.Cylinder:Draw(v.transform + v.direction.Unit * hitLength, v.radius, v.height, v.config.VisShapeQuality)
				Ceive.Plane:Draw(v.result.Position, v.result.Normal, Vector3.new(v.config.VisNormalPlaneSize, v.config.VisNormalPlaneSize, 0))
			else
				Ceive.PushProperty("Color3", v.config.FailColor)

				Ceive.Arrow:Draw(v.transform.Position, v.direction.Unit * hitLength + v.transform.Position, v.config.VisArrowSize, v.config.VisArrowSize, v.config.VisShapeQuality)
				Ceive.Cylinder:Draw(v.transform + v.direction.Unit * hitLength, v.radius, v.height, v.config.VisShapeQuality)
			end

		end

		v.framesrendered += 1
	end
end

local dumpcast = {}

local Caster = {}

function Caster:Raycast(origin: Vector3, direction: Vector3, rayparams: RaycastParams, overrideconfig: config?): RaycastResult?
	overrideconfig = overrideconfig or self.Config
	if overrideconfig and overrideconfig ~= self.Config then
		overrideconfig = table.clone(self.Config)
		for i, v in pairs(overrideconfig) do
			overrideconfig[i] = v
		end
	end

	local res = (self.World :: WorldRoot):Raycast(origin, direction, rayparams)

	if overrideconfig.VisualizeCast then
		local data = {
			type = "raycast",
			origin = origin,
			direction = direction,
			result = res,
			config = overrideconfig,
			framesrendered = 0
		}
		table.insert(rendering, data)
	end
	return res
end

function Caster:Spherecast(origin: Vector3, radius: number, direction: Vector3, rayparams: RaycastParams, overrideconfig: config?): RaycastResult?
	overrideconfig = overrideconfig or self.Config
	if overrideconfig and overrideconfig ~= self.Config then
		overrideconfig = table.clone(self.Config)
		for i, v in pairs(overrideconfig) do
			overrideconfig[i] = v
		end
	end

	local res = (self.World :: WorldRoot):Spherecast(origin, radius, direction, rayparams)

	if overrideconfig.VisualizeCast then
		local data = {
			type = "spherecast",
			origin = origin,
			direction = direction,
			result = res,
			radius = radius,
			config = overrideconfig,
			framesrendered = 0
		}
		table.insert(rendering, data)
	end
	return res
end

function Caster:Shapecast(part: BasePart, direction: Vector3, rayparams: RaycastParams, overrideconfig: config?): RaycastResult?
	overrideconfig = overrideconfig or self.Config
	if overrideconfig and overrideconfig ~= self.Config then
		overrideconfig = table.clone(self.Config)
		for i, v in pairs(overrideconfig) do
			overrideconfig[i] = v
		end
	end

	local res = (self.World :: WorldRoot):Shapecast(part, direction, rayparams)

	if overrideconfig.VisualizeCast then
		local data = {
			type = "shapecast",
			transform = part.CFrame,
			direction = direction,
			result = res,
			shapesize = part.Size,
			config = overrideconfig,
			framesrendered = 0
		}
		table.insert(rendering, data)
	end
	return res
end

function Caster:Blockcast(transform: CFrame, size: Vector3, direction: Vector3, rayparams: RaycastParams, overrideconfig: config?): RaycastResult?
	overrideconfig = overrideconfig or self.Config
	if overrideconfig and overrideconfig ~= self.Config then
		overrideconfig = table.clone(self.Config)
		for i, v in pairs(overrideconfig) do
			overrideconfig[i] = v
		end
	end

	local res = (self.World :: WorldRoot):Blockcast(transform, size, direction, rayparams)

	if overrideconfig.VisualizeCast then
		local data = {
			type = "boxcast",
			transform = transform,
			direction = direction,
			result = res,
			shapesize = size,
			config = overrideconfig,
			framesrendered = 0
		}
		table.insert(rendering, data)
	end
end

function Caster:Circlecast(origin: Vector3, radius: number, points: number, direction: Vector3, rayparams: RaycastParams, overrideconfig: config?): RaycastResult?
	overrideconfig = overrideconfig or self.Config
	if overrideconfig and overrideconfig ~= self.Config then
		overrideconfig = table.clone(self.Config)
		for i, v in pairs(overrideconfig) do
			overrideconfig[i] = v
		end
	end

	local directionUnit = direction.Unit
	local angleStep = 2 * math.pi / points
	local closestHitResult
	local closestDistance = math.huge

	for i = 0, points - 1 do
		local angle = i * angleStep
		local offset = Vector3.new(math.cos(angle), 0, math.sin(angle)) * radius
		local startPoint = origin + offset
		local res = (self.World :: WorldRoot):Raycast(startPoint, direction, rayparams)

		if res then
			local hitDistance = (origin - res.Position).Magnitude
			if hitDistance < closestDistance then
				closestHitResult = res
				closestDistance = hitDistance
			end
		end
	end


	if overrideconfig.VisualizeCast then
		local data = {
			type = "circlecast",
			origin = origin,
			direction = direction,
			result = closestHitResult,
			points = points,
			radius = radius,
			config = overrideconfig,
			framesrendered = 0
		}
		table.insert(rendering, data)
	end

	return closestHitResult
end

function Caster:Cylindercast(transform: CFrame, height: number, radius: number, direction: Vector3, rayparams: RaycastParams, overrideconfig: config?): RaycastResult?
	overrideconfig = overrideconfig or self.Config
	if overrideconfig and overrideconfig ~= self.Config then
		overrideconfig = table.clone(self.Config)
		for i, v in pairs(overrideconfig) do
			overrideconfig[i] = v
		end
	end

	local cylinderPart = Instance.new("Part")
	cylinderPart.Shape = Enum.PartType.Cylinder
	cylinderPart.Size = Vector3.new(height, radius * 2, radius * 2)
	cylinderPart.CFrame = transform * CFrame.Angles(0, math.pi / 2, math.pi / 2)

	local cylinderResult = self.World:Shapecast(
		cylinderPart, 
		direction, 
		rayparams
	)

	cylinderPart:Destroy()


	if overrideconfig.VisualizeCast then
		local data = {
			type = "cylindercast",
			direction = direction,
			result = cylinderResult,
			radius = radius,
			height = height,
			transform = transform,
			config = overrideconfig,
			framesrendered = 0
		}
		table.insert(rendering, data)
	end

	return cylinderResult
end

function Caster:Capsulecast(transform: CFrame, height: number, radius: number, direction: Vector3, rayparams: RaycastParams, overrideconfig: config?): RaycastResult?
	overrideconfig = overrideconfig or self.Config
	if overrideconfig and overrideconfig ~= self.Config then
		overrideconfig = table.clone(self.Config)
		for i, v in pairs(overrideconfig) do
			overrideconfig[i] = v
		end
	end

	local halfHeight = height / 2
	local capsuleUp = transform.UpVector
	local capsuleOrigin = transform.Position
	local startPoint = capsuleOrigin - capsuleUp * halfHeight
	local endPoint = capsuleOrigin + capsuleUp * halfHeight

	local bottomCapResult = self.World:Spherecast(startPoint, radius, direction, rayparams) or false
	local topCapResult = self.World:Spherecast(endPoint, radius, direction, rayparams) or false

	local cylinderPart = Instance.new("Part")
	cylinderPart.Shape = Enum.PartType.Cylinder
	cylinderPart.Size = Vector3.new(height, radius * 2, radius * 2)
	cylinderPart.CFrame = transform * CFrame.Angles(0, math.pi / 2, math.pi / 2)

	local cylinderResult = self.World:Shapecast(
		cylinderPart, 
		direction, 
		rayparams
	) or false

	cylinderPart:Destroy()

	local closestHit = nil
	local closestDistance = math.huge

	local resultsToCheck = {bottomCapResult, topCapResult, cylinderResult}
	for _, res in ipairs(resultsToCheck) do
		if res and res.Distance < closestDistance then
			closestHit = res
			closestDistance = res.Distance
		end
	end


	if overrideconfig.VisualizeCast then
		local data = {
			type = "capsulecast",
			direction = direction,
			result = closestHit,
			radius = radius,
			height = height,
			transform = transform,
			config = overrideconfig,
			framesrendered = 0
		}
		table.insert(rendering, data)
	end

	return closestHit
end

function dumpcast.new(world: WorldRoot, config: config?): typeof(Caster)
	if not config then
		config = table.clone(configbase)
	else
		local b = table.clone(configbase)
		for i, v in pairs(config) do
			b[i] = v
		end
		config = b
	end
	local self = setmetatable({}, {__index = Caster})

	self.World = world
	self.Config = config

	return self
end

local dumpcastsignal = if game:GetService("RunService"):IsServer() then game:GetService("RunService").Heartbeat else game:GetService("RunService").RenderStepped
local dumpcastrender = dumpcastsignal:Connect(render)

setmetatable(dumpcast, {
	__index = function(self, index)
		if index == "StepSignal" then
			return dumpcastsignal
		end
		return
	end,
	__newindex = function(self, index, value)
		if index == "StepSignal" then
			local isSignal = false
			if typeof(value) == "RBXScriptSignal" then
				isSignal = true
			else
				local s, val = pcall(function()
					return type(value["Connect"]) == "function"
				end)

				isSignal = s and val
			end
			
			assert(isSignal, "invalid signal provided for property StepSignal of dumpcast.")

			dumpcastrender:Disconnect()
			dumpcastsignal = value
			dumpcastrender = dumpcastsignal:Connect(render)
			return
		end
		rawset(dumpcast, index, value)
	end,
	__tostring = "dumpcast"
})

export type dumpcast = {
	new: (world: WorldRoot, config: config?) -> typeof(Caster),
	StepSignal: RBXScriptSignal,
}

return (dumpcast :: dumpcast)