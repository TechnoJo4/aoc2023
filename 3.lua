local f = io.open("i/3", "r")
local s = f:read("*a")
f:close()

-- extract numbers
local i = 1
local d = {}
local grid = {}
for line in s:gmatch("(.-)\n") do
	grid[i] = {}
	for pos,num in line:gmatch("()(%d+)") do
		d[#d+1] = tonumber(num)
		for j=0,#num-1 do
			grid[i][pos+j] = #d
		end
	end
	i = i + 1
end

-- part 1
i = 1
local touched = {}
for line in s:gmatch("(.-)\n") do
	for pos in line:gmatch("()[^.%d]") do
		for j=-1,1 do
			for k=-1,1 do
				local found = grid[i+j][pos+k]
				if found then
					touched[found] = true
				end
			end
		end
	end
	i = i + 1
end

local sum = 0
for k,_ in pairs(touched) do
	sum = sum + d[k]
end
print(sum)

-- part 2
i = 1
local sum = 0
for line in s:gmatch("(.-)\n") do
	for pos in line:gmatch("()%*") do
		local touched = {}
		for j=-1,1 do
			for k=-1,1 do
				local found = grid[i+j][pos+k]
				if found then
					touched[found] = true
				end
			end
		end

		local t2 = {}
		for k,_ in pairs(touched) do t2[#t2+1] = k end

		if #t2 == 2 then
			sum = sum + d[t2[1]]*d[t2[2]]
		end
	end
	i = i + 1
end
print(sum)
