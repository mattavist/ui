
---------------------------------------------------- Some slash commands
SlashCmdList["FRAME"] = function()
    ChatFrame1:AddMessage(GetMouseFoci()[1]:GetName())
end
SLASH_FRAME1 = "/frame"
SLASH_FRAME2 = "/fn"

SlashCmdList["RELOADUI"] = function() ReloadUI() end
SLASH_RELOADUI1 = "/rl"

SlashCmdList["RCSLASH"] = function() DoReadyCheck() end
SLASH_RCSLASH1 = "/rc"

---------------------------------------------------- Changing some variables
SetCVar("screenshotQuality", 6)

---------------------------------------------------- Not Sure
local fontName = "Interface\\AddOns\\SharedMedia\\fonts\\Input.ttf"
local fontHeight = 24
local function FS_SetFont()
	DAMAGE_TEXT_FONT = fontName
	COMBAT_TEXT_HEIGHT = fontHeight
	COMBAT_TEXT_CRIT_MAXHEIGHT = fontHeight + 2
	COMBAT_TEXT_CRIT_MINHEIGHT = fontHeight - 2
	local _, _, fFlags = CombatTextFont:GetFont()
	CombatTextFont:SetFont(fontName, fontHeight, fFlags)
	CombatTextFontOutline:SetFont(fontName, fontHeight, fFlags)
end
FS_SetFont()


------Sells Grays
local function OnEvent()
	for bag=0,4 do
		for slot=0,C_Container.GetContainerNumSlots(bag) do
			local link = C_Container.GetContainerItemLink(bag, slot)
			if link and select(3, GetItemInfo(link)) == 0 then
				--ShowMerchantSellCursor(1)
				C_Container.UseContainerItem(bag, slot)
			end
		end
	end
end

local f = CreateFrame("Frame")
f:RegisterEvent("MERCHANT_SHOW")
f:SetScript("OnEvent", OnEvent)
if MerchantFrame:IsVisible() then OnEvent() end
