local RS = game:GetService("ReplicatedStorage")

local Tycoon = require(RS.Tycoon)

local tycoons = Tycoon.init(workspace.Tycoons)

if not game:IsLoaded() then
    game.Loaded:Wait()
end

while true do
    for _, tycoon in ipairs(tycoons) do
        print(tycoon.Owner)
    end

    task.wait(1)
end
