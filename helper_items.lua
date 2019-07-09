local Helper = require(GetScriptDirectory() .. "/helper");
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

function ItemsHelper.HasMana(npcBot, item)
    return npcBot:GetMana() > item:GetManaCost()
end


function ItemsHelper.heal(npcBot, item)
    if item == nil then
        return
    end
        
    local itemName = item:GetName();
    local health = npcBot:GetHealth() / npcBot:GetMaxHealth();
    local enemyHeroes = Helper.GetNearbyEnemies(npcBot, 1000);

    if (itemName == "item_tango") and health < 0.8 then
        local trees = npcBot:GetNearbyTrees(500);
        if #trees > 1 then
            npcBot:Action_UseAbilityOnTree(item, trees[1]);
        end

    elseif (itemName == "item_flask") and health < 0.5 and #enemyHeroes < 1 then
        npcBot:Action_UseAbilityOnEntity(item, npcBot);

    elseif (itemName == "item_magic_wand") and health < 0.5 and item:GetCurrentCharges() > 0 then
        npcBot:Action_UseAbility(item);

    elseif (itemName == "item_urn_of_shadows") then
        if health < 0.7 and item:GetCurrentCharges() > 0 and #enemyHeroes < 1 then
            npcBot:Action_UseAbilityOnEntity(item, npcBot);
        
        -- kill enemy below 30%
        elseif #enemyHeroes >= 1 then
            for key, enemy in pairs(enemyHeroes) do
                local enemyHealth = enemy:GetHealth() / enemy:GetMaxHealth();
                if enemyHealth < 0.3 then
                    npcBot:Action_UseAbilityOnEntity(item, npcBot);
                    return
                end
            end
        end
    end


end

function ItemsHelper.mana(npcBot, item)
    if item == nil or 
        ItemsHelper.IsSkillOnCooldown(item) then
        return
    end

    local itemName = item:GetName()
    local mana = npcBot:GetMana() / npcBot:GetMaxMana();

    if (itemName == "item_clarity") and mana < 0.7 then
        npcBot:Action_UseAbilityOnEntity(item, npcBot);
    end

    if (itemName == "item_arcane_boots") and mana < 0.5 then
        npcBot:Action_UseAbility(item);
    end

end

function ItemsHelper.blinkToEnemy(npcBot, item, blinkEnemyHeroesNum, blinkCreepsNum)
    if item == nil or ItemsHelper.IsSkillOnCooldown(item) or
        not ItemsHelper.HasMana(npcBot, item) then
        return
    end
    
    if (item:GetName() == "item_blink") then
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
    if item == nil or ItemsHelper.IsSkillOnCooldown(item) or
        not ItemsHelper.HasMana(npcBot, item) then
        return
    end

    if (item:GetName() == "item_blade_mail")  then
        local enemyHeroes = Helper.GetNearbyEnemies(npcBot, 300);

        if #enemyHeroes > bladeMailEnemiesNum then
            npcBot:Action_UseAbility(item);
        end
    end
end

function ItemsHelper.blackKingBar(npcBot, item)
    if item == nil or ItemsHelper.IsSkillOnCooldown(item) or
        not ItemsHelper.HasMana(npcBot, item) then
        return
    end
    
    
    if (item:GetName() == "item_black_king_bar") then
        local enemyHeroes = Helper.GetNearbyEnemies(npcBot, 300);

        if #enemyHeroes >= 1 or npcBot:WasRecentlyDamagedByAnyHero(1.0) then
            npcBot:Action_UseAbility(item);
        end
    end
end


function ItemsHelper.forceStaff(npcBot, item)
    if item == nil or ItemsHelper.IsSkillOnCooldown(item) or
        not ItemsHelper.HasMana(npcBot, item) then
        return
    end

    if (item:GetName() == "item_black_king_bar") then
        local enemyHeroes = Helper.GetNearbyEnemies(npcBot, 300);
        local health = npcBot:GetHealth() / npcBot:GetMaxHealth();


        if #enemyHeroes > 2 or health < 0.6 or npcBot:WasRecentlyDamagedByAnyHero(1.0) or npcBot:WasRecentlyDamagedByCreep(1.0) then
            npcBot:Action_UseAbilityOnEntity(item, npcBot);
        end
    end
end


return ItemsHelper