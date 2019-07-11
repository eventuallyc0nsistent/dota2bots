local MyBots = {
  -- "npc_dota_hero_pudge",
  -- "npc_dota_hero_mirana",
  "npc_dota_hero_earthshaker",
  "npc_dota_hero_axe",
  "npc_dota_hero_shadow_shaman",
  "npc_dota_hero_sven",
  "npc_dota_hero_lion",
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

function UpdateLaneAssignments()
    if ( GetTeam() == TEAM_RADIANT ) then
        return {
            [1] = LANE_BOT,
            [2] = LANE_BOT,
            [3] = LANE_MID,
            [4] = LANE_TOP,
            [5] = LANE_TOP,
        }
    elseif ( GetTeam() == TEAM_DIRE ) then
        return {
            [1] = LANE_TOP,
            [2] = LANE_TOP,
            [3] = LANE_MID,
            [4] = LANE_BOT,
            [5] = LANE_BOT,
        }
    end
end

----------------------------------------------------------------------------------------------------
