local buttonSize = 47
local padding = 20
local numRows = 12
local numCols = 2

-- Sidebars
local MultiBarHolder = CreateFrame("Frame", "MultiBarHolder", UIParent, "SecureHandlerStateTemplate")
MultiBarHolder:SetWidth(buttonSize * numCols + padding * 2)
MultiBarHolder:SetHeight(buttonSize * numRows + padding * 2)
MultiBarHolder:SetPoint("TOPLEFT", MultiBarLeft, "TOPLEFT", padding * -1, padding)

MultiBarLeft:SetParent(MultiBarHolder)
MultiBarRight:SetParent(MultiBarHolder)
MultiBarHolder:SetAlpha(0)

MultiBarHolder:HookScript("OnEnter", function()
	MultiBarHolder:SetAlpha(1)
end)

MultiBarHolder:HookScript("OnLeave", function()
	if not MultiBarHolder:IsMouseOver() then
		MultiBarHolder:SetAlpha(0)
	end
end)
