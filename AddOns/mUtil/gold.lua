local charData

local loader = CreateFrame("Frame", nil, UIParent)
loader:RegisterEvent("PLAYER_ENTERING_WORLD")
loader:SetScript("OnEvent", function()
    charData = mCharData
    if not charData then
		charData = {}
	end
	charData[UnitName("player")] = floor(abs(GetMoney() / 10000))
	mCharData = charData
end)

local saver = CreateFrame("Frame", nil, UIParent)
saver:RegisterEvent("PLAYER_LOGOUT")
saver:SetScript("OnEvent", function()
	if charData then
    	mCharData = charData
    end
end)

SlashCmdList["TRY"] = function()
	local total = 0
	charData[UnitName("player")] = floor(abs(GetMoney() / 10000))
	mCharData = charData

	for key, value in pairs(charData) do
		if value > 30 then
    		ChatFrame1:AddMessage(key.."  -  "..value.."g")
    	end
    	total = total + value
    end
    ChatFrame1:AddMessage("Total  -  "..total.."g")
end
SLASH_TRY1 = "/d"