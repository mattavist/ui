local mediaPath = "Interface\\media\\"

local addon = CreateFrame("Frame", nil, UIParent)
addon:RegisterEvent("PLAYER_ENTERING_WORLD")
addon:SetScript("OnEvent", function(self, event, unit, ...)
    addon:UnregisterEvent("PLAYER_ENTERING_WORLD")

    ChatFrame1:SetFont(mediaPath.."Asap-Bold.ttf", 15, "OUTLINE")
    ChatFrame2:SetFont(mediaPath.."Asap-Bold.ttf", 15, "OUTLINE")
    ChatFrame3:SetFont(mediaPath.."Asap-Bold.ttf", 15, "OUTLINE")
    ChatFrame4:SetFont(mediaPath.."Asap-Bold.ttf", 15, "OUTLINE")
end)