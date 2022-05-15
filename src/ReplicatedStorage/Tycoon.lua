local RS = game:GetService("ReplicatedStorage")

local Utils = require(RS.Utils)

local debounce = 0
local Tycoon = {}
      Tycoon.__index = Tycoon
      Tycoon.Tycoons = {}


local function findRequiredPart(root, name)
    local required = root:FindFirstChild(name)

    if required and required:IsA("Part") then
        return required
    end
end


function Tycoon.new(root)
    assert(Utils.isOneOf(root, "Model", "Folder"), "Root must be a Model or Folder")

    local claim = findRequiredPart(root, "Claim")

    assert(claim, "Claim part must be present within root")

    local self = {
        Owner = nil,
        Claim = claim,
        Root = root,
        Steps = {

        }
    }

    setmetatable(self, Tycoon)

    claim.Touched:Connect(function(hit)
        self:OnClaimTouched(hit)
    end)

    self:InitSteps()

    return self
end


function Tycoon:OnClaimTouched(hit)
    if self.Owner then return end

    debounce += 1

    if debounce > 1 then
        return
    end

    local playerFound = Utils.findPlayerFromAncestor(hit)

    if playerFound then
        self.Owner = playerFound
    end

    debounce = 0
end


function Tycoon:InitSteps()
    local stepsFound = self.Root:FindFirstChild("Steps")

    if not stepsFound then
        return warn("No steps found in root")
    end

    for _, step in ipairs(stepsFound:GetChildren()) do

    end
end


function Tycoon.init(tycoonContainer)
    for _, child in ipairs(tycoonContainer:GetChildren()) do
        table.insert(Tycoon.Tycoons, Tycoon.new(child))
        -- local success, message = pcall(function()
        --     table.insert(Tycoon.Tycoons, Tycoon.new(child))
        -- end)

        -- if not success then
        --     warn(message)
        -- end
    end

    return Tycoon.Tycoons
end


return Tycoon
