local function reshapeMap()
	Minimap:ClearAllPoints()
	Minimap:SetScale(1.0)
	Minimap:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -12, -12)
	Minimap:SetMaskTexture("Interface\\AddOns\\mTweak\\media\\mask.blp")

	local mbg = Minimap:CreateTexture(nil, "BACKGROUND")
	mbg:SetPoint("BOTTOMRIGHT", 2, -2)
	mbg:SetPoint("TOPLEFT", -2, 2)
	mbg:SetColorTexture(0, 0, 0)
end

local function enableMouse()
	Minimap:EnableMouseWheel(true)
	Minimap:SetScript("OnMouseWheel", function(_, zoom)
	    if zoom > 0 then
	        Minimap_ZoomIn()
	    else
	        Minimap_ZoomOut()
	    end
	end)
end

local function hideElements()
	local dummy = function() end

	local frames = {
	    --MiniMapMeetingStoneBorder,
	    MiniMapTrackingBackground,
	    --MiniMapMeetingStoneFrame,
	    --MiniMapBattlefieldBorder,
	    --MiniMapVoiceChatFrame,
	    MiniMapWorldMapButton,
	    MinimapZoneTextButton,
	    --MinimapToggleButton,
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
end

local function tracking()
	MiniMapTrackingButton:SetAlpha(0)
	MiniMapTrackingIcon:SetAlpha(0)
	MiniMapTracking:ClearAllPoints()
	MiniMapTracking:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 5, -5)
	MiniMapTracking:SetScale(1)
	MiniMapTracking:Show()
end

local function garrison()
	GarrisonLandingPageMinimapButton:SetAlpha(0)
	GarrisonLandingPageMinimapButton:ClearAllPoints()
	GarrisonLandingPageMinimapButton:SetPoint("TOPRIGHT", Minimap)
	GarrisonLandingPageMinimapButton:SetScale(1)
	GarrisonLandingPageMinimapButton:Show()
end

local function mail()
	MiniMapMailFrame:ClearAllPoints()
	MiniMapMailFrame:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", 6, -8)
	MiniMapMailIcon:SetTexture("Interface\\AddOns\\zdios\\media\\mail")
end

local map = CreateFrame("Frame", nil, UIParent)
map:RegisterEvent("PLAYER_ENTERING_WORLD")
map:SetScript("OnEvent", function()
	reshapeMap()
	enableMouse()
	hideElements()
	tracking()
	garrison()
	mail()
end)

Minimap:HookScript("OnEnter", function()
	MiniMapTrackingButton:SetAlpha(1)
	MiniMapTrackingIcon:SetAlpha(1)
	GarrisonLandingPageMinimapButton:SetAlpha(1)
end)

Minimap:HookScript("OnLeave", function()
	if not Minimap:IsMouseOver() then
		MiniMapTrackingButton:SetAlpha(0)
		MiniMapTrackingIcon:SetAlpha(0)
		GarrisonLandingPageMinimapButton:SetAlpha(0)
	end
end)