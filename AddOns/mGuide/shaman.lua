local addon, ns = ...
local shaman = CreateFrame("Frame")

shaman.enhance = function()
	local spell = nil
	if ns.auraDuration("Flametongue", "player", "HELPFUL") < ns.gcd then
		spell = "Flametongue"
	elseif ns.checkSpell("Stormstrike") then
		spell = "Stormstrike"
	elseif ns.checkSpell("Boulderfist") then
		spell = "Boulderfist"
	--elseif checkSpell("Lava Lash") then
	--	spell = "Lava Lash"
	elseif ns.checkSpell("Lightning Bolt") then
		spell = "Lightning Bolt"
	end

	return spell
end

ns.shaman = shaman