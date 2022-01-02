--!nolint UninitializedLocal
local RS = game:GetService("ReplicatedStorage")

local Utils = require(RS.Utils)
local _S = Utils.Services

local weapon;
local player = _S.Players.LocalPlayer
local playerChar = player.Character or player.CharacterAdded:Wait()
local playerHum = playerChar:WaitForChild("Humanoid", 60)
local jumps = 3


local function onStateChanged(_, state)
	if state ~= Enum.HumanoidStateType.Landed then return end

	jumps = 3
end


local function onJump(action, state, input)
	if state ~= Enum.UserInputState.Begin or jumps <= 0 then return Enum.ContextActionResult.Sink end

	jumps -= 1

	playerHum:ChangeState(Enum.HumanoidStateType.Jumping)
end


local function onLightAttack(action, state, input)
	if state ~= Enum.UserInputState.Begin then return Enum.ContextActionResult.Sink end

	print("Light")
	task.wait(0.4)
end


local function onHeavyAttack(action, state, input)
	if state ~= Enum.UserInputState.Begin then return Enum.ContextActionResult.Sink end

	print("Heavy")
	task.wait(0.7)
end


local function onDodge(action, state, input)
	if state ~= Enum.UserInputState.Begin then return Enum.ContextActionResult.Sink end

	print("Dodge")

	local duration = 2

	if playerHum:GetState() == Enum.HumanoidStateType.Freefall then
		duration = 4
	end

	task.wait(duration)
end


local function onEquipOrThrow(action, state, input)
	if state ~= Enum.UserInputState.Begin then return Enum.ContextActionResult.Sink end

	if weapon then
		print("Throw")
	else
		print("Equip")
	end
end


playerHum.StateChanged:Connect(onStateChanged)
_S.ContextActionService:BindAction("Jump", Utils.debounce(onJump, Enum.ContextActionResult.Sink), false, Enum.KeyCode.Space)
_S.ContextActionService:BindAction("LightAttack", Utils.debounce(onLightAttack, Enum.ContextActionResult.Sink), false, Enum.KeyCode.J)
_S.ContextActionService:BindAction("HeavyAttack", Utils.debounce(onLightAttack, Enum.ContextActionResult.Sink), false, Enum.KeyCode.K)
_S.ContextActionService:BindAction("Dodge", Utils.debounce(onLightAttack, Enum.ContextActionResult.Sink), false, Enum.KeyCode.L)
_S.ContextActionService:BindAction("EquipOrThrow", Utils.debounce(onLightAttack, Enum.ContextActionResult.Sink), false, Enum.KeyCode.H)
