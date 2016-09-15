-- Remove default buff borders, replace with a black square
local f = CreateFrame("Frame")

function redrawBorder(button, icon)
	local buttonbg = button:CreateTexture(nil, "BACKGROUND", nil, -1)
	buttonbg:ClearAllPoints()
	buttonbg:SetPoint("BOTTOMRIGHT", button, 2, -2)
	buttonbg:SetPoint("TOPLEFT", button, -2, 2)
	buttonbg:SetColorTexture(0, 0, 0)
	icon:SetTexCoord(0.06, 0.94, 0.06, 0.94)
end

function f:OnEvent(event, addon)
	hooksecurefunc("CreateFrame", function(frameType, name, parent, template)
	--hooksecurefunc("AuraButton_Update", function(buttonName, index, filter)
		--local buffName = buttonName..index
		if (template == "BuffButtonTemplate") then
			local buff = _G[name]
			local icon = _G[name.."Icon"]
			if buff then
				redrawBorder(buff, icon)
			end
		end
	end)

	--hooksecurefunc("AuraButton_UpdateDuration", function(auraButton, timeLeft)
		--local duration = auraButton.duration
		--ChatFrame1:AddMessage("debug line" ..timeLeft)
	--end)

	self:UnregisterEvent(event)

end

f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", f.OnEvent)