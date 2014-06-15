--show sun strike, light strike, torrent, split earth, arrow, charge, infest, assassinate, hook, powershoot, Kunkka's ghost ship, ice blast, cold feed and supports stolen spell usage by rubick.
require("libs.Utils")
require("libs.Res")
require("libs.SideMessage")
--sunstrike, torrent, and other
local effects = {}
--arrow
local TArrow = {}
--boat
local TBoat = {}
--charge
local TCharge = {} local speeed = 600
local speed = {600,650,700,750}
--infest
local TInfest = nil
--sniper
local TAssis = nil
--pudge and wr
local RC = {} local ss = {}
--ancient
local blastmsg = nil local TCold = nil
--all
local check = true 
local enemy = {}

spells = {
-- modifier name, effect name, second effect, aoe-range, spell name
{"modifier_invoker_sun_strike", "invoker_sun_strike_team","invoker_sun_strike_ring_b","area_of_effect","invoker_sun_strike" },
{"modifier_lina_light_strike_array", "lina_spell_light_strike_array_ring_collapse","lina_spell_light_strike_array_sphere","light_strike_array_aoe","lina_light_strike_array"},
{"modifier_kunkka_torrent_thinker", "kunkka_spell_torrent_pool","kunkka_spell_torrent_bubbles_b","radius","kunkka_torrent"},
{"modifier_leshrac_split_earth_thinker", "leshrac_split_earth_b","leshrac_split_earth_c","radius","leshrac_split_earth"}
}

RangeCastList = {
--hero with table
npc_dota_hero_pudge =
{
Spell = 1,
Start = {1390,1290,1190,1090},
End = {1280,1170,1060,950},
Count = 10,
Range = {70,90,110,130},
},
npc_dota_hero_windrunner =
{
Spell = 2,
Start = {890,890,890,890},
End = {710,710,710,710},
Count = 15,
Range = {122,122,122,122},
}
}

heroes = {
--name, status
{"npc_dota_hero_mirana",mirana},
{"npc_dota_hero_spirit_breaker",bara},
{"npc_dota_hero_life_stealer",naix},
{"npc_dota_hero_sniper",snipe},
{"npc_dota_hero_windrunner",wr},
{"npc_dota_hero_pudge",pudge},
{"npc_dota_hero_rubick",rubick},
{"npc_dota_hero_kunkka",kunkka},
{"npc_dota_hero_ancient_apparition",aa},
}

function Main(tick)

	if not client.connected or client.loading or client.console or not SleepCheck() then return end
	local me = entityList:GetMyHero() if not me then return end

	local cast = entityList:GetEntities({classId=CDOTA_BaseNPC})
	local hero = entityList:GetEntities({type=LuaEntity.TYPE_HERO, illusion = false})

	if check then
		if #hero == 10 then
			if #enemy == 0 then
				for i,v in ipairs(hero) do
					if v.team ~= me.team then
						table.insert(enemy,v.name)
					end
				end
			end
		end
		if #enemy == 5 then
			for l,k in ipairs(heroes) do
				if enemy[1] ~= k[1] and enemy[2] ~= k[1] and enemy[3] ~= k[1] and enemy[4] ~= k[1] and enemy[5] ~= k[1] then
					k[2] = 1
				else
					k[2] = 0
				end
				if k[2]~= nil then
					check = false
				end
			end
		end
	end

	DirectBase(cast,me)
	Sleep(125)
	if heroes[1][2] ~= 1 then Arrow(cast,me,hero,heroes[1][1]) end
	if heroes[2][2] ~= 1 then Charge(cast,me,hero,heroes[2][1]) end
	if heroes[3][2] ~= 1 then Infest(me,hero,tick,heroes[3][1]) end
	if heroes[4][2] ~= 1 then Snipe(me,hero,tick,heroes[4][1]) end
	if heroes[5][2] ~= 1 or heroes[6][2] ~= 1 then RangeCast(me,hero) end
	if heroes[7][2] ~= 1 then WhatARubick(hero,me,cast,tick) end
	if heroes[8][2] ~= 1 then Boat(cast,me) end
	if heroes[9][2] ~= 1 then Ancient(cast,me,hero,heroes[9][1]) end

