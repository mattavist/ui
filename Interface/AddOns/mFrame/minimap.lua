local function reshapeMap()
	Minimap:ClearAllPoints()
	Minimap:SetScale(1.0)
	Minimap:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -12, -12)
	Minimap:SetMaskTexture("Interface\\AddOns\\mFrame\\mask.blp")

	local mbg = Minimap:CreateTexture(nil, "BACKGROUND")
	mbg:SetPoint("BOTTOMRIGHT", 2, -2)
	mbg:SetPoint("TOPLEFT", -2, 2)
	mbg:SetColorTexture(0, 0, 0)
	MinimapCompassTexture:Hide()
	MinimapCluster.BorderTop:Hide()
	MinimapZoneText:Hide()
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
	    TimeManagerClockButton,
	    MiniMapTrackingBackground,
	    MiniMapWorldMapButton,
	    MinimapZoneTextButton,
	    MiniMapMailBorder,
	    MinimapBorderTop,
	    MinimapNorthTag,
	    MinimapZoomOut,
	    MinimapZoomIn,
	    MinimapBorder,
	    GameTimeFrame,
	    AddonCompartmentFrame,
	}

	for _, mapFrame in pairs(frames) do
	    mapFrame:Hide()
	    mapFrame.Show = dummy
	end
end

local function tracking()
	MinimapCluster.Tracking:Hide()
	MinimapCluster.Tracking:ClearAllPoints()
	MinimapCluster.Tracking:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 3, -3)
	MinimapCluster.Tracking:SetFrameLevel(Minimap:GetFrameLevel() + 1)
	MinimapCluster.Tracking:SetScale(1.5)
end

local function expansion()
	ExpansionLandingPageMinimapButton:Hide()
	ExpansionLandingPageMinimapButton:ClearAllPoints()
	ExpansionLandingPageMinimapButton:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", -4, 8)
	ExpansionLandingPageMinimapButton:SetScale(1)
	ExpansionLandingPageMinimapButton:Show()
end

local function mail()
	MinimapCluster.IndicatorFrame:ClearAllPoints()
	MinimapCluster.IndicatorFrame:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", -5, -5)
end

local map = CreateFrame("Frame", nil, UIParent)
map:RegisterEvent("PLAYER_ENTERING_WORLD")
map:SetScript("OnEvent", function()
	reshapeMap()
	enableMouse()
	hideElements()
	tracking()
	expansion()
	mail()
end)

Minimap:HookScript("OnEnter", function()
	MinimapCluster.Tracking:Show()
	ExpansionLandingPageMinimapButton:Show()
end)

Minimap:HookScript("OnLeave", function()
	if not Minimap:IsMouseOver() then
		MinimapCluster.Tracking:Hide()
		ExpansionLandingPageMinimapButton:Hide()
    		-- QueueStatusButton:ClearAllPoints()
    		-- QueueStatusButton:SetPoint("CENTER", Minimap, "BOTTOMLEFT", 0, 0)
	end
end)