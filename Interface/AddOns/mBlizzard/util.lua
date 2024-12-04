
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

