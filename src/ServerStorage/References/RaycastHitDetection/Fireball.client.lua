local RS = game:GetService("ReplicatedStorage")

local Utils = require(RS.Utils)
local _S = Utils.Services

local player = _S.Players.LocalPlayer
local playerChar = player.Character or player.CharacterAdded:Wait()
local playerHead = playerChar:WaitForChild("Head", 60)
local playerMouse = player:GetMouse()
      playerMouse.TargetFilter = workspace:WaitForChild("Projectiles", 60)
local Fireball = Utils.waitForDescendant(RS, "Fireball")


local function onCastMagic(action, state, input)
    if state ~= Enum.UserInputState.Begin then return end

    if action == "Fireball" then
        Fireball:FireServer(playerMouse.Hit.p)
        --task.wait(5)
    end
end


_S.ContextActionService:BindAction("Fireball", Utils.debounce(onCastMagic), false, Enum.KeyCode.F)
