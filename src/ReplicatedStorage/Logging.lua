local HTTP = game:GetService("HttpService")
local Players = game:GetService("Players")

local Endpoints = {
    authenticate = "",
    dump = "",
    log = "",
    root = "%s/api/%s"
}
local Logging = {
    Code = nil,
    Connection = nil,
    Format = nil,
    Secret = nil,
    URL = nil,
    Bound = false,
    Buffer = {},
    Connections = {}
}


local function getEndpoint(route)
    assert(Logging.URL, "URL attribute must be set")

    local endpointFound = Endpoints[route]

    if not endpointFound then
        route = if route:sub(1, 1) ~= "/" then route else "/" .. route
        local message = string.format('endpoint "%s" doesn\'t exist', route)

        error(message)
    elseif #endpointFound == 0 then
        endpointFound = string.format(Endpoints.root, Logging.URL, route)
        Endpoints[route] = endpointFound
    end

    return endpointFound
end


function Logging.authenticate(webhook)
    local url = getEndpoint("authenticate")
    local data = { Webhook = webhook }
    local success, secretOrError = pcall(HTTP.PostAsync, HTTP, url, data, Enum.HttpContentType.ApplicationJson)

    if not success then
        error(secretOrError)
    end

    Logging.Secret = secretOrError
end


function Logging.checksum(message, speaker)
    -- function that determines whether a message should be logged depending on
    -- it's return value - put whatever you want here

    -- returning true will log the message
    -- returning false will ignore it
    return true
end


function Logging.callback(message, speaker)
    if not Logging.Connection or Logging.checksum(message, speaker) then return end

    local url = getEndpoint("log")
    local data = {
        Code = Logging.Code,
        Content = message,
        Player = speaker.Name,
        Time = time()
    }
    local success, message = pcall(HTTP.PostAsync, HTTP, url, data, Enum.HttpContentType.ApplicationJson)

    if not success then
        error(message)
    end
end


function Logging.dump()
    if not Logging.Connection then return end

    local url = getEndpoint("dump")
    local data = {
        Code = Logging.Code
    }
    local success, message = pcall(HTTP.PostAsync, HTTP, url, data, Enum.HttpContentType.ApplicationJson)

    if not success then
        error(message)
    end
end


local function onPlayerAdded(player)
    player.Chatted:Connect(Logging.callback)
end


function Logging.start(format)
    assert(not Logging.Connection, "cannot start multiple times")

    Logging.Format = format
    local secretOrError;

    if not Logging.Code then
        local success;
        success, secretOrError = pcall(Logging.authenticate)

        if not success then
            error(secretOrError)
        end
    end

    Logging.Code = if Logging.Code then Logging.Code else secretOrError

    for _, player in ipairs(Players:GetPlayers()) do
        onPlayerAdded(player)
    end

    Logging.Connection = Players.PlayerAdded:Connect(onPlayerAdded)

    if not Logging.Bound then
        game:BindToClose(Logging.dump)
    end
end


function Logging.stop()
    if not Logging.Connection then return end

    Logging.Connection:Disconnect()

    Logging.Connection = nil
end


function Logging.reset()
    Logging.Code = nil
end


return Logging
