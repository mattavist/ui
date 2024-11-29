local _, ns = ...
local api, cfg, media = ns.api, ns.cfg, ns.media

local debug = function(msg)
	DEFAULT_CHAT_FRAME:AddMessage(msg)
end

local generic = function(self)
	local Health = CreateFrame('StatusBar', nil, self)
	Health:SetHeight(20)
	Health:SetPoint('TOP')
	Health:SetPoint('LEFT')
	Health:SetPoint('RIGHT')
	Health:SetStatusBarTexture(media.textures.status_texture)
	Health:SetStatusBarColor(unpack(cfg.colors.health))
	Health:GetStatusBarTexture():SetHorizTile(false)

	-- Add a background
	local Background = Health:CreateTexture(nil, 'BACKGROUND')
	Background:SetAllPoints()
	Background:SetTexture(1, 1, 1, .5)

	-- Options
	Health.colorTapping = true
	Health.colorDisconnected = true
	Health.colorClass = true
	Health.colorReaction = true
	Health.colorHealth = true

	-- Make the background darker.
	Background.multiplier = .5

	-- Register it with oUF
	Health.bg = Background
	self.Health = Health

	-- Apply Sizing
	api:SetBackdrop(self, 2, 2, 2, 2)
	-- api:CreateDropShadow(self, 6, 6)
	self:SetSize(unpack(cfg.FrameSize))
	self:SetScale(cfg.FrameScale)
end


local UnitSpecific = {
	pet = function(self) end,
	target = function(self) end,
}

local Shared = function(self, unit)
	generic(self)

	if (UnitSpecific[unit]) then
		UnitSpecific[unit](self)
	end
end

oUF:RegisterStyle("matt", Shared)
oUF:Factory(function(self)
	self:SetActiveStyle("matt")
	self:Spawn(cfg.InProgress):SetPoint("LEFT", UIParent, "Left", 20, 0)
end)
