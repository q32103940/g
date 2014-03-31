--[[
List = {			--table name
Hero_name = {		--hero name
animation = 99,		--animation 
range = 999,		--distance between me and target
ability = {"",""}	--ability to evade
vector = {"",""}	--mask for ability vector: "non","me", "aoe", "target" , "ONme"
items = {"",""}		--items to evade
vectors = {"",""}	--mask for items vector
itemLat = number 	--sleep for item with latency
spellLat = 			--sleep for spell with latency
latency = "string"	--sleep with latency + distance(me,target)/900, 900 avarge project speed
toface = 1			--if enemy to face
]]

AnimationList = {


-- magnus uti animation
npc_dota_hero_magnataur = {
animation = 21,
range = 400,
ability = {"ember_spirit_sleight_of_fist","slark_dark_pact"},
items = {"item_manta"},
vector = {"specialE","non","non"},
vectors = {"non"},
itemLat = 10},

npc_dota_hero_zuus = {
animation = 11,
range = 50000,
items = {"item_cyclone"},
vectors = {"ONme"},
},

npc_dota_hero_centaur = {
animation = 6,
range = 300,
ability = {"ember_spirit_sleight_of_fist"},
vector = {"specialE"},
spellLat = 150},

npc_dota_hero_mirana = {
animation = 11,
range = 625,
ability = {"ember_spirit_sleight_of_fist"},
vector = {"specialE"},
spellLat = 150},

npc_dota_hero_earthshaker = {
animation = 10,
range = 300,
ability = {"ember_spirit_sleight_of_fist"},
vector = {"specialE"},
spellLat = 250},

npc_dota_hero_bounty_hunter = {
animation = 4,
range = 700,
toface = 1,
ability = {"ember_spirit_sleight_of_fist"},
vector = {"specialE"},
spellLat = "10"},

npc_dota_hero_vengefulspirit = {
animation = 12,
range = 600,
toface = 1,
ability = {"ember_spirit_sleight_of_fist"},
vector = {"specialE"},
spellLat = "10"},

npc_dota_hero_skeleton_king = {
animation = 7,
range = 700,
toface = 1,
ability = {"ember_spirit_sleight_of_fist"},
vector = {"specialE"},
spellLat = "100"},

npc_dota_hero_sand_king = {
animation = 8,
range = 700,
toface = 1,
ability = {"ember_spirit_sleight_of_fist"},
vector = {"specialE"},
spellLat = "50"},

}

InitiativeList = {

npc_dota_hero_batrider = {
spells = "batrider_flaming_lasso",
ability = {"ember_spirit_activate_fire_remnant"},
vector = {"specialE"}
}

}

ModifierList = {

npc_dota_hero_lion = {
modifier = "modifier_lion_finger_of_death",
ability = {"ember_spirit_sleight_of_fist","phoenix_supernova","abaddon_borrowed_time"},
vector = {"specialE","non","non"},
items = {"item_bloodstone","item_black_king_bar","item_manta"},
vectors = {"me","non","non"}},

npc_dota_hero_lina = {
modifier = "modifier_lina_laguna_blade",
ability = {"ember_spirit_sleight_of_fist","phoenix_supernova","abaddon_borrowed_time"},
vector = {"specialE","non","non"},
items = {"item_bloodstone","item_black_king_bar","item_manta"},
vectors = {"me","non","non"}},

}

