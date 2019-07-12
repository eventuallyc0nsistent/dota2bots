----------------------------------------------------------------------------------------------------

_G._savedEnv = getfenv()
module( "ability_item_usage_generic", package.seeall )

----------------------------------------------------------------------------------------------------
function GetHeroName(npcBot)
    local playerId = npcBot:GetPlayerID();
    local npcHeroName = GetSelectedHeroName(playerId);
    local heroName = '';
    local names = {}

    for i in string.gmatch(npcHeroName, "([^_]+)") do
        table.insert(names, i);
    end

    return table.concat(names, '_', 4)
end

function AbilityUsageThink()
    local npcBot = GetBot();

    local heroName = GetHeroName(npcBot);
    local AbilityUsage = require(GetScriptDirectory() .. "/"..heroName.."/ability_usage");
    AbilityUsage.Think();
end

----------------------------------------------------------------------------------------------------

function ItemUsageThink()
    local npcBot = GetBot();
    local heroName = GetHeroName(npcBot);
    local ItemUsage = require(GetScriptDirectory() .. "/"..heroName.."/item_usage");
    local ItemsHelper = require(GetScriptDirectory() .. "/helper_items");

    ItemsHelper.teleport(npcBot);
    for i = 0,5 do
        local item = npcBot:GetItemInSlot(i);

        ItemsHelper.heal(npcBot, item);
        ItemsHelper.mana(npcBot, item);
    end

    ItemUsage.Think();
end

----------------------------------------------------------------------------------------------------


for k,v in pairs( ability_item_usage_generic ) do   _G._savedEnv[k] = v end
