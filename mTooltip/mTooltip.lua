local tip = CreateFrame('Frame', UIParent)


local classColors = {
    ["DEATHKNIGHT"] = "|cFFC41F3B",
    ["DEMONHUNTER"] = "|cFFA330C9",
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

tip:SetScript("OnEvent", function ()
    -- Reanchor the tooltip
    if mouseAnchor then
        GameTooltip:SetAnchorType("ANCHOR_CURSOR")
    else
        GameTooltip:ClearAllPoints()
        GameTooltip:SetPoint("BOTTOMLEFT", WorldFrame, "BOTTOMRIGHT", -700, 400)
    end

    --Recolor unit name
    local class, cls = UnitClass("mouseover")
    if cls and UnitIsPlayer("mouseover") then
        local playerName = _G["GameTooltipTextLeft" .. 1]
        playerName:SetText(classColors[cls]..playerName:GetText())
    end

    -- Add target line
    local mouseovertarget = UnitName("mouseovertarget")
    if mouseovertarget then
        if mouseovertarget == UnitName("player") then
            mouseovertarget = "YOU"
        end
        GameTooltip:AddLine(mouseovertarget, 1, 1, 1)
    end

    -- Move Health bar
    GameTooltip:AddLine("|c00000000_", 1, 1, 1) -- A blank line
    local bar = GameTooltipStatusBar
    bar:ClearAllPoints()
    bar:SetPoint("BOTTOMLEFT", 10, 12)
    bar:SetPoint("BOTTOMRIGHT", -10, 12)
    bar:SetHeight(5)
    bar:SetStatusBarTexture("Interface\\AddOns\\oUF_Karma\\media\\Statusbar")
    GameTooltip.statusBar = bar

    -- Redraw the updated tooltip
    GameTooltip:Show() 
end)

tip:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
