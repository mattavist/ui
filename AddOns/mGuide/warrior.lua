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

local function tankSwap()
	if not UnitExists("focus") then
		return false
	elseif not ns.checkSpell("Taunt") then
		return false
	end

	-- Nighthold
	if ns.auraStacks("Chronometric Particles", "focus", "HARMFUL") > 7 then
		return true
	elseif ns.auraStacks("Arcane Slash", "focus", "HARMFUL") > 1 then
		return true
	elseif ns.auraStacks("Annihilated", "focus", "HARMFUL") > 1 then
		return true
	elseif ns.auraStacks("Searing Brand", "focus", "HARMFUL") > 7 then
		return true
	elseif ns.auraStacks("Recursive Strikes", "focus", "HARMFUL") > 7 then
		return true
	elseif ns.auraStacks("Ablation", "focus", "HARMFUL") > 3 then
		return true
	--elseif ns.auraDuration("Thunder Clap", "focus", "HARMFUL") > 0 then
	--	return true
	-- Tomb of Sargeras
	elseif ns.auraDuration("Burden of Pain", "focus", "HARMFUL") > 0 then
		return true
	elseif ns.auraStacks("Lunar Fire", "focus", "HARMFUL") > 1 then
		return true
	elseif ns.auraStacks("Desolate", "focus", "HARMFUL") > 1 then
		return true
	-- Antorus
	end

	return false
end

warrior.prot = function()
	local spell = nil
	local glow = tankSwap()
	local left = false
	local right = false
	local leftPulse = false
	local rightPulse = false
	local topPulse = true

	local revenge = ns.auraDuration("Revenge!", "Player", "HELPFUL") > 0.5
	local ignorePain = ns.auraDuration("Vengeance: Ignore Pain", "Player", "HELPFUL") > 0
	local shieldBlock = ns.auraDuration("Shield Block", "Player", "HELPFUL") < 3 and ns.checkSpell("Shield Block")

	-- Left and Right Buttons
	if shieldBlock then
		left = "Shield Block"
	end

	if ignorePain then
		right = "Ignore Pain"
	end

	if ns.checkSpell("Shield Slam") then
		spell = "Shield Slam"
	elseif not ignorePain and ns.checkSpell("Revenge") then
		spell = "Revenge"
	elseif ns.checkSpell("Thunder Clap") then
		spell = "Thunder Clap"
	elseif revenge and ns.checkSpell("Revenge") then
		spell = "Revenge"
	else
		spell = "Devastator"
	end

	return spell, glow, left, right, pummelStatus(), leftPulse, rightPulse, topPulse
end

warrior.arms = function()
	local spell = nil
	local glow = false
	local left = false
	local right = false
	local leftPulse = false
	local rightPulse = false
	local topPulse = true

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
		rightPulse = true
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
	elseif ns.talentChosen(1, 2) and ns.auraDuration("Overpower!", "Player", "HELPFUL") > 0 then -- and ns.checkSpell("Overpower") then

		spell = "Overpower"
	elseif ns.checkSpell("Execute") and focusedRageStacks < 3 then
		spell = "Execute"
	elseif ns.checkSpell("Mortal Strike") then
		spell = "Mortal Strike"
	elseif ns.checkSpell("Slam") and (battleCry or (rage > 32)) then
		spell = "Slam"
	elseif ns.checkSpell("Colossus Smash") then
		spell = "Colossus Smash"
	else
		spell = "Heroic Throw"
	end

	return spell, glow, left, right, pummelStatus(), leftPulse, rightPulse, topPulse
end

warrior.fury = function()
	local spell = nil
	local glow = false
	local left = false
	local right = false
	local leftPulse = false
	local rightPulse = false
	local topPulse = true

	local rage = UnitPower("player")
	local enraged = ns.auraDuration("Enrage", "Player", "HELPFUL") > 1
	local battleShout = ns.auraDuration("Battle Shout", "Player", "HELPFUL") > 600

	-- Charge on left
	if ns.checkSpell("Charge") and UnitExists("target") and IsSpellInRange("Charge", "target") ~= 0 then
		left = "Charge"
	elseif ns.checkSpell("Battle Shout") and not battleShout then
		left = "Battle Shout"
		leftPulse = true
	end

	-- Battle Cry on right
	if ns.checkSpell("Heroic Throw") and UnitExists("target") and IsSpellInRange("Heroic Throw", "target") ~= 0 then
		right = "Heroic Throw"
	elseif ns.checkSpell("Recklessness") then
		right = "Recklessness"
		rightPulse = true
	end

	-- Rotation
	if ns.checkSpell("Rampage") and (not enraged or rage > 95) then
		spell = "Rampage"
	elseif ns.checkSpell("Execute") and enraged then
		spell = "Execute"
	elseif ns.checkSpell("Bloodthirst") then
		spell = "Bloodthirst"
	elseif ns.checkSpell("Raging Blow") then
		spell = "Raging Blow"
	elseif ns.checkSpell("Bladestorm") then
		spell = "Bladestorm"
	else
		spell = "Whirlwind"
	end

	return spell, glow, left, right, pummelStatus(), leftPulse, rightPulse, topPulse
end


ns.warrior = warrior