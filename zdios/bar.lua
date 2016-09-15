
local addon = CreateFrame("Frame", nil, UIParent)
addon:RegisterEvent("PLAYER_REGEN_ENABLED")
addon:RegisterEvent("PLAYER_REGEN_DISABLED")
addon:RegisterEvent("PLAYER_ENTERING_WORLD")
addon:RegisterEvent("PLAYER_TARGET_CHANGED")
addon:RegisterEvent("UNIT_SPELLCAST_START")
addon:RegisterEvent("UNIT_SPELLCAST_STOP")
addon:SetScript("OnEvent", function(self, event, unit, ...)
	local backdrop = {
		bgFile = "Interface\\AddOns\\oUF_Karma\\media\\backdrop",  
  		edgeFile = "Interface\\AddOns\\oUF_Karma\\media\\backdrop_edge",
  		tile = false,
  		tileSize = 12,
  		edgeSize = 12,

  		insets = {
  			left = 12,
  			right = 1,
  			top = 1,
  			bottom = 12
  		}
	}

	width = oUF_karmaPlayer:GetWidth()
	ChatFrame1:AddMessage("Talking head debug line" ..width)

	MyStatusBar = CreateFrame("StatusBar", nil, UIParent)
	MyStatusBar:SetStatusBarTexture("Interface\\AddOns\\oUF_Karma\\media\\Statusbar")
	--MyStatusBar:SetBackdrop(backdrop)
	--MyStatusBar:SetBackdropBorderColor(0, 0, 0, 1)
	--MyStatusBar:SetBackdropColor(0, 0, 0, 0)
	--MyStatusBar:GetStatusBarTexture():SetHorizTile(false)
	MyStatusBar:SetMinMaxValues(0, 100)
	MyStatusBar:SetValue(70)
	MyStatusBar:SetWidth(width)
	MyStatusBar:SetHeight(20)
	MyStatusBar:SetPoint("BOTTOM",oUF_karmaPlayer,"TOP", 0, 15)
	MyStatusBar:SetStatusBarColor(0,0,.9)

	end)