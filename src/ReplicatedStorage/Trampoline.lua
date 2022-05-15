local Trampoline = {}


-- TODO: implement depth which integrates trampolining into the children of
-- parent N times
function Trampoline.new(parent)
    local actualModule = {}

    for _, module in ipairs(parent:GetChildren()) do
        actualModule[module.Name] = require(module)
    end

    return actualModule
end


return Trampoline
