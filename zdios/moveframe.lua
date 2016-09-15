local f = CreateFrame("Frame")

function f:OnEvent(event, addon)
	-- Move Talking Head Frame to top of screen
	if addon == "Blizzard_TalkingHeadUI" then
		ChatFrame1:AddMessage("Talking head debug line")
		hooksecurefunc("TalkingHeadFrame_PlayCurrent", function()
			TalkingHeadFrame:SetPoint("BOTTOM", WorldFrame, "TOP", 0, -300)
		end)
		self:UnregisterEvent(event)

	-- Move Digsite Progress to Bottom of screen
	elseif addon == "Blizzard_ArchaeologyUI" then
		hooksecurefunc("ArcheologyDigsiteProgressBar_OnUpdate", function()
			ArcheologyDigsiteProgressBar:SetPoint("BOTTOM", WorldFrame, "BOTTOM", 0, 50)
		end)
		self:UnregisterEvent(event)
	end
end

f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", f.OnEvent)