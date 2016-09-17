------------MINIMAP
local myscale = 1
function GetMinimapShape() return "SQUARE" end
Minimap:ClearAllPoints()
Minimap:SetScale(myscale)
Minimap:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -12 / myscale, -12 / myscale)
Minimap:SetMaskTexture("Interface\\AddOns\\zdios\\media\\mask.blp")


---------------------------------------------------- 1 px background
local mbg = Minimap:CreateTexture(nil, "BACKGROUND")
mbg:SetPoint("BOTTOMRIGHT", 2 / myscale, -2 / myscale)
mbg:SetPoint("TOPLEFT", -2 / myscale, 2 / myscale)
mbg:SetColorTexture(0, 0, 0)

---------------------------------------------------- Mousewheel zoom
Minimap:EnableMouseWheel(true)
Minimap:SetScript("OnMouseWheel", function(_, zoom)
    if zoom > 0 then
        Minimap_ZoomIn()
    else
        Minimap_ZoomOut()
    end
end)

---------------------------------------------------- Hiding ugly things 
local dummy = function() end

local frames = {
    MiniMapMeetingStoneBorder,
    MiniMapTrackingBackground,
    MiniMapMeetingStoneFrame,
    MiniMapBattlefieldBorder,
    MiniMapVoiceChatFrame,
    MiniMapWorldMapButton,
    MinimapZoneTextButton,
    MiniMapTrackingIcon,
    MinimapToggleButton,
    MiniMapMailBorder,
    MinimapBorderTop,
    MinimapNorthTag,
    MinimapZoomOut,
    MinimapZoomIn,
    MinimapBorder,
    GameTimeFrame
}

for _, mapFrame in pairs(frames) do
    mapFrame:Hide()
    mapFrame.Show = dummy
end

frames = nil

---------------------------------------------------- Clock

---------------------------------------------------- Tracking
MiniMapTrackingButton:SetAlpha(0)
MiniMapTracking:ClearAllPoints()
MiniMapTracking:SetPoint("BOTTOMLEFT", Minimap)
MiniMapTracking:SetScale(1)
MiniMapTracking:Show()

---------------------------------------------------- Mission
GarrisonLandingPageMinimapButton:SetAlpha(0)
GarrisonLandingPageMinimapButton:ClearAllPoints()
GarrisonLandingPageMinimapButton:SetPoint("TOPLEFT", Minimap)
GarrisonLandingPageMinimapButton:SetScale(1)
GarrisonLandingPageMinimapButton:Show()

---------------------------------------------------- BG icon
--MiniMapBattlefieldFrame:ClearAllPoints()
--MiniMapBattlefieldFrame:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", -3, 0)

---------------------------------------------------- Mail icon
MiniMapMailFrame:ClearAllPoints()
MiniMapMailFrame:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", 6, -8)
MiniMapMailIcon:SetTexture("Interface\\AddOns\\zdios\\media\\mail")