end

function GenerateSideMessage(heroName,spellName)
	local test = sideMessage:CreateMessage(200,60)
	test:AddElement(drawMgr:CreateRect(10,10,72,40,0xFFFFFFFF,drawMgr:GetTextureId("NyanUI/heroes_horizontal/"..heroName:gsub("npc_dota_hero_",""))))
	test:AddElement(drawMgr:CreateRect(85,0,62,62,0xFFFFFFFF,drawMgr:GetTextureId("Stuff/statpop_exclaim")))
	test:AddElement(drawMgr:CreateRect(150,10,40,40,0xFFFFFFFF,drawMgr:GetTextureId("NyanUI/spellicons/"..spellName)))
end

function WhatARubick(hero,me,cast,tick)
	for i,v in ipairs(hero) do
		if v.team ~= me.team then
			if v.classId == CDOTA_Unit_Hero_Rubick then
				local stolen = v:GetAbility(5)
				if stolen then
					if stolen.name == "mirana_arrow" then
						Arrow(cast,me,hero,v.name)
					elseif stolen.name == "spirit_breaker_charge_of_darkness" then
						Charge(cast,me,hero,v.name)
					elseif stolen.name == "life_stealer_infest" then
						Infest(me,hero,tick,v.name)
					elseif stolen.name == "sniper_assassinate" then
						Snipe(me,hero,tick,v.name)
					elseif stolen.name == "kunkka_ghostship" then
						Boat(cast,me)
					elseif stolen.name == "ancient_apparition_ice_blast" then
						Ancient(cast,me,hero,v.name)
					end
				end
			end
		end
	end
end

function DirectBase(cast,me)
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
end

function RangeCast(me,hero)
	for i,v in ipairs(hero) do
		if v.team ~= me.team then
			if RangeCastList[v.name] then
				local number = RangeCastList[v.name].Spell
				if number then
					local spell = v:GetAbility(tonumber(number))
					if spell and spell.cd ~= 0 then
						local ind = RangeCastList[v.name].End
						local count = RangeCastList[v.name].Count
						local range = RangeCastList[v.name].Range
						local srart = RangeCastList[v.name].Start
						if math.floor(spell.cd*100) > srart[spell.level] and not ss[v.handle] then
							ss[v.handle] = true
							for z = 1, count do
								local p = Vector(v.position.x + range[spell.level]*z * math.cos(v.rotR), v.position.y + range[spell.level]*z * math.sin(v.rotR), v.position.z+50)
								RC[z] = Effect(p, "fire_torch" )
								RC[z]:SetVector(1,Vector(0,0,0))
								RC[z]:SetVector(0, p )
							end
						elseif (math.floor(spell.cd*100) < ind[spell.level] or v.alive == false) and ss[v.handle] then
							ss = {}
							RC = {}
							collectgarbage("collect")
						end
					end
				end
			end
		end
	end
end

function Arrow(cast,me,hero,heroName)
	if not icon then
		icon = drawMgr:CreateRect(0,0,16,16,0x000000ff) icon.visible = false
	end
	local arrow = FindArrow(cast,me)
	if arrow then
		if not start then
			GenerateSideMessage(heroName,"mirana_arrow")
			start = arrow.position
			runeMinimap = MapToMinimap(start.x,start.y)
			icon.x = runeMinimap.x-20/2
			icon.y = runeMinimap.y-20/2
			icon.textureId = drawMgr:GetTextureId("NyanUI/miniheroes/"..heroName:gsub("npc_dota_hero_",""))
		end
		if arrow.visibleToEnemy and not vec then
			vec = arrow.position
			if GetDistance2D(vec,start) < 75 then
				vec = nil
			end
		end
		if start and vec and #TArrow == 0 then
			for z = 1,29 do
				local p = FindAB(start,vec,100*z+100)
				TArrow[z] = Effect(p, "candle_flame_medium" )
				TArrow[z]:SetVector(0,p)
			end
		end
	elseif vec then
		TArrow = {}
		collectgarbage("collect")
		start,vec = nil,nil
	end
	for i,v in ipairs(hero) do
		if v.team ~= me.team then
			if v.name == heroName then
				if arrow then
					icon.visible = not v.visible
				else
					runeMinimap = nil
					icon.visible = false
				end
			end
		end
	end
