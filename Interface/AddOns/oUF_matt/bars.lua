local _, ns = ...
local cfg, media, bars, api = ns.cfg, ns.media, ns.bars, ns.api

-- Group Role Indicator
local function UpdateRoleIcon(self, event)
	local lfdrole = self.GroupRoleIndicator

	local role = UnitGroupRolesAssigned(self.unit)
	-- Show roles when testing
	if role == "NONE" and cfg.units.party.forceRole then
		local rnd = random(1, 3)
		role = rnd == 1 and "TANK" or
		    (rnd == 2 and "HEALER" or (rnd == 3 and "DAMAGER"))
	end

	if UnitIsConnected(self.unit) and role ~= "NONE" then
		lfdrole:SetTexture(media.roleIconTextures[role])
		lfdrole:SetVertexColor(unpack(media.roleIconColor[role]))
	else
		lfdrole:Hide()
	end
end

function bars:CreateGroupRoleIndicator(frame)
	if frame.cfg.UnitName ~= "party" then return end

	local GroupRoleIndicator = frame.Health:CreateTexture(nil, "OVERLAY")
	GroupRoleIndicator:SetPoint("LEFT", frame, -10, 0)
	GroupRoleIndicator:SetSize(23, 23)
	GroupRoleIndicator:SetAlpha(1)
	--
	-- TODO: Can choose different icons, see ouf/elements/grouproleindicator.lua:Update
	-- GroupRoleIndicator.Override = UpdateRoleIcon
	-- self:RegisterEvent("UNIT_CONNECTION", UpdateRoleIcon)

	return GroupRoleIndicator
end

-- Health Prediction
local function createHealthPrediction(frame)
	if not frame.Health then return end
	if not frame.cfg.HealthPrediction then return end

	-- Position and size
	local myBar = CreateFrame('StatusBar', nil, frame.Health)
	myBar:SetPoint('TOP')
	myBar:SetPoint('BOTTOM')
	myBar:SetPoint('LEFT', frame.Health:GetStatusBarTexture(), 'RIGHT')
	myBar:SetWidth(frame.cfg.FrameSize[1])
	myBar:SetStatusBarTexture(media.textures.status_texture)
	myBar:SetStatusBarColor(125 / 255, 255 / 255, 50 / 255, .4)

	local otherBar = CreateFrame('StatusBar', nil, frame.Health)
	otherBar:SetPoint('TOP')
	otherBar:SetPoint('BOTTOM')
	otherBar:SetPoint('LEFT', frame.Health:GetStatusBarTexture(), 'RIGHT')
	otherBar:SetWidth(frame.cfg.FrameSize[1])
	otherBar:SetStatusBarTexture(media.textures.status_texture)
	otherBar:SetStatusBarColor(100 / 255, 235 / 255, 200 / 255, .4)

	local absorbBar = CreateFrame('StatusBar', nil, frame.Health)
	absorbBar:SetPoint('TOP')
	absorbBar:SetPoint('BOTTOM')
	absorbBar:SetPoint('LEFT', frame.Health:GetStatusBarTexture(), 'RIGHT')
	absorbBar:SetWidth(frame.cfg.FrameSize[1])
	absorbBar:SetStatusBarTexture(media.textures.status_texture)
	absorbBar:SetStatusBarColor(18053 / 255, 255 / 255, 205 / 255, .35)


	local healAbsorbBar = CreateFrame('StatusBar', nil, frame.Health)
	healAbsorbBar:SetPoint('TOP')
	healAbsorbBar:SetPoint('BOTTOM')
	healAbsorbBar:SetPoint('RIGHT', frame.Health:GetStatusBarTexture())
	healAbsorbBar:SetWidth(frame.cfg.FrameSize[1])
	healAbsorbBar:SetReverseFill(true)
	healAbsorbBar:SetStatusBarTexture(media.textures.status_texture)
	healAbsorbBar:SetStatusBarColor(183 / 255, 244 / 255, 255 / 255, .35)

	local overAbsorb = frame.Health:CreateTexture(nil, "OVERLAY")
	overAbsorb:SetPoint('TOP')
	overAbsorb:SetPoint('BOTTOM')
	overAbsorb:SetPoint('LEFT', frame.Health, 'RIGHT')
	overAbsorb:SetWidth(10)

	local overHealAbsorb = frame.Health:CreateTexture(nil, "OVERLAY")
	overHealAbsorb:SetPoint('TOP')
	overHealAbsorb:SetPoint('BOTTOM')
	overHealAbsorb:SetPoint('RIGHT', frame.Health, 'LEFT')
	overHealAbsorb:SetWidth(10)

	return {
		myBar = myBar,
		otherBar = otherBar,
		absorbBar = absorbBar,
		healAbsorbBar = healAbsorbBar,
		overAbsorb = overAbsorb,
		overHealAbsorb = overHealAbsorb,
		maxOverflow = 1.05,
	}
