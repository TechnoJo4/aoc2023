local f = io.open("i/6", "r")
local s = f:read("*a").."\n"
f:close()

local function go(times, dists)
	local result = 1
	for i=1,#times do
		--dist = (time - held) * held
		--     = time*held - held^2
		--     = -held^2 + time*held
		--solve x where y = -1 * x^2 + B*x + 0
		--                 a=-1      b=time c=-dist

		a = -1
		b = times[i]
		c = -1-dists[i]
		d = math.sqrt(b*b - 4*a*c)
		min = math.ceil((-b + d)/(2*a))
		max = math.floor((-b - d)/(2*a))

		result = result * (1 + max - min)
	end
	print(result)
end

-- part 1
local l = s:match("()\n")
local times = {}
local dists = {}

for num in s:sub(1,l):gmatch("(%d+)") do
	times[#times+1] = tonumber(num)
end
for num in s:sub(1+l):gmatch("(%d+)") do
	dists[#dists+1] = tonumber(num)
end
go(times, dists)

-- part 2
times = { tonumber(s:sub(1,l):gsub(" ", ""):match("(%d+)")) }
dists = { tonumber(s:sub(1+l):gsub(" ", ""):match("(%d+)")) }
go(times, dists)
