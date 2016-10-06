local mapScale = 1.3  -- Change this to whatever you like

local scaler = CreateFrame("Frame", nil, UIParent)
scaler:RegisterEvent("WORLD_MAP_UPDATE")
scaler:SetScript("OnEvent", function(self, event, unit, ...)
    WorldMapFrame:ClearAllPoints()
    WorldMapFrame:SetPoint("CENTER", WorldFrame, "CENTER")
    WorldMapFrame:SetScale(mapScale)
end)