end

function bars:createHealth(frame)
	local TempLoss = CreateFrame('StatusBar', nil, frame)
	TempLoss:SetReverseFill(true)
	TempLoss:SetHeight(frame.cfg.HealthHeight)
	TempLoss:SetPoint('TOP')
	TempLoss:SetPoint('LEFT')
	TempLoss:SetPoint('RIGHT')
	TempLoss:SetStatusBarTexture(media.textures.debuff_texture)
	TempLoss:GetStatusBarTexture():SetHorizTile(true)

	local Health = CreateFrame('StatusBar', nil, frame)
	Health:SetPoint("LEFT")
	Health:SetPoint('TOPRIGHT', TempLoss:GetStatusBarTexture(), 'TOPLEFT')
	Health:SetPoint('BOTTOMRIGHT', TempLoss:GetStatusBarTexture(), 'BOTTOMLEFT')
	Health:SetStatusBarTexture(media.textures.status_texture)
	Health:GetStatusBarTexture():SetHorizTile(false)

	-- Options
	Health.colorTapping = true
	Health.colorDisconnected = true
	if frame.cfg.UnitName == "pet" then
		Health.colorClassPet = true
		Health.colorClass = false
	else
		Health.colorClass = true
	end
	Health.colorReaction = true
	Health.colorHealth = true

	Health.TempLoss = TempLoss
	frame.Health = Health
	frame.HealthPrediction = createHealthPrediction(frame)
end

function bars:createPower(frame)
	if frame.cfg.PowerHeight == 0 then return end

	local Power = CreateFrame('StatusBar', nil, frame)
	Power:SetHeight(frame.cfg.PowerHeight)
	Power:SetPoint('BOTTOM')
	Power:SetPoint('LEFT')
	Power:SetPoint('RIGHT')
	Power:SetStatusBarTexture(media.textures.status_texture)
	Power:GetStatusBarTexture():SetHorizTile(false)

	-- Options
	Power.frequentUpdates = true
	Power.colorTapping = false
	Power.colorDisconnected = false
	Power.colorPower = true
	Power.colorClass = false
	Power.colorReaction = false

	frame.Power = Power
end

local function CheckForSpellInterrupt(castbar)
	local unit = castbar.__owner.cfg.UnitName
	if unit == "vehicle" then unit = "player" end

	local owner = castbar.__owner
	local initialColor = cfg.Castbar.Color
	if owner.cfg and owner.cfg.CastbarColor then
		initialColor = owner.cfg.CastbarColor
	end

	castbar:SetStatusBarColor(unpack(initialColor))
	if castbar.Glowborder then castbar.Glowborder:Hide() end

	if UnitCanAttack("player", unit) then
		if castbar.notInterruptible then
			castbar:SetStatusBarColor(unpack(cfg.Castbar.UninterruptibleColor))
		else
			if castbar.Glowborder then
				castbar.Glowborder:SetBackdropBorderColor(unpack(cfg.Castbar.InterruptibleGlowColor))
				castbar.Glowborder:Show()
			end
		end
	end
