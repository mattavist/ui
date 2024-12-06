-- rBlizzardStuff/blizzardui: blizzard ui adjustments, state-drivers and mouseover fading for multibars
-- zork, 2024

-----------------------------
-- Variables
-----------------------------

local A, L = ...
local helper = CreateFrame("Frame")

local faderConfig = {
  fadeInAlpha = 1,
  fadeInDuration = 0.3,
  fadeInSmooth = "OUT",
  fadeOutAlpha = 0,
  fadeOutDuration = 0.9,
  fadeOutSmooth = "OUT",
  fadeOutDelay = 0,
}

-----------------------------
-- Functions
-----------------------------
local function registerAltHandler(self)
  local settings = "[mod:alt] show; hide"
  RegisterStateDriver(self, "visibility", settings)

  self.Show = function(self)
    if IsAltKeyDown() then
      helper.Show(self)
    end
  end
end

--AdjustBlizzardFrames
local function AdjustBlizzardFrames()
  -- PlayerFrame handled by combathide.lua
  -- Left/Right MultiBar handled by mousehide.lua

  -- Show/Hide on Alt
  registerAltHandler(BagsBar)
  registerAltHandler(MicroMenuContainer)
  registerAltHandler(MicroButtonAndBagsBar)
  registerAltHandler(MainStatusTrackingBarContainer)
  registerAltHandler(ObjectiveTrackerFrame)

  --hide bufframe by clicking the button
  -- if BuffFrame.CollapseAndExpandButton:GetChecked() then
  --   BuffFrame.CollapseAndExpandButton:Click()
  -- end
end

rLib:RegisterCallback("PLAYER_LOGIN", AdjustBlizzardFrames)
