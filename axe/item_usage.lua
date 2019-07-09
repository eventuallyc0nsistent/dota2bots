local Helper = require(GetScriptDirectory() .. "/helper");
local ItemsHelper = require(GetScriptDirectory() .. "/helper_items");

local ItemUsage = {}

function ItemUsage.Think()

    local npcBot = GetBot();
    local enemyHeroes = nil;
    local creeps = nil; 

    for i = 0,5 do
        local item = npcBot:GetItemInSlot(i);

        ItemsHelper.heal(npcBot, item);
        ItemsHelper.mana(npcBot, item);
        ItemsHelper.blinkToEnemy(npcBot, item, 2, 5);
        ItemsHelper.bladeMail(npcBot, item, 1);
        ItemsHelper.blackKingBar(npcBot, item);
        ItemsHelper.forceStaff(npcBot, item);

    end

    return
end

return ItemUsage