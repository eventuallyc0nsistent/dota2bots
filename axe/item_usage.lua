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
        ItemsHelper.bladeMail(npcBot, item, 3);

        if (itemName == "item_force_staff") then

            if ItemsHelper.IsSkillOnCooldown(item) then
                return
            end
            if #enemyHeroes > 1 or health < 0.6 or npcBot:WasRecentlyDamagedByAnyHero(1.0) or npcBot:WasRecentlyDamagedByCreep(1.0) then
                npcBot:Action_UseAbilityOnEntity(item, npcBot);
            end

        elseif (itemName == "item_black_king_bar") then

            if ItemsHelper.IsSkillOnCooldown(item) then
                return
            end
            if #enemyHeroes >= 1 or npcBot:WasRecentlyDamagedByAnyHero(1.0) then
                npcBot:Action_UseAbility(item);
            end
        end

    end

    return
end

return ItemUsage