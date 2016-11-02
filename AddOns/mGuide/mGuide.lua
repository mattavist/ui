local addon, ns = ...
local guider = CreateFrame("Frame", "guider", UIParent, UIParent)
local mainFrame = nil
local throttleCount = 0
local lastStart = 0

local function initGuideFrame(size, anchor, x, y, showGCD, hideFrame)
	local guideFrame = CreateFrame("Frame", "mGuideFrame", guider)
	guideFrame:SetSize(size, size)
	guideFrame:SetPoint("CENTER", anchor, x, y)
	guideFrame.lastSpell = nil
	guideFrame.hideFrame = hideFrame

	-- Background and Border
	guideFrame.background = guideFrame:CreateTexture(nil, "BACKGROUND")
	guideFrame.background:SetPoint("BOTTOMRIGHT", 3, -3)
	guideFrame.background:SetPoint("TOPLEFT", -3, 3)
	guideFrame.background:SetColorTexture(0, 0, 0, 0.75)

	-- Shader for OOR, not castable
	guideFrame.foreground = guideFrame:CreateTexture(nil, "BACKGROUND",nil,2)
	guideFrame.foreground:SetPoint("BOTTOMRIGHT")
	guideFrame.foreground:SetPoint("TOPLEFT")

	-- Spell Icon
	guideFrame.spellTexture = guideFrame:CreateTexture(nil,"BACKGROUND",nil,1)
	guideFrame.spellTexture:SetTexCoord(0.1,0.9,0.1,0.9) --cut out crappy icon border
	guideFrame.spellTexture:SetAllPoints(guideFrame) --make texture same size as button

	-- Show GCD Swirl on Frame
	if showGCD then
		guideFrame.PlayerCooldown = CreateFrame("Cooldown", nil, guideFrame, "CooldownFrameTemplate")
		guideFrame.PlayerCooldown:SetAllPoints(guideFrame)
	end

	-- Set up pulse animation
	guideFrame.ag = guideFrame:CreateAnimationGroup()
	guideFrame.ag:SetLooping("BOUNCE")
	local a2 = guideFrame.ag:CreateAnimation("Scale")
	animSize = (110 - size)/100
	a2:SetScale(animSize, animSize)
	a2:SetDuration(.25)
	a2:SetSmoothing("IN_OUT")

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

local function setSpell(frame, spell, glow, pulse)
	if spell and UnitCanAttack("player", "target") then
		if spell ~= frame.lastSpell then
			frame:Show()
			frame.spellTexture:SetTexture(GetSpellTexture(spell))
			frame.lastSpell = spell
		end
		spellShade(frame, spell)
	elseif frame.hideFrame then
		frame:Hide()
		frame.lastSpell = nil
	end

	if glow then 
		ActionButton_ShowOverlayGlow(frame)
	else 
		ActionButton_HideOverlayGlow(frame)
	end

	if pulse then
		frame.ag:Play()
	else
		frame.ag:Stop()
	end
end


local function gcdSpiral(frame)
	local start, gcd = GetSpellCooldown(61304)
	if start > 0 then
	    ns.gcdTime = start + gcd
		local time = GetTime()
		frame.PlayerCooldown:SetCooldown(time, ns.gcdTime - time)
	end
end


local function rotate()
    -- Save CPU by only running once every throttleCount times
    throttleCount = throttleCount + 1
    if (throttleCount < 10) then -- Hard coded for performance
        return
    end
    throttleCount = 0

    if GetTime() > ns.gcdTime then
    	gcdSpiral(mainFrame)
    end

	-- Set the spell texture and glow if it has changed
    local spell, glow, left, right, top, leftPulse, rightPulse, topPulse = guide()
	setSpell(mainFrame, spell, glow, false)
	setSpell(mainFrame.leftFrame, left, false, leftPulse)
	setSpell(mainFrame.rightFrame, right, false, rightPulse)
	setSpell(mainFrame.topFrame, top, false, topPulse)
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
guider:RegisterEvent("PLAYER_ENTERING_WORLD")
guider:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
guider:SetScript("OnEvent", function(self, event, unit, ...)
	if not mainFrame then
		mainFrame = initGuideFrame(50, UIParent, 0, -190, true, false)
		mainFrame.leftFrame = initGuideFrame(36, mainFrame, -60, -7, false, true)
		mainFrame.rightFrame = initGuideFrame(36, mainFrame, 60, -7, false, true)
		mainFrame.topFrame = initGuideFrame(80, mainFrame, 0, 100, false, true)
		mainFrame:Hide()
	end

	guide = getSpec()
	if not guide then
		mainFrame.PlayerCooldown:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED")
		mainFrame.PlayerCooldown:UnregisterEvent("UNIT_SPELLCAST_START")
		guider:SetScript("OnUpdate", nil)
		mainFrame:Hide()
	else
		mainFrame.PlayerCooldown:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
		mainFrame.PlayerCooldown:RegisterEvent("UNIT_SPELLCAST_START")
		guider:SetScript("OnUpdate", rotate)
	end
end)
