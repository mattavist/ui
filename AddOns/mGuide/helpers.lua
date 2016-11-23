local addon, ns = ...
ns.gcd = 7
ns.gcdTime = 0
ns.start = 0
--ns.gcdTime = 0
--ns.gcd = 1.3

local function checkSpell(spellName)
	local canCast = true
	learned, notEnoughMana = IsUsableSpell(spellName)
	start, cooldown, enable = GetSpellCooldown(spellName)
	if start and start ~= 0 then
		canCast = ns.gcdTime >= start + cooldown - .1
	end
	return canCast and not notEnoughMana and learned
end

local function auraDuration(buffName, unit, auraType)
	local name, _, _, _, _, _, expires = UnitAura(unit, buffName, nil, auraType)
    if name then
    	return expires - GetTime()
	end

    return 0
end

local function auraStacks(buffName, unit, auraType)
	local name, _, _, count = UnitAura(unit, buffName, nil, auraType)
    if name then
    	return count
	end

    return 0
end

local function talentChosen(row, column)
	local _, selected = GetTalentTierInfo(row, 1)
	return selected == column
end

local function getBuffValue(buffName, unit)
	local name, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, value = UnitAura(unit, buffName)
	if name then
		return value
	else
		return 0
	end
end

ns.checkSpell = checkSpell
ns.auraDuration = auraDuration
ns.auraStacks = auraStacks
ns.talentChosen = talentChosen
ns.getBuffValue = getBuffValue