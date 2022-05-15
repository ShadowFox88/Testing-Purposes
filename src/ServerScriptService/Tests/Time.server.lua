local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TimeConverter = require(ReplicatedStorage.TimeConverter)

print(
    TimeConverter.milliseconds("1s"),
    TimeConverter.milliseconds("34s"),
    TimeConverter.milliseconds("1m"),
    TimeConverter.milliseconds("1.5m"),
    TimeConverter.milliseconds("0.5s")
)
