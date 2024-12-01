local _, ns = ...
local api, cfg, media = ns.api, ns.cfg, ns.media

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

-- Create Glow Border
function api:SetGlowBorder(self)
    local glow = CreateFrame("Frame", nil, self, "BackdropTemplate")
    glow:SetFrameLevel(0)
    glow:SetPoint("TOPLEFT", self, "TOPLEFT", -6, 6)
    glow:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 6, -6)
    glow:SetBackdrop({
        bgFile = media.textures.white_square,
        edgeFile = media.textures.glow_texture,
        tile = false,
        tileSize = 16,
        edgeSize = 4,
        insets = {left = -4, right = -4, top = -4, bottom = -4}
    })
    glow:SetBackdropColor(0, 0, 0, 0)
    glow:SetBackdropBorderColor(0, 0, 0, 1)

    self.Glowborder = glow
end
