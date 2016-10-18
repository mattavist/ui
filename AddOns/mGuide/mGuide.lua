local b = CreateFrame("BUTTON", "mGuideFrame", UIParent, "SecureHandlerClickTemplate");
b:SetSize(50,50)
b:SetPoint("CENTER",0,-190)
b:RegisterForClicks("AnyUp")
local mbg = b:CreateTexture(nil, "BACKGROUND")
mbg:SetPoint("BOTTOMRIGHT", 3, -3)
mbg:SetPoint("TOPLEFT", -3, 3)
mbg:SetColorTexture(0, 0, 0)
local t = b:CreateTexture(nil,"BACKGROUND",nil,1)
t:SetTexCoord(0.1,0.9,0.1,0.9) --cut out crappy icon border
t:SetAllPoints(b) --make texture same size as button

CreateFrame("Cooldown", "PlayerCooldown", b, "CooldownFrameTemplate")
PlayerCooldown:SetAllPoints(b)


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

local throttleCount = 0
b:SetScript("OnUpdate", function()
	--if not InCombatLockdown() then
	--	return
	--end

    -- Save CPU by only running once every throttleCount times
    throttleCount = throttleCount + 1
    if (throttleCount < 5) then -- Hard coded for performance
        return
    end
    throttleCount = 0

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

b:RegisterForClicks("AnyUp", "AnyDown")
local upDown = { [false] = "Up", [true] = "Down" }
local function show(text, color)
  DEFAULT_CHAT_FRAME:AddMessage(text, color, color, color)
end
local color = .60
b:SetScript("OnMouseDown", function(self, button)
  color = .60
  show(format("OnMouseDown: %s", button), color, color, color)
  PlayerCooldown:SetCooldown(GetTime(), 1.5)
end)

b:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
b:SetScript("OnEvent", function(self, _, unit, spellName, _)
	if unit == "player" then
		--ChatFrame3:AddMessage(unit.."  "..spellName)
		PlayerCooldown:SetCooldown(GetTime(), 1.25)
	end
end)