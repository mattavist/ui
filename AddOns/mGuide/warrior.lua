local addon, ns = ...
local warrior = CreateFrame("Frame")
local aoeTime = false

warrior.prot = function()
	local spell = nil
	if ns.auraDuration("Vengeance: Ignore Pain", "Player", "HELPFUL") > 0 then
		spell = "Ignore Pain"
	elseif ns.auraDuration("Vengeance: Focused Rage", "Player", "HELPFUL") > 0 then
		spell = "Focused Rage"
	end

	return spell, false
end

warrior.arms = function()
	local spell = nil
	local rage = UnitPower("player")
	local focusedRageTalented = ns.talentChosen(5, 3)
	local colSmashOnTarget = ns.auraDuration("Colossus Smash", "target", "HARMFUL|PLAYER") > 0
	local shatteredDefenses = ns.auraDuration("Shattered Defenses", "Player", "HELPFUL") > 0.5
	local battleCry = ns.auraDuration("Battle Cry", "Player", "HELPFUL") > 0.5
	local focusedRageStacks = ns.auraStacks("Focused Rage", "Player", "HELPFUL")

	-- Arms glow is based on focus rage
	if focusedRageTalented and ns.checkSpell("Focused Rage") and (
		battleCry or (
		(rage < 32 and (shatteredDefenses and focusedRageStacks < 1)) or
		(rage > 90 and focusedRageStacks < 3))) then
			glow = true
	else
		glow = false
	end

	-- Decide whether to use AoE or Single Target rotation based on cleave buff
	if aoeTime then
		if GetTime() > aoeTime then
			aoeTime = false
		end
	end
	if ns.getBuffValue("Cleave", "Player") >= 1 then
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

	return spell, glow
end


ns.warrior = warrior