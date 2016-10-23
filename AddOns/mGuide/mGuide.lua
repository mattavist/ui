local mGuideFrame = CreateFrame("Frame", "mGuideFrame", UIParent)
local background = mGuideFrame:CreateTexture(nil, "BACKGROUND")
local spellTexture = mGuideFrame:CreateTexture(nil,"BACKGROUND",nil,1)
local gcdTime = 0
local gcd = 0
local throttleCount = 0
local lastSpell = nil
local aoeTime = false

local function checkSpell(spellName)
	local canCast = true
	learned, notEnoughMana = IsUsableSpell(spellName)
	start, cooldown, enable = GetSpellCooldown(spellName)
	if start and start ~= 0 then
		canCast = gcdTime >= start + cooldown
	end
	return canCast and not notEnoughMana and learned
end

local function setSpell(spellName)
	spellTexture:SetTexture(GetSpellTexture(spellName))
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

local function rage()
	return UnitPower("player")
end

local function getBuffValue(buffName, unit)
	local name, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, value = UnitAura(unit, buffName)
	--local name, _, _, _, _, _, expires = UnitAura(unit, buffName, nil, "HELPFUL")
	if name then
		return value
	else
		return 0
	end
end

local function enhanceShamanGuide()
	local spell = nil
	if auraDuration("Flametongue", "player", "HELPFUL") < gcd then
		spell = "Flametongue"
	elseif checkSpell("Stormstrike") then
		spell = "Stormstrike"
	elseif checkSpell("Boulderfist") then
		spell = "Boulderfist"
	--elseif checkSpell("Lava Lash") then
	--	spell = "Lava Lash"
	elseif checkSpell("Lightning Bolt") then
		spell = "Lightning Bolt"
	end

	return spell
end

local function protWarriorGuide()
	local spell = nil
	if auraDuration("Vengeance: Ignore Pain", "Player", "HELPFUL") > 0 then
		spell = "Ignore Pain"
	elseif auraDuration("Vengeance: Focused Rage", "Player", "HELPFUL") > 0 then
		spell = "Focused Rage"
	end

	return spell
end

local function armsWarriorGuide()
	local spell = nil
	local overpowerTalented = talentChosen(1, 2)
	local focusedRageTalented = talentChosen(5, 3)
	local colSmashOnTarget = auraDuration("Colossus Smash", "target", "HARMFUL|PLAYER") > 0.3
	local shatteredDefenses = auraDuration("Shattered Defenses", "Player", "HELPFUL") > 0.3
	local battleCry = auraDuration("Battle Cry", "Player", "HELPFUL") > 0.3
	local focusedRageStacks = auraStacks("Focused Rage", "Player", "HELPFUL")

	-- Decide whether to use AoE or Single Target rotation based on cleave buff
	if aoeTime then
		if GetTime() > aoeTime then
			aoeTime = false
		end
	end

	if getBuffValue("Cleave", "Player") >= 30 then
		aoeTime = GetTime() + 4
	end

	-- AoE Rotation
	if aoeTime then 
		if checkSpell("Warbreaker") then
			spell = "Warbreaker"
		elseif checkSpell("Bladestorm") and colSmashOnTarget then
			spell = "Bladestorm"
		elseif checkSpell("Cleave") then
			spell = "Cleave"
		elseif checkSpell("Whirlwind") and rage() > 35 then
			spell = "Whirlwind"
		elseif checkSpell("Heroic Throw") then
			spell = "Heroic Throw"
		end
	elseif focusedRageTalented then
		-- Focused Rage Rotation
		if checkSpell("Colossus Smash") and not colSmashOnTarget and not shatteredDefenses then
			spell = "Colossus Smash"
		elseif checkSpell("Warbreaker") and not colSmashOnTarget and not shatteredDefenses then
			spell = "Warbreaker"
		elseif overpowerTalented and checkSpell("Overpower") and auraDuration("Overpower!", "Player", "HELPFUL") then
			spell = "Overpower"
		elseif checkSpell("Execute") then
			if focusedRageTalented then
				if focusedRageStacks < 3 then
					spell = "Execute"
				end
			elseif shatteredDefenses then
				spell = "Execute"
			end
		end
		elseif focusRageTalented and checkSpell("Focused Rage") and focusedRageStacks < 3 or battleCry then
			spell = "Focused Rage"
		elseif checkSpell("Mortal Strike") then
			spell = "Mortal Strike"
		elseif checkSpell("Slam") and rage() > 40 or battleCry then
			spell = "Slam"
		elseif checkSpell("Colossus Smash") then
			spell = "Colossus Smash"
		elseif checkSpell("Heroic Throw") then
			spell = "Heroic Throw"
		end
	else
		-- Single Target Rotation
		if checkSpell("Colossus Smash") and not colSmashOnTarget and not shatteredDefenses then
			spell = "Colossus Smash"
		elseif checkSpell("Warbreaker") and not colSmashOnTarget and not shatteredDefenses then
			spell = "Warbreaker"
		elseif overpowerTalented and checkSpell("Overpower") and auraDuration("Overpower!", "Player", "HELPFUL") then
			spell = "Overpower"
		elseif checkSpell("Execute") and shatteredDefenses then
			spell = "Execute"
		elseif checkSpell("Mortal Strike") then
			spell = "Mortal Strike"
		elseif checkSpell("Slam") and rage() > 40 then
			spell = "Slam"
		elseif checkSpell("Colossus Smash") then
			spell = "Colossus Smash"
		elseif checkSpell("Heroic Throw") then
			spell = "Heroic Throw"
		end
	end

	return spell
