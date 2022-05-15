local rainbow = workspace:WaitForChild("Rainbow")

while true do
    for i = 0, 1, 0.01 do
        rainbow.Color = Color3.fromHSV(i, 1, 1)
        task.wait()
    end
end
