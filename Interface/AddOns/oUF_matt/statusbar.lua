local _, ns = ...
local cfg, media, statusbar = ns.cfg, ns.media, ns.statusbar

function statusbar:createHealth(self, unit)
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
	if unit == "pet" then
		Health.colorClassPet = true
		Health.colorClass = false
	else
		Health.colorClass = true
	end
	Health.colorReaction = true
	Health.colorHealth = true
	color = RAID_CLASS_COLORS[select(2, UnitClass("player"))]

	-- Make the background darker.
	Background.multiplier = .5

	-- Register it with oUF
	Health.bg = Background
	self.Health = Health
end


function statusbar:createPower(self, unit)
	if cfg[unit].PowerHeight == 0 then return end

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


