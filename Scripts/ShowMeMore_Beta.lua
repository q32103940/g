--show sun strike, light strike, torrent, split earth, arrow, charge, infest, assassinate, hook, powershoot and more (later).
require("libs.Utils")	
require("libs.Res")
require("libs.SideMessage")
--size
local XX = client.screenSize.x/1280
local YY = client.screenSize.y/1024*125/math.floor(client.screenRatio*100)
--sunstrike, torrent, and other
local effects = {}
--arrow
local TArrow = {}
local icon = drawMgr:CreateRect(0,0,16,16,0x000000ff) icon.visible = false
local MSGArrow = nil
--charge
local TCharge = {}
local speed = {600,650,700,750}
local speeed = 600
local aa = {}
local MSGCharge = {}
--infest
local TInfest = {}
local MSGInfest = {}
--sniper
local TAssis = {}
local MSGAssis = {}
--pudge and wr
local RC = {}
local ss = {}
--all
local check = true
local enemy = {}
local sleep = {0,0,0,0}

spells = {
-- modifier name, effect name, second effect, aoe-range, spell name
{"modifier_invoker_sun_strike", "invoker_sun_strike_team","invoker_sun_strike_ring_b","area_of_effect","invoker_sun_strike" },
{"modifier_lina_light_strike_array", "lina_spell_light_strike_array_ring_collapse","lina_spell_light_strike_array_sphere","light_strike_array_aoe","lina_light_strike_array"},
{"modifier_kunkka_torrent_thinker", "kunkka_spell_torrent_pool","kunkka_spell_torrent_bubbles_b","radius","kunkka_torrent"},
{"modifier_leshrac_split_earth_thinker", "leshrac_split_earth_b","leshrac_split_earth_c","radius","leshrac_split_earth"}
}

RangeCastList = {
--hero with table
npc_dota_hero_pudge = {
Spell = 1,
Start = {1390,1290,1190,1090},
End = {1280,1170,1060,950},
Count = 10,
Range = {70,90,110,130}},
npc_dota_hero_windrunner = {
Spell = 2,
Start = {890,890,890,890},
End = {710,710,710,710},
Count = 15,
Range = {122,122,122,122}}
}

heroes = {
--name, status
{"npc_dota_hero_mirana",mirana},
{"npc_dota_hero_spirit_breaker",bara},
{"npc_dota_hero_life_stealer",naix},
{"npc_dota_hero_sniper",pudge},
{"npc_dota_hero_windrunner",wr},
{"npc_dota_hero_pudge",assis},
}

function Main(tick)

	if not client.connected or client.loading or client.console then return end
	local me = entityList:GetMyHero() if not me then return end

	local cast = entityList:GetEntities({classId=CDOTA_BaseNPC})
	local hero = entityList:GetEntities({type=LuaEntity.TYPE_HERO, illusion = false})

	if check then
		if #hero == 10 then
			for i,v in ipairs(hero) do
				if v.team ~= me.team then
					table.insert(enemy,v.name)
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
			end
		end
	end

	if tick > sleep[1] then
		DirectBase(cast,me)
		sleep[1] = tick + 125
	end

	if heroes[1][2] ~= 1 then Arrow(cast,me,hero,tick) end
	if heroes[2][2] ~= 1 then Charge(cast,me,hero) end
	if heroes[3][2] ~= 1 then Infest(me,hero,tick) end
	if heroes[4][2] ~= 1 then Snipe(me,hero,tick) end
	if heroes[5][2] ~= 1 or heroes[6][2] ~= 1 then RangeCast(me,hero,tick) end

end

function GenerateSideMessage(heroName,spellName)
	local myFont = drawMgr:CreateFont("sideMsg","Arial",14,10) 
	local test = sideMessage:CreateMessage(200*XX,60*YY)
	test:AddElement(drawMgr:CreateRect(10*XX,10*YY,72*XX,40*YY,0xFFFFFFFF,drawMgr:GetTextureId("NyanUI/heroes_horizontal/"..heroName:gsub("npc_dota_hero_",""))))
	test:AddElement(drawMgr:CreateRect(85*XX,0*YY,62*XX,62*YY,0xFFFFFFFF,drawMgr:GetTextureId("Stuff/statpop_exclaim")))
	test:AddElement(drawMgr:CreateRect(150*XX,10*YY,40*XX,40*YY,0xFFFFFFFF,drawMgr:GetTextureId("NyanUI/spellicons/"..spellName)))
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

