local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local DEFAULT_TWEEN_INFO = TweenInfo.new()
local PROJECTILES = workspace:WaitForChild("Projectiles")
local FireballEvent = ReplicatedStorage:WaitForChild("Fireball")

-- copied over because lazy
function isOneOf(instance: Instance, ...: string): boolean
	for _, className in { ... } do
		if instance:IsA(className) then
			return true
		end
	end

	return false
end

local function onFireballEvent(player: Player, direction: Vector3)
	local connection, tween
	local playerChar = player.Character
	local fireball = playerChar.Head:Clone()
	fireball.CanCollide = false
	fireball.CFrame = CFrame.new(fireball.Position, direction)
	local mover = Instance.new("BodyVelocity")
	mover.Velocity = fireball.CFrame.lookVector * 40

	for _, child in ipairs(fireball:GetChildren()) do
		if not isOneOf(child, "Decal", "Mesh") then
			child:Destroy()
		end
	end

	local start = time()

	connection = RunService.Heartbeat:Connect(function(delta)
		if time() - start >= 5 then
			connection:Disconnect()
		end

		local origin = fireball.CFrame
		local raycastParams = RaycastParams.new()
		raycastParams.FilterDescendantsInstances = { PROJECTILES, playerChar }
		raycastParams.FilterType = Enum.RaycastFilterType.Exclude
		local result = workspace:Raycast(origin.p, origin.p + mover.Velocity * delta, raycastParams)

		if result then
			connection:Disconnect()

			local faceFound = fireball:FindFirstChild("face")
			local humanoidFound = result.Instance.Parent:FindFirstChild("Humanoid")
			mover.Velocity = Vector3.new(0, 0, 0)
			tween = TweenService:Create(fireball, DEFAULT_TWEEN_INFO, {
				Size = fireball.Size * 2.5,
				Transparency = 1,
			})

			if humanoidFound and humanoidFound ~= playerChar.Humanoid then
				humanoidFound:TakeDamage(10)
			end

			tween:Play()

			if faceFound then
				local faceTween = TweenService:Create(fireball.face, DEFAULT_TWEEN_INFO, {
					Transparency = 1,
				})

				faceTween:Play()
			end
		end
	end)

	mover.Parent = fireball
	fireball.Parent = PROJECTILES

	fireball:SetNetworkOwner(player)
	task.wait(5)

	if tween and tween.PlaybackState == Enum.PlaybackState.Playing then
		tween.Completed:Wait()
	end

	fireball:Destroy()
end

FireballEvent.OnServerEvent:Connect(onFireballEvent)
