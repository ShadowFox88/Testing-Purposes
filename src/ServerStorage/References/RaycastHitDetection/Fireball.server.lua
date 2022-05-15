local RS = game:GetService("ReplicatedStorage")

local Utils = require(RS.Utils)
local _S = Utils.Services

local INDICATOR = _S.ServerStorage.Indicator
local DEFAULT_TWEEN_INFO = TweenInfo.new()
local TWEEN_INFO = TweenInfo.new(5)
local PROJECTILES = workspace:WaitForChild("Projectiles")
local FireballEvent = Utils.waitForDescendant(RS, "Fireball")


local function onFireballEvent(player, direction)
    local connection, tween;
    local playerChar = player.Character
    local fireball = playerChar.Head:Clone()
          fireball.CanCollide = false
          fireball.CFrame = CFrame.lookAt(fireball.Position, direction)
    local mover = Instance.new("BodyVelocity")
          mover.Velocity = fireball.CFrame.lookVector * 40

    for _, child in ipairs(fireball:GetChildren()) do
        if not Utils.isOneOf(child, "Decal", "Mesh") then
            child:Destroy()
        end
    end

    local start = time()

    connection = _S.RunService.Heartbeat:Connect(function(delta)
        if time() - start >= 5 then
            connection:Disconnect()
        end

        local origin = fireball.CFrame
        local raycastParams = RaycastParams.new()
              raycastParams.FilterDescendantsInstances = {PROJECTILES, playerChar}
              raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
        local result = workspace:Raycast(origin.p, origin.p + mover.Velocity * delta, raycastParams)

        if result then
            connection:Disconnect()

            local humanoidFound = result.Instance.Parent:FindFirstChild("Humanoid")
            mover.Velocity = Vector3.new(0, 0, 0)
            tween = _S.TweenService:Create(fireball, DEFAULT_TWEEN_INFO, {
                Size = fireball.Size * 2.5,
                Transparency = 1
            })
            local decalTween = _S.TweenService:Create(fireball.face, DEFAULT_TWEEN_INFO, {
                Transparency = 1
            })

            if humanoidFound and humanoidFound ~= playerChar.Humanoid then
                humanoidFound:TakeDamage(10)
            end

            tween:Play()
            decalTween:Play()
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