end

local function guideParent()
    -- Save CPU by only running once every throttleCount times
    throttleCount = throttleCount + 1
    if (throttleCount < 10) then -- Hard coded for performance
        return
    end
    throttleCount = 0

	local spell = guide()
	if spell and spell ~= lastSpell then
		setSpell(spell)
		lastSpell = spell
	end
end

local function initGuideFrame()
	mGuideFrame:SetSize(40,40)
	mGuideFrame:SetPoint("CENTER",0,-190)
	background:SetPoint("BOTTOMRIGHT", 3, -3)
	background:SetPoint("TOPLEFT", -3, 3)
	background:SetColorTexture(0, 0, 0)
	spellTexture:SetTexCoord(0.1,0.9,0.1,0.9) --cut out crappy icon border
	spellTexture:SetAllPoints(mGuideFrame) --make texture same size as button

	-- Show GCD Swirl on Frame
	CreateFrame("Cooldown", "PlayerCooldown", mGuideFrame, "CooldownFrameTemplate")
	PlayerCooldown:SetAllPoints(mGuideFrame)
	mGuideFrame:SetScript("OnEvent", function(self, _, unit, _, _)
		if unit == "player" then
			local gcdStart, gcd = GetSpellCooldown(61304)
			gcdTime = gcdStart + gcd
			PlayerCooldown:SetCooldown(gcdStart, gcd)
		end
	end)
end

local function getSpec()
	local guide = nil
	local _, class, _ = UnitClass("player")
	local specID = GetSpecialization()

	if class == "SHAMAN" then
		if specID == 2 then
			guide = enhanceShamanGuide
		end
	elseif class == "WARRIOR" then
		if specID == 1 then
			guide = armsWarriorGuide
		elseif specID == 3 then
			if talentChosen(6, 1) then -- Checks for Vengeance talent
				guide = protWarriorGuide
			end
		end
	end

	return guide
end

-- Initializes and changes guide when spec changes
local addon = CreateFrame("Frame", nil, UIParent)
addon:RegisterEvent("PLAYER_ENTERING_WORLD")
addon:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
addon:SetScript("OnEvent", function(self, event, unit, ...)
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