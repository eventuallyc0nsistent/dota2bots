local Helper = require(GetScriptDirectory() .. "/helper");
local ItemsHelper = require(GetScriptDirectory() .. "/helper_items");
local AbilityUsage = {}

local Abilities = {
    "earthshaker_fissure",
    "earthshaker_enchant_totem",
    "earthshaker_aftershock",
    "earthshaker_echo_slam",
}

function AbilityUsage.Fissure(npcBot, skill)
    if Helper.IsChannelingAbility(npcBot) or ItemsHelper.IsSkillOnCooldown(skill) then
        return
    end

    local useAbility = nil;
    local enemyHeroes = npcBot:GetNearbyHeroes(skill:GetCastRange(), true, BOT_MODE_NONE);
    local creeps = npcBot:GetNearbyLaneCreeps(skill:GetCastRange(), true);


    if #creeps > 5 then
        useAbility = true
        location = creeps[1]:GetLocation()
    elseif #enemyHeroes > 1 and #creeps == 0 then
        useAbility = true
        location = enemyHeroes[1]:GetLocation()

    elseif (#creeps + #enemyHeroes) > 5 then
        useAbility = true
        location = enemyHeroes[1]:GetLocation()
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

function AbilityUsage.Totem(npcBot, skill)
    if Helper.IsChannelingAbility(npcBot) or ItemsHelper.IsSkillOnCooldown(skill) then
        return
    end

    local useAbility = nil;
    local skillRadius = 300;

    local enemyHeroes = npcBot:GetNearbyHeroes(skillRadius, true, BOT_MODE_NONE);
    local creeps = #npcBot:GetNearbyLaneCreeps(skillRadius, true);
    
    -- chasing lone enemy
    if Helper.IsLoneLowHealthEnemy(enemyHeroes) then
        useAbility = true;

    elseif #enemyHeroes > 1 then
        useAbility = true;
    elseif (#enemyHeroes + creeps) > 3 then
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

function AbilityUsage.Ult(npcBot, skill)
    if Helper.IsChannelingAbility(npcBot) or ItemsHelper.IsSkillOnCooldown(skill) then
        return
    end

    local skillMana = Helper.GetSkillMana(npcBot, skill);
    local manaLimit = skillMana + 0.1;
    print(skill:GetCastRange());
    local enemyHeroes = npcBot:GetNearbyHeroes(skill:GetCastRange(), true, BOT_MODE_NONE);
    local creeps = #npcBot:GetNearbyLaneCreeps(skill:GetCastRange(), true);

    -- chasing lone enemy
    if Helper.IsLoneLowHealthEnemy(enemyHeroes) then
        useAbility = true;
    elseif #enemyHeroes > 3 then
        useAbility = true;
    elseif #\\ > 2 and creeps > 8 then
        useAbility = true;
    end

    if Helper.IsSkillActive(skill) and 
        (Helper.GetMana(npcBot) > manaLimit) then

        npcBot:Action_UseAbility(skill);
        return
    end

end

function AbilityUsage.Think()
    local npcBot = GetBot();

    local fissure = npcBot:GetAbilityByName(Abilities[1]);
    local totem = npcBot:GetAbilityByName(Abilities[2]);
    local aftershock = npcBot:GetAbilityByName(Abilities[3]);
    local echo_slam = npcBot:GetAbilityByName(Abilities[4]);

    AbilityUsage.Fissure(npcBot, fissure)
    AbilityUsage.Totem(npcBot, totem)
    AbilityUsage.Ult(npcBot, echo_slam)
end

return AbilityUsage
