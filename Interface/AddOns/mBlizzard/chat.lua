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
CHAT_FRAME_WIDTH = 615
CHAT_FRAME_HEIGHT = 250

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

-----------------------------
-- Functions
-----------------------------

local function SetChatFrame1()
  ChatFrame1:ClearAllPoints()
  ChatFrame1:SetSize(CHAT_FRAME_WIDTH, CHAT_FRAME_HEIGHT)
  ChatFrame1:SetPoint("BOTTOMLEFT", 12, 12)
end

local function SetChatFrame4()
  ChatFrame4:ClearAllPoints()
  ChatFrame4:SetSize(CHAT_FRAME_WIDTH, CHAT_FRAME_HEIGHT)
  ChatFrame4:SetPoint("BOTTOMRIGHT", -12, 12)
end

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

local function ApplyHide(tab)
  tab:Hide()
end


--SkinChat
local function SkinChat()
  -- TODO: Create a backdrop for the 
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
    local Background = CreateFrame("Frame", nil, _G[name.."EditBox"], "BackdropTemplate")
    -- local Background = _G[name.."EditBox"]:CreateTexture(nil, 'BACKGROUND')
    Background:SetAllPoints()
    -- Background:SetTexture(1, 1, 1, 1)
    Background:SetBackdrop(backdrop_tab)
    Background:SetBackdropColor(0,0,0,1)
    Background:SetBackdropBorderColor(0,0,0,0)
    Background:SetFrameLevel(0)
  end

  TextToSpeechButtonFrame:Hide()
  SetChatFrame1()
  SetChatFrame4()
  ChatFrame4Tab:SetAlpha(0)
  UpdateToastPosition()
  rLib:CreateFrameFader(QuickJoinToastButton, faderConfig)
end

rLib:RegisterCallback("PLAYER_LOGIN", SkinChat)

hooksecurefunc("FCF_SetButtonSide", UpdateToastPosition)
