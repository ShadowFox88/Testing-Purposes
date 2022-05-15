local rotate = workspace:WaitForChild("Rotate", 60)

for i = 1, math.huge do
    rotate.PrimaryPart.CFrame *= CFrame.Angles(0, math.rad(i / 180), 0)

    task.wait()
end
