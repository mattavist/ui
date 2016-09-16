
local addon = CreateFrame("Frame", nil, UIParent)
addon:RegisterEvent("PLAYER_REGEN_ENABLED")
addon:RegisterEvent("PLAYER_REGEN_DISABLED")
addon:RegisterEvent("PLAYER_ENTERING_WORLD")
addon:RegisterEvent("PLAYER_TARGET_CHANGED")
addon:RegisterEvent("UNIT_SPELLCAST_START")
addon:RegisterEvent("UNIT_SPELLCAST_STOP")
addon:SetScript("OnEvent", function(self, event, unit, ...)

    
--DOES THIS WHEN LOGGING IN OR ZONING
    if (event == "PLAYER_ENTERING_WORLD") then
		TimeManagerClockButton:Hide()
		collectgarbage("collect")
		LootHistoryFrame:SetScale(1.5)
		ChatFrame1:SetFont("Interface\\AddOns\\oUF_Karma\\media\\EMBLEM.ttf", 16, "OUTLINE")
		ChatFrame3:SetFont("Interface\\AddOns\\oUF_Karma\\media\\EMBLEM.ttf", 16, "OUTLINE")
    end

--DOES THIS WHEN EXITING COMBAT
    if (event == "PLAYER_REGEN_ENABLED" and not UnitExists("target")) then
		if (UnitHealth("player") == UnitHealthMax("player")) then
			MultiBarBottomLeft:SetAlpha(0)
			oUF_karmaPlayer:SetAlpha(0)
			rABS_MainMenuBar:SetAlpha(0)
			end	
   		end

 --DOES THIS WHEN PLAYER LOSES A TARGET WHILE NOT IN COMBAT
    if (not InCombatLockdown() and not UnitExists("target")) then 
		if (UnitHealth("player") == UnitHealthMax("player")) then
			MultiBarBottomLeft:SetAlpha(0)
			oUF_karmaPlayer:SetAlpha(0)
			rABS_MainMenuBar:SetAlpha(0)
		end	 
    end

    if (event == "UNIT_SPELLCAST_STOP" and not InCombatLockdown() and not UnitExists("target")) then
    	if unit == "player" then
			MultiBarBottomLeft:SetAlpha(0)
			oUF_karmaPlayer:SetAlpha(0)
			rABS_MainMenuBar:SetAlpha(0)
		end
	end
    
	
--DOES THIS WHEN ENTERING COMBAT
    if (event == "PLAYER_REGEN_DISABLED") then
		MultiBarBottomLeft:SetAlpha(1)
		oUF_karmaPlayer:SetAlpha(1)
		rABS_MainMenuBar:SetAlpha(1)
    end

--DOES THIS WHEN PLAYER ACQUIRES A TARGET WHILE  NOT IN COMBAT
    if (event == "PLAYER_TARGET_CHANGED") then
		if (UnitExists("target"))  then
			MultiBarBottomLeft:SetAlpha(1)
			oUF_karmaPlayer:SetAlpha(1)
			rABS_MainMenuBar:SetAlpha(1)
		end
	end

--DOES THIS WHEN PLAYER ACQUIRES A TARGET WHILE  NOT IN COMBAT
    if (event == "UNIT_SPELLCAST_START") then
    	if unit == "player" then
			oUF_karmaPlayer:SetAlpha(1)
		end
	end
end)