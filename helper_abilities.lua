local Helper = require(GetScriptDirectory() .. "/helper");
local ItemsHelper = require(GetScriptDirectory() .. "/helper_items");
local AbilityHelper = {}

function AbilityHelper.useInArea(npcBot, skill, radius, enemyHeroesNum, creepsNum)
    -- TODO: use near tower

    if Helper.IsChannelingAbility(npcBot) or 
        ItemsHelper.IsSkillOnCooldown(skill) or
        not Helper.IsSkillActive(skill) or
        not ItemsHelper.HasMana(npcBot, skill) then
        return
    end

    local useAbility = nil;

    local enemyHeroes = npcBot:GetNearbyHeroes(radius, true, BOT_MODE_NONE);
    local creeps = #npcBot:GetNearbyLaneCreeps(radius, true);

    -- chasing lone enemy
    if Helper.IsLoneLowHealthEnemy(enemyHeroes) then
        useAbility = true;

    elseif #enemyHeroes > enemyHeroesNum then
        useAbility = true;
    elseif (#enemyHeroes + creeps) > (enemyHeroesNum + creepsNum) then
        useAbility = true;
    end

    if useAbility ~= nil then
        local skillMana = Helper.GetSkillMana(npcBot, skill);
        local manaLimit = skillMana + 0.1;

        if Helper.IsSkillActive(skill) and 
            (Helper.GetMana(npcBot) > manaLimit) then

            npcBot:Action_UseAbility(skill);
            return
        end
    end
end

function AbilityHelper.useOnTargetLocation(npcBot, skill, range, enemyHeroesNum, creepsNum)
    if Helper.IsChannelingAbility(npcBot) 
        or ItemsHelper.IsSkillOnCooldown(skill) or
        not Helper.IsSkillActive(skill) or
        not ItemsHelper.HasMana(npcBot, skill) then
        return
    end

    local useAbility = nil;
    local enemyHeroes = npcBot:GetNearbyHeroes(range, true, BOT_MODE_NONE);
    local creeps = npcBot:GetNearbyLaneCreeps(range, true);

    if #enemyHeroes > enemyHeroesNum then
        useAbility = true
        location = enemyHeroes[1]:GetLocation()

    elseif (#creeps + #enemyHeroes) > (enemyHeroesNum + creepsNum) then
        useAbility = true
        if #enemyHeroes > 0 then
            location = enemyHeroes[1]:GetLocation()
        else
            location = creeps[1]:GetLocation()
        end
    end

    if useAbility ~= nil then
        
        local skillMana = Helper.GetSkillMana(npcBot, skill);
        local manaLimit = skillMana + 0.1;

        if Helper.IsSkillActive(skill) and 
        (Helper.GetMana(npcBot) > manaLimit) then
            
            npcBot:Action_UseAbilityOnLocation(skill, location);
            return
        end
    end
end

function AbilityHelper.useOnTargetEnemy(npcBot, skill, range, enemyHeroesNum, creepNum)
    if Helper.IsChannelingAbility(npcBot) 
        or ItemsHelper.IsSkillOnCooldown(skill) or
        not Helper.IsSkillActive(skill) or
        not ItemsHelper.HasMana(npcBot, skill) then
        return
    end

    local sid = npcBot:GetPlayerID();
    local source = GetSelectedHeroName(sid);

    local useAbility = nil;
    local enemyHeroes = npcBot:GetNearbyHeroes(range, true, BOT_MODE_NONE);
    local creeps = npcBot:GetNearbyLaneCreeps(range, true);

    if #enemyHeroes > enemyHeroesNum then
        for key, enemy in pairs(enemyHeroes) do
            if Helper.IsLowHealth(enemy) then
                useAbility = true
                target = enemy
            end
        end
    elseif useAbility == nil and #enemyHeroes > enemyHeroesNum then
        useAbility = true
        target = enemyHeroes[1];
    elseif useAbility == nil and creepsNum ~=nil and #creeps > creepsNum then
        useAbility = true
        target = creeps[1];
    end

    if useAbility ~= nil then
        local skillMana = Helper.GetSkillMana(npcBot, skill);
        local manaLimit = skillMana + 0.1;

        if Helper.GetMana(npcBot) > manaLimit then
            npcBot:Action_UseAbilityOnEntity(skill, target);
        end
    end
    return
end

return AbilityHelper