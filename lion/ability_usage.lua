local Helper = require(GetScriptDirectory() .. "/helper");
local ItemsHelper = require(GetScriptDirectory() .. "/helper_items");
local AbilityHelper = require(GetScriptDirectory() .. "/helper_abilities");

local Abilities = {
	"lion_impale",
	"lion_voodoo",
	"lion_mana_drain",
	"lion_finger_of_death",
}
local AbilityUsage = {}

function AbilityUsage.Impale(npcBot, skill)
    AbilityHelper.useOnTargetLocation(npcBot, skill, skill:GetCastRange(), 2, 5);
end


function AbilityUsage.Hex(npcBot, skill)
    AbilityHelper.useOnTargetEnemy(npcBot, skill, skill:GetCastRange(), 0);
end

function AbilityUsage.ManaDrain(npcBot, skill)
    AbilityHelper.useOnTargetEnemy(npcBot, skill, skill:GetCastRange(), 0);
end

function AbilityUsage.Ult(npcBot, skill)
	if Helper.IsChannelingAbility(npcBot) or 
        ItemsHelper.IsSkillOnCooldown(skill) or 
        not Helper.IsSkillActive(skill) or
        not ItemsHelper.HasMana(npcBot, skill) then
        return
    end

    AbilityHelper.useOnTargetEnemy(npcBot, skill, skill:GetCastRange(), 0);
end

function AbilityUsage.Think()
    local npcBot = GetBot();

    local impale = npcBot:GetAbilityByName(Abilities[1]);
    local hex = npcBot:GetAbilityByName(Abilities[2]);
    local manaDrain = npcBot:GetAbilityByName(Abilities[3]);
    local ult = npcBot:GetAbilityByName(Abilities[4]);

    AbilityUsage.Ult(npcBot, ult);
    AbilityUsage.Impale(npcBot, impale);
    AbilityUsage.Hex(npcBot, hex);
    AbilityUsage.ManaDrain(npcBot, manaDrain);

end

return AbilityUsage
