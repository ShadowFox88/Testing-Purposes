local rotate = workspace:WaitForChild("Rotate")

local i = 0

while true do
	i = (i + 1) % 360
	rotate.PrimaryPart.CFrame *= CFrame.Angles(0, math.rad(i / 180), 0)

	task.wait()
end
