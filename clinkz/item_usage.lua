local Helper = require(GetScriptDirectory() .. "/helper");
local ItemsHelper = require(GetScriptDirectory() .. "/helper_items");

local ItemUsage = {}

function ItemUsage.Think()

    local npcBot = GetBot();

    ItemsHelper.teleport(npcBot);
    for i = 0,5 do
        local item = npcBot:GetItemInSlot(i);
        ItemsHelper.heal(npcBot, item);
        ItemsHelper.mana(npcBot, item);
    end

    return
end

return ItemUsage
