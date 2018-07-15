-- LYNSTATS by Lyn (aka eiszeit on wowinterface)
-- you can use it but don't rename it or copy-cat the code for your "<insert letter here>Stats" addon.

local addon = CreateFrame("Button", "LynStats", UIParent)

--
-- the x-files aka. configuration
--
-- frame
local frame_anchor = "CENTER" -- LEFT, TOPLEFT, TOP, TOPRIGHT, RIGHT, CENTER, BOTTOMRIGHT, BOTTOM, BOTTOMLEFT
local frame_parent = "Minimap"
local pos_x = -3
local pos_y = -70
-- text
local text_anchor = "BOTTOMLEFT"
local font = "INTERFACE\\ADDONS\\SHAREDMEDIA\\FONTS\\Porky.ttf"
local size = 14
local addonlist = 70 -- how much addons should be shown?
local classcolors = true -- true or false
local shadow = true -- true / false
local outline = true -- true / false
local time24 = false -- true: 24h / false: 12h
-- tooltip
local tip_anchor = "TOPRIGHT"
local tip_x = -12
local tip_y = -150


-- reinforcements!
local color, mail, hasmail, ticktack, lag, fps, ep, xp_cur, xp_max, text, blizz, memory, entry, i, nr, xp_rest, ep, before, after, hours, minutes

if classcolors == true then
	color = RAID_CLASS_COLORS[select(2, UnitClass("player"))]
else
	color = { r=0, g=0.8, b=1 } -- own textcolor
end

-- format memory stuff
local memformat = function(number)
	if number > 1024 then
		return string.format("%.2f mb", (number / 1024))
	else
		return string.format("%.1f kb", floor(number))
	end
end

-- ordering
local addoncompare = function(a, b)
	return a.memory > b.memory
end

-- the allmighty
function addon:new()
	text = self:CreateFontString(nil, "OVERLAY")
	if outline == true then
		text:SetFont(font, size, "OUTLINE")
	else
		text:SetFont(font, size, nil)
	end
	if shadow == true then
		text:SetShadowOffset(1,-1)
		text:SetShadowColor(0,0,0)
	end
	text:SetPoint(text_anchor, self)
	text:SetTextColor(color.r, color.g, color.b)

	self:SetPoint(frame_anchor, frame_parent, frame_anchor, pos_x, pos_y)
	self:SetWidth(50)
	self:SetHeight(13)
	
	self:SetScript("OnUpdate", self.update)
	self:SetScript("OnEnter", self.enter)
	self:SetScript("OnLeave", function() GameTooltip:Hide() end)
end

-- update
local last = 0
function addon:update(elapsed)
	last = last + elapsed

	if last > 1 then	
		-- date thingy
		if time24 == true then
			ticktack = date("%H:%M")
		else
			ticktack = date("%I:%M")
		end
		ticktack = "|c00ffffff"..ticktack.."|r"
		
		-- mail stuff
		-- variable you have to put inside the text string: mail
		
		--[[
		hasmail = (HasNewMail() or 0);
		if hasmail > 0 then
			mail = "|c00FA58F4NEW MAIL|r   /   "
		else
			mail = ""
		end
		--]]
		
		-- fps crap
		-- variable you have to put inside the text string: fps
		
		--[[
		fps = GetFramerate()
		fps = "|c00ffffff"..floor(fps).."|r fps   /   "
		--]]
		
		-- latency
		-- variable you have to put inside the text string: lag
		
		--[[
		lag = select(3, GetNetStats())
		lag = "|c00ffffff"..lag.."|r ms   /   "
		--]]
		
		-- xp stuff
		xp_cur = UnitXP("player")
		xp_max = UnitXPMax("player")
		xp_rest = GetXPExhaustion("player") or nil
		if UnitLevel("player") < MAX_PLAYER_LEVEL then
			ep = "  |c00ffffff"..floor((xp_cur/xp_max)*100).."%|r   /   "
			if xp_rest ~= nil then	
				ep = ep.."|c0000ff11"..floor((xp_rest/xp_max)*100).."%|r   /   "
			else
				ep = ep
			end
		else
			ep = ""
		end
		
		-- reset timer
		last = 0
		
		-- the magic!
		text:SetText(ep..ticktack)
		self:SetWidth(text:GetStringWidth())
	end
end

--[[
	ADDON LIST
--]]
function addon:enter()
	GameTooltip:SetOwner(self, "ANCHOR_NONE")
	GameTooltip:SetPoint(tip_anchor, UIParent, tip_anchor, tip_x, tip_y)
	blizz = collectgarbage("count")
	addons = {}
	total = 0
	nr = 0
	UpdateAddOnMemoryUsage()
	GameTooltip:AddDoubleLine(select(3, GetNetStats()).." ms", floor(GetFramerate()).." fps", color.r, color.g, color.b, color.r, color.g, color.b)
	GameTooltip:AddLine(" ")
	for i=1, GetNumAddOns(), 1 do
		if (GetAddOnMemoryUsage(i) > 0 ) then
			memory = GetAddOnMemoryUsage(i)
			entry = {name = GetAddOnInfo(i), memory = memory}
			table.insert(addons, entry)
			total = total + memory
		end
	end
	table.sort(addons, addoncompare)
	for _, entry in pairs(addons) do
		if nr < addonlist then
			GameTooltip:AddDoubleLine(entry.name, memformat(entry.memory), 1, 1, 1, 1, 1, 1)
			nr = nr+1
		end
	end
	GameTooltip:AddLine(" ")
	GameTooltip:AddDoubleLine("Total", memformat(total), color.r, color.g, color.b, color.r, color.g, color.b)
	GameTooltip:AddDoubleLine("Total incl. Blizzard", memformat(blizz), color.r, color.g, color.b, color.r, color.g, color.b)
	GameTooltip:Show()
end

-- and... go!
addon:new()