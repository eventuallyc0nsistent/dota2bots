local ItemsHelper = {}

function ItemsHelper.IsSkillOnCooldown(skill)
    skillCdTimeTimeRemaining = false;
    if skill:GetCooldownTimeRemaining() > 0 then
        skillCdTimeTimeRemaining = true;
    end
    
    if skillCdTimeTimeRemaining or not skill:IsFullyCastable() then
        return true;
    end
    return false;
end


function ItemsHelper.heal(npcBot, item)
    if item == nil then
        return
    end
    
    if ItemsHelper.IsSkillOnCooldown(item) then
        return
    end
        
    local itemName = item:GetName();
    local health = npcBot:GetHealth() / npcBot:GetMaxHealth();

    -- less than 80% health
    if (itemName == "item_tango") and health < 0.8 then
        local trees = npcBot:GetNearbyTrees(500);
        if #trees > 1 then
            npcBot:Action_UseAbilityOnTree(item, trees[1]);
        end

    -- flask oon less than 50% health
    elseif (itemName == "item_flask") and health < 0.5 and #enemyHeroes < 1 then
        npcBot:Action_UseAbilityOnEntity(item, npcBot);
    end
end

function ItemsHelper.mana(npcBot, item)
    if item == nil then
        return
    end
    
    if ItemsHelper.IsSkillOnCooldown(item) then
        return
    end

    local itemName = item:GetName()
    local mana = npcBot:GetMana() / npcBot:GetMaxMana();

    if (itemName == "item_clarity") and mana < 0.7 then
        npcBot:Action_UseAbilityOnEntity(item, npcBot);
    end

    if (itemName == "item_arcane_boots") and mana < 0.5 then
        npcBot:Action_UseAbility(call);
    end

end

function ItemsHelper.blinkToEnemy(npcBot, item, blinkEnemyHeroesNum, blinkCreepsNum)
    if item == nil then
        return
    end
    
    if ItemsHelper.IsSkillOnCooldown(item) then
        return
    end


    if (itemName == "item_blink") then
        local blinkRange = 1200;
        local useBlink = nil;
        local location = nil;
        
        local enemyHeroes = Helper.GetNearbyEnemies(npcBot, blinkRange);
        local creeps = Helper.GetNearbyLaneCreeps(npcBot, blinkRange);


        if Helper.IsNotReadyToFight(npcBot) then
            return

        -- always blink if enemy low
        elseif Helper.IsLoneLowHealthEnemy(enemyHeroes) then
            useBlink = true;
            location = enemyHeroes[1]:GetLocation();

        -- only blink when there are so many enemies
        elseif #enemyHeroes > blinkEnemyHeroesNum then
            useBlink = true;
            location = enemyHeroes[1]:GetLocation();

        -- only blink when there are so many creeps
        elseif #creeps > blinkCreepsNum then
            useBlink = true;
            location = creeps[1]:GetLocation();
        end

        if useBlink ~= nil then
            npcBot:Action_UseAbilityOnLocation(item, location);    
        end

    end
end

function ItemsHelper.bladeMail(npcBot, item, bladeMailEnemiesNum)
    if item == nil then
        return
    end
    
    if ItemsHelper.IsSkillOnCooldown(item) then
        return
    end

    if (itemName == "item_blade_mail")  then
        if #enemyHeroes > bladeMailEnemiesNum then
            npcBot:Action_UseAbility(item);
        end
    end
end

return ItemsHelper