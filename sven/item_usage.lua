local Helper = require(GetScriptDirectory() .. "/helper");
local ItemsHelper = require(GetScriptDirectory() .. "/helper_items");
local ItemUsage = {}

function ItemUsage.Think()
    local npcBot = GetBot();
    local enemyHeroes = nil;
    local creeps = nil; 

    for i = 0,5 do
        local item = npcBot:GetItemInSlot(i);

        ItemsHelper.blinkToEnemy(npcBot, item, 2, 5);
        ItemsHelper.blackKingBar(npcBot, item);

    end

    return
end

return ItemUsage
