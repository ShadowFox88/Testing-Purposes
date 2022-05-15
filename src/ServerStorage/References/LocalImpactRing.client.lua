local RS = game:GetService("ReplicatedStorage")

local Utils = require(RS.Utils)
local _S = Utils.Services

local player = _S.Players.LocalPlayer
local playerChar = player.Character or player.CharacterAdded:Wait()


local function getRandomAngles()
    local angles = {}

    for i = 1, 3 do
        table.insert(angles, math.rad(math.random(-180, 180)))
    end

    return CFrame.Angles(table.unpack(angles))
end


local function getOffset(origin)
    local direction = Vector3.new(0, -3, 0)
    local result = workspace:Raycast(origin.Position, direction)

    if not result then
        return CFrame.new(0, 0, 0)
    end

    return CFrame.new(direction)
end


local function onInputBegan(input, inGui)
    if input.KeyCode ~= Enum.KeyCode.J or input.UserInputState ~= Enum.UserInputState.Begin or inGui then return end

    local origin = playerChar.PrimaryPart.CFrame
    local offset = getOffset(origin)

    for i = 1, 360 do
        local part = Instance.new("Part")
        part.Anchored = true
        part.CFrame = origin * offset
            * CFrame.Angles(0, math.rad(i), 0)
            * CFrame.new(0, 0, -10)
            * getRandomAngles()
        part.Parent = workspace
    end
end


_S.UserInputService.InputBegan:Connect(Utils.debounce(onInputBegan))
