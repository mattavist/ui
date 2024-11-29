local _, ns = ...
local api, cfg = ns.api, ns.cfg

function api:SetBackdrop(self, insetLeft, insetRight, insetTop, insetBottom,
                         color)
    local frame = self

    if self:GetObjectType() == "Texture" then frame = self:GetParent() end

    local lvl = frame:GetFrameLevel()

    if not frame.Backdrop then
        local backdrop = CreateFrame("Frame", nil, frame, "BackdropTemplate")
        backdrop:SetAllPoints(frame)
        backdrop:SetFrameLevel(lvl == 0 and 0 or lvl - 1)

        backdrop:SetBackdrop {
            bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
            tile = false,
            tileSize = 0,
            insets = {
                left = -insetLeft,
                right = -insetRight,
                top = -insetTop,
                bottom = -insetBottom
            }
        }
        backdrop:SetBackdropColor(unpack(color or cfg.colors.backdrop))
        frame.Backdrop = backdrop
    end
end
