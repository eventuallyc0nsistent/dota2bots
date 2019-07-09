-- BOT_MODE_NONE,               -- 0
-- BOT_MODE_LANING,             -- 1
-- BOT_MODE_ATTACK,             -- 2
-- BOT_MODE_ROAM,               -- 3
-- BOT_MODE_RETREAT,            -- 4
-- BOT_MODE_SECRET_SHOP,        -- 5
-- BOT_MODE_SIDE_SHOP,          -- 6
-- BOT_MODE_PUSH_TOWER_TOP,     -- 7
-- BOT_MODE_PUSH_TOWER_MID,     -- 8
-- BOT_MODE_PUSH_TOWER_BOT,     -- 9
-- BOT_MODE_DEFEND_TOWER_TOP,   -- 10
-- BOT_MODE_DEFEND_TOWER_MID,   -- 11
-- BOT_MODE_DEFEND_TOWER_BOT,   -- 12
-- BOT_MODE_ASSEMBLE,           -- 13
-- BOT_MODE_TEAM_ROAM,          -- 14
-- BOT_MODE_FARM,               -- 15
-- BOT_MODE_DEFEND_ALLY,        -- 16
-- BOT_MODE_EVASIVE_MANEUVERS,  -- 17
-- BOT_MODE_ROSHAN,             -- 18
-- BOT_MODE_ITEM,               -- 19
-- BOT_MODE_WARD,               -- 20

local Helper = {};

function Helper.GetSkillMana(npcBot, skill)
    return skill:GetManaCost()/npcBot:GetMaxMana();
end

function Helper.GetMana(npcBot)
    return npcBot:GetMana()/npcBot:GetMaxMana();
end


function Helper.IsSkillActive(skill)
    if skill:GetLevel() > 0 then
        return true;
    end
    return false;
end

function Helper.UseAbilityOnEntity(npcBot, skill, target)
    local skillMana = Helper.GetSkillMana(npcBot, skill);
    local manaLimit = skillMana + 0.1;
    
    if Helper.IsSkillActive(skill) and 
        (Helper.GetMana(npcBot) > manaLimit) then

        npcBot:Action_UseAbilityOnEntity(skill, target);
    end
end

function Helper.IsChannelingAbility(npcBot)
    if npcBot:IsChanneling() or npcBot:IsUsingAbility() or npcBot:IsCastingAbility() then
        return true;
    end
    return false;
end

function Helper.IsLoneLowHealthEnemy(enemyHeroes)
    return #enemyHeroes == 1 and (enemyHeroes[1]:GetHealth()/enemyHeroes[1]:GetMaxHealth()) < 0.5
end

function Helper.IsNotReadyToFight(npcBot)
    return npcBot:GetActiveMode() == BOT_MODE_RETREAT or npcBot:GetActiveMode() == BOT_MODE_EVASIVE_MANEUVERS
end

function Helper.GetNearbyEnemies(npcBot, range)
    return npcBot:GetNearbyHeroes(range, true, BOT_MODE_NONE);
end

function Helper.GetNearbyLaneCreeps(npcBot, range)
    return npcBot:GetNearbyLaneCreeps(range, true);
end

function Helper.log(skill)
    print('-----------------------------------------------------------')
    print(DotaTime(), skill:GetName(), 'CD', skill:GetCooldownTimeRemaining());
    print(DotaTime(), skill:GetName(), 'Status', skill:IsFullyCastable());
end

return Helper