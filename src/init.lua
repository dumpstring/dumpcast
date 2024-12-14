local Ceive = require(script.Ceive)

local rendering : {{
	type: "raycast" | "spherecast" | "capsulecast" | "shapecast" | "boxcast" | "circlecast",
	origin: Vector3,
	direction: Vector3,
	result: RaycastResult?,
	radius: number?,
	framesrendered: number,
	capsuleheight: number?,
	transform: CFrame?,
	shapesize: Vector3?,
	points: number?,
	config: config,
}} = {}

export type config = {
	visenabled: boolean,
	lifetime: number,
	alwaysontop: boolean,
	arrowsize: number,
	arrowquality: number,
	normalplanesize: number,
	
	spherequality: number,
	
	capsulecastresolution: number,
	
	failcolor: Color3,
	successcolor: Color3,
}

local configbase = {
	visenabled = true,
	lifetime = 1,
	alwaysontop = true,

	arrowsize = 0.25,
	arrowquality = 12,
	normalplanesize = 1,
	
	capsulecastresolution = 0.25,

	spherequality = 12,

	failcolor = Color3.new(1, 0, 0),
	successcolor = Color3.new(0, 1, 0)
}

local function render()
	for i, v in ipairs(rendering) do
		if v.framesrendered > v.config.lifetime then
			table.remove(rendering, table.find(rendering, v))
			continue
		end
		
		if not v.config.visenabled then
			v.framesrendered += 1
			continue
		end
		Ceive.PushProperty("AlwaysOnTop", v.config.alwaysontop)
		if v.type == "raycast" then
			local hitLength = v.direction.Magnitude
			if v.result then
				Ceive.PushProperty("Color3", v.config.successcolor)
				hitLength = (v.origin - v.result.Position).Magnitude

				Ceive.Plane:Draw(v.result.Position, v.result.Normal, Vector3.new(v.config.normalplanesize, v.config.normalplanesize, 0))
				Ceive.Arrow:Draw(v.origin, v.origin + (v.direction.Unit * hitLength), v.config.arrowsize, v.config.arrowsize, v.config.arrowquality)
			else
				Ceive.PushProperty("Color3", v.config.failcolor)
				Ceive.Arrow:Draw(v.origin, v.origin + (v.direction.Unit * hitLength), v.config.arrowsize, v.config.arrowsize, v.config.arrowquality)
			end
		end
		if v.type == "spherecast" then
			local hitLength = v.direction.Magnitude
			if v.result then
				Ceive.PushProperty("Color3", v.config.successcolor)
				hitLength = v.result.Distance + v.radius

				Ceive.Arrow:Draw(v.origin, v.direction.Unit * hitLength + v.origin, v.config.arrowsize, v.config.arrowsize, v.config.arrowquality)
				Ceive.Capsule:Draw(CFrame.new(v.origin + v.direction.Unit * (hitLength - v.radius)), v.radius, 0, v.config.spherequality, 360)
				Ceive.Plane:Draw(v.result.Position, v.result.Normal, Vector3.new(v.config.normalplanesize, v.config.normalplanesize, 0))
			else
				Ceive.PushProperty("Color3", v.config.failcolor)

				Ceive.Arrow:Draw(v.origin, v.direction + v.origin, v.config.arrowsize, v.config.arrowsize, v.config.arrowquality)
				Ceive.Capsule:Draw(CFrame.new(v.origin + v.direction.Unit * hitLength), v.radius, 0, v.config.spherequality, 360)
			end
		end
		if v.type == "capsulecast" then
			local hitLength = v.direction.Magnitude
			
			if v.result then
				Ceive.PushProperty("Color3", v.config.successcolor)
				hitLength = v.result.Distance
				
				Ceive.Arrow:Draw(v.transform.Position, v.direction.Unit * hitLength + v.transform.Position, v.config.arrowsize, v.config.arrowsize, v.config.arrowquality)
				Ceive.Capsule:Draw(v.transform + v.direction.Unit * hitLength, v.radius, v.capsuleheight, v.config.spherequality)
				Ceive.Plane:Draw(v.result.Position, v.result.Normal, Vector3.new(v.config.normalplanesize, v.config.normalplanesize, 0))
			else
				Ceive.PushProperty("Color3", v.config.failcolor)
				
				Ceive.Arrow:Draw(v.transform.Position, v.direction.Unit * hitLength + v.transform.Position, v.config.arrowsize, v.config.arrowsize, v.config.arrowquality)
				Ceive.Capsule:Draw(v.transform + v.direction.Unit * hitLength, v.radius, v.capsuleheight, v.config.spherequality)
			end
			
		end
		if v.type == "shapecast" or v.type == "boxcast" then
			local hitLength = v.direction.Magnitude
			
			if v.result then
				Ceive.PushProperty("Color3", v.config.successcolor)
				hitLength = v.result.Distance
				
				Ceive.Arrow:Draw(v.transform.Position, v.direction.Unit * hitLength + v.transform.Position, v.config.arrowsize, v.config.arrowsize, v.config.arrowquality)
				Ceive.Box:Draw(v.transform + v.direction.Unit * hitLength, v.shapesize, true)
				Ceive.Text:Draw(v.transform.Position + v.direction.Unit * hitLength, v.type, 10)
				Ceive.Plane:Draw(v.result.Position, v.result.Normal, Vector3.new(v.config.normalplanesize, v.config.normalplanesize, 0))
			else
				Ceive.PushProperty("Color3", v.config.failcolor)

				Ceive.Arrow:Draw(v.transform.Position, v.direction.Unit * hitLength + v.transform.Position, v.config.arrowsize, v.config.arrowsize, v.config.arrowquality)
				Ceive.Box:Draw(v.transform + v.direction.Unit * hitLength, v.shapesize, true)
				Ceive.Text:Draw(v.transform.Position + v.direction.Unit * hitLength, v.type, 10)
			end
		end
		if v.type == "circlecast" then
			local hitLength = v.direction.Magnitude

			if v.result then
				Ceive.PushProperty("Color3", v.config.successcolor)
				hitLength = v.result.Distance

				Ceive.Arrow:Draw(v.origin, v.direction.Unit * hitLength + v.origin , v.config.arrowsize, v.config.arrowsize, v.config.arrowquality)
				Ceive.Circle:Draw(CFrame.new(v.origin, v.origin + v.direction) + v.direction.Unit * hitLength, v.radius, v.points - 0.5, 360)
				Ceive.Plane:Draw(v.result.Position, v.result.Normal, Vector3.new(v.config.normalplanesize, v.config.normalplanesize, 0))
			else
				Ceive.PushProperty("Color3", v.config.failcolor)

				Ceive.Circle:Draw(CFrame.new(v.origin, v.origin + v.direction.Unit) + v.direction.Unit * hitLength, v.radius, v.points - 0.5, 360)
				Ceive.Arrow:Draw(v.origin, v.direction.Unit * hitLength + v.origin , v.config.arrowsize, v.config.arrowsize, v.config.arrowquality)
			end
		end

		v.framesrendered += 1
	end
