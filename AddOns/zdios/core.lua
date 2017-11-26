
---------------------------------------------------- Some slash commands
SlashCmdList["FRAME"] = function()
    ChatFrame1:AddMessage(GetMouseFocus():GetName())
end
SLASH_FRAME1 = "/frame"
SLASH_FRAME2 = "/gn"

SlashCmdList["RELOADUI"] = function() ReloadUI() end
SLASH_RELOADUI1 = "/rl"

SlashCmdList["RCSLASH"] = function() DoReadyCheck() end
SLASH_RCSLASH1 = "/rc"

---------------------------------------------------- Changing some variables
SetCVar("screenshotQuality", 6)

---------------------------------------------------- Not Sure
local fontName = "Interface\\AddOns\\zdios\\media\\font.ttf"
local fontHeight = 24
local function FS_SetFont()
	DAMAGE_TEXT_FONT = fontName
	COMBAT_TEXT_HEIGHT = fontHeight
	COMBAT_TEXT_CRIT_MAXHEIGHT = fontHeight + 2
	COMBAT_TEXT_CRIT_MINHEIGHT = fontHeight - 2
	local fName, fHeight, fFlags = CombatTextFont:GetFont()
	CombatTextFont:SetFont(fontName, fontHeight, fFlags)
end
FS_SetFont()


------Sells Greys
local function OnEvent()
	for bag=0,4 do
		for slot=0,GetContainerNumSlots(bag) do
			local link = GetContainerItemLink(bag, slot)
			if link and select(3, GetItemInfo(link)) == 0 then
				--ShowMerchantSellCursor(1)
				UseContainerItem(bag, slot)
			end
		end
	end
end

local f = CreateFrame("Frame")
f:RegisterEvent("MERCHANT_SHOW")
f:SetScript("OnEvent", OnEvent)
if MerchantFrame:IsVisible() then OnEvent() end

--[[
local c = CreateFrame("Frame")
c:RegisterEvent("SPELL_UPDATE_USABLE")
c:SetScript("OnEvent", function(self, event, unit, ...)
	for i = 1, 24 do
		local button = nil
		if i < 13 then
			button = _G["ActionButton"..i]
		else
			button = _G["MultiBarBottomLeftButton"..i-12]
			i = i + 48
		end

		local actionType, id = GetActionInfo(i)
        local actionName = GetSpellInfo(id)

        if actionName and button then
			local start, cooldown, enable = GetSpellCooldown(actionName)
			
			if start and start ~= 0 and cooldown > 12 then
				button:SetAlpha(1)
			else
				button:SetAlpha(.25)
			end
		end
	end
end)
]]