--Save as Deadly.lua and place this script to the Ensage\Scripts\Libs folder.
 
-- HeroName = {                             -- Name without "_", and " ".
-- Spell = "Spell_name",                    -- "heroname_spell_name"
-- Dmg = {100, 175, 250, 325},              -- Damage
-- DmgA = {650,925,1250},                   -- Damage with aghanim (can skip)
-- Range = 2500,                            -- some skills return wrong range so better to be entered manually
-- Type = DAMAGE_MAGC,                      -- DAMAGE_PHYS - Physical Damage, DAMAGE_MAGC, DAMAGE_PURE, DAMAGE_COMP - Composite, DAMAGE_HPRM -- HP Removal Damage, DAMAGE_UNIV -- Universal Damage
-- Target = "nontarget"},                   -- "target", "nontarget", "area".
 
list = {
 
npc_dota_hero_tinker = {
 Spell = "tinker_heat_seeking_missile",
 Dmg = {100, 175, 250, 325},
 Type = DAMAGE_MAGC,
 Target = "nontarget"},
 
npc_dota_hero_lich = {
 Spell = "lich_frost_nova",
 Dmg = {50, 100, 150, 200},
 Range = 2500,
 Type = DAMAGE_MAGC,
 Target = "target"},

npc_dota_hero_skeleton_king = {
 Spell = "skeleton_king_hellfire_blast",
 Dmg = {80, 160, 230, 300}, 
 Type = DAMAGE_MAGC,
 Target = "target"},

npc_dota_hero_chen = {
 Spell = "chen_test_of_faith",
 Dmg = {50, 100, 150, 200}, 
 Type = DAMAGE_PURE,
 Target = "target"},

npc_dota_hero_puck = {
 Spell = "puck_waning_rift",
 Dmg = {70, 140, 210, 280}, 
 Range = 400,
 Type = DAMAGE_MAGC,
 Target = "nontarget"},
 
npc_dota_hero_queenofpain = {
 Spell = "queenofpain_scream_of_pain",
 Dmg = {85, 165, 225, 300}, 
 Range = 475,
 Type = DAMAGE_MAGC,
 Target = "nontarget"},

npc_dota_hero_dragon_knight = {
 Spell = "dragon_knight_breathe_fire",
 Dmg = {90, 170, 240, 300}, 
 Type = DAMAGE_MAGC,
 Target = "target"},

npc_dota_hero_death_prophet = {
 Spell = "death_prophet_carrion_swarm",
 Dmg = {100, 175, 250, 300}, 
 Type = DAMAGE_MAGC,
 Target = "target"},

npc_dota_hero_phantom_lancer = {
 Spell = "phantom_lancer_spirit_lance",
 Dmg = {100, 150, 200, 250}, 
 Type = DAMAGE_MAGC,
 Target = "target"},
 
npc_dota_hero_leshrac = {
 Spell = "leshrac_lightning_storm",
 Dmg = {80, 140, 200, 260}, 
 Type = DAMAGE_MAGC,
 Target = "target"},

npc_dota_hero_shadow_shaman = {
 Spell = "shadow_shaman_ether_shock",
 Dmg = {140, 200, 260, 320}, 
 Type = DAMAGE_MAGC,
 Target = "target"},

npc_dota_hero_vengefulspirit = {
 Spell = "vengefulspirit_magic_missile",
 Dmg = {100, 175, 250, 325}, 
 Type = DAMAGE_MAGC,
 Target = "target"},

npc_dota_hero_phantom_assassin = {
 Spell = "phantom_assassin_stifling_dagger",
 Dmg = {30, 50, 70, 90},
 Type = DAMAGE_PURE,
 Target = "target"},

npc_dota_hero_earth_spirit = {
 Spell = "earth_spirit_boulder_smash",
 Dmg = {125, 125, 125, 125},
 Range = 250,
 Type = DAMAGE_MAGC,
 Target = "target"},

npc_dota_hero_sven = {
 Spell = "sven_storm_bolt",
 Dmg = {100, 175, 250, 325},
 Range = 650,
 Type = DAMAGE_MAGC,
 Target = "target"},

npc_dota_hero_tidehunter = {
 Spell = "tidehunter_gush",
 Dmg = {110, 160, 210, 260},
 Range = 750,
 Type = DAMAGE_MAGC,
 Target = "target"},

npc_dota_hero_luna = {
 Spell = "luna_lucent_beam",
 Dmg = {75, 150, 210, 260},
 Type = DAMAGE_MAGC,
 Target = "target"},

npc_dota_hero_night_stalker = {
 Spell = "night_stalker_void",
 Dmg = {90, 160, 225, 335},
 Range = 550,
 Type = DAMAGE_MAGC,
 Target = "target"},

npc_dota_hero_bane = {
 Spell = "bane_brain_sap",
 Dmg = {90, 160, 230, 300},
 Type = DAMAGE_PURE,
 Range = 600,
 Target = "target"},

npc_dota_hero_rubick = {
 Spell = "rubick_fade_bolt",
 Dmg = {70, 140, 210, 280},
 Type = DAMAGE_MAGC,
 Target = "target"},
 
npc_dota_hero_lion = {
 Spell = "lion_finger_of_death",
 Dmg = {600, 725, 850},
 DmgA = {725, 875, 1025},
 Type = DAMAGE_MAGC,
 Target = "target"},
 
npc_dota_hero_crystal_maiden = {
 Spell = "crystal_maiden_crystal_nova",
 Dmg = {100, 150, 200, 250},
 Range = 700,
 Type = DAMAGE_MAGC,
 Target = "area"},
 
npc_dota_hero_axe = {
 Spell = "axe_culling_blade",
 Dmg = {250, 350, 450},
 DmgA = {300, 450, 625},
 Range = 500,
 Type = DAMAGE_HPRM,
 Target = "target"},
 
npc_dota_hero_shredder = {
 Spell = "shredder_whirling_death",
 Dmg = {100, 150, 200, 250},
 Range = 300,
 Type = DAMAGE_MAGC,
 Target = "nontarget"},
 
npc_dota_hero_sniper = {
 Spell = "sniper_assassinate",
 Dmg = {355, 505, 655},
 Type = DAMAGE_MAGC,
 Target = "target"},
 
npc_dota_hero_earthshaker = {
 Spell = "earthshaker_fissure",
 Dmg = {125, 175, 225, 275},
 Range = 1300,
 Type = DAMAGE_MAGC,
 Target = "target"},
 
npc_dota_hero_centaur = {
 Spell = "centaur_double_edge",
 Dmg = {175, 250, 325, 400},
 Range = 300,
 Type = DAMAGE_MAGC,
 Target = "target"},
 
npc_dota_hero_broodmother = {
 Spell = "broodmother_spawn_spiderlings",
 Dmg = {75, 150, 225, 300},
 Type = DAMAGE_MAGC,
 Target = "target"},
 
npc_dota_hero_bounty_hunter = {
 Spell = "bounty_hunter_shuriken_toss",
 Dmg = {100, 200, 250, 325},
 Type = DAMAGE_MAGC,
 Range = 700,
 Target = "target"},
 
npc_dota_hero_lina = {
 Spell = "lina_laguna_blade",
 Dmg = {450,675,950},
 DmgA = {650,925,1250},
 Range = 650,
 Type = DAMAGE_MAGC,
 Target = "target"},
 
npc_dota_hero_abaddon = {
 Spell = "abaddon_death_coil",
 Dmg = {100, 150, 200, 250},
 Type = DAMAGE_MAGC,
 Target = "target"},
 
npc_dota_hero_rattletrap = {
 Spell = "rattletrap_rocket_flare",
 Dmg = {80, 120, 160, 200},
 Range = 1000,
 Type = DAMAGE_MAGC,
 Target = "area"},
 
--hero with specific spell 
 --hero with aoe predict spell
 
--[[AncientApparition = {
 Spell = "ancient_apparition_ice_blast",
 Dmg = {650, 530, 770},
 Range = 50000,
 Time = 1,
 CastTime = 2.3,
 Speed = 1500,
 Type = DAMAGE_MAGC,
 Target = "area"},]]

--[[Pudge = {
 Spell = pudge_hook",
 Dmg = {90, 180, 270, 360},
 Range = 1300,
 Time = 1,
 CastTime = 0.3,
 Speed = 1333.33,
 Type = DAMAGE_PURE,
 Target = "area"},]]
 
npc_dota_hero_furion = {
 Spell = "furion_wrath_of_nature",
 Dmg = {140,180,225},
 DmgA = {155,210,275},
 Range = 30000,
 Type = DAMAGE_MAGC,
 Target = "target"},
 
npc_dota_hero_zuus = {
 Spell = "zuus_thundergods_wrath",
 Dmg = {225,350,475},
 DmgA = {440,540,640},
 Range = 50000,
 Type = DAMAGE_MAGC,
 Target = "nontarget"},
 
npc_dota_hero_shadow_demon = {
 Spell = "shadow_demon_shadow_poison",
 Dmg = {20, 35, 60, 65},
 DmgM = {1, 2, 4, 8, 16}, 
 Type = DAMAGE_MAGC,
 Cast = 1,
 Target = "nontarget"},

npc_dota_hero_magnataur = {
 Spell = "magnataur_shockwave",
 Dmg = {75, 150, 225, 300},
 Range = 1000,
 Time = 1,
 CastTime = 0.3,
 Speed = 1050,
 Type = DAMAGE_MAGC,
 Target = "area"},
 
npc_dota_hero_windrunner = {
 Spell = "windrunner_powershot",
 Dmg = {108, 180, 252, 334},
 Range = 1825,
 Time = 1,
 CastTime = 1.2,
 Speed = 3000,
 Type = DAMAGE_MAGC,
 Target = "area",
 Sleep = 600},
 
--[[Kunkka = {
 Spell = "kunkka_torrent",
 Dmg = {120,180,240,300},
 Range = 1500,
 Type = DAMAGE_MAGC,
 Target = "area"},]]

 --hero with non-standard dmg spell
 
-- hero with modifier spell

npc_dota_hero_visage = {  
 Spell = "visage_soul_assumption",
 Type = DAMAGE_MAGC,
 Cast = 1,
 Dmg = 0,
 Target = "target"},

npc_dota_hero_alchemist = {  
 Spell = "alchemist_unstable_concoction",
 Type = DAMAGE_PHYS,
 Cast = 1,
 Dmg = 0,
 Mod = {32,47,63,78},
 Range = 800,
 Target = "target"},
 
 --
 
npc_dota_hero_invoker = {
 Spell = "invoker_sun_strike",
 Dmg = {100,162,225,287,350,412,475},
 Range = 50000,
 Type = DAMAGE_PURE,
 Cast = 1,
 Target = "area"}, 
 
npc_dota_hero_morphling = {
 Spell = "morphling_adaptive_strike",
 Dmg = {20, 40, 60, 80},
 DmgM = {0.5,1,1.5,2},
 Type = DAMAGE_MAGC,
 Cast = 1,
 Target = "nontarget"},
 
--[[TemplarAssassin = {
 Spell = "templar_assassin_meld",
 Dmg = {50, 100, 150, 200},
 Range = 500,
 Type = DAMAGE_MAGC,
 Target = "target"},]]
 
npc_dota_hero_mirana = {
 Spell = "mirana_starfall",
 Dmg = {75,150,225,300},
 Range = 625,
 Type = DAMAGE_MAGC,
 Cast = 1,
 Target = "nontarget"},

npc_dota_hero_doom_bringer = {
 Spell = "doom_bringer_lvl_death",
 Doom = {{levelMultiplier = 6, dmg = 125}, {levelMultiplier = 5, dmg = 175}, {levelMultiplier = 4, dmg = 225}, {levelMultiplier = 3, dmg = 275}},
 Dmg = 0,
 Type = DAMAGE_MAGC,
 Cast = 1,
 Target = "target"},
 
npc_dota_hero_nyx_assassin = {
 Spell = "nyx_assassin_mana_burn",
 Dmg = {3.5,4,4.5,5},
 Type = DAMAGE_MAGC,
 Cast = 1,
 Target = "target"},
 
npc_dota_hero_elder_titan = {
 Spell = "elder_titan_ancestral_spirit",
 Dmg = {60,100,140,180},
 DmgM = {1.08,1.16,1.25,1.25},
 Type = DAMAGE_MAGC,
 Cast = 1,
 Target = "area"},
 
npc_dota_hero_necrolyte = {
 Spell = "necrolyte_reapers_scythe",
 Dmg = {0.4,0.6,0.9},
 DmgA = {0.6,0.9,1.2},
 Type = DAMAGE_MAGC,
 Cast = 1,
 Target = "target"},
 
npc_dota_hero_antimage = {
 Spell = "antimage_mana_void",
 Dmg = {0.6,0.85,1.1},
 Type = DAMAGE_MAGC,
 Cast = 1,
 Target = "target"},
 
npc_dota_hero_life_stealer = {
 Spell = "life_stealer_infest",
 Dmg = {150,275,400},
 Type = DAMAGE_MAGC,
 Range = 700,
 Target = "target"},
 
npc_dota_hero_obsidian_destroyer = {
 Spell = "obsidian_destroyer_sanity_eclipse",
 Dmg = {8,9,10},
 DmgA = {9,10,11},
 Type = DAMAGE_MAGC,
 Cast = 1,
 Target = "area"},
 
npc_dota_hero_nevermore = {
 Spell = "nevermore_shadowraze1",
 Dmg = {75,150,225,300},
 Range = 1000,
 Cast = 1,
 Type = DAMAGE_MAGC}

}
