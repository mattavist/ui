local b = CreateFrame("BUTTON", "mGuideFrame", UIParent, "SecureHandlerClickTemplate");
b:SetSize(50,50)
b:SetPoint("CENTER",0,-190)
b:RegisterForClicks("AnyUp")
local t = b:CreateTexture(nil,"BACKGROUND",nil,-6)
t:SetTexCoord(0.1,0.9,0.1,0.9) --cut out crappy icon border
t:SetAllPoints(b) --make texture same size as button
local lastSpell = nil

local function checkSpell(spellName)
	local canCast = true
	learned, notEnoughMana = IsUsableSpell(spellName)
	start, cooldown, enable = GetSpellCooldown(spellName)
	if start ~= 0 then
		toReady = GetTime() - start
		canCast = cooldown - toReady <= 1.6
	end

	return canCast and not notEnoughMana
end

local function setSpell(spellName)
	t:SetTexture(GetSpellTexture(spellName))
end

local function checkBuff(buffName)
	local name, _, _, _, _, _, expires = UnitBuff("player", buffName)
    if name then
    	if (expires - GetTime()) <= 1 then
    		return false
    	end
    	return true
    end
    return false
end

b:SetScript("OnUpdate", function()
	if not InCombatLockdown() then
		return
	end
	
	local spell = nil
	
	if not checkBuff("Flametongue") then
		spell = "Flametongue"
	elseif checkSpell("Stormstrike") then
		spell = "Stormstrike"
	elseif checkSpell("Boulderfist") then
		spell = "Boulderfist"
	elseif checkSpell("Lava Lash") then
		spell = "Lava Lash"
	else
		spell = "Lightning Bolt"
	end

	if not (spell == lastSpell) then
		setSpell(spell)
	end
end)

