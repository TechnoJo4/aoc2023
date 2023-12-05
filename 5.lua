local f = io.open("i/5", "r")
local s = f:read("*a").."\n"
f:close()

-- parse
local line1 = s:sub(1,s:match("()\n"))
local seeds = {}
for num in line1:gmatch("(%d+)") do
	seeds[#seeds+1] = tonumber(num)
end

local maps = {}
for map in s:gmatch(":\n(.-\n\n)") do
	local tbl = {}
	maps[#maps+1] = tbl

	for ds,ss,rl in map:gmatch("(%d+) (%d+) (%d+)\n") do
		tbl[#tbl+1] = { tonumber(ss), tonumber(rl), tonumber(ds) }
	end
end

-- part 1
local min
for _,seed in ipairs(seeds) do
	local v = seed
	for _,map in ipairs(maps) do
		for _,range in ipairs(map) do
			local d = v - range[1]
			if 0 <= d and d < range[2] then
				v = d + range[3]
				break
			end
		end
	end

	if not min or v < min then
		min = v
	end
end
print(min)

-- part 2
local ranges = {}

for start,size in line1:gmatch("(%d+) (%d+)") do
	start,size = tonumber(start), tonumber(size)
	ranges[#ranges+1] = { start, start + size - 1 }
end

local function translate(mr, r)
	return { r[1] - mr[1] + mr[3], r[2] - mr[1] + mr[3] }
end

for _,map in pairs(maps) do
	local i = 1
	repeat
		for _,maprange in pairs(map) do
			-- if map range overlaps with seed range
			local me = maprange[1] + maprange[2] - 1
			if me >= ranges[i][1] and maprange[1] <= ranges[i][2] then
				-- get part of range to be translated
				local new = { math.max(maprange[1], ranges[i][1]), math.min(me, ranges[i][2]) }

				-- if non-translated portions will remain, add to the end of ranges list
				if new[1] > ranges[i][1] then
					ranges[#ranges+1] = { ranges[i][1], new[1] - 1 }
				end
				if new[2] < ranges[i][2] then
					ranges[#ranges+1] = { new[2] + 1, ranges[i][2] }
				end

				ranges[i] = translate(maprange, new) -- change range with translated

				break -- don't translate twice
			end
		end

		i = i + 1
	until i > #ranges
end

local min
for _,r in pairs(ranges) do
	if not min or r[1] < min then
		min = r[1]
	end
end
print(min)
