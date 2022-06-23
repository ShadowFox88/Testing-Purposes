local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Utils = require(ReplicatedStorage.Utils)

local TWEEN_INFO = TweenInfo.new()


local function createVanishTween(instance: Instance)
    local tween = TweenService:Create(instance, TWEEN_INFO, {
        Transparency = 1
    })

    tween:Play()
end


local function behead(player: Player)
    local playerChar = player.Character
    local playerHead: BasePart = playerChar.Head
    local playerFace: Decal = playerHead.face
    local levitate = TweenService:Create(playerHead.Neck, TWEEN_INFO, {
        C0 = playerHead.Neck.C0 * CFrame.new(0, 1, 0)
    })
    local vanishingTweens = {
        TweenService:Create(playerHead, TWEEN_INFO, {
            Transparency = 1
        }),
        TweenService:Create(playerFace, TWEEN_INFO, {
            Transparency = 1
        })
    }

    for _, child in ipairs(player.Character:GetChildren()) do
        local isAccessory = child:IsA("Accessory")
        if not (isAccessory or child:IsA("Decal")) then continue end

        if isAccessory then
            child = child.Handle
        end

        local tween = createVanishTween(child)

        table.insert(vanishingTweens, tween)
    end

    for _, tween in ipairs(vanishingTweens) do
        tween:Play()
    end

    levitate:Play()
    task.wait(TWEEN_INFO.Time)

    playerChar:BreakJoints()
end


return function(_, targets)
    if #targets == 0 then return "No players to behead." end

    Utils.map(targets, behead)

    return "Beheaded players."
end
