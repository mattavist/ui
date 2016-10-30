local addon, ns = ...
local warrior = CreateFrame("Frame")
local aoeTime = false

local function pummelStatus()
	local _, _, _, _, _, _, _, _, notInterruptible = UnitCastingInfo("target")
	if ns.checkSpell("Pummel") and notInterruptible == false then
		return "Pummel"
	else
		return false
	end
end

warrior.prot = function()
	local spell = nil
	local glow = false
	local left = false
	local right = false

	-- Set spell to Ignore Pain or Focused Rage
	if ns.auraDuration("Vengeance: Ignore Pain", "Player", "HELPFUL") > 0 then
		left = "Ignore Pain"
	elseif ns.auraDuration("Vengeance: Focused Rage", "Player", "HELPFUL") > 0 then
		right = "Focused Rage"
	end

	if ns.checkSpell("Shield Slam") then
		spell = "Shield Slam"
	elseif ns.checkSpell("Revenge") then
		spell = "Revenge"
	else
		spell = "Shield Block"
	end

	return spell, glow, left, right, pummelStatus()
end

warrior.arms = function()
	local spell = nil
	local glow = false
	local left = false
	local right = false

	local rage = UnitPower("player")
	local focusedRageTalented = ns.talentChosen(5, 3)
	local colSmashOnTarget = ns.auraDuration("Colossus Smash", "target", "HARMFUL|PLAYER") > 0
	local shatteredDefenses = ns.auraDuration("Shattered Defenses", "Player", "HELPFUL") > 0.5
	local battleCry = ns.auraDuration("Battle Cry", "Player", "HELPFUL") > 0.5
	local focusedRageStacks = ns.auraStacks("Focused Rage", "Player", "HELPFUL")

	-- Charge on left
	if ns.checkSpell("Charge") and UnitExists("target") and IsSpellInRange("Charge", "target") ~= 0 then
		left = "Charge"
	end

	-- Battle Cry on right
	if ns.checkSpell("Heroic Throw") and UnitExists("target") and IsSpellInRange("Heroic Throw", "target") ~= 0 then
		right = "Heroic Throw"
	elseif ns.checkSpell("Battle Cry") and IsSpellInRange("Pummel", "target") ~= 0 then
		right = "Battle Cry"
	end

	-- Arms glow is based on focus rage
	if focusedRageTalented and (GetSpellCooldown("Focused Rage") == 0) and (
		battleCry or (
		(rage < 32 and (shatteredDefenses and focusedRageStacks < 1)) or
		(rage > 90 and focusedRageStacks < 3))) then
			glow = true
	end

	-- Decide whether to use AoE or Single Target rotation based on cleave buff
	if aoeTime then
		if GetTime() > aoeTime then
			aoeTime = false
		end
	end
	if ns.getBuffValue("Cleave", "Player") >= 30 then
		aoeTime = GetTime() + 4
	end

	-- Rotation
	if aoeTime and ns.checkSpell("Cleave") then
		spell = "Cleave"
	elseif ns.checkSpell("Whirlwind") and ns.auraDuration("Cleave", "Player", "HELPFUL") > 0.5 then
		spell = "Whirlwind"
	elseif ns.checkSpell("Colossus Smash") then--and not shatteredDefenses then
		spell = "Colossus Smash"
	elseif ns.checkSpell("Warbreaker") and not colSmashOnTarget then --and not shatteredDefenses then
		spell = "Warbreaker"
	elseif ns.talentChosen(1, 2) and ns.auraDuration("Overpower!", "Player", "HELPFUL") then -- ns.checkSpell("Overpower") and 
		spell = "Overpower"
	elseif ns.checkSpell("Execute") and focusedRageStacks < 3 then
		spell = "Execute"
	elseif ns.checkSpell("Mortal Strike") then
		spell = "Mortal Strike"
	elseif ns.checkSpell("Slam") and (battleCry or (rage > 32)) then
		spell = "Slam"
	elseif ns.checkSpell("Colossus Smash") then
		spell = "Colossus Smash"
	elseif ns.checkSpell("Heroic Throw") then
		spell = "Heroic Throw"
	end

	return spell, glow, left, right, pummelStatus()
end


ns.warrior = warrior