function RangeCast(me,hero,tick)
	for i,v in ipairs(hero) do
		if v.team ~= me.team then
			if RangeCastList[v.name] then
				local number = RangeCastList[v.name].Spell
				if number then
					local spell = v:GetAbility(number+0)								
					if spell.cd ~= 0 then					
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
							ss[v.handle] = nil
							for z = 1, count do
								RC[z] = nil
							end
							collectgarbage("collect")
						end
					end
				end
			end
		end
	end
end

function Arrow(cast,me,hero,tick)
	for i,v in ipairs(hero) do
		if v.team ~= me.team then
			if v.name == "npc_dota_hero_mirana" then
				if sleep[2] >= tick then
					icon.visible = not v.visible
				else
					runeMinimap = nil
					icon.visible = false
				end
			end
		end
	end
	for i,v in ipairs(cast) do
		local vision = v.dayVision
		if vision == 650 then
			if not MSGArrow then
				GenerateSideMessage("npc_dota_hero_mirana","mirana_arrow")
				MSGArrow = true
			end
			if not start then
				start = v.position
				return
			end
			if v.visibleToEnemy then
				if not vec then
					vec = v.position
					if GetDistance2D(vec,start) < 75 then
						vec = nil
					end
				end
			end
			if start ~= nil and vec ~= nil and #TArrow == 0 then
				for z = 1,29 do
					local p = FindAB(start,vec,100*z+100)
					TArrow[z] = Effect(p, "candle_flame_medium" )
					TArrow[z]:SetVector(0,p)
				end
			end
			if runeMinimap == nil then
				runeMinimap = MapToMinimap(start.x,start.y)
				icon.x = runeMinimap.x-20/2
				icon.y = runeMinimap.y-20/2
				icon.textureId = drawMgr:GetTextureId("NyanUI/miniheroes/mirana")
				sleep[2] = tick + 3500
			end
		end
	end

	if start ~= nil and vec ~= nil and tick > sleep[2] then
		TArrow = {}
		collectgarbage("collect")
		start,vec,MSGArrow = nil,nil,nil
	end

end

function Charge(cast,me,hero)
	for i,v in ipairs(hero) do
		if v.team ~= me.team then
			if v.name == "npc_dota_hero_spirit_breaker" then
				ISeeBara =  not v.visible
				if not ISeeBara then time = client.gameTime end
				if v:GetAbility(1) and v:GetAbility(1).level ~= 0 then
					speeed = speed[v:GetAbility(1).level]
				end
			end
		else
			local offset = v.healthbarOffset
			if offset == -1 then return end
			if not TCharge[v.handle] then
				TCharge[v.handle] = {}  TCharge[v.handle].main = drawMgr:CreateRect(-10,-60,26,26,0xFF8AB160,drawMgr:GetTextureId("NyanUI/miniheroes/spirit_breaker")) TCharge[v.handle].main.visible = false
				TCharge[v.handle].main.entity = v TCharge[v.handle].main.entityPosition = Vector(0,0,offset)
				TCharge[v.handle].map = drawMgr:CreateRect(0,0,20,20,0xFF8AB160,drawMgr:GetTextureId("NyanUI/miniheroes/spirit_breaker")) TCharge[v.handle].map.visible = false
			end
			if v.visible and v.alive then
				if v:DoesHaveModifier("modifier_spirit_breaker_charge_of_darkness_vision") then
					if not MSGCharge[v.handle] then
						GenerateSideMessage(v.name,"spirit_breaker_charge_of_darkness")
						MSGCharge[v.handle] = true
					end
					TCharge[v.handle].main.visible = true
					TCharge[v.handle].map.visible = ISeeBara
					for _,k in ipairs(cast) do
						if k.dayVision == 0 and k.unitState == 59802112 then
							if not aa[v.handle] then
								aa[v.handle] = true
								time = client.gameTime
							end
							local distance = GetDistance2D(v,k)
							local Ddistance = distance - (client.gameTime - time)*speeed
							local minimap = MapToMinimap((k.position.x - v.position.x) * Ddistance / GetDistance2D(k,v) + v.position.x,(k.position.y - v.position.y) * Ddistance / GetDistance2D(k,v) + v.position.y)
							TCharge[v.handle].map.x = minimap.x-20/2
							TCharge[v.handle].map.y = minimap.y-20/2
						end
					end
				else
					if aa[v.handle] ~= nil then
						aa[v.handle] = nil
					end
					MSGCharge[v.handle] = nil
					TCharge[v.handle].main.visible = false
					TCharge[v.handle].map.visible = false
				end
			else
				if aa[v.handle] ~= nil then
					aa[v.handle] = nil
				end
				MSGCharge[v.handle] = nil
				TCharge[v.handle].main.visible = false
				TCharge[v.handle].map.visible = false
			end
		end
	end
end

function Infest(me,hero,tick)
	if tick > sleep[3] then
		for i,v in ipairs(hero) do
			if v.team ~= me.team then
				local offset = v.healthbarOffset
				if offset == -1 then return end

				if not TInfest[v.handle] then
					TInfest[v.handle] = {}  TInfest[v.handle] = drawMgr:CreateRect(-10,-60,26,26,0xFF8AB160,drawMgr:GetTextureId("NyanUI/miniheroes/life_stealer")) TInfest[v.handle].visible = false
					TInfest[v.handle].entity = v TInfest[v.handle].entityPosition = Vector(0,0,offset)
				end

				if v.visible and v.alive then
					if v:DoesHaveModifier("modifier_life_stealer_infest_effect") then
						if not MSGInfest[v.handle] then
							GenerateSideMessage(v.name,"life_stealer_infest")
							MSGInfest[v.handle] = true
						end
						TInfest[v.handle].visible = true
					else
						TInfest[v.handle].visible = false
						MSGInfest[v.handle] = nil
					end
				else
					TInfest[v.handle].visible = false
				end
			end
		end
		sleep[3] = tick + 250
	end
end

function Snipe(me,hero,tick)
	if tick > sleep[4] then
		for i,v in ipairs(hero) do
			if v.team == me.team then
				local offset = v.healthbarOffset
				if offset == -1 then return end

				if not TAssis[v.handle] then
					TAssis[v.handle] = {}  TAssis[v.handle] = drawMgr:CreateRect(-10,-60,26,26,0xFF8AB160,drawMgr:GetTextureId("NyanUI/miniheroes/sniper")) TAssis[v.handle].visible = false
					TAssis[v.handle].entity = v TAssis[v.handle].entityPosition = Vector(0,0,offset)
				end

				if v.visible and v.alive then
					if v:DoesHaveModifier("modifier_sniper_assassinate") then
						if not MSGAssis[v.handle] then
							GenerateSideMessage(v.name,"sniper_assassinate")
							MSGAssis[v.handle] = true
						end
						TAssis[v.handle].visible = true
					else
						MSGAssis[v.handle] = nil
						TAssis[v.handle].visible = false
					end
				else
					MSGAssis[v.handle] = nil
					TAssis[v.handle].visible = false
				end
			end
		end
		sleep[4] = tick + 250
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

function GameClose()
	effects = {} enemy = {}	TArrow = {}
	TCharge = {} TInfest = {} TAssis = {}
	aa = {}	enemy = {} RC = {} ss = {} MSGAssis = {}
	MSGInfest = {} MSGCharge = {} check = true	
	start,vec,runeMinimap,MSGArrow = nil,nil,nil,nil
	icon.visible = false
	sleep = {0,0,0,0}
	collectgarbage("collect")
end

script:RegisterEvent(EVENT_TICK, Main)
script:RegisterEvent(EVENT_CLOSE, GameClose)
