local tip = CreateFrame('Frame', UIParent)

local function line()
    -- Reanchor the tooltip
    GameTooltip:ClearAllPoints()
    GameTooltip:SetPoint("BOTTOMLEFT", WorldFrame, "BOTTOMRIGHT", -700, 400)

    -- Add 
    local target = UnitName("mouseovertarget")
    local player = UnitName("player")
    if target == player then
        target = "YOU"
    end

    if target then
        GameTooltip:AddLine(target, 1, 1, 1)
        GameTooltip:Show()
    end
end

tip:SetScript("OnEvent", function () line() end)
tip:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
