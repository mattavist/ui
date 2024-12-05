-- rBlizzardStuff/blizzardui: blizzard ui adjustments, state-drivers and mouseover fading for multibars
-- zork, 2024

-----------------------------
-- Variables
-----------------------------

local A, L = ...

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

--AdjustBlizzardFrames
local function AdjustBlizzardFrames()
  -- PlayerFrame handled by combathide.lua
  -- Left/Right MultiBar handled by mousehide.lua

  -- Show/Hide on Ctrl
  local modifier = "[mod:ctrl,nomod:shift] show; hide"
  RegisterStateDriver(BagsBar, "visibility", modifier)
  RegisterStateDriver(MicroMenuContainer, "visibility", modifier)
  RegisterStateDriver(MicroButtonAndBagsBar, "visibility", modifier)
  RegisterStateDriver(MainStatusTrackingBarContainer, "visibility", modifier)
  RegisterStateDriver(ObjectiveTrackerFrame, "visibility", modifier)

  --hide bufframe by clicking the button
  -- if BuffFrame.CollapseAndExpandButton:GetChecked() then
  --   BuffFrame.CollapseAndExpandButton:Click()
  -- end
end

rLib:RegisterCallback("PLAYER_LOGIN", AdjustBlizzardFrames)
