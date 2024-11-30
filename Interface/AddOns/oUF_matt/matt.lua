local _, ns = ...
local api, cfg, tags, statusbar = ns.api, ns.cfg, ns.tags, ns.statusbar

cfg.InProgress = "player"

local debug = function(msg)
	DEFAULT_CHAT_FRAME:AddMessage(msg)
end

local generic = function(self, unit)
	self:SetSize(unpack(cfg[unit].FrameSize))
	api:SetBackdrop(self, cfg.FrameInset, cfg.FrameInset, cfg.FrameInset, cfg.FrameInset)
	self:RegisterForClicks("AnyDown")

	statusbar:createHealth(self, unit)
	statusbar:createPower(self, unit)

	tags:CreateNameString(self, cfg[unit].NameSide, 200)
	tags:CreateHPPercString(self, cfg[unit].HPSide, 200)

	-- self:SetScale(cfg[unit].FrameScale)
	-- api:CreateDropShadow(self, 6, 6)
end


local UnitSpecific = {
	player = function(self) end,
	pet = function(self) end,
	target = function(self) end,
	targettarget = function(self) end,
}

local Shared = function(self, unit)
	generic(self, unit)

	if (UnitSpecific[unit]) then
		UnitSpecific[unit](self)
	end
end

oUF:RegisterStyle("matt", Shared)
oUF:Factory(function(self)
	self:SetActiveStyle("matt")
	self:Spawn("player"):SetPoint(unpack(cfg.player.Position))
	self:Spawn("pet"):SetPoint(unpack(cfg.pet.Position))
	-- self:Spawn("target"):SetPoint(unpack(cfg.target.Position))
	self:Spawn("targettarget"):SetPoint(unpack(cfg.targettarget.Position))
end)
