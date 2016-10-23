local addon, ns = ...
local shaman = CreateFrame("Frame")

shaman.enhance = function()
	local spell = nil
	local maelstrom = UnitPower("player")
	local boulderfistTalented = ns.talentChosen(1, 3)
	local hailstormTalented = ns.talentChosen(4, 3)

	if boulderfistTalented and ns.checkSpell("Boulderfist") and ns.auraDuration("Boulderfist", "player", "HELPFUL") < ns.gcd then
		spell = "Rockbiter"
	elseif hailstormTalented and ns.checkSpell("Frostbrand") and ns.auraDuration("Frostbrand", "player", "HELPFUL") < ns.gcd then
		spell = "Frostbrand"
	elseif ns.auraDuration("Flametongue", "player", "HELPFUL") < ns.gcd then
		spell = "Flametongue"
	elseif ns.checkSpell("Feral Spirit") then
		spell = "Feral Spirit"
	elseif ns.checkSpell("Doom Winds") then
		spell = "Doom Winds"
	elseif ns.checkSpell("Stormstrike") then
		spell = "Stormstrike"
	elseif ns.checkSpell("Rockbiter") then
		spell = "Rockbiter"
	elseif ns.checkSpell("Lava Lash") and maelstrom > 100 then
		spell = "Lava Lash"
	elseif ns.checkSpell("Lightning Bolt") then
		spell = "Lightning Bolt"
	end

	return spell
end

ns.shaman = shaman