local DSS = game:GetService("DataStoreService")
local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Run = game:GetService("RunService")

local Utils = require(RS.Utils)

local RETRY_COUNT = 2
local DEFAULT_PLAYER_DATA = {}
local keys = {}
local DataStore = DSS:GetDataStore("${0:name}")


local function createPlayerData(key, playerData)
    -- physically create the player's data/represent it how you wish

end


local function getPlayerData(key): table
    -- grab and return the player's data in a table for saving

end


local function retry(callback, ...)
    local success, result;

    for _ = 1, RETRY_COUNT do
        success, result = pcall(callback, ...)

        if success then break end
    end

    return success, result
end


local function onPlayerAdded(player)
    local key = player.UserId
    local success, playerData = retry(DataStore.GetAsync, DataStore, key)
    keys[player] = key

    if not (success or playerData) then
        local message = string.format('Could not load %s\'s data with key "%s" (%s)', player.Name, key, typeof(key))

        return warn(message)
    elseif success then
        playerData = DEFAULT_PLAYER_DATA

        retry(DataStore.SetAsync, DataStore, key, playerData)
    end

    createPlayerData(key, playerData)
end


local function onPlayerRemoving(player)
    local key = keys[player]
    local playerData = getPlayerData(key)
    keys[player] = nil

    retry(DataStore.UpdateAsync, DataStore, key, function(currentData)
        return playerData
    end)
end


game:BindToClose(function()
    Utils.map(Players:GetPlayers(), onPlayerRemoving)
end)


if Run:IsStudio() then
    Utils.map(Players:GetPlayers(), onPlayerAdded)
end

Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)
