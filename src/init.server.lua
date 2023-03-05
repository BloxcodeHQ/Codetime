--[=[
	Plugin entry point

	(c) 2023 Bloxcode
]=]

local modules = script:WaitForChild("modules")
local loader = script.Parent:FindFirstChild("LoaderUtils", true).Parent

local require = require(loader).bootstrapPlugin(modules)


local function init(plugin)
	
end

if plugin then
	init(plugin)
end