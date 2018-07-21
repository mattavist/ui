local mediaPath = "Interface\\media\\"

-- Small tweaks and register hider/shower
local addon = CreateFrame("Frame", nil, UIParent)
addon:RegisterEvent("PLAYER_ENTERING_WORLD")
addon:SetScript("OnEvent", function(self, event, unit, ...)
    addon:UnregisterEvent("PLAYER_ENTERING_WORLD")
    LootHistoryFrame:SetScale(1.5)
    TimeManagerClockButton:Hide()
    ChatFrame1:SetFont(mediaPath.."Asap-Bold.ttf", 16, "OUTLINE")
    ChatFrame3:SetFont(mediaPath.."Asap-Bold.ttf", 16, "OUTLINE")
end)