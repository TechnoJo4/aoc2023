local f = io.open("i/8", "r")
local s = f:read("*a")
f:close()

-- parse
local sequence = s:match("^(.-)\n")

local nl = {}
local nr = {}
for label,l,r in s:gmatch("(...) = .(...), (...)") do
	nl[label] = l
	nr[label] = r
end

-- part 1
local a = {R=nr, L=nl}

if nl["AAA"] then
	local i = 1
	local c = 0
	local n = "AAA"
	repeat
		n = a[sequence:sub(i,i)][n]

		i = i + 1
		c = c + 1
		if i > #sequence then i = 1 end
	until n == "ZZZ"
	print(c)
end

-- part 2
local function factor(n)
	local t = {}
	for i=2,math.sqrt(n) do
		while n % i == 0 do
			n = n / i
			t[i] = (t[i] or 0) + 1
		end
	end

	t[n] = 1
	return t
end

local function gcd(a,b)
	if b == 0 then return a end
	return gcd(b, a%b)
end

local product

local fs = {}
for n,_ in pairs(nl) do
	if n:sub(3,3) == "A" then
		local i = 1
		local c = 0
		repeat
			n = a[sequence:sub(i,i)][n]

			i = i + 1
			c = c + 1
			if i > #sequence then i = 1 end
		until n:sub(3,3) == "Z"

		if product then
			product = gcd(product, c)
		else
			product = c
		end

		fs[#fs+1] = c
	end
end

for i=1,#fs do
	fs[i] = fs[i]/product
end
for i=1,#fs do
	product = product * fs[i]
end

print(product)