end

local function onPostCastStart(castbar)
	local unit = castbar.__owner.cfg.UnitName
	if unit == "vehicle" then unit = "player" end

	-- Set the castbar unit's initial color
	castbar:SetStatusBarColor(unpack(cfg.Castbar.Color))
	CheckForSpellInterrupt(castbar, unit)
	api:StartFadeIn(castbar)
end

local function OnPostCastFail(castbar)
	castbar:SetStatusBarColor(235 / 255, 25 / 255, 25 / 255, 0.8)
	if castbar.Max then castbar.Max:Hide() end
	api:StartFadeOut(castbar)
end

local function OnPostCastInterruptible(castbar)
	CheckForSpellInterrupt(castbar, castbar.__owner.cfg.UnitName)
end

function bars:CreateCast(frame)
	if not frame.cfg.EnableCastbar then return end

	-- Position and size
	local Castbar = CreateFrame('StatusBar', nil, UIParent)
	Castbar:SetSize(cfg.PrimaryFrameWidth, 20)
	Castbar:SetPoint("LEFT", frame, "LEFT", 0, cfg.Castbar.OffsetY)
	Castbar:SetStatusBarTexture(media.textures.status_texture)
	Castbar:SetFrameStrata("HIGH")
	Castbar:SetToplevel(true)
	Castbar:GetStatusBarTexture():SetHorizTile(false)
	api:SetBackdrop(Castbar, cfg.FrameInset, cfg.FrameInset, cfg.FrameInset, cfg.FrameInset)

	-- Add a spark
	local Spark = Castbar:CreateTexture(nil, 'OVERLAY')
	Spark:SetSize(20, 20)
	Spark:SetBlendMode('ADD')
	Spark:SetPoint('CENTER', Castbar:GetStatusBarTexture(), 'RIGHT', 0, 0)

	-- Add a timer
	local Time = Castbar:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
	Time:SetTextColor(1, 1, 1)
	Time:SetShadowOffset(1, -1)
	Time:SetFont(cfg.Castbar.Font, cfg.Castbar.FontSize, "THINOUTLINE")
	if frame.cfg.UnitName == "target" then
		Time:SetPoint('LEFT', Castbar)
	else
		Time:SetPoint('RIGHT', Castbar)
	end

	-- Add spell text
	local Text = Castbar:CreateFontString(nil, 'OVERLAY')
	Text:SetTextColor(1, 1, 1)
	Text:SetShadowOffset(1, -1)
	Text:SetFont(cfg.Castbar.Font, cfg.Castbar.FontSize, "THINOUTLINE")
	Text:SetPoint('CENTER', Castbar)

	-- Add Shield
	local Shield = Castbar:CreateTexture(nil, 'OVERLAY')
	Shield:SetSize(20, 20)
	Shield:SetPoint('CENTER', Castbar)

	-- Add safezone (latency display)
	if frame.cfg.UnitName == "player" then
		Castbar.SafeZone = Castbar:CreateTexture(nil, 'OVERLAY')
	end

	-- Non Interruptable glow
	api:SetGlowBorder(Castbar)
	Castbar.Glowborder:SetPoint("TOPLEFT", Castbar, "TOPLEFT", -6, 6)

	Castbar.PostCastStart = onPostCastStart
	Castbar.PostCastFail = OnPostCastFail
	Castbar.PostCastInterruptible = OnPostCastInterruptible

	api:CreateFaderAnimation(Castbar)
	Castbar.faderConfig = cfg.Castbar.Fader

	-- Register it with oUF
	Castbar.bg = Background
	Castbar.Spark = Spark
	Castbar.Time = Time
	Castbar.Text = Text
	Castbar.Icon = Icon
	Castbar.Shield = Shield
	Castbar.timeToHold = cfg.Castbar.TimeToHold
	frame.Castbar = Castbar
end