end

if game:GetService("RunService"):IsClient() then
	game:GetService("RunService").RenderStepped:Connect(render)
else
	game:GetService("RunService").Heartbeat:Connect(render)
end

local dumpcast = {}

local Caster = {}

function Caster:Raycast(origin: Vector3, direction: Vector3, rayparams: RaycastParams, overrideconfig: config?): RaycastResult?
	if not overrideconfig then
		overrideconfig = self.Config
	else
		local b = table.clone(self.Config)
		for i, v in pairs(overrideconfig) do
			b[i] = v
		end
		overrideconfig = b
	end
	local res = (self.World :: WorldRoot):Raycast(origin, direction, rayparams)
	local data = {
		type = "raycast",
		origin = origin,
		direction = direction,
		result = res,
		config = overrideconfig,
		framesrendered = 0
	}
	table.insert(rendering, data)
	return res
end

function Caster:Spherecast(origin: Vector3, radius: number, direction: Vector3, rayparams: RaycastParams, overrideconfig: config?): RaycastResult?
	if not overrideconfig then
		overrideconfig = self.Config
	else
		local b = table.clone(self.Config)
		for i, v in pairs(overrideconfig) do
			b[i] = v
		end
		overrideconfig = b
	end
	local res = (self.World :: WorldRoot):Spherecast(origin, radius, direction, rayparams)
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
	return res
