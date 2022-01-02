local RS = game:GetService("ReplicatedStorage")

local Logging = require(RS.Logging)
      Logging.URL = "https://logging-omega.vercel.app/"

local WEBHOOK = "https://canary.discord.com/api/webhooks/921051613001556008/iKu6J01ij35PbUP64QQCc9-Km57P1tYaoZVARBgS0y-AuALQa8ThHUDbHMjgL0Izm2qG"
local secret = Logging.authenticate(WEBHOOK)

print(secret)
