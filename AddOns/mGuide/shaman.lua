local addon, ns = ...
local shaman = CreateFrame("Frame")

local function windShockStatus()
	local _, _, _, _, _, _, _, _, notInterruptible = UnitCastingInfo("target")
	if ns.checkSpell("Wind Shear") and notInterruptible == false then
		return "Wind Shear"
	else
		return false
	end
end

shaman.enhance = function()
	local spell = nil
	local glow = false
	local left = false
	local right = false
	local leftPulse = false
	local rightPulse = false
	local topPulse = true

	local maelstrom = UnitPower("player")
	local lightningShield = ns.auraDuration("Lightning Shield", "Player", "HELPFUL") > 1

	-- Right
	if ns.checkSpell("Lightning Shield") and not lightningShield then
		right = "Lightning Shield"
		--rightPulse = true
	elseif UnitExists("target") and IsSpellInRange("Lightning Bolt", "target") ~= 0 and IsSpellInRange("Rockbiter", "target") == 0 then
		right = "Lightning Bolt"
	end

	-- Left
	if ns.checkSpell("Feral Lunge") and IsSpellInRange("Feral Lunge", "target") ~= 0 then
		left = "Feral Lunge"
	elseif ns.checkSpell("Feral Spirit") then
		left = "Feral Spirit"
		--leftPulse = true
	end

	if ns.checkSpell("Flametongue") and ns.auraDuration("Flametongue", "player", "HELPFUL") < ns.gcd then
		spell = "Flametongue"
	elseif ns.checkSpell("Stormstrike") then
		spell = "Stormstrike"
	elseif ns.checkSpell("Flametongue") then
		spell = "Flametongue"
	elseif ns.checkSpell("Sundering") then
		spell = "Sundering"
	elseif ns.checkSpell("Rockbiter") and maelstrom < 70 then
		spell = "Rockbiter"
	elseif ns.checkSpell("Lava Lash") and maelstrom > 40 then
		spell = "Lava Lash"
	elseif ns.checkSpell("Rockbiter") then
		spell = "Rockbiter"
	elseif ns.checkSpell("Lightning Bolt") then
		spell = "Lightning Bolt"
	end

	return spell, glow, left, right, windShockStatus(), leftPulse, rightPulse, topPulse
end

ns.shaman = shaman