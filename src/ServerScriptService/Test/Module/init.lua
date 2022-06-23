local Types = require(script.Types)

local Module = {
    Types = Types
}


function Module.run(data: Types.Array<string>)
    for i, v in pairs(data) do
        print(i, v)
    end
end


return Module
