sleeptick = nil
effects = {} -- saved effect list
spells = {
	-- modifier name, effect name, second effect, aoe-range, spell name
	{"modifier_invoker_sun_strike", "invoker_sun_strike_team","invoker_sun_strike_ring_b","area_of_effect","invoker_sun_strike" },
	{"modifier_lina_light_strike_array", "lina_spell_light_strike_array_ring_collapse","lina_spell_light_strike_array_sphere","light_strike_array_aoe","lina_light_strike_array"},
	{"modifier_kunkka_torrent_thinker", "kunkka_spell_torrent_pool","kunkka_spell_torrent_bubbles_b","radius","kunkka_torrent"},
	{"modifier_leshrac_split_earth_thinker", "leshrac_split_earth_b","leshrac_split_earth_c","radius","leshrac_split_earth"}	
}

function Tick( tick )
	if not client.connected or client.loading or client.console or (sleeptick and tick < sleeptick) or not entityList:GetMyHero() then return end		

	local me = entityList:GetMyHero()

	cast = entityList:GetEntities({classId=CDOTA_BaseNPC})
	for i,v in ipairs(cast) do
		if v.team ~= me.team and #v.modifiers > 0 then
			local modifiers = v.modifiers			
			for i,k in ipairs(spells) do
				if modifiers[1].name == k[1] and (not k.handle or k.handle ~= v.handle) then
					k.handle = v.handle
					local Spell = FindSpell(v.owner,k[5])						
					local Range = GetSpecial(Spell,k[4],Spell.level+0)
					local entry = { Effect(v, k[2]),Effect(v, k[3]),  Effect( v, "range_display") }
					entry[3]:SetVector(1, Vector( Range, 0, 0) )
					table.insert(effects, entry)
				end
			end
		end
	end
	sleeptick = tick + 125
end

function GetSpecial(spell,Name,lvl)
	local specials = spell.specials
	for _,v in ipairs(specials) do
		if v.name == Name then
			return v:GetData( math.min(v.dataCount,lvl) )
		end
	end
end

function FindSpell(target,spellName)
	local abilities = target.abilities
	for _,v in ipairs(abilities) do
		if v.name == spellName then
			return v
		end
	end
end

function GameClose()
	effects = {}
	collectgarbage("collect")
end

script:RegisterEvent(EVENT_TICK, Tick)
script:RegisterEvent(EVENT_CLOSE, GameClose)
