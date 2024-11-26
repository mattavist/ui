
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
