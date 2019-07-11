local Helper = require(GetScriptDirectory() .. "/helper");
local ItemsHelper = require(GetScriptDirectory() .. "/helper_items");
local AbilityHelper = require(GetScriptDirectory() .. "/helper_abilities");

local AbilityUsage = {}

local Abilities = {
	"sven_storm_bolt",
	"sven_great_cleave",
	"sven_warcry",
	"sven_gods_strength",
}

function AbilityUsage.Hammer(npcBot, skill)
	AbilityHelper.useOnTargetEnemy(npcBot, skill, skill:GetCastRange(), 1);
end

function AbilityUsage.WarCry(npcBot, skill)
	AbilityHelper.useInArea(npcBot, skill, 300, 1, 3);
end

function AbilityUsage.Ult(npcBot, skill)
    if Helper.IsChannelingAbility(npcBot) or 
        ItemsHelper.IsSkillOnCooldown(skill) or 
        not Helper.IsSkillActive(skill) or
        not ItemsHelper.HasMana(npcBot, skill) then
        return
    end

    AbilityHelper.useInArea(npcBot, skill, 300, 2, 10);
end

function AbilityUsage.Think()
    local npcBot = GetBot();

    local hammer = npcBot:GetAbilityByName(Abilities[1]);
    local warcry = npcBot:GetAbilityByName(Abilities[3]);
    local ult = npcBot:GetAbilityByName(Abilities[4]);

    AbilityUsage.Hammer(npcBot, hammer);
    AbilityUsage.WarCry(npcBot, warcry);
    AbilityUsage.Ult(npcBot, ult);
end

return AbilityUsage
