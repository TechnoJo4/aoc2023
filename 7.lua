local f = io.open("i/7", "r")
local s = f:read("*a")
f:close()

-- utter garbage solution this was not a fun day
-- 👎

local cards = { ["A"] = 14, ["K"] = 13, ["Q"] = 12, ["J"] = 11, ["T"] = 10 }
for i=2,9 do cards[tostring(i)] = i end

-- parse
local hands = {}
local bids = {}
for line in s:gmatch("(.-)\n") do
	local hand,bid = line:match("(.....) (%d+)")

	hands[#hands+1] = {}
	for i=1,5 do
		hands[#hands][i] = cards[hand:sub(i,i)]
	end

	bids[#bids+1] = tonumber(bid)
end

-- part 1
local ranks = {}
for i=1,#hands do ranks[i] = i end

local function count(t, v, j)
	local c = 0
	for i=1,#t do
		if t[i] == v or (t[i] == 1 and not j) then
			c = c + 1
		end
	end
	return c
end

local function classify(hand)
	local m
	local mc = 0
	local mv
	for i=1,5 do
		local c = count(hand, hand[i])
		if c > mc then
			mv = hand[i]
			m = { [i] = true }
			mc = c
		elseif hand[i] == mv then
			m[i] = true
		end
	end

	if mc == 5 then return 1 end
	if mc == 4 then return 2 end
	if mc == 1 then return 7 end

	if mc == 3 then
		local oi
		for i=1,5 do
			if not m[i] then
				oi = i
				break
			end
		end

		if count(hand, hand[oi]) == 2 then
			return 3
		else
			return 4
		end
	end

	-- mc = 2
	if mc == 2 then
		local m2c = 0
		for i=1,5 do
			if not m[i] then
				local c = count(hand, hand[i])
				if c > m2c then
					m2c = c
				end
			end
		end
		if m2c == 2 then
			return 5
		end
		if m2c == 1 then
			return 6 
		end
	end
end

table.sort(ranks, function(a, b)
	a, b = hands[a], hands[b]
	ca, cb = classify(a), classify(b)
	if ca ~= cb then return ca < cb end

	for i=1,5 do
		if a[i] ~= b[i] then
			return a[i] > b[i]
		end
	end
end)

local winnings = 0
for i=1,#ranks do
	winnings = winnings + bids[ranks[i]] * (1 + #ranks - i)
end
print(winnings)

-- part 2
for _,hand in pairs(hands) do
	for i=1,5 do
		if hand[i] == cards["J"] then
			hand[i] = 1
		end
	end
end

local function classify2(hand)
	local js = {}

	local m
	local mc = 0
	local mv
	for i=1,5 do
		if hand[i] == 1 then
			js[i] = true
			if m then m[i] = true end
		end

		local c = count(hand, hand[i])
		if c > mc then
			mv = hand[i]
			m = { [i] = true }
			for i=1,5 do
				if js[i] then
					m[i] = true
				end
			end
			mc = c
		elseif hand[i] == mv then
			m[i] = true
		end
	end

	if mc == 5 then return 1 end
	if mc == 4 then return 2 end
	if mc == 1 then return 7 end

	if mc == 3 then
		local oi
		for i=1,5 do
			if not m[i] then
				oi = i
				break
			end
		end

		if count(hand, hand[oi], true) == 2 then
			return 3
		else
			return 4
		end
	end

	-- mc = 2
	if mc == 2 then
		local m2c = 0
		for i=1,5 do
			if not m[i] then
				local c = count(hand, hand[i], true)
				if c > m2c then
					m2c = c
				end
			end
		end
		if m2c == 2 then
			return 5
		end
		if m2c == 1 then
			return 6 
		end
	end
end

table.sort(ranks, function(a, b)
	a, b = hands[a], hands[b]
	ca, cb = classify2(a), classify2(b)
	if ca ~= cb then return ca < cb end

	for i=1,5 do
		if a[i] ~= b[i] then
			return a[i] > b[i]
		end
	end
end)

local winnings = 0
for i=1,#ranks do
	winnings = winnings + bids[ranks[i]] * (1 + #ranks - i)
end
print(winnings)
