local mapScale = 1.3  -- Change this to whatever you like

local scaler = CreateFrame("Frame", nil, UIParent)
scaler:RegisterEvent("NEW_WMO_CHUNK")
scaler:SetScript("OnEvent", function(self, event, unit, ...)
    WorldMapFrame:ClearAllPoints()
    WorldMapFrame:SetPoint("CENTER", WorldFrame, "CENTER")  -- Need to figure this out
    WorldMapFrame:SetScale(mapScale)
end)