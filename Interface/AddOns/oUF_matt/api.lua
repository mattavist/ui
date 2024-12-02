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

-- Fading
local function FaderOnFinished(self) self.__owner:SetAlpha(self.finAlpha) end

local function FaderOnUpdate(self)
    self.__owner:SetAlpha(self.__animFrame:GetAlpha())
end

function api:StartFadeIn(frame)
    if frame.fader.direction == "in" then return end
    frame.fader:Pause()
    frame.fader.anim:SetFromAlpha(frame.faderConfig.fadeOutAlpha or 0)
    frame.fader.anim:SetToAlpha(frame.faderConfig.fadeInAlpha or 1)
    frame.fader.anim:SetDuration(frame.faderConfig.fadeInDuration or 0.3)
    frame.fader.anim:SetSmoothing(frame.faderConfig.fadeInSmooth or "OUT")
    frame.fader.anim:SetStartDelay(frame.faderConfig.fadeInDelay or 0)
    frame.fader.finAlpha = frame.faderConfig.fadeInAlpha
    frame.fader.direction = "in"
    frame.fader:Play()
end

function api:StartFadeOut(frame)
    if frame.fader.direction == "out" then return end
    frame.fader:Pause()
    frame.fader.anim:SetFromAlpha(frame.faderConfig.fadeInAlpha or 1)
    frame.fader.anim:SetToAlpha(frame.faderConfig.fadeOutAlpha or 0)
    frame.fader.anim:SetDuration(frame.faderConfig.fadeOutDuration or 0.3)
    frame.fader.anim:SetSmoothing(frame.faderConfig.fadeOutSmooth or "OUT")
    frame.fader.anim:SetStartDelay(frame.faderConfig.fadeOutDelay or 0)
    frame.fader.finAlpha = frame.faderConfig.fadeOutAlpha
    frame.fader.direction = "out"
    frame.fader:Play()
end

function api:CreateFaderAnimation(frame)
    if frame.fader then return end
    local animFrame = CreateFrame("Frame", nil, frame)
    animFrame.__owner = frame
    frame.fader = animFrame:CreateAnimationGroup()
    frame.fader.__owner = frame
    frame.fader.__animFrame = animFrame
    frame.fader.direction = nil
    frame.fader.setToFinalAlpha = false
    frame.fader.anim = frame.fader:CreateAnimation("Alpha")
    frame.fader:HookScript("OnFinished", FaderOnFinished)
    frame.fader:HookScript("OnUpdate", FaderOnUpdate)
end

local function fadeIn(frame) api:StartFadeIn(frame) end

local function fadeOut(frame) api:StartFadeOut(frame) end

function api:CreateFrameFader(frame, faderConfig)
    if frame.faderConfig then return end
    frame.faderConfig = faderConfig
    api:CreateFaderAnimation(frame)
    frame:HookScript("OnShow", fadeIn)
    frame:HookScript("OnHide", fadeOut)
end
