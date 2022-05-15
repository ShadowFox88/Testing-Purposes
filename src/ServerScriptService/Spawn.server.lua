local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local Utils = require(ReplicatedStorage.Utils)
local attributes = {
    ["Boolean"] = "Blocking"
}


function createInstanceValue(type, name, parent)
    local className = string.format("%sValue", type)
    local resource = Instance.new(className)
          resource.Parent = parent
end


local function onPlayerAdded(player)
    local playerChar = player.Character or player.CharacterAdded:Wait()

    for type, data in pairs(attributes) do
        data = if typeof(data) == "table" then data else {data}

        Utils.map(data, function(value, key, table)

        end)
    end
end


Players.PlayerAdded:Connect(onPlayerAdded)