end

function Caster:Shapecast(part: BasePart, direction: Vector3, rayparams: RaycastParams, overrideconfig: config?): RaycastResult?
	if not overrideconfig then
		overrideconfig = self.Config
	else
		local b = table.clone(self.Config)
		for i, v in pairs(overrideconfig) do
			b[i] = v
		end
		overrideconfig = b
	end
	local res = (self.World :: WorldRoot):Shapecast(part, direction, rayparams)
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
	return res
end

function Caster:Boxcast(transform: CFrame, size: Vector3, direction: Vector3, rayparams: RaycastParams, overrideconfig: config?): RaycastResult?
	if not overrideconfig then
		overrideconfig = self.Config
	else
		local b = table.clone(self.Config)
		for i, v in pairs(overrideconfig) do
			b[i] = v
		end
		overrideconfig = b
	end
	
	local castpart = Instance.new("Part")
	castpart.Transparency = 1
	castpart.CanCollide = false
	castpart.CanQuery = false
	castpart.CanTouch = false
	castpart.Anchored = true
	castpart.Locked = true
	
	castpart.Name = "dumpcast_BoxcastPart"
	castpart.CFrame = transform
	castpart.Size = size
	
	local res = (self.World :: WorldRoot):Shapecast(castpart, direction, rayparams)
	castpart:Destroy()
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

function Caster:CircleCast(origin: Vector3, radius: number, points: number, direction: Vector3, rayparams: RaycastParams, overrideconfig: config?): RaycastResult?
	if not overrideconfig then
		overrideconfig = self.Config
	else
		local b = table.clone(self.Config)
		for i, v in pairs(overrideconfig) do
			b[i] = v
		end
		overrideconfig = b
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

	return closestHitResult
end

function Caster:Capsulecast(transform: CFrame, height: number, radius: number, direction: Vector3, rayparams: RaycastParams, overrideconfig: config?): RaycastResult?
	local config = overrideconfig or self.Config
	if overrideconfig and overrideconfig ~= self.Config then
		config = table.clone(self.Config)
		for i, v in pairs(overrideconfig) do
			config[i] = v
		end
	end

	local resolution = config.capsulecastresolution or 3
	local length = direction.Magnitude

	local halfHeight = height / 2
	local capsuleUp = transform.UpVector
	local capsuleOrigin = transform.Position
	local startPoint = capsuleOrigin - capsuleUp * halfHeight
	local endPoint = capsuleOrigin + capsuleUp * halfHeight

	local stepCount = math.max(1, math.ceil(length * resolution))
	local stepSize = 1 / stepCount

	local closestHit = nil
	local closestDistance = math.huge

	for i = 0, stepCount do
		local t = i / stepCount
		local currentOrigin = startPoint:Lerp(endPoint, t)

		local res = (self :: WorldRoot):Spherecast(currentOrigin, radius, direction, rayparams)

		if res and res.Distance < closestDistance then
			closestHit = res
			closestDistance = res.Distance

			if config.strictFirstHit then
				break
			end
		end
	end

	local data = {
		type = "capsulecast",
		direction = direction,
		result = closestHit,
		radius = radius,
		capsuleheight = height,
		transform = transform,
		config = config,
		framesrendered = 0
	}
	table.insert(rendering, data)

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

	self.World = world or workspace
	self.Config = config

	return self
end

return dumpcast