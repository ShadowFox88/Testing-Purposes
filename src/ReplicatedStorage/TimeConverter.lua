--> USOT = UNITS OF TIME
--> UOT = UNIT OF TIME
--> IP = INDEX POSITION

local units = {
    {"MS", 1000},
    {"S", 60},
    {"M", 60},
    {"H", 60},
    {"D", 24}
}
local Time = {}
      Time.Units = units


function Time.getIndexFor(interval)
    for i, data in ipairs(Time.Units) do
        local actualInterval, _ = table.unpack(data)

        if actualInterval == interval then
            return i
        end
    end

    return 0
end


local function doActualConversion(amount, interval, index)
    local converted = amount

    for i = index, 0, -1 do
        local data = Time.units[i]
        local _, resolvedAmount = table.unpack(data)
        converted *= resolvedAmount
    end

    return converted
end


function Time.convert(format)
    local amountFound = format:match("(%-?%d*%.?%d+)")
    local intervalFound = format:match("([sSmMhHdD][sS]?)")

    if not (amountFound or intervalFound) then
        local message = string.format("%s is not a valid time format", format)

        error(message)
    end

    amountFound = tonumber(amountFound)
    intervalFound = intervalFound:upper()
    local index = Time.getIndexFor(intervalFound)

    if index > 0 then
        return doActualConversion(amountFound, intervalFound, index)
    end

    error("Time is either undefined or nonexistant.")
end


function Time.milliseconds(format)
    return Time.convert(format, "MS")
end


-- function Time.minutes(format)
--     local UOT = format:match("%a+")

--     if UOT and Time.find(UOT:upper()) then
--         -- shadowing
--         local Time = format:match("[%d+%p]+")

--         if Time then
--             return Time.convert(tonumber(Time), UOT:upper(), "M")
--         else
--             warn("Time is either undefined or nonexistant.")
--         end
--     else
--         warn("Unit of time is either undefined or nonexistant.")
--     end
-- end


-- function Time.seconds(Format)
--     local UOT = Format:match("%a+")

--     if UOT and Time.find(UOT:upper()) then
--         local Time = Format:match("[%d+%p]+")

--         if Time then
--             return Time.convert(tonumber(Time), UOT:upper(), "S")
--         else
--             warn("Time is either undefined or nonexistant.")
--         end
--     else
--         warn("Unit of time is either undefined or nonexistant.")
--     end
-- end


return Time
