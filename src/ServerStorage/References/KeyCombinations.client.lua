local UserInputService = game:GetService("UserInputService")


local function onInputBegan(input, inGui)
    if inGui then return end

    if input.KeyCode == Enum.KeyCode.F and UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
        print(input.KeyCode.Name, "pressed whilst Shift was left down")
    end
end


UserInputService.InputBegan:Connect(onInputBegan)
