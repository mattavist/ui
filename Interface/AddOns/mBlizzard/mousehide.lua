-- NOTE: Need to disable this module to move the bars

local padding = 20
local faderConfig = {
  fadeInAlpha = 1,
  fadeInDuration = 0.3,
  fadeInSmooth = "OUT",
  fadeOutAlpha = 0,
  fadeOutDuration = 0.3,
  fadeOutSmooth = "OUT",
  fadeOutDelay = 0,
}

-- Create a frame to hold both bars
local MultiBarHolder = CreateFrame("Frame", "MultiBarHolder", UIParent, "SecureHandlerStateTemplate")
MultiBarHolder:SetPoint("TOPLEFT", MultiBarLeft, "TOPLEFT", -padding, padding)
MultiBarHolder:SetPoint("BOTTOMRIGHT", MultiBarRight, "BOTTOMRIGHT", padding, -padding)

-- Parent the bars to the holder
MultiBarLeft:SetParent(MultiBarHolder)
MultiBarRight:SetParent(MultiBarHolder)

-- Create the mouseover fader
rLib:CreateFrameFader(MultiBarHolder, faderConfig)
