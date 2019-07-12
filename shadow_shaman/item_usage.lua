local Helper = require(GetScriptDirectory() .. "/helper");
local ItemsHelper = require(GetScriptDirectory() .. "/helper_items");

local ItemUsage = {}

function ItemUsage.Think()

    local npcBot = GetBot();

    for i = 0,5 do
        local item = npcBot:GetItemInSlot(i);

        ItemsHelper.blinkToEnemy(npcBot, item, 4, 12);
        ItemsHelper.blackKingBar(npcBot, item);
        ItemsHelper.euls(npcBot, item);

    end

    return
end

return ItemUsage
