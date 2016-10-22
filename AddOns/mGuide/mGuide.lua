local mGuideFrame = CreateFrame("Frame", "mGuideFrame", UIParent)
local background = mGuideFrame:CreateTexture(nil, "BACKGROUND")
local spellTexture = mGuideFrame:CreateTexture(nil,"BACKGROUND",nil,1)
local gcdTime = 0
local throttleCount = 0
local lastSpell = nil

local function checkSpell(spellName)
	local canCast = true
	learned, notEnoughMana = IsUsableSpell(spellName)
	start, cooldown, enable = GetSpellCooldown(spellName)
	if start ~= 0 then
		canCast = gcdTime >= start + cooldown
	end
	return canCast and not notEnoughMana and learned
end

local function setSpell(spellName)
	spellTexture:SetTexture(GetSpellTexture(spellName))
end

local function checkAura(buffName, unit, type)
	local name, _, _, _, _, _, expires = UnitAura(unit, buffName, nil, type)
    if name then
    	if (expires - GetTime()) <= 1.5 then
    		return false
    	end
    	return true
    end
    return false
end

local function rage()
	return UnitPower("player")
end

local function enhanceShamanGuide()
	local spell = nil
	if not checkAura("Flametongue", "player", "HELPFUL") then
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

local function armsWarriorGuide()
	local spell = nil
	local colSmashOnTarget = checkAura("Colossus Smash", "target", "HARMFUL")
	local shatteredDefenses = checkAura("Shattered Defenses", "Player", "HELPFUL")

	if checkSpell("Colossus Smash") and not colSmashOnTarget and not shatteredDefenses then
		spell = "Colossus Smash"
	elseif checkSpell("Warbreaker") and not colSmashOnTarget and not shatteredDefenses then
		spell = "Warbreaker"
	elseif checkSpell("Overpower") and checkAura("Overpower!", "Player", "HELPFUL") then
		spell = "Overpower"
	elseif checkSpell("Execute") and shatteredDefenses then
		spell = "Execute"
	elseif checkSpell("Mortal Strike") then
		spell = "Mortal Strike"
	elseif checkSpell("Slam") and rage() > 40 then
		spell = "Slam"
	elseif checkSpell("Heroic Throw") then
		spell = "Heroic Throw"
	end

	return spell
end

local function guideParent()
	--if not InCombatLockdown() then
	--	return
	--end

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
	mGuideFrame:SetScript("OnEvent", function(self, _, unit, spellName, _)
		if unit == "player" then
			time = GetTime()
			if gcdTime > time + .3 then
				--ChatFrame3:AddMessage("Not spiralinga")
				return
			end
			gcdTime = time + 1.27
			PlayerCooldown:SetCooldown(time, 1.27)
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
		mGuideFrame:SetScript("OnUpdate", nil)
		mGuideFrame:Hide()
	else
		mGuideFrame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
		mGuideFrame:SetScript("OnUpdate", guideParent)
		mGuideFrame:Show()
	end
end)