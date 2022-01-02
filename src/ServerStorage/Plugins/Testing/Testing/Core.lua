local HTTP = game:GetService("HttpService")
local RS = game:GetService("ReplicatedStorage")
local SSS = game:GetService("ServerScriptService")

local Utils = require(RS.Utils)

local onButtonClick;


function toVSSnippet(source, name, description, prefix)
    assert(typeof(source) == "string")
	assert(typeof(name) == "string")

	prefix = if prefix ~= nil then prefix else ""
	description = if description ~= nil then description else ""
	local previous;
	local snippetInfo = {
		body = {},
		description = description,
		prefix = prefix
	}

	local newlines = 0
	local lines = source:split("\n")

	for _, line in ipairs(lines) do
		if line == "" then
			newlines += 1
		elseif newlines > 0 then
			previous ..= string.rep("\n", newlines)
			newlines = 0

			table.insert(snippetInfo.body, previous)
		else
			previous = line

			table.insert(snippetInfo.body, line)
		end
	end

	local payload = {[name] = snippetInfo}

	print(payload)
end


local function core(pluginInfo)
    toVSSnippet(
        SSS.Testing.Source,
        "Create Datastore",
        "Create a luau datastore for persistent data manipulation",
        "datastore"
    )
end


-- local function onButtonClick(pluginInfo)
--     do end
-- end


return function(pluginInfo)
    return core, onButtonClick
end
