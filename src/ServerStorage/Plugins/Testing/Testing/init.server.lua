local callback = require(script.Core)

local toolbar = plugin:CreateToolbar("Testing Purposes")
local button = toolbar:CreateButton("Test", "For Testing Purposes", "rbxassetid://52756150")
local pluginInfo = {
    Button = button,
    Plugin = plugin,
    Toolbar = toolbar
}
local main, onButtonClick = callback(pluginInfo)

if onButtonClick then
    button.Click:Connect(function()
        onButtonClick(pluginInfo)
    end)
end

main(pluginInfo)
