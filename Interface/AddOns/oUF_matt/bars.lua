local _, ns = ...
local cfg, media, bars, api = ns.cfg, ns.media, ns.bars, ns.api

local function createHealthPrediction(self)
	if not self.Health then return end
	if not self.cfg.HealthPrediction then return end

	-- Position and size
	local myBar = CreateFrame('StatusBar', nil, self.Health)
	myBar:SetPoint('TOP')
	myBar:SetPoint('BOTTOM')
	myBar:SetPoint('LEFT', self.Health:GetStatusBarTexture(), 'RIGHT')
	myBar:SetWidth(self.cfg.FrameSize[1])
	myBar:SetStatusBarTexture(media.textures.status_texture)
	myBar:SetStatusBarColor(125 / 255, 255 / 255, 50 / 255, .4)

	local otherBar = CreateFrame('StatusBar', nil, self.Health)
	otherBar:SetPoint('TOP')
	otherBar:SetPoint('BOTTOM')
	otherBar:SetPoint('LEFT', self.Health:GetStatusBarTexture(), 'RIGHT')
	otherBar:SetWidth(self.cfg.FrameSize[1])
	otherBar:SetStatusBarTexture(media.textures.status_texture)
	otherBar:SetStatusBarColor(100 / 255, 235 / 255, 200 / 255, .4)

	local absorbBar = CreateFrame('StatusBar', nil, self.Health)
	absorbBar:SetPoint('TOP')
	absorbBar:SetPoint('BOTTOM')
	absorbBar:SetPoint('LEFT', self.Health:GetStatusBarTexture(), 'RIGHT')
	absorbBar:SetWidth(self.cfg.FrameSize[1])
	absorbBar:SetStatusBarTexture(media.textures.status_texture)
	absorbBar:SetStatusBarColor(18053 / 255, 255 / 255, 205 / 255, .35)


	local healAbsorbBar = CreateFrame('StatusBar', nil, self.Health)
	healAbsorbBar:SetPoint('TOP')
	healAbsorbBar:SetPoint('BOTTOM')
	healAbsorbBar:SetPoint('RIGHT', self.Health:GetStatusBarTexture())
	healAbsorbBar:SetWidth(self.cfg.FrameSize[1])
	healAbsorbBar:SetReverseFill(true)
	healAbsorbBar:SetStatusBarTexture(media.textures.status_texture)
	healAbsorbBar:SetStatusBarColor(183 / 255, 244 / 255, 255 / 255, .35)

	local overAbsorb = self.Health:CreateTexture(nil, "OVERLAY")
	overAbsorb:SetPoint('TOP')
	overAbsorb:SetPoint('BOTTOM')
	overAbsorb:SetPoint('LEFT', self.Health, 'RIGHT')
	overAbsorb:SetWidth(10)

	local overHealAbsorb = self.Health:CreateTexture(nil, "OVERLAY")
	overHealAbsorb:SetPoint('TOP')
	overHealAbsorb:SetPoint('BOTTOM')
	overHealAbsorb:SetPoint('RIGHT', self.Health, 'LEFT')
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

function bars:createHealth(self, unit)
	local TempLoss = CreateFrame('StatusBar', nil, self)
	TempLoss:SetReverseFill(true)
	TempLoss:SetHeight(self.cfg.HealthHeight)
	TempLoss:SetPoint('TOP')
	TempLoss:SetPoint('LEFT')
	TempLoss:SetPoint('RIGHT')
	TempLoss:SetStatusBarTexture(media.textures.debuff_texture)
	TempLoss:GetStatusBarTexture():SetHorizTile(true)

	local Health = CreateFrame('StatusBar', nil, self)
	Health:SetPoint("LEFT")
	Health:SetPoint('TOPRIGHT', TempLoss:GetStatusBarTexture(), 'TOPLEFT')
	Health:SetPoint('BOTTOMRIGHT', TempLoss:GetStatusBarTexture(), 'BOTTOMLEFT')
	Health:SetStatusBarTexture(media.textures.status_texture)
	Health:GetStatusBarTexture():SetHorizTile(false)

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

	Health.TempLoss = TempLoss
	self.Health = Health
	self.HealthPrediction = createHealthPrediction(self)
end

function bars:createPower(self, unit)
	if self.cfg.PowerHeight == 0 then return end

	local Power = CreateFrame('StatusBar', nil, self)
	Power:SetHeight(self.cfg.PowerHeight)
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

	self.Power = Power
end

local function CheckForSpellInterrupt(self, unit)
	if unit == "vehicle" then unit = "player" end

	local owner = self.__owner
	local initialColor = cfg.CastbarColor
	if owner.cfg and owner.cfg.CastbarColor then
		initialColor = owner.cfg.CastbarColor
	end

	self:SetStatusBarColor(unpack(initialColor))
	if self.Glowborder then self.Glowborder:Hide() end

	if UnitCanAttack("player", unit) then
		if self.notInterruptible then
			self:SetStatusBarColor(unpack(cfg.UninterruptibleCastbarColor))
		else
			if self.Glowborder then
				self.Glowborder:SetBackdropBorderColor(unpack(cfg.InterruptibleCastbarGlowColor))
				self.Glowborder:Show()
			end
		end
	end
end

local function onPostCastStart(self, unit)
	if unit == "vehicle" then
		unit = "player"
	end

	-- Set the castbar unit's initial color
	self:SetStatusBarColor(unpack(cfg.CastbarColor))
	CheckForSpellInterrupt(self, unit)
	api:StartFadeIn(self)
end

local function OnPostCastFail(self, unit)
	self:SetStatusBarColor(235 / 255, 25 / 255, 25 / 255, 0.8)
	if self.Max then self.Max:Hide() end
	api:StartFadeOut(self)
end

local function OnPostCastInterruptible(self, unit)
	CheckForSpellInterrupt(self, unit)
end

function bars:CreateCast(self, unit)
	if not self.cfg.EnableCastbar then return end

	-- Position and size
	local Castbar = CreateFrame('StatusBar', nil, UIParent)
	Castbar:SetSize(cfg.PrimaryFrameWidth, 20)
	Castbar:SetPoint("LEFT", self, "LEFT", 0, cfg.CastbarOffsetY)
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
	Time:SetFont(cfg.CastbarFont, cfg.CastbarFontSize, "THINOUTLINE")
	if unit == "target" then
		Time:SetPoint('LEFT', Castbar)
	else
		Time:SetPoint('RIGHT', Castbar)
	end

	-- Add spell text
	local Text = Castbar:CreateFontString(nil, 'OVERLAY')
	Text:SetTextColor(1, 1, 1)
	Text:SetShadowOffset(1, -1)
	Text:SetFont(cfg.CastbarFont, cfg.CastbarFontSize, "THINOUTLINE")
	Text:SetPoint('CENTER', Castbar)

	-- Add Shield
	local Shield = Castbar:CreateTexture(nil, 'OVERLAY')
	Shield:SetSize(20, 20)
	Shield:SetPoint('CENTER', Castbar)

	-- Add safezone (latency display)
	if unit == "player" then
		Castbar.SafeZone = Castbar:CreateTexture(nil, 'OVERLAY')
	end

	-- Non Interruptable glow
	api:SetGlowBorder(Castbar)
	Castbar.Glowborder:SetPoint("TOPLEFT", Castbar, "TOPLEFT", -6, 6)

	Castbar.PostCastStart = onPostCastStart
	Castbar.PostCastFail = OnPostCastFail
	Castbar.PostCastInterruptible = OnPostCastInterruptible

	api:CreateFaderAnimation(Castbar)
	Castbar.faderConfig = cfg.CastbarFader

	-- Register it with oUF
	Castbar.bg = Background
	Castbar.Spark = Spark
	Castbar.Time = Time
	Castbar.Text = Text
	Castbar.Icon = Icon
	Castbar.Shield = Shield
	Castbar.timeToHold = cfg.CastbarTimeToHold
	self.Castbar = Castbar
end
