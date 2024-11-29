local _, ns = ...
local api, cfg, media = ns.api, ns.cfg, ns.media

local debug = function(msg)
	DEFAULT_CHAT_FRAME:AddMessage(msg)
end

local createHealth = function(self, unit)
	local Health = CreateFrame('StatusBar', nil, self)
	Health:SetHeight(cfg[unit].HealthHeight)
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
	Background:SetTexture(media.textures.texture_bg)

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
end


local createPower = function(self, unit)
	local Power = CreateFrame('StatusBar', nil, self)
	Power:SetHeight(cfg[unit].PowerHeight)
	Power:SetPoint('BOTTOM')
	Power:SetPoint('LEFT')
	Power:SetPoint('RIGHT')
	Power:SetStatusBarTexture(media.textures.status_texture)
	-- Power:SetStatusBarColor(unpack(cfg.colors.health))
	Power:GetStatusBarTexture():SetHorizTile(false)

	-- Add a background
	local Background = Power:CreateTexture(nil, 'BACKGROUND')
	Background:SetAllPoints(Power)
	Background:SetTexture(media.textures.texture_bg)

	-- Options
	Power.frequentUpdates = true
	Power.colorTapping = false
	Power.colorDisconnected = false
	Power.colorPower = true
	Power.colorClass = false
	Power.colorReaction = false

	-- Make the background darker.
	Background.multiplier = .5

	-- Register it with oUF
	Power.bg = Background
	self.Power = Power
end


local generic = function(self, unit)
	createHealth(self, unit)
	createPower(self, unit)
end


local UnitSpecific = {
	pet = function(self) end,
	target = function(self) end,
}

local Shared = function(self, unit)
	generic(self, unit)
	self:SetSize(unpack(cfg[unit].FrameSize))
	-- self:SetScale(cfg[unit].FrameScale)
	api:SetBackdrop(self, cfg.FrameInset, cfg.FrameInset, cfg.FrameInset, cfg.FrameInset)
	-- api:CreateDropShadow(self, 6, 6)

	if (UnitSpecific[unit]) then
		UnitSpecific[unit](self)
	end
end

oUF:RegisterStyle("matt", Shared)
oUF:Factory(function(self)
	self:SetActiveStyle("matt")
	self:Spawn(cfg.InProgress):SetPoint(unpack(cfg[cfg.InProgress].Position))
end)
