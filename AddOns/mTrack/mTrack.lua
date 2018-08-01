local timerUpdater = CreateFrame('Frame', UIParent)
local auraUpdater = CreateFrame('Frame', UIParent)
local throttleCount = 0
local mediaPath = "Interface\\media\\"
barHeight = 20
barWidth = 175
barOffset = -(barHeight + 10)

local trackedTimers = {}
local buffIndex = { 
    -- Warrior
    "Bladestorm",
    "Ultimatum",
    "Shield Block",
    "Ignore Pain",
    "Shield Wall",
    "Last Stand",
    "Rallying Cry",
    "Battle Cry",
    "Enrage",
    "Recklessness",
    "Enraged Regeneration",

    -- Shaman
    --"Landslide",
    "Flametongue",
    "Frostbrand",
    "Astral Shift",
    "Spirit Walk",
    "Wind Rush",

    -- Both
    "Bloodlust",
}

-- DK Purple { 163/255, 48/255, 201/255 }
-- Mage Blue { 105/255, 204/255, 240/255 }
-- Monk Green { 0/255, 255/255, 150/255}


local trackedBuffs = {
    -- Warrior
    ["Bladestorm"] = {
        color = { 0/255, 112/255, 222/255 }, -- Blue
        isTimer = true
    },

    ["Ultimatum"] = {
        color = { 255/255, 245/255, 105/255 }, -- Yellow
        isTimer = true
    },

    ["Shield Block"] = {
        spellID = 132404,
        color = { 148/255, 130/255, 201/255 }, -- Purple
        isTimer = true
    },

    ["Ignore Pain"] = {
        color = { 245/255, 140/255, 186/255 }, -- Pink
        textValue = function(absorb) -- Returns absorbed damage as "___K"
                        return string.format("%uK", absorb/1000)
        end,
        maxValue = function()
            return UnitHealthMax("player")
        end
    },

    ["Shield Wall"] = {
        color = { 199/255, 156/255, 110/255 }, -- Brown
        isTimer = true
    },

    ["Last Stand"] = {
        color = { 245/255, 140/255, 186/255 }, -- Pink
        isTimer = true
    },

    ["Rallying Cry"] = {
        color = { 245/255, 140/255, 186/255 }, -- Pink
        isTimer = true
    },

    ["Enrage"] = {
        color = { 196/255, 30/255, 59/255 }, -- Red
        isTimer = true
    },

    ["Recklessness"] = {
        color = { 255/255, 125/255, 10/255 }, -- Orange
        isTimer = true
    },

    ["Enraged Regeneration"] = {
        color = { 171/255, 212/255, 115/255 }, -- Green
        isTimer = true
    },

    

    -- Shaman
    ["Landslide"] = {
        color = { 171/255, 212/255, 115/255 }, -- Green
        isTimer = true
    },

    ["Flametongue"] = {
        color = { 255/255, 125/255, 10/255 }, -- Orange
        isTimer = true
    },

    ["Frostbrand"] = {
        color = { 255/255, 255/255, 255/255 }, -- White
        isTimer = true
    },

    ["Bloodlust"] = {
        color = { 196/255, 30/255, 59/255 }, -- Red
        isTimer = true
    },

    ["Astral Shift"] = {
        color = { 245/255, 140/255, 186/255 }, -- Pink
        isTimer = true
    },

    ["Spirit Walk"] = {
        color = { 0/255, 112/255, 222/255 }, -- Blue
        isTimer = true
    },

    ["Wind Rush"] = {
        color = { 0/255, 112/255, 222/255 }, -- Blue
        isTimer = true
    },
}

--backdrop table
local backdrop_tab = { 
    bgFile = mediaPath.."backdrop", 
    edgeFile = mediaPath.."backdrop_edge",
    tile = false,
    tileSize = 0, 
    edgeSize = 2, 
    insets = { 
        left = 2, 
        right = 2, 
        top = 2, 
        bottom = 2,
    },
}

-- Returns a font object
local function getFont(frame, name, size, outline)
    local font = frame:CreateFontString(nil, "OVERLAY")
    font:SetFont(name, size, outline)
    font:SetShadowColor(0, 0, 0, 0.8)
    font:SetShadowOffset(1, -1)
    return font
end


