local addon, ns = ...
local mainFrame = nil
local throttleCount = 0

local function initGuideFrame(size, parent, x, y, showGCD)
	local guideFrame = CreateFrame("Frame", "mGuideFrame", parent)
	guideFrame.background = guideFrame:CreateTexture(nil, "BACKGROUND")
	guideFrame.foreground = guideFrame:CreateTexture(nil, "BACKGROUND",nil,2)
	guideFrame.spellTexture = guideFrame:CreateTexture(nil,"BACKGROUND",nil,1)
	guideFrame.lastSpell = nil

	guideFrame:SetSize(size, size)
	guideFrame:SetPoint("CENTER", x, y)
	guideFrame.background:SetPoint("BOTTOMRIGHT", 3, -3)
	guideFrame.background:SetPoint("TOPLEFT", -3, 3)
	guideFrame.background:SetColorTexture(0, 0, 0, 0.75)
	guideFrame.foreground:SetPoint("BOTTOMRIGHT")
	guideFrame.foreground:SetPoint("TOPLEFT")
	guideFrame.spellTexture:SetTexCoord(0.1,0.9,0.1,0.9) --cut out crappy icon border
	guideFrame.spellTexture:SetAllPoints(guideFrame) --make texture same size as button

	-- Show GCD Swirl on Frame
	if showGCD then
		guideFrame.PlayerCooldown = CreateFrame("Cooldown", nil, guideFrame, "CooldownFrameTemplate")
		guideFrame.PlayerCooldown:SetAllPoints(guideFrame)
		guideFrame.PlayerCooldown:SetScript("OnEvent", function(self, _, unit, _, _)
			if unit == "player" then
				gcdStart, ns.gcd = GetSpellCooldown(61304)
				newgcdTime = gcdStart + ns.gcd
				if newgcdTime ~= ns.gcdTime then
					ns.gcdTime = newgcdTime
					mainFrame.PlayerCooldown:SetCooldown(GetTime(), ns.gcd)
				end
			end
		end)
	end
	return guideFrame
end

local function spellShade(guide, spell)
	if IsSpellInRange(spell, "target") == 0 then
		guide.foreground:SetColorTexture(1, 0, 0, 0.5) -- Out of range
	elseif not ns.checkSpell(spell) then
		guide.foreground:SetColorTexture(0, 0, 1, 0.5) -- Not enough mana
	else
		guide.foreground:SetColorTexture(1, 0, 0, 0) -- Usable
	end
end	

local function setSpell(frame, spell, glow)
	if spell then
		if spell ~= frame.lastSpell then
			frame:Show()
			frame.spellTexture:SetTexture(GetSpellTexture(spell))
			frame.lastSpell = spell
		end
		spellShade(frame, spell)
	elseif frame ~= mainFrame then
		frame:Hide()
		frame.lastSpell = nil
	end

	if glow then 
		ActionButton_ShowOverlayGlow(frame)
	else 
		ActionButton_HideOverlayGlow(frame)
	end
end


local function rotate()
    -- Save CPU by only running once every throttleCount times
    throttleCount = throttleCount + 1
    if (throttleCount < 10) then -- Hard coded for performance
        return
    end
    throttleCount = 0

	-- Set the spell texture and glow if it has changed
    local spell, glow, left, right = guide()
	setSpell(mainFrame, spell, glow)
	setSpell(mainFrame.leftFrame, left, false)
	setSpell(mainFrame.rightFrame, right, false)
end


local function getSpec()
	local guide = nil
	local _, class, _ = UnitClass("player")
	local specID = GetSpecialization()

	if class == "SHAMAN" then
		if specID == 2 then
			guide = ns.shaman.enhance
		end
	elseif class == "WARRIOR" then
		if specID == 1 then
			guide = ns.warrior.arms
		elseif specID == 3 and ns.talentChosen(6, 1) then -- Checks for Vengeance talent
			guide = ns.warrior.prot
		end
	end

	return guide
end

-- Initializes and changes guide when spec changes
local guider = CreateFrame("Frame", nil, UIParent)
guider:RegisterEvent("PLAYER_ENTERING_WORLD")
guider:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
guider:SetScript("OnEvent", function(self, event, unit, ...)
	if not mainFrame then
		mainFrame = initGuideFrame(50, UIParent, 0, -190, true)
		mainFrame.leftFrame = initGuideFrame(36, mainFrame, -60, -7, false)
		mainFrame.rightFrame = initGuideFrame(36, mainFrame, 60, -7, false)
	end

	guide = getSpec()
	if not guide then
		mainFrame.PlayerCooldown:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED")
		mainFrame.PlayerCooldown:UnregisterEvent("UNIT_SPELLCAST_START")
		mainFrame:SetScript("OnUpdate", nil)
		mainFrame:Hide()
	else
		mainFrame.PlayerCooldown:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
		mainFrame.PlayerCooldown:RegisterEvent("UNIT_SPELLCAST_START")
		mainFrame:SetScript("OnUpdate", rotate)
		mainFrame:Show()
	end
end)

