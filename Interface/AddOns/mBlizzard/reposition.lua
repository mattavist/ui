local f = CreateFrame("Frame")

local framesToMove = {
    ["QueueStatusButton"] = {
        name = QueueStatusButton,
        func = "Show",  -- Better func available?
        secondaryFunc = "SetPoint",
        frameAnchor = "CENTER",
        parent = Minimap,
        parentAnchor = "BOTTOMLEFT",
        x = 0,
        y = 0,
        setParent = true,
    },
}

local function setFrameMover(frame)
    if frame.hooked then
        return
    end
    frame.hooked = true
    local moving

    -- TODO: CONSIDER USING THIS TO PREVENT SUBSEQUENT MOVES
    -- TODO: INSTEAD OF HOOKING A FUNC?
    -- local dummy = function() end
    -- frame.Show = dummy


    hooksecurefunc(frame.name, frame.func, function(self)
        if moving then
            return
        end

        moving = true

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

    if frame.name.setParent then
        frame.name:SetParent(frame.parent)
    end
    frame.name:Show()
end

function f:OnEnter()
    setFrameMover(framesToMove["QueueStatusButton"])
    f:UnregisterEvent("PLAYER_ENTERING_WORLD")
end


f:SetScript("OnEvent", f.OnEnter)
f:RegisterEvent("PLAYER_ENTERING_WORLD")