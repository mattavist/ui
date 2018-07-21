SlashCmdList["test_cmd"] = function() 
	ChatFrame1:AddMessage("Hello")
	for i=1,40,1 do
		local name, _, _, _, duration, expires, _, _, _, spellID, _, _, _, _, value1, _, _ = UnitBuff("player", _)
		if name == "Bounding Stride" then
			ChatFrame1:AddMessage("Bounding Stride!")
			return
		end
	end
end

SLASH_test_cmd1 = "/testcmd"

--[[ Useful things
ChatFrame1:AddMessage("This is the message "..variable)

]]