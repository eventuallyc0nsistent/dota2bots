local Helper = require(GetScriptDirectory() .. "/helper");
local ItemsHelper = require(GetScriptDirectory() .. "/helper_items");
local AbilityHelper = require(GetScriptDirectory() .. "/helper_abilities");

local AbilityUsage = {}
local Abilities = {
  "axe_berserkers_call",
  "axe_battle_hunger",
  "axe_counter_helix",
  "axe_culling_blade",
};


function AbilityUsage.AxeCall(npcBot, skill)
    AbilityHelper.useInArea(npcBot, skill, 300, 1, 3);
end


function AbilityUsage.AxeHunger(npcBot, skill)
    AbilityHelper.useOnTargetEnemy(npcBot, skill, skill:GetCastRange(), 1);
end

function AbilityUsage.AxeUlt(npcBot, skill)
    
    if Helper.IsChannelingAbility(npcBot) or 
        ItemsHelper.IsSkillOnCooldown(skill) or
        not Helper.IsSkillActive(skill) or
        not ItemsHelper.HasMana(npcBot, skill) then
        return
    end

    local enemyHeroes = npcBot:GetNearbyHeroes(skill:GetCastRange(), true, BOT_MODE_NONE);
    if #enemyHeroes < 1 then
        return
    end

    local skillLvl = skill:GetLevel();
    local ultReady = nil;
    for key, enemy in pairs(enemyHeroes) do
        if enemy:GetHealth() <= 250 and skillLvl == 1 then
            ultReady = true;
        elseif enemy:GetHealth() <= 325 and skillLvl == 2 then
            ultReady = true;
        elseif enemy:GetHealth() <= 400 and skillLvl == 3 then
            ultReady = true;
        end

        if ultReady ~= nil then
            Helper.UseAbilityOnEntity(npcBot, skill, enemy);
            return
        end
    end
end

function AbilityUsage.Think()
    local npcBot = GetBot();

    local call = npcBot:GetAbilityByName(Abilities[1]);
    local hunger = npcBot:GetAbilityByName(Abilities[2]);
    local ult = npcBot:GetAbilityByName(Abilities[4]);

    AbilityUsage.AxeUlt(npcBot, ult);
    AbilityUsage.AxeCall(npcBot, call);
    AbilityUsage.AxeHunger(npcBot, hunger);
end

return AbilityUsage