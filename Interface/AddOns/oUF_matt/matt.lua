local _, ns = ...
local api, cfg, tags, bars, util = ns.api, ns.cfg, ns.tags, ns.bars, ns.util

cfg.debugEnabled = true
local generic = function(self, unit)
	self.cfg = cfg[unit]

	util:debug("Creating " .. unit .. " frame")
	if self.cfg then
		util:debug("matt: cfg is not nil for " .. unit)
		if self.cfg.CastbarColor then
			util:debug("matt: first color is " .. self.cfg.CastbarColor[1])
		else
			util:debug("  matt: first color is nil")
		end
	else
		util:debug("matt: cfg is nil for " .. unit)
	end
	self:SetSize(unpack(self.cfg.FrameSize))
	api:SetBackdrop(self, cfg.FrameInset, cfg.FrameInset, cfg.FrameInset, cfg.FrameInset)
	self:RegisterForClicks("AnyDown")

	bars:createHealth(self, unit)
	bars:createPower(self, unit)
	bars:CreateCast(self, unit)

	tags:CreateNameString(self, self.cfg.NameSide, self.cfg.FontSize, self.cfg.FrameSize[1] - 15)
	tags:CreateHPPercString(self, self.cfg.HPSide, self.cfg.FontSize, 200)

	-- self:SetScale(self.cfg.FrameScale)
	-- api:CreateDropShadow(self, 6, 6)
end

local partySpecific = function()
	local yOffset = ("%d"):format(cfg.party.FrameOffsetY)
	local initialConfig = ([[self:SetHeight(%d) self:SetWidth(%d)]]):format(unpack(cfg.party.FrameSize))

	local party = oUF:SpawnHeader(
		"oUF_mattParty", nil, "party",
		"showParty", true, "showRaid", false, "showPlayer", false,
		"yOffset", yOffset, "groupBy", "ASSIGNEDROLE",
		"groupingOrder", "TANK,HEALER,DAMAGER",
		"oUF-initialConfigFunction", initialConfig
	)
	party:SetPoint(unpack(cfg.party.Position))
end

-- local UnitSpecific = {
-- 	player = function(self) end,
-- 	pet = function(self) end,
-- 	target = function(self) end,
-- 	targettarget = function(self) end,
-- 	party = function(self) partySpecific end,
-- }

local Shared = function(self, unit)
	generic(self, unit)

	-- Currently useless
	-- if (UnitSpecific[unit]) then
	-- 	UnitSpecific[unit](self)
	-- end
end

oUF:RegisterStyle("matt", Shared)
oUF:Factory(function(self)
	self:SetActiveStyle("matt")

	-- TODO: Create a table for spawners, run a generic one if its not in there,
	-- run a specific one if it is (e.g. party)
	self:Spawn("player"):SetPoint(unpack(cfg.player.Position))
	self:Spawn("pet"):SetPoint(unpack(cfg.pet.Position))
	self:Spawn("target"):SetPoint(unpack(cfg.target.Position))
	self:Spawn("targettarget"):SetPoint(unpack(cfg.targettarget.Position))
	partySpecific()
	-- TODO: Will need to handle raid the same way as party
end)
