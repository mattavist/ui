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
  local modifier = "ctrl"
  RegisterStateDriver(BagsBar, "visibility", "[mod:"..modifier.."] show; hide")
  RegisterStateDriver(MicroMenuContainer, "visibility", "[mod:"..modifier.."] show; hide")
  RegisterStateDriver(MicroButtonAndBagsBar, "visibility", "[mod:"..modifier.."] show; hide")
  RegisterStateDriver(MainStatusTrackingBarContainer, "visibility", "[mod:"..modifier.."] show; hide")
  RegisterStateDriver(ObjectiveTrackerFrame, "visibility", "[mod:"..modifier.."] show; hide")

  --hide bufframe by clicking the button
  -- if BuffFrame.CollapseAndExpandButton:GetChecked() then
  --   BuffFrame.CollapseAndExpandButton:Click()
  -- end
end

rLib:RegisterCallback("PLAYER_LOGIN", AdjustBlizzardFrames)
