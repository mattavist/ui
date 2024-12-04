-- rBlizzardStuff/chat: chat adjustments
-- zork, 2024

-----------------------------
-- Variables
-----------------------------

local A, L = ...

CHAT_TAB_HIDE_DELAY = 0
CHAT_FRAME_TAB_NORMAL_MOUSEOVER_ALPHA = 1
CHAT_FRAME_TAB_NORMAL_NOMOUSE_ALPHA = 0
CHAT_FRAME_TAB_SELECTED_MOUSEOVER_ALPHA = 1
CHAT_FRAME_TAB_SELECTED_NOMOUSE_ALPHA = 0
CHAT_FRAME_TAB_ALERTING_MOUSEOVER_ALPHA = 1
CHAT_FRAME_TAB_ALERTING_NOMOUSE_ALPHA = 1
CHAT_FRAME_SIZE = {615, 250}
CHAT_FRAME_INSET = 12

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

local editBoxFocusAlpha = 1
local editBoxAlpha = 0

local ChatFramePosition = {
    ChatFrame1 = {"BOTTOMLEFT", CHAT_FRAME_INSET, CHAT_FRAME_INSET},
    ChatFrame4 = {"BOTTOMRIGHT", -CHAT_FRAME_INSET, CHAT_FRAME_INSET},
}

-----------------------------
-- Functions
-----------------------------

local function ApplyClamp(chatframe)
  helper.SetClampRectInsets(chatframe,0,0,0,0)
  if chatframe == ChatFrame1 then
    SetChatFrame1Position()
  end
end

local function UpdateToastPosition()
  QuickJoinToastButton:ClearAllPoints()
  QuickJoinToastButton:SetPoint("BOTTOMLEFT",ChatFrame1,"TOPLEFT",0,ChatFrame1Tab:GetHeight()-2)
end

--backdrop table
local mediaPath = "Interface\\media\\"
local inset = 6
local backdrop_tab = { 
    bgFile = mediaPath.."backdrop", 
    edgeFile = mediaPath.."backdrop_edge",
    tile = false,
    tileSize = 0, 
    edgeSize = 0, 
    insets = { 
        left = inset,
        right = inset, 
        top = inset, 
        bottom = inset,
    },
}

local function ApplyHide(tab, alpha)
  if alpha > .4 and alpha < 1 then return end

  if alpha == .4 then
    alpha = 0
  end

  helper.SetAlpha(tab, alpha)
end


--SkinChat
local function SkinChat()
  for i = 1, NUM_CHAT_WINDOWS do
    local chatframe = _G["ChatFrame"..i]
    if not chatframe then return end

    chatframe:SetClampRectInsets(0,0,0,0)
    hooksecurefunc(chatframe, "SetClampRectInsets", ApplyClamp)
    hooksecurefunc(_G["ChatFrame"..i.."Tab"], "SetAlpha", ApplyHide)

    local name = chatframe:GetName()
    _G[name.."ButtonFrame"]:Hide()
    _G[name.."EditBox"]:SetAltArrowKeyMode(false)
    _G[name.."EditBox"]:ClearAllPoints()
    _G[name.."EditBox"]:SetPoint("BOTTOMLEFT",chatframe,"TOPLEFT",QuickJoinToastButton:GetWidth(),ChatFrame1Tab:GetHeight()-3)
    _G[name.."EditBox"]:SetPoint("BOTTOMRIGHT",chatframe,"TOPRIGHT",20,0)
    _G[name.."EditBoxFocusLeft"]:SetAlpha(editBoxFocusAlpha)
    _G[name.."EditBoxFocusMid"]:SetAlpha(editBoxFocusAlpha)
    _G[name.."EditBoxFocusRight"]:SetAlpha(editBoxFocusAlpha)
    _G[name.."EditBoxLeft"]:SetAlpha(editBoxAlpha)
    _G[name.."EditBoxMid"]:SetAlpha(editBoxAlpha)
    _G[name.."EditBoxRight"]:SetAlpha(editBoxAlpha)
    _G[name.."Tab"]:SetAlpha(0)

    local Background = CreateFrame("Frame", nil, _G[name.."EditBox"], "BackdropTemplate")
    Background:SetAllPoints()
    Background:SetBackdrop(backdrop_tab)
    Background:SetBackdropColor(0,0,0,1)
    Background:SetBackdropBorderColor(0,0,0,0)
    Background:SetFrameLevel(0)

    local position = ChatFramePosition[name]
    if position then
      chatframe:ClearAllPoints()
      chatframe:SetSize(unpack(CHAT_FRAME_SIZE))
      chatframe:SetPoint(unpack(position))
    end
  end

  TextToSpeechButtonFrame:Hide()
  UpdateToastPosition()
  rLib:CreateFrameFader(QuickJoinToastButton, faderConfig)
end

rLib:RegisterCallback("PLAYER_LOGIN", SkinChat)

hooksecurefunc("FCF_SetButtonSide", UpdateToastPosition)
