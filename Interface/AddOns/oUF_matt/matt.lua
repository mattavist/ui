local _, ns = ...
local api, cfg, media = ns.api, ns.cfg, ns.media

local debug = function(msg)
	DEFAULT_CHAT_FRAME:AddMessage(msg)
end

function api:CreateFontstring(frame, font, size, outline)
    -- local Text = Castbar:CreateFontString(nil, 'OVERLAY', 'GameFontNormalSmall')
    local fs = frame:CreateFontString(nil, "OVERLAY")
    fs:SetFont(font, size, outline)
    fs:SetShadowColor(0, 0, 0, 1)
    fs:SetShadowOffset(1, -1)
    return fs
end

oUF.Tags.Methods['matt:name'] = function(unit, realUnit)
	return UnitName(unit or realUnit)
end

oUF.Tags.Methods['matt:hpperc'] = function(unit)
	local min, max = UnitHealth(unit), UnitHealthMax(unit)
	local percent = floor((min / max) * 100 + 0.5)

	if percent < 100 and percent > 0 then
	    return percent .. "%"
	else
	    return ""
	end
end

-- Need to create the event right after defining its func
oUF.Tags.Events['matt:name'] = 'UNIT_NAME_UPDATE UNIT_CONNECTION UNIT_ENTERING_VEHICLE UNIT_EXITING_VEHICLE'
oUF.Tags.Events['matt:hpperc'] = 'UNIT_HEALTH UNIT_MAXHEALTH UNIT_NAME_UPDATE'

function CreateNameString(self, font, size, outline, point, width)
    -- if not self.Health or not self.cfg.name.show then return end

    local name = api:CreateFontstring(self.Health, font, size, outline)
    name:SetPoint(point, self, "TOP"..point, 4, 0)
    name:SetJustifyH(point)
    name:SetWidth(width)
    name:SetHeight(size)
    self:Tag(name, "[matt:name]")
    self.Name = name
end

function CreateHPPercString(self, font, size, outline, point, width)
    -- if not self.Health or not self.cfg.name.show then return end

    local name = api:CreateFontstring(self.Health, font, size, outline)
    name:SetPoint(point, self, "TOP"..point, -4, 0)
    name:SetJustifyH(point)
    name:SetWidth(width)
    name:SetHeight(size)
    self:Tag(name, "[matt:hpperc]")
    self.Name = name
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
	self:SetSize(unpack(cfg[unit].FrameSize))
	api:SetBackdrop(self, cfg.FrameInset, cfg.FrameInset, cfg.FrameInset, cfg.FrameInset)
	self:RegisterForClicks("AnyDown")
	createHealth(self, unit)
	createPower(self, unit)

	local font = "Fonts\\FRIZQT__.TTF"
	CreateNameString(self, font, 20, "THINOUTLINE", "LEFT", 200)
	CreateHPPercString(self, font, 20, "THINOUTLINE", "RIGHT", 200)
	-- self:Tag(self.Name, "[lum:name]")

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
