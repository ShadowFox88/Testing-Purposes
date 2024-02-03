local ContextActionService = game:GetService("ContextActionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerMouse = player:GetMouse()
playerMouse.TargetFilter = workspace:WaitForChild("Projectiles", 60)
local Fireball: RemoteEvent = ReplicatedStorage:WaitForChild("Fireball")

-- defined here because lazy
local function debounce(callback)
	local running = false

	return function(...)
		if running then
			return
		end

		running = true
		local result = callback(...)
		running = false

		return result
	end
end

local function onCastMagic(action, state, input)
	if state ~= Enum.UserInputState.Begin then
		return
	end

	if action == "Fireball" then
		Fireball:FireServer(playerMouse.Hit.p)
		--task.wait(5)
	end
end

ContextActionService:BindAction("Fireball", debounce(onCastMagic), false, Enum.KeyCode.F)
