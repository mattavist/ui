local function hideAll()
    MultiBarBottomLeft:SetAlpha(0)
    oUF_karmaPlayer:SetAlpha(0)
    rABS_MainMenuBar:SetAlpha(0)
end

local function showAll()
    MultiBarBottomLeft:SetAlpha(1)
    oUF_karmaPlayer:SetAlpha(1)
    rABS_MainMenuBar:SetAlpha(1)
end

local addon = CreateFrame("Frame", nil, UIParent)
addon:RegisterEvent("PLAYER_ENTERING_WORLD")
addon:SetScript("OnEvent", function(self, event, unit, ...)
-- Register events and small tweaks when logging in or zoning
    if (event == "PLAYER_ENTERING_WORLD") then
        addon:RegisterEvent("PLAYER_REGEN_ENABLED")
        addon:RegisterEvent("PLAYER_REGEN_DISABLED")
        addon:RegisterEvent("PLAYER_TARGET_CHANGED")
        addon:RegisterEvent("UNIT_SPELLCAST_START")
        addon:RegisterEvent("UNIT_SPELLCAST_STOP")
		LootHistoryFrame:SetScale(1.5)
		ChatFrame1:SetFont("Interface\\AddOns\\oUF_Karma\\media\\EMBLEM.ttf", 16, "OUTLINE")
		ChatFrame3:SetFont("Interface\\AddOns\\oUF_Karma\\media\\EMBLEM.ttf", 16, "OUTLINE")
        addon:UnregisterEvent("PLAYER_ENTERING_WORLD")
    end

-- Hide when leaving combat, losing target, or stopping a spellcast when not in combat, nothing targeted, 
-- and at max health
    if (event == "PLAYER_REGEN_ENABLED" or event == "PLAYER_TARGET_CHANGED" or "UNIT_SPELLCAST_STOP") and
        (not InCombatLockdown() and not UnitExists("target")) and
        (UnitHealth("player") == UnitHealthMax("player")) then
        hideAll()
    end
    
-- Show when entering combat, gaining a target, or starting a spellcast
    if (event == "PLAYER_REGEN_DISABLED") or
        (event == "PLAYER_TARGET_CHANGED" and UnitExists("target")) or
        (event == "UNIT_SPELLCAST_START" and unit == "player") then
        showAll()
    end
end)