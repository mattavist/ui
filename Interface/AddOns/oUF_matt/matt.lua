local _, ns = ...
local api, cfg, tags, statusbar = ns.api, ns.cfg, ns.tags, ns.statusbar

local debug = function(msg)
	DEFAULT_CHAT_FRAME:AddMessage(msg)
end

local generic = function(self, unit)
	self:SetSize(unpack(cfg[unit].FrameSize))
	api:SetBackdrop(self, cfg.FrameInset, cfg.FrameInset, cfg.FrameInset, cfg.FrameInset)
	self:RegisterForClicks("AnyDown")

	statusbar:createHealth(self, unit)
	statusbar:createPower(self, unit)

	tags:CreateNameString(self, "LEFT", 200)
	tags:CreateHPPercString(self, "RIGHT", 200)

	-- self:SetScale(cfg[unit].FrameScale)
	-- api:CreateDropShadow(self, 6, 6)
end


local UnitSpecific = {
	pet = function(self) end,
	target = function(self) end,
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
	self:Spawn(cfg.InProgress):SetPoint(unpack(cfg[cfg.InProgress].Position))
end)
