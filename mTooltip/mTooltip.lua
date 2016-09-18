local tip = CreateFrame('Frame', UIParent)

local classColors = {
    ["DEATH KNIGHT"] = "|cFFC41F3B",
    ["DEMON HUNTER"] = "|cFFA330C9",
    ["DRUID"] = "|cFFFF7D0A",
    ["HUNTER"] = "|cFFABD473",
    ["MAGE"] = "|cFF69CCF0",
    ["MONK"] = "|cFF00FF96",
    ["PALADIN"] = "|cFFF58CBA",
    ["PRIEST"] = "|cFFFFFFFF",
    ["ROGUE"] = "|cFFFFF569",
    ["SHAMAN"] = "|cFF0070DE",
    ["WARLOCK"] = "|cFF9482C9",
    ["WARRIOR"] = "|cFFC79C6E"
}

local function line()
    --Recolor unit name
    local class, cls = UnitClass("mouseover")
    if cls then
        local playerName = _G["GameTooltipTextLeft" .. 1]
        playerName:SetText(classColors[cls]..playerName:GetText())
    end

    -- Reanchor the tooltip
    GameTooltip:ClearAllPoints()
    GameTooltip:SetPoint("BOTTOMLEFT", WorldFrame, "BOTTOMRIGHT", -700, 400)

    -- Add target line
    local target = UnitName("mouseovertarget")
    local player = UnitName("player")
    if target == player then
        target = "YOU"
    end

    if target then
        GameTooltip:AddLine(target, 1, 1, 1)
    end

    GameTooltip:Show()
end

tip:SetScript("OnEvent", function () line() end)
tip:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
