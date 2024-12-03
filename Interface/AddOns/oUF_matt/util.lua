local _, ns = ...
local cfg, util =  ns.cfg, ns.util

function util:debug(msg)
	if cfg.debugEnabled then
		DEFAULT_CHAT_FRAME:AddMessage(msg)
	end
end

