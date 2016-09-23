local function hideAll()
    MultiBarBottomLeft:SetAlpha(0)
    oUF_karmaPlayer:SetAlpha(0)
    rABS_MainMenuBar:SetAlpha(0)
    BuffFrame:SetAlpha(0)
end

local function showAll()
    MultiBarBottomLeft:SetAlpha(1)
    oUF_karmaPlayer:SetAlpha(1)
    rABS_MainMenuBar:SetAlpha(1)
    BuffFrame:SetAlpha(1)
end

local addon = CreateFrame("Frame", nil, UIParent)
addon:RegisterEvent("PLAYER_ENTERING_WORLD")
addon:SetScript("OnEvent", function(self, event, unit, ...)
-- Register events and small tweaks when logging in or zoning
    

-- Hide when leaving combat, losing target, or stopping a spellcast when not in combat, nothing targeted, 
-- and at max health
    if (event == "PLAYER_REGEN_ENABLED" or event == "PLAYER_TARGET_CHANGED" or "UNIT_SPELLCAST_STOP") then
        if (not InCombatLockdown() and not UnitExists("target")) and 
            (UnitHealth("player") == UnitHealthMax("player")) then
            hideAll()
        end
    end
    
-- Show when entering combat, gaining a target, or starting a spellcast
    if (event == "PLAYER_REGEN_DISABLED") or
        (event == "PLAYER_TARGET_CHANGED" and UnitExists("target")) or
        (event == "UNIT_SPELLCAST_START" and unit == "player") then
        showAll()
    end

    if (event == "PLAYER_ENTERING_WORLD") then
        addon:RegisterEvent("PLAYER_REGEN_ENABLED")
        addon:RegisterEvent("PLAYER_REGEN_DISABLED")
        addon:RegisterEvent("PLAYER_TARGET_CHANGED")
        addon:RegisterEvent("UNIT_SPELLCAST_START")
        addon:RegisterEvent("UNIT_SPELLCAST_STOP")

        LootHistoryFrame:SetScale(1.5)
        TimeManagerClockButton:Hide()
        ChatFrame1:SetFont("Interface\\AddOns\\oUF_Karma\\media\\Asap-Bold.ttf", 16, "OUTLINE")
        ChatFrame3:SetFont("Interface\\AddOns\\oUF_Karma\\media\\Asap-Bold.ttf", 16, "OUTLINE")
        showAll()
        addon:UnregisterEvent("PLAYER_ENTERING_WORLD")
        hideAll()
    end
end)