end

function Charge(cast,me,hero,heroName)
	if not TCharge[1] then
		TCharge[1] = drawMgr:CreateRect(-10,-60,26,26,0xFF8AB160,drawMgr:GetTextureId("NyanUI/miniheroes/"..heroName:gsub("npc_dota_hero_",""))) TCharge[1].visible = false
		TCharge[2] = drawMgr:CreateRect(0,0,20,20,0xFF8AB160,drawMgr:GetTextureId("NyanUI/miniheroes/"..heroName:gsub("npc_dota_hero_",""))) TCharge[2].visible = false
	end
	for i,v in ipairs(hero) do
		if v.team ~= me.team then
			if v.name == heroName then
				ISeeBara = not v.visible
				if not ISeeBara then time = client.gameTime end
				if v:GetAbility(1) and v:GetAbility(1).level ~= 0 then
					speeed = speed[v:GetAbility(1).level]
				end
			end
		end
	end
	local target = FindByModifierS(hero,"modifier_spirit_breaker_charge_of_darkness_vision",me)
	if target then
		local offset = target.healthbarOffset
		if offset == -1 then return end
		if not TCharge[1].visible then
			GenerateSideMessage(target.name,"spirit_breaker_charge_of_darkness")
			TCharge[1].entity = target
			TCharge[1].entityPosition = Vector(0,0,offset)
			TCharge[1].visible = true
		end
		local Charged = FindCharge(cast)
		if Charged then
			if not aa then aa = true
				time = client.gameTime
			end
			local distance = GetDistance2D(Charged,target)
			local Ddistance = distance - (client.gameTime - time)*speeed
			local minimap = MapToMinimap((Charged.position.x - target.position.x) * Ddistance / GetDistance2D(Charged,target) + target.position.x,(Charged.position.y - target.position.y) * Ddistance / GetDistance2D(Charged,target) + target.position.y)
			TCharge[2].x = minimap.x-20/2
			TCharge[2].y = minimap.y-20/2
			TCharge[2].visible = ISeeBara
		end
	elseif TCharge[1].visible then
		aa = nil
		TCharge[1].visible = false
		TCharge[2].visible = false
	end

end

function Infest(me,hero,tick,heroName)
	if not TInfest then
		TInfest = drawMgr:CreateRect(-10,-60,26,26,0xFF8AB160,drawMgr:GetTextureId("NyanUI/miniheroes/"..heroName:gsub("npc_dota_hero_",""))) TInfest.visible = false
	end
	local target = FindByModifierI(hero,"modifier_life_stealer_infest_effect",me)
	if target then
		local offset = target.healthbarOffset
		if offset == -1 then return end
		if not TInfest.visible then
			GenerateSideMessage(target.name,"life_stealer_infest")
			TInfest.entity = target
			TInfest.entityPosition = Vector(0,0,offset)
			TInfest.visible = true
		end
	elseif TInfest.visible then
		TInfest.visible = false
	end
end

function Snipe(me,hero,tick,heroName)
	if not TAssis then
		TAssis = drawMgr:CreateRect(-10,-60,26,26,0xFF8AB160,drawMgr:GetTextureId("NyanUI/miniheroes/"..heroName:gsub("npc_dota_hero_",""))) TAssis.visible = false
	end
	local target = FindByModifierS(hero,"modifier_sniper_assassinate",me)
	if target then
		local offset = target.healthbarOffset
		if offset == -1 then return end
		if not TAssis.visible then
			GenerateSideMessage(target.name,"sniper_assassinate")
			TAssis.entity = target
			TAssis.entityPosition = Vector(0,0,offset)
			TAssis.visible = true
		end
	elseif TAssis.visible then
		TAssis.visible = false
	end
