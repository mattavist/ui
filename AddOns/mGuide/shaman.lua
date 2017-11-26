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
	local hailstormTalented = ns.talentChosen(4, 3)

	-- Right
	if UnitExists("target") and IsSpellInRange("Lightning Bolt", "target") ~= 0 and IsSpellInRange("Rockbiter", "target") == 0 then
		right = "Lightning Bolt"
	elseif ns.checkSpell("Doom Winds") and IsSpellInRange("Stormstrike", "target") ~= 0 then
		right = "Doom Winds"
		rightPulse = true
	end

	-- Left
	if ns.checkSpell("Feral Lunge") and IsSpellInRange("Feral Lunge", "target") ~= 0 then
		left = "Feral Lunge"
	elseif ns.checkSpell("Feral Spirit") then
		left = "Feral Spirit"
		leftPulse = true
	end

	if hailstormTalented and ns.checkSpell("Frostbrand") and ns.auraDuration("Frostbrand", "player", "HELPFUL") < ns.gcd then
		spell = "Frostbrand"
	elseif ns.checkSpell("Rockbiter") and ns.auraDuration("Landslide", "player", "HELPFUL") < ns.gcd then
		spell = "Rockbiter"
	elseif ns.auraDuration("Emalon 's Charged Core", "player", "HELPFUL") > 0 and ns.checkSpell("Crash Lightning") then
		spell = "Crash Lightning"
	elseif ns.checkSpell("Earthen Spike") then
		spell = "Earthen Spike"
	elseif ns.auraDuration("Flametongue", "player", "HELPFUL") < ns.gcd then
		spell = "Flametongue"
	elseif ns.checkSpell("Stormstrike") then
		spell = "Stormstrike"
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