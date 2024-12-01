local _, ns = ...
local cfg, media, bars, api = ns.cfg, ns.media, ns.bars, ns.api

function bars:createHealth(self, unit)
	local Health = CreateFrame('StatusBar', nil, self)
	Health:SetHeight(cfg[unit].HealthHeight)
	Health:SetPoint('TOP')
	Health:SetPoint('LEFT')
	Health:SetPoint('RIGHT')
	Health:SetStatusBarTexture(media.textures.status_texture)
	Health:SetStatusBarColor(unpack(cfg.colors.health))
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
	color = RAID_CLASS_COLORS[select(2, UnitClass("player"))]

	self.Health = Health
end

function bars:createPower(self, unit)
	if cfg[unit].PowerHeight == 0 then return end

	local Power = CreateFrame('StatusBar', nil, self)
	Power:SetHeight(cfg[unit].PowerHeight)
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

	local initialColor = cfg[unit].CastbarColor or cfg.CastbarColor
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
		-- else
		-- 	unit = self.__owner.mystyle
	end


	-- Set the castbar unit's initial color
	self:SetStatusBarColor(unpack(cfg.CastbarColor))

	CheckForSpellInterrupt(self, unit)
	-- SetHearthstoneBindingLocation(self, unit)

	-- api:StartFadeIn(self)  TODO: Implement this?
	self.__owner:SetAlpha(1)
end

local function OnPostCastFail(self, unit)
	self:SetStatusBarColor(235 / 255, 25 / 255, 25 / 255, 0.8)
	-- api:StartFadeOut(self)  TODO: Implement this?
	self.__owner:SetAlpha(0)

	if self.Max then self.Max:Hide() end
end

local function OnPostCastInterruptible(self, unit)
	CheckForSpellInterrupt(self, unit)
end

function bars:CreateCast(self, unit)
	if not cfg[unit].EnableCastbar then return end

	-- Position and size
	local Castbar = CreateFrame('StatusBar', nil, UIParent)
	Castbar:SetSize(cfg.PrimaryFrameWidth, 20)
	Castbar:SetPoint("LEFT", self, "LEFT", 0, cfg.CastbarOffsetY)
	Castbar:SetStatusBarTexture(media.textures.status_texture)
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

	-- Add safezone
	local SafeZone = Castbar:CreateTexture(nil, 'OVERLAY')


	-- Non Interruptable glow
	api:SetGlowBorder(Castbar)
	Castbar.Glowborder:SetPoint("TOPLEFT", Castbar, "TOPLEFT", -6, 6)

	Castbar.PostCastStart = onPostCastStart
	Castbar.PostCastFail = OnPostCastFail
	Castbar.PostCastInterruptible = OnPostCastInterruptible

	-- Register it with oUF
	Castbar.bg = Background
	Castbar.Spark = Spark
	Castbar.Time = Time
	Castbar.Text = Text
	Castbar.Icon = Icon
	Castbar.Shield = Shield
	Castbar.SafeZone = SafeZone
	self.Castbar = Castbar
end
