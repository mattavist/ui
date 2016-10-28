local addon, ns = ...
local mGuideFrame = CreateFrame("Frame", "mGuideFrame", UIParent)
local background = mGuideFrame:CreateTexture(nil, "BACKGROUND")
local foreground = mGuideFrame:CreateTexture(nil, "BACKGROUND",nil,2)
local spellTexture = mGuideFrame:CreateTexture(nil,"BACKGROUND",nil,1)
local gcdTime = 0
local throttleCount = 0
local lastSpell = nil
local gcd = 1.3

local function checkSpell(spellName)
	local canCast = true
	learned, notEnoughMana = IsUsableSpell(spellName)
	start, cooldown, enable = GetSpellCooldown(spellName)
	if start and start ~= 0 then
		canCast = gcdTime >= start + cooldown
	end
	return canCast and not notEnoughMana and learned
end

local function auraDuration(buffName, unit, auraType)
	local name, _, _, _, _, _, expires = UnitAura(unit, buffName, nil, auraType)
    if name then
    	return expires - GetTime()
	end

    return 0
end

local function auraStacks(buffName, unit, auraType)
	local name, _, _, count = UnitAura(unit, buffName, nil, auraType)
    if name then
    	return count
	end

    return 0
end

local function talentChosen(row, column)
	local _, selected = GetTalentTierInfo(row, 1)
	return selected == column
end

local function getBuffValue(buffName, unit)
	local name, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, value = UnitAura(unit, buffName)
	if name then
		return value
	else
		return 0
	end
end

local function setSpell(spellName)
	spellTexture:SetTexture(GetSpellTexture(spellName))
end

local function guideParent()
    -- Save CPU by only running once every throttleCount times
    throttleCount = throttleCount + 1
    if (throttleCount < 10) then -- Hard coded for performance
        return
    end
    throttleCount = 0

	-- Set the spell texture if it has changed
    local spell, glow = guide()
	if spell and spell ~= lastSpell then
		setSpell(spell)
		lastSpell = spell
	end

	-- Make it pulse a glowing thing
	if glow then
		ActionButton_ShowOverlayGlow(mGuideFrame)
	else
		ActionButton_HideOverlayGlow(mGuideFrame)
	end

	-- Set the cooldown spiral
	if spell then
		background:SetColorTexture(0, 0, 0, .75)
		if IsSpellInRange(spell, "target") == 0 then
			foreground:SetColorTexture(1, 0, 0, 0.5) -- Out of range
		elseif not checkSpell(spell) then
			foreground:SetColorTexture(0, 0, 1, 0.5) -- Not enough mana
		else
			foreground:SetColorTexture(1, 0, 0, 0) -- Usable
		end
	else
		background:SetColorTexture(0, 0, 0, 0)
	end
end

local function initGuideFrame()
	mGuideFrame:SetSize(50,50)
	mGuideFrame:SetPoint("CENTER",0,-190)
	background:SetPoint("BOTTOMRIGHT", 3, -3)
	background:SetPoint("TOPLEFT", -3, 3)
	background:SetColorTexture(0, 0, 0, 0.75)
	foreground:SetPoint("BOTTOMRIGHT")
	foreground:SetPoint("TOPLEFT")
	spellTexture:SetTexCoord(0.1,0.9,0.1,0.9) --cut out crappy icon border
	spellTexture:SetAllPoints(mGuideFrame) --make texture same size as button

	-- Show GCD Swirl on Frame
	CreateFrame("Cooldown", "PlayerCooldown", mGuideFrame, "CooldownFrameTemplate")
	PlayerCooldown:SetAllPoints(mGuideFrame)
	mGuideFrame:SetScript("OnEvent", function(self, _, unit, _, _)
		if unit == "player" then
			gcdStart, gcd = GetSpellCooldown(61304)
			gcdTime = gcdStart + gcd
			PlayerCooldown:SetCooldown(gcdStart, gcd)
			if gcd then
				ns.gcd = gcd
			end
		end
	end)
end

local function getSpec()
	local guide = nil
	local _, class, _ = UnitClass("player")
	local specID = GetSpecialization()

	if class == "SHAMAN" then
		if specID == 2 then
			guide = ns.shaman.enhance
		end
	elseif class == "WARRIOR" then
		if specID == 1 then
			guide = ns.warrior.arms
		elseif specID == 3 and ns.talentChosen(6, 1) then -- Checks for Vengeance talent
			guide = ns.warrior.prot
		end
	end

	return guide
end

-- Initializes and changes guide when spec changes
local guider = CreateFrame("Frame", nil, UIParent)
guider:RegisterEvent("PLAYER_ENTERING_WORLD")
guider:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
guider:SetScript("OnEvent", function(self, event, unit, ...)
	if event == "PLAYER_SPECIALIZATION_CHANGED" then
		if not unit == "Player" then
			return
		end
	elseif event == "PLAYER_ENTERING_WORLD" then
		initGuideFrame()
	end

	guide = getSpec()
	if not guide then
		mGuideFrame:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED")
		mGuideFrame:UnregisterEvent("UNIT_SPELLCAST_START")
		mGuideFrame:SetScript("OnUpdate", nil)
		mGuideFrame:Hide()
	else
		mGuideFrame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
		mGuideFrame:RegisterEvent("UNIT_SPELLCAST_START")
		mGuideFrame:SetScript("OnUpdate", guideParent)
		mGuideFrame:Show()
	end
end)

-- Put shared functions and variables in the namespace
ns.checkSpell = checkSpell
ns.auraDuration = auraDuration
ns.auraStacks = auraStacks
ns.talentChosen = talentChosen
ns.getBuffValue = getBuffValue
ns.gcd = gcd