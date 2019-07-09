local Helper = require(GetScriptDirectory() .. "/helper");
local ItemsHelper = require(GetScriptDirectory() .. "/helper_items");

local AbilityUsage = {}
local Abilities = {
  "axe_berserkers_call",
  "axe_battle_hunger",
  "axe_counter_helix",
  "axe_culling_blade",
};


function AbilityUsage.AxeCall(npcBot, call)
    
    -- TODO: call near tower
    if Helper.IsChannelingAbility(npcBot) or ItemsHelper.IsSkillOnCooldown(call) then
        return
    end

    local callRadius = 300;
    local useAbility = nil;

    local enemyHeroes = npcBot:GetNearbyHeroes(callRadius, true, BOT_MODE_NONE);
    local creeps = #npcBot:GetNearbyLaneCreeps(callRadius, true);

    -- chasing lone enemy
    if Helper.IsLoneLowHealthEnemy(enemyHeroes) then
        useAbility = true;

    elseif #enemyHeroes > 1 then
        useAbility = true;
    elseif (#enemyHeroes + creeps) > 3 then
        useAbility = true;
    end

    if useAbility ~= nil then
        local skillMana = Helper.GetSkillMana(npcBot, call);
        local manaLimit = skillMana + 0.1;

        if Helper.IsSkillActive(call) and 
            (Helper.GetMana(npcBot) > manaLimit) then

            npcBot:Action_UseAbility(call);
            return
        end
    end
end


function AbilityUsage.AxeHunger(npcBot, hunger)
    
    if Helper.IsChannelingAbility(npcBot) or ItemsHelper.IsSkillOnCooldown(hunger) then
        return
    end

    local enemyHeroes = npcBot:GetNearbyHeroes(hunger:GetCastRange(), true, BOT_MODE_NONE);
    if #enemyHeroes >= 1 then
        Helper.UseAbilityOnEntity(npcBot, hunger, enemyHeroes[1]);
        return
    end
end

function AbilityUsage.AxeUlt(npcBot, ult)
    
    if Helper.IsChannelingAbility(npcBot) or ItemsHelper.IsSkillOnCooldown(ult) then
        return
    end

    -- ult
    local enemyHeroes = npcBot:GetNearbyHeroes(ult:GetCastRange(), true, BOT_MODE_NONE);
    if #enemyHeroes < 1 then
        return
    end

    local skillLvl = ult:GetLevel();
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
            Helper.UseAbilityOnEntity(npcBot, ult, enemy);
            return
        end
    end
end

function AbilityUsage.Think()
    local npcBot = GetBot();

    local call = npcBot:GetAbilityByName(Abilities[1]);
    local hunger = npcBot:GetAbilityByName(Abilities[2]);
    local helix = npcBot:GetAbilityByName(Abilities[3]);
    local ult = npcBot:GetAbilityByName(Abilities[4]);

    AbilityUsage.AxeUlt(npcBot, ult);
    AbilityUsage.AxeCall(npcBot, call);
    AbilityUsage.AxeHunger(npcBot, hunger);
end

return AbilityUsage