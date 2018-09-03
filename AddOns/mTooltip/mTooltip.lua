local tip = CreateFrame('Frame', UIParent)
local mediaPath = "Interface\\media\\"

local mouseAnchor = nil

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
        GameTooltip:SetPoint("BOTTOMRIGHT", WorldFrame, "BOTTOMRIGHT", 
            -700 + tonumber(GameTooltip:GetWidth()), 400)
    end

    --Recolor unit name
    local class, cls = UnitClass("mouseover")
    if cls and UnitIsPlayer("mouseover") then
        local playerName = _G["GameTooltipTextLeft" .. 1]
        local color = classColors[cls]
        if playerName:GetText() and color then
            playerName:SetText(color..playerName:GetText())
        end
    end

    -- Move Health bar
    local bar = GameTooltipStatusBar
    bar:ClearAllPoints()
    bar:SetPoint("BOTTOMLEFT", 10, 12)
    bar:SetPoint("BOTTOMRIGHT", -10, 12)
    bar:SetHeight(5)
    bar:SetStatusBarTexture(mediaPath.."Statusbar")
    GameTooltip.statusBar = bar
    GameTooltip:SetHeight(200)

    -- Redraw the updated tooltip
    GameTooltip:Show() 

end)
tip:RegisterEvent("UPDATE_MOUSEOVER_UNIT")

local function hooker()
    -- Add target line
    local mouseovertarget = UnitName("mouseovertarget")
    if mouseovertarget then
        GameTooltip:AddLine("Target: "..mouseovertarget, 1, 1, 1)
    end
    GameTooltip:AddLine("|c00000000_", 1, 1, 1) -- A blank line
end
GameTooltip:HookScript("OnTooltipSetUnit", hooker)
