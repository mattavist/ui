local addon, ns = ...
local warrior = CreateFrame("Frame")

warrior.prot = function()
	local spell = nil
	if ns.auraDuration("Vengeance: Ignore Pain", "Player", "HELPFUL") > 0 then
		spell = "Ignore Pain"
	elseif ns.auraDuration("Vengeance: Focused Rage", "Player", "HELPFUL") > 0 then
		spell = "Focused Rage"
	end

	return spell
end

warrior.arms = function()
	local spell = nil
	local overpowerTalented = ns.talentChosen(1, 2)
	local focusedRageTalented = ns.talentChosen(5, 3)
	local colSmashOnTarget = ns.auraDuration("Colossus Smash", "target", "HARMFUL|PLAYER") > 0.3
	local shatteredDefenses = ns.auraDuration("Shattered Defenses", "Player", "HELPFUL") > 0.3
	local battleCry = ns.auraDuration("Battle Cry", "Player", "HELPFUL") > 0.3
	local focusedRageStacks = ns.auraStacks("Focused Rage", "Player", "HELPFUL")
	local rage = UnitPower("player")

	-- Decide whether to use AoE or Single Target rotation based on cleave buff
	if aoeTime then
		if GetTime() > aoeTime then
			aoeTime = false
		end
	end

	if ns.getBuffValue("Cleave", "Player") >= 30 then
		aoeTime = GetTime() + 4
	end

	-- AoE Rotation
	if aoeTime then 
		if ns.checkSpell("Warbreaker") then
			spell = "Warbreaker"
		elseif ns.checkSpell("Bladestorm") and colSmashOnTarget then
			spell = "Bladestorm"
		elseif ns.checkSpell("Cleave") then
			spell = "Cleave"
		elseif ns.checkSpell("Whirlwind") and rage > 35 then
			spell = "Whirlwind"
		elseif ns.checkSpell("Heroic Throw") then
			spell = "Heroic Throw"
		end
	else
		-- Focused Rage Rotation
		if ns.checkSpell("Colossus Smash") and not colSmashOnTarget and not shatteredDefenses then
			spell = "Colossus Smash"
		elseif ns.checkSpell("Warbreaker") and not colSmashOnTarget and not shatteredDefenses then
			spell = "Warbreaker"
		elseif overpowerTalented and ns.checkSpell("Overpower") and ns.auraDuration("Overpower!", "Player", "HELPFUL") then
			spell = "Overpower"
		elseif ns.checkSpell("Execute") then
			if focusedRageTalented then
				if focusedRageStacks < 3 then
					spell = "Execute"
				end
			elseif shatteredDefenses then
				spell = "Execute"
			end
		elseif focusRageTalented and ns.checkSpell("Focused Rage") and focusedRageStacks < 3 or battleCry then
			spell = "Focused Rage"
		elseif ns.checkSpell("Mortal Strike") then
			spell = "Mortal Strike"
		elseif ns.checkSpell("Slam") and rage > 40 or battleCry then
			spell = "Slam"
		elseif ns.checkSpell("Colossus Smash") then
			spell = "Colossus Smash"
		elseif ns.checkSpell("Heroic Throw") then
			spell = "Heroic Throw"
		end
	end

	return spell
end


ns.warrior = warrior