local mapScale = 1  -- Change this to whatever you like
scaler = CreateFrame("Frame", "Scaler", UIParent)

local loader = CreateFrame("Frame", "Loader", UIParent)
loader:RegisterEvent("PLAYER_ENTERING_WORLD")
loader:SetScript("OnEvent", function(self, event, unit, ...)
    self:RegisterEvent("WORLD_MAP_OPEN")
end)

scaler:SetScript("OnEvent", function(self, event, unit, ...)
    WorldMapFrame:ClearAllPoints()
    WorldMapFrame:SetPoint("CENTER", WorldFrame, "CENTER")  -- Need to figure this out
    WorldMapFrame:SetScale(mapScale)
end)