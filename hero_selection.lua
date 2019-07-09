local MyBots = {
  "npc_dota_hero_axe",
  -- "npc_dota_hero_pudge",
  -- "npc_dota_hero_mirana",
  "npc_dota_hero_earthshaker",
  "npc_dota_hero_shadow_shaman",
  "npc_dota_hero_puck",
  "npc_dota_hero_crystal_maiden",
  -- "npc_dota_hero_lion",
};


----------------------------------------------------------------------------------------------------

function Think()

    local IDs = GetTeamPlayers(GetTeam());
    for i,id in pairs(IDs) do
        if IsPlayerBot(id) then
          SelectHero(id, MyBots[i]);
        end
    end

end

function GetBotNames()
  return {
    'Ramesh',
    'Suresh',
    'Paresh',
    'Ganesh',
    'Mahesh',
    'Roshesh',
    'Rakesh',
    'Jignesh',
    'Mukesh',
    'Vignesh',
  }
end

----------------------------------------------------------------------------------------------------
