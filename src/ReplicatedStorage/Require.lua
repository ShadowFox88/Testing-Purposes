local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Utils = require(ReplicatedStorage.Utils)

local _require = {}
local requireMeta = {}


function requireMeta:__tostring(): string
    return "function: require"
end


local function containsDuplicate(container: Array<Instance | string>): boolean
    local total = #container

    for index, value in ipairs(container) do
        for innerIndex = index + 1, total do
            if value == container[innerIndex] then
                return true
            end
        end
    end

    return false
end


function requireMeta:__call(...: Instance | string): ...{any} | (...any) -> any
    local paths = {...}
    local options = paths[#paths]
    local allowDuplicates = false
    local moduleDirectory = ReplicatedStorage
    local modules = {}

    if #paths == 0 then
        error("expected 1 or more modules, got 0")
    elseif options and typeof(options) == "table" then
        allowDuplicates = options.AllowDuplicates or allowDuplicates
        moduleDirectory = options.Directory or moduleDirectory

        table.remove(paths, #paths)
    end

    if not allowDuplicates and containsDuplicate(paths) then error("cannot import duplicate modules") end

    -- TODO: reduce scopes with functions
    for _, path in ipairs(paths) do
        -- TODO: this looks funky, possible to change??? should change???
        local instance = path
        local routes = {}

        if path == nil then
            local message = string.format(
                "cannot locate module %s in %s from import %s",
                path,
                moduleDirectory:GetFullName(),
                path
            )

            error(message)
        elseif typeof(path) == "string" then
            local parent = moduleDirectory
            local partitions = path:split("/")
            local totalPartitions = #partitions

            for i, partition in ipairs(partitions) do
                if i < totalPartitions then
                    instance = parent:FindFirstChild(partition)

                    if not instance then
                        local message = string.format(
                            "cannot locate module %s in %s from import %s",
                            partition,
                            parent:GetFullName(),
                            path
                        )

                        error(message)
                    end

                    parent = instance
                else
                    -- TODO: error check when period is used with no suceeding
                    -- module to search for???
                    routes = partition:split(".")
                    local head = table.remove(routes, 1)
                    instance = parent:FindFirstChild(head)

                    if not instance then
                        local message = string.format(
                            "cannot locate module %s in %s from import %s",
                            partition,
                            parent:GetFullName(),
                            path
                        )

                        error(message)
                    end
                end
            end
        end

        local module = require(instance)

        for _, route in ipairs(routes) do
            module = module[route]
        end

        table.insert(modules, module)
    end

    return table.unpack(modules)
end


return setmetatable(_require, requireMeta)
