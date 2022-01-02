local DATA = {}
local Benchmark = {}

for i = 1, 10000 do
	table.insert(DATA, i)
end


function Benchmark.next()
	for i, v in next, DATA do
		print(i, "=", v)
	end
end


function Benchmark.pairs()
	for i, v in pairs(DATA) do
		print(i, "=", v)
	end
end


function Benchmark.ipairs()
	for i, v in ipairs(DATA) do
		print(i, "=", v)
	end
end


return Benchmark
