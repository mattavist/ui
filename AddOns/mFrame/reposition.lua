local f = CreateFrame("Frame")
local s = CreateFrame("Frame")

local framesToMove = {
    ["ObjectiveTrackerFrame"] = {
        name = ObjectiveTrackerFrame,
        func = "SetPoint",
        frameAnchor = "TOPLEFT",
        parent = UIParent,
        parentAnchor = "TOPLEFT",
        x = 30,
        y = 25,
        height = 500
    },
    ["AlertFrame"] = {
        name = AlertFrame,
        func = "SetParent",
        frameAnchor = "TOP",
        parent = UIParent,
        parentAnchor = "BOTTOM",
        x = 0,
        y = 600,
        height = nil
    },
    ["TalkingHeadFrame"] = {
        name = TalkingHeadFrame,
        func = "TalkingHeadFrame_PlayCurrent",
        frameAnchor = "TOP",
        parent = WorldFrame,
        parentAnchor = "CENTER",
        x = 300,
        y = -300,
        height = 300
    },
    ["ArcheologyDigsiteProgressBar"] = {
        name = {ArcheologyDigsiteProgressBar},
        func = "ArcheologyDigsiteProgressBar_OnUpdate",
        frameAnchor = "BOTTOM",
        parent = WorldFrame,
        parentAnchor = "BOTTOM",
        x = 0,
        y = 50,
        height = nil
    },
    ["ChatFrame1"] = {
        name = ChatFrame1,
        func = "Show",  -- Better func available?
        secondaryFunc = "SetPoint",
        frameAnchor = "BOTTOMLEFT",
        parent = UIParent,
        parentAnchor = "BOTTOMLEFT",
        x = 12,
        y = 12,
        height = 250,
        width = 615
    },
    ["ChatFrame4"] = {
        name = ChatFrame4,
        func = "Show",  -- Better func available?
        secondaryFunc = "SetPoint",
        frameAnchor = "BOTTOMRIGHT",
        parent = UIParent,
        parentAnchor = "BOTTOMRIGHT",
        x = -12,
        y = 12,
        height = 250,
        width = 615
    },
    ["QueueStatusButton"] = {
        name = QueueStatusButton,
        func = "Show",  -- Better func available?
        secondaryFunc = "SetPoint",
        frameAnchor = "CENTER",
        parent = Minimap,
        parentAnchor = "BOTTOMLEFT",
        x = 0,
        y = 0,
    },
}

local framesToHide = {
    MicroMenu,
    BagsBar,
    MainStatusTrackingBarContainer,
}

local function setFrameMover(frame)
    if frame.hooked then
        return
    end
    frame.hooked = true
    local moving

    hooksecurefunc(frame.name, frame.func, function(self)
        if moving then
            return
        end

        moving = true

        ChatFrame1:AddMessage("Moving "..frame.name:GetName().." into proper place for "..frame.func)
        frame.name:ClearAllPoints()
        frame.name:SetPoint(frame.frameAnchor, frame.parent, frame.parentAnchor, frame.x, frame.y)
        if frame.height then
            frame.name:SetHeight(frame.height)
        end
        if frame.width then
            frame.name:SetWidth(frame.width)
        end
        moving = nil
    end)

    if frame.secondaryFunc then
        hooksecurefunc(frame.name, frame.secondaryFunc, function(self)
            if moving then
                return
            end

            moving = true

            ChatFrame1:AddMessage("Moving "..frame.name:GetName().." into proper place for "..frame.secondaryFunc)
            frame.name:ClearAllPoints()
            frame.name:SetPoint(frame.frameAnchor, frame.parent, frame.parentAnchor, frame.x, frame.y)
            if frame.height then
                frame.name:SetHeight(frame.height)
            end
            if frame.width then
                frame.name:SetWidth(frame.width)
            end
            moving = nil
        end)
    end
end

local function hideFrames()
    for _, frame in pairs(framesToHide) do
        frame:Hide()
    end
end

function s:OnAddon(event, addon)
    -- Move Talking Head Frame to top of screen
    if addon == "Blizzard_TalkingHeadUI" then
        hooksecurefunc("TalkingHeadFrame_PlayCurrent", function()
            AlertFrame:ClearAllPoints()
            AlertFrame:SetPoint("BOTTOM", 0, 350)
            TalkingHeadFrame:SetPoint("BOTTOMRIGHT", WorldFrame, "BOTTOMRIGHT", -10, 650)
            TalkingHeadFrame.ignoreFramePositionManager = true
        end)

    -- Move Digsite Progress to Bottom of screen
    elseif addon == "Blizzard_ArchaeologyUI" then
        hooksecurefunc("ArcheologyDigsiteProgressBar_OnUpdate", function()
            ArcheologyDigsiteProgressBar:SetPoint("BOTTOM", WorldFrame, "BOTTOM", 0, 50)
            ArcheologyDigsiteProgressBar.ignoreFramePositionManager = true
        end)
    end
end

function f:OnEnter()
    setFrameMover(framesToMove["ObjectiveTrackerFrame"])

    setFrameMover(framesToMove["ChatFrame1"])
    ChatFrame1:Show()
    setFrameMover(framesToMove["ChatFrame4"])
    ChatFrame4:Show()

    setFrameMover(framesToMove["QueueStatusButton"])
    QueueStatusButton:Show()

    AlertFrame:ClearAllPoints()
    AlertFrame:SetPoint("BOTTOM", 0, 350)

    hideFrames()
    f:UnregisterEvent("PLAYER_ENTERING_WORLD")
    s:SetScript("OnEvent", s.OnAddon)
    s:RegisterEvent("ADDON_LOADED")
end


f:SetScript("OnEvent", f.OnEnter)
s:SetScript("OnEvent", s.OnAddon)
f:RegisterEvent("PLAYER_ENTERING_WORLD")