--[[
  Author: Zack Youngren
  License: GNU AGPLv3
]]

------------------------
-- Start User Options --
------------------------

-- Shows a raid warning that only the player will see
local show_private_warning = true

-- Plays a sound that only the player will hear
local play_private_sound = true

-- Messages the party on behalf of the player
local alert_party = false

-- Disable this alerting when the user is in a raid
local disable_when_in_raid = true

----------------------
-- End User Options --
----------------------

local LootMethodAlerter_EventFrame = CreateFrame("FRAME")
LootMethodAlerter_EventFrame:RegisterEvent("PARTY_LOOT_METHOD_CHANGED")

local loot_method_strings = {
  ["needbeforegreed"] = "Need Before Greed",
  ["group"] = "Group Loot",
  ["master"] = "Master Looter",
  ["roundrobin"] = "Round Robin",
  ["freeforall"] = "Free For All",
}

local function onPartyLootMethodChanged(self, event, ...)
  if disable_when_in_raid and IsInRaid() then
    return
  end

  local lootmethod = GetLootMethod()
  local warning_message = "Loot method has been set to " .. loot_method_strings[lootmethod]

  if show_private_warning then
    RaidNotice_AddMessage(RaidWarningFrame, "|cffff0000" .. "WARNING: " .. "|r" .. warning_message, ChatTypeInfo["RAID_WARNING"])
  end

  if play_private_sound then
    PlaySound(8959) -- RAID_WARNING
  end

  if alert_party then
    SendChatMessage("Loot Method Alerter: " .. warning_message, "PARTY")
  end
end

LootMethodAlerter_EventFrame:SetScript("OnEvent", onPartyLootMethodChanged)