-- Creates a new bar frame
local function createBar()
    local bar = CreateFrame("StatusBar", nil, UIParent)
    bar:SetStatusBarTexture(mediaPath.."Statusbar")
    bar:GetStatusBarTexture():SetHorizTile(false)
    bar:GetStatusBarTexture():SetVertTile(false)
    bar:SetWidth(barWidth)
    bar:SetHeight(barHeight)
    bar:SetFrameLevel(1)

    -- Helper frame for the backdrop
    local backdrop = CreateFrame("Frame", nil, bar)
    backdrop:SetFrameLevel(0)
    backdrop:SetPoint("TOPLEFT",-2,2)
    backdrop:SetPoint("BOTTOMRIGHT",2,-2)
    backdrop:SetBackdrop(backdrop_tab)
    backdrop:SetBackdropColor(0,0,0,0.6)
    backdrop:SetBackdropBorderColor(0,0,0,1)

    -- Spell name text
    local spellName = getFont(bar, mediaPath.."LemonMilk.otf", 16, "THINOUTLINE")
    spellName:SetPoint("CENTER", 0, 6)
    spellName:SetJustifyH("CENTER")
    bar.spellName = spellName

    --[[ Tracked value text
    local spellValue = getFont(bar, mediaPath.."ROADWAY.ttf", 16, "THINOUTLINE")
    spellValue:SetPoint("RIGHT", -2, 0)
    spellValue:SetJustifyH("RIGHT", spellValue, "LEFT", -5, 0)
    bar.spellValue = spellValue
    ]]

    return bar
end

-- Repositions all bars in a stack
local function positionBars()
    local activeBars = 0
    for _, buff in pairs(buffIndex) do
        info = trackedBuffs[buff]
        if info then
            if info.active then
                info.bar:SetPoint("TOP", mGuideFrame, "BOTTOM", 0, activeBars * barOffset - 20)
                activeBars = activeBars + 1
            end
        end
    end
end

-- Displays the bar, or create it if it didn't exist already
local function drawBar(buffName, info)
    if not info.bar then
        info.bar = createBar()
        info.bar:SetStatusBarColor(info.color[1], info.color[2], info.color[3])
        info.bar.spellName:SetFormattedText(buffName)
    end
    positionBars()
    info.bar:Show()
end

-- Redraw the bar based on buff duration, runs OnUpdate if there are active bars to redraw
local function updateTimers()
    -- Save CPU by only running once every throttleCount times
    throttleCount = throttleCount + 1
    if (throttleCount < 3) then -- Hard coded for performance
        return
    end
    throttleCount = 0

    -- This will only update currently active timers in trackedTimers
    for _, info in pairs(trackedTimers) do
        local remaining = info.expires - GetTime()
        --info.bar.spellValue:SetFormattedText("%.1f", remaining)
        info.bar:SetValue(remaining)
    end
end

local function getBuff(buff, info)
    --[[ Used to search by spell name for efficiency, but seems I can't anymore
    local name, _, _, _, _, duration, expires, _, _, spellID, _, _, _, _, value1, _, _, _, _ = UnitBuff("player", info.spellID)

    -- If buff has a SpellID, make sure we got the correct buff, needed for buffs that share the same name
    if spellID ~= info.spellID then]]

    -- Just iterate through all buffs on player and match the name
    for i=1,40,1 do
        local name, _, _, _, duration, expires, _, _, _, spellID, _, _, _, _, value1, _, _ = UnitBuff("player", i)
        
        if name == buff then
            return name, duration, expires, value1
        end
    end
    --end
    
    return name, duration, expires, value1
end

-- Every time UNIT_AURA fires collect the information on all tracked buffs
-- This can be broken when UnitBuff can return multiple values for one buff name, i.e. "Shield Block" with 
-- tier bonus that modify its buff. Only way to fix this is iterate over all player buffs and find the one
-- with the correct SpellID
local function updateAuras()
    local activeTimers = false
    for buff, info in pairs(trackedBuffs) do
        local name, duration, expires, value1 = getBuff(buff, info)
        if name then
            if not info.active then -- create frame
                info.active = true
                drawBar(buff, info)
            end

            if info.isTimer then
                info.expires = expires
                info.bar:SetMinMaxValues(0, duration)
                trackedTimers[buff] = info
                activeTimers = true
                timerUpdater:SetScript("OnUpdate", updateTimers)
            else
                info.bar:SetMinMaxValues(0, info.maxValue())
                info.bar:SetValue(value1)
                --info.bar.spellValue:SetFormattedText(info.textValue(value1))
            end
            
        elseif info.active then -- destroy frame
            info.active = false
            trackedTimers[buff] = nil
            info.bar:Hide()
            positionBars()
        end
    end
    if not activeTimers then
        timerUpdater:SetScript("OnUpdate", nil)
    end

end

auraUpdater:SetScript("OnEvent", function () updateAuras() end)
auraUpdater:RegisterEvent("UNIT_AURA", "player")
