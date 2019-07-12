local Helper = require(GetScriptDirectory() .. "/helper");
local ItemsHelper = require(GetScriptDirectory() .. "/helper_items");

local ItemUsage = {}

function ItemUsage.Think()

    local npcBot = GetBot();
    print(npcBot:GetActiveMode(), BOT_ACTION_DESIRE_VERYLOW, npcBot:GetActiveModeDesire());
    for i = 0,5 do
        local item = npcBot:GetItemInSlot(i);

        ItemsHelper.blinkToEnemy(npcBot, item, 4, 10);
        ItemsHelper.blackKingBar(npcBot, item);
        ItemsHelper.euls(npcBot, item);

    end

    return
end

return ItemUsage
