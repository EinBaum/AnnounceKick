
local addonName = "AnnounceKick"
local addonVersion = "1.0.0"

--------------------------------------------------------------------------------

local cc = "Your Kick "
local ccLen = strlen(cc)
local chatType = "SAY"
local strings = {
	["Hit"]		= SPELLLOGSELFOTHER,		-- Your %s hits %s for %s.
	["Crit"]	= SPELLLOGCRITSELFOTHER,	-- Your %s crits %s for %s.
	["Dodge"]	= SPELLDODGEDSELFOTHER,		-- Your %s was dodged by %s.
	["Parry"]	= SPELLPARRIEDSELFOTHER,	-- Your %s is parried by %s.
	["Miss"]	= SPELLMISSSELFOTHER,		-- Your %s missed %s.
	["Block"]	= SPELLBLOCKEDSELFOTHER,	-- Your %s was blocked by %s.
	["Deflect"]	= SPELLDEFLECTEDSELFOTHER,	-- Your %s was deflected by %s.
	["Evade"]	= SPELLEVADEDSELFOTHER,		-- Your %s was evaded by %s.
	["Immune"]	= SPELLIMMUNESELFOTHER,		-- Your %s failed. %s is immune.
	["Absorb"]	= SPELLLOGABSORBSELFOTHER,	-- Your %s is absorbed by %s.
	["Reflect"]	= SPELLREFLECTSELFOTHER,	-- Your %s is reflected back by %s.
	["Resist"]	= SPELLRESISTSELFOTHER		-- Your %s was resisted by %s.
}
local stringsHit = {
	["Hit"] = 1,
	["Crit"] = 1,
	["Absorb"] = 1
}

--------------------------------------------------------------------------------

local function print(text)
	DEFAULT_CHAT_FRAME:AddMessage(text, 1, 1, 0.5)
end

local function announce(spell, target, hitType)
	local msg = nil
	if stringsHit[hitType] then
		msg = format("%s <%s> 10s CD", spell, target)
	else
		msg = format(">>>MISSED<<< %s on <%s> (%s) 10s CD", spell, target, hitType)
	end
	SendChatMessage(msg, chatType)
end

--------------------------------------------------------------------------------

local function init()
	for index in strings do
		for _, pattern in {"%%s", "%%d"} do
			strings[index] = gsub(strings[index], pattern, "(.*)")
		end
	end
	print(format("%s %s loaded.", addonName, addonVersion))
end

local function check()
	if strsub(arg1, 1, ccLen) ~= cc then
		return
	end

	for typ, str in strings do
		local _, _, spell, target = strfind(arg1, str)
		if spell and target then
			announce(spell, target, typ)
			return
		end
	end
end

--------------------------------------------------------------------------------

local frame = CreateFrame("frame")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE")
frame:SetScript("OnEvent", function()
	if event == "CHAT_MSG_SPELL_SELF_DAMAGE" then
		check()
	elseif event == "ADDON_LOADED" then
		if strlower(arg1) == strlower(addonName) then
			frame:UnregisterEvent("ADDON_LOADED")
			init()
		end
	end
end)
