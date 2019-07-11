local Helper = require(GetScriptDirectory() .. "/helper");
local ItemsHelper = require(GetScriptDirectory() .. "/helper_items");
local AbilityHelper = require(GetScriptDirectory() .. "/helper_abilities");
local AbilityUsage = {}

local Abilities = {
    "earthshaker_fissure",
    "earthshaker_enchant_totem",
    "earthshaker_aftershock",
    "earthshaker_echo_slam",
}

function AbilityUsage.Fissure(npcBot, skill)
    AbilityHelper.useOnTargetLocation(npcBot, skill, skill:GetCastRange(), 2, 5);
end

function AbilityUsage.Totem(npcBot, skill)
    AbilityHelper.useInArea(npcBot, skill, 300, 1, 3);
end

function AbilityUsage.Ult(npcBot, skill)

    if Helper.IsChannelingAbility(npcBot) or 
        ItemsHelper.IsSkillOnCooldown(skill) or 
        not Helper.IsSkillActive(skill) or
        not ItemsHelper.HasMana(npcBot, skill) then
        return
    end

    local ultRange = 300;
    local enemyHeroes = #npcBot:GetNearbyHeroes(ultRange, true, BOT_MODE_NONE);
    local creeps = #npcBot:GetNearbyLaneCreeps(ultRange, true);

    if enemyHeroes > 2 and creeps > 8 then
        npcBot:Action_UseAbility(skill);
        return
    end

end

function AbilityUsage.Think()
    local npcBot = GetBot();

    local fissure = npcBot:GetAbilityByName(Abilities[1]);
    local totem = npcBot:GetAbilityByName(Abilities[2]);
    local echo_slam = npcBot:GetAbilityByName(Abilities[4]);

    AbilityUsage.Fissure(npcBot, fissure)
    AbilityUsage.Totem(npcBot, totem)
    AbilityUsage.Ult(npcBot, echo_slam)
end

return AbilityUsage
