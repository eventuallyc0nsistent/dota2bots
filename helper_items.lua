----------------------------------------------------------------------------------------------------

_G._savedEnv = getfenv()
module( "helper_items", package.seeall )

----------------------------------------------------------------------------------------------------

local Helper = require(GetScriptDirectory() .. "/helper");
local ItemsHelper = {}
npcHeroes = {}

local Items = {
    "item_tango",                   -- 1
    "item_flask",                   -- 2
    "item_magic_wand",              -- 3
    "item_urn_of_shadows",          -- 4
    "item_clarity",                 -- 5
    "item_arcane_boots",            -- 6
    "item_blink",                   -- 7
    "item_blade_mail",              -- 8
    "item_black_king_bar",          -- 9
    "item_force_staff",             -- 10
    "item_cyclone",                 -- 11
    "item_mekansm",                 -- 12
}

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


function ItemsHelper.teleport(npcBot)
    local i = npcBot:FindItemSlot('item_tpscroll');
    local item = npcBot:GetItemInSlot(i);
    -- getLastLocation of hero
    -- if he hasnt moved in a while then send him to fountain

    if item ~=nil or
        ItemsHelper.IsSkillOnCooldown(item) or
        not ItemsHelper.HasMana(npcBot, item) then
        return
    end


    local location = Helper.GetFountainLoc(npcBot:GetTeam());
    local health = npcBot:GetHealth() / npcBot:GetMaxHealth();
    local enemyHeroes = Helper.GetNearbyEnemies(npcBot, 1000);

    if health < 0.2 and #enemyHeroes < 1 then
        npcBot:Action_UseAbilityOnLocation(item, location);
    end
end

function ItemsHelper.heal(npcBot, item)
    if item == nil then
        return
    end

    local itemName = item:GetName();
    local health = npcBot:GetHealth() / npcBot:GetMaxHealth();
    local enemyHeroes = Helper.GetNearbyEnemies(npcBot, 1000);

    if (itemName == Items[1]) and health < 0.8 and not npcBot:HasModifier('modifier_tango_heal') then
        local trees = npcBot:GetNearbyTrees(500);
        if #trees > 1 then
            npcBot:Action_UseAbilityOnTree(item, trees[1]);
        end

    elseif (itemName == Items[2]) and health < 0.5 and #enemyHeroes < 1 and not npcBot:HasModifier('modifier_flask_healing') then
        npcBot:Action_UseAbilityOnEntity(item, npcBot);

    elseif (itemName == Items[3]) and health < 0.5 and item:GetCurrentCharges() > 0 then
        npcBot:Action_UseAbility(item);

    elseif (itemName == Items[12]) and health < 0.25 then
        npcBot:Action_UseAbility(item);
    
    elseif (itemName == Items[4]) then
        if item:GetCurrentCharges() == 0 then
            return
        end

        if health < 0.6 and #enemyHeroes < 1 then
            npcBot:Action_UseAbilityOnEntity(item, npcBot);
        

        elseif #enemyHeroes >= 1 then
            for key, enemy in pairs(enemyHeroes) do
                if Helper.IsLowHealth(enemy) then
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

    if (itemName == Items[5]) and mana < 0.7 and not npcBot:HasModifier('modifier_clarity_potion')  then
        npcBot:Action_UseAbilityOnEntity(item, npcBot);
    
    elseif (itemName == Items[6]) and mana < 0.5 then
        npcBot:Action_UseAbility(item);

    elseif (itemName == Items[3]) and mana < 0.5 and item:GetCurrentCharges() > 0 then
        npcBot:Action_UseAbility(item);
    end

end

function ItemsHelper.blinkToEnemy(npcBot, item, blinkEnemyHeroesNum, blinkCreepsNum)
    if item == nil or ItemsHelper.IsSkillOnCooldown(item) or
        not ItemsHelper.HasMana(npcBot, item) then
        return
    end
    
    if (item:GetName() == Items[7]) then
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

        elseif (#enemyHeroes + #creeps) > (blinkEnemyHeroesNum + blinkCreepsNum) then
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

    if (item:GetName() == Items[8])  then
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
    
    
    if (item:GetName() == Items[9]) then
        local enemyHeroes = Helper.GetNearbyEnemies(npcBot, 300);

        if #enemyHeroes >= 1 and npcBot:WasRecentlyDamagedByAnyHero(1.0) then
            npcBot:Action_UseAbility(item);
        end
    end
end


function ItemsHelper.forceStaff(npcBot, item)
    if item == nil or ItemsHelper.IsSkillOnCooldown(item) or
        not ItemsHelper.HasMana(npcBot, item) then
        return
    end

    if (item:GetName() == Items[10]) then
        local enemyHeroes = Helper.GetNearbyEnemies(npcBot, 300);
        local health = npcBot:GetHealth() / npcBot:GetMaxHealth();

        if #enemyHeroes > 2 or health < 0.6 or npcBot:WasRecentlyDamagedByAnyHero(1.0) then
            npcBot:Action_UseAbilityOnEntity(item, npcBot);
        end
    end
end

function ItemsHelper.euls(npcBot, item)
    if item == nil or ItemsHelper.IsSkillOnCooldown(item) or
        not ItemsHelper.HasMana(npcBot, item) then
        return
    end
    
    if (item:GetName() == Items[11]) then
        local enemyHeroes = Helper.GetNearbyEnemies(npcBot, 300);
        local health = npcBot:GetHealth() / npcBot:GetMaxHealth();

        if (#enemyHeroes > 2 and health < 0.6) or npcBot:WasRecentlyDamagedByAnyHero(1.5) then
            npcBot:Action_UseAbilityOnEntity(item, npcBot);
        end
    end

end


for k,v in pairs( helper_items ) do _G._savedEnv[k] = v end

return ItemsHelper