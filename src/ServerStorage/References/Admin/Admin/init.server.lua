local ServerStorage = game:GetService("ServerStorage")

local Cmdr = require(ServerStorage.Cmdr)

Cmdr:RegisterDefaultCommands()
Cmdr:RegisterCommandsIn(script.Commands)
