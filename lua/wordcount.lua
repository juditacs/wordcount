#!/usr/bin/env lua

local counts = setmetatable({}, {__index=function() return 0 end})
for line in io.stdin:lines() do
	for word in line:gmatch("%S+") do
		counts[word] = counts[word] + 1
	end
end
local sorted = {}
local n = 0
for word in pairs(counts) do
	n = n + 1
	sorted[n] = word
end
table.sort(sorted, function(a,b)
	local na = counts[a]
	local nb = counts[b]
	if na == nb then
		return a < b
	else
		return na > nb
	end
end)
for i=1, n do
	local word = sorted[i]
	print(word, counts[word])
end
