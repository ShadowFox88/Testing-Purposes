--!nolint
--!strict
local function closure(x: number, y: number): () -> number
	return function()
		return x + y
	end
end

local callback: () -> number = closure(2, 2)

local value: number = callback()

print(value)

local function HOF(callback: () -> any): () -> any
	return function()
		return callback()
	end
end

local callback: () -> any = HOF(function()
	return "Hello, World!"
end)

local value: any = callback()

print(value)
