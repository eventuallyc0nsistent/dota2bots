local Helper = require(GetScriptDirectory() .. "/helper");
local ItemsHelper = require(GetScriptDirectory() .. "/helper_items");
local AbilityHelper = require(GetScriptDirectory() .. "/helper_abilities");
local AbilityUsage = {}

local Abilities = {
    "shadow_shaman_ether_shock",
    "shadow_shaman_voodoo",
    "shadow_shaman_shackles",
    "shadow_shaman_mass_serpent_ward",
}

function AbilityUsage.Shock(npcBot, skill)
    AbilityHelper.useOnTargetEnemy(npcBot, skill, skill:GetCastRange(), 0, 10);
end

function AbilityUsage.Hex(npcBot, skill)
    AbilityHelper.useOnTargetEnemy(npcBot, skill, skill:GetCastRange(), 0);
end

function AbilityUsage.Shackle(npcBot, skill)
    AbilityHelper.useOnTargetEnemy(npcBot, skill, skill:GetCastRange(), 0);
end


function AbilityUsage.Ult(npcBot, skill)
    if Helper.IsChannelingAbility(npcBot) or 
        ItemsHelper.IsSkillOnCooldown(skill) or 
        not Helper.IsSkillActive(skill) or
        not ItemsHelper.HasMana(npcBot, skill) then
        return
    end

    AbilityHelper.useOnTargetLocation(npcBot, skill, skill:GetCastRange(), 2, 3);
end


function AbilityUsage.Think()
    local npcBot = GetBot();

    local shock = npcBot:GetAbilityByName(Abilities[1]);
    local hex = npcBot:GetAbilityByName(Abilities[2]);
    local shackle = npcBot:GetAbilityByName(Abilities[3]);
    local ult = npcBot:GetAbilityByName(Abilities[4]);

    AbilityUsage.Hex(npcBot, hex);
    AbilityUsage.Shock(npcBot, shock);
    AbilityUsage.Shackle(npcBot, shackle);
    AbilityUsage.Ult(npcBot, ult);

end

return AbilityUsage