end

function Boat(cast,me)

	local ship = FindBoat(cast,me)
	if ship then
		if not start1 then
			start1 = ship.position
			return
		end
		if ship.visibleToEnemy and not vec1 then
			vec1 = ship.position
			if GetDistance2D(vec1,start1) < 75 then
				vec1 = nil
			end
		end
		if start1 ~= nil and vec1 ~= nil and not TBoat[1] then
			local p = FindAB(start1,vec1,1950)
			TBoat[1] = Effect(p,"range_display")
			TBoat[1]:SetVector(0,p)
			TBoat[1]:SetVector(1,Vector(425,0,0))
			TBoat[2] = Effect(p,"kunkka_ghostship_marker")
			TBoat[2]:SetVector(0,p)
		end
	elseif vec1 then
		TBoat = {}
		collectgarbage("collect")
		start1,vec1 = nil,nil
	end

end

function Ancient(cast,me,hero,heroName)

	local blast = FindBlast(cast,me)
	if blast then
		if not blastmsg then
			blastmsg = true
			GenerateSideMessage(heroName,"ancient_apparition_ice_blast")
		end
	elseif blastmsg then
		blastmsg = false
	end
	local coldclear = false
	local cold = FindByModifierS(hero,"modifier_cold_feet",me)
	if cold then
		if not TCold then
			local vpos = Vector(cold.position.x,cold.position.y,cold.position.z)
			TCold = Effect(vpos,"range_display")
			TCold:SetVector(0,vpos)
			TCold:SetVector(1,Vector(740,0,0))
		end
	elseif TCold ~= nil then
		TCold = nil
		coldclear = true
	end
	if coldclear then
		collectgarbage("collect")
	end

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

function FindAB(first, second, distance)
	local xAngle = math.deg(math.atan(math.abs(second.x - first.x)/math.abs(second.y - first.y)))
	local retValue = nil
	local retVector = Vector()
	if first.x <= second.x and first.y >= second.y then
			retValue = 270 + xAngle
	elseif first.x >= second.x and first.y >= second.y then
			retValue = (90-xAngle) + 180
	elseif first.x >= second.x and first.y <= second.y then
			retValue = 90+xAngle
	elseif first.x <= second.x and first.y <= second.y then
			retValue = 90 - xAngle
	end
	retVector = Vector(first.x + math.cos(math.rad(retValue))*distance,first.y + math.sin(math.rad(retValue))*distance,0)
	client:GetGroundPosition(retVector)
	retVector.z = retVector.z+100
	return retVector
end

function FindByModifierS(target,mod,me)
	for i,v in ipairs(target) do
		if v.team == me.team and v.visible and v.alive and v:DoesHaveModifier(mod) then
			return v
		end
	end
	return nil
end

function FindByModifierI(target,mod,me)
	for i,v in ipairs(target) do
		if v.team ~= me.team and v.visible and v.alive and v:DoesHaveModifier(mod) then
			return v
		end
	end
	return nil
end

function FindBlast(cast,me)
	for i, v in ipairs(cast) do
		if v.team ~= me.team and v.dayVision == 550 and v.unitState == 58753536 or v.unitState == 58753792 then
			return v
		end
	end
	return nil
end

function FindCharge(cast)
	for i, v in ipairs(cast) do
		if v.dayVision == 0 and v.unitState == 59802112 then
			return v
		end
	end
	return nil
end

function FindBoat(cast,me)
	for i,v in ipairs(cast) do
		if v.team ~= me.team and v.dayVision == 400 and v.unitState == 59802112 then
			return v
		end
	end
	return nil
end

function FindArrow(cast,me)
	for i, v in ipairs(cast) do
		if v.team ~= me.team and v.dayVision == 650 then
			return v
		end
	end
	return nil
end

function GameClose()
	script:Reload()
end

script:RegisterEvent(EVENT_TICK, Main)
script:RegisterEvent(EVENT_CLOSE, GameClose)
