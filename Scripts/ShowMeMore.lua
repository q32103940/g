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
local speeed = 600
local speed = {600,650,700,750} local aa = nil
--pudge and wr
local RC = {} local ss = {}
--all
local check = true 
local enemy = {}
local stage = 1	
--drawMgr
local icon = drawMgr:CreateRect(0,0,18,18,0x000000ff) icon.visible = false
local PKIcon = drawMgr:CreateRect(0,0,18,18,0x000000ff) PKIcon.visible = false
local TInfest = drawMgr:CreateRect(-10,-60,26,26,0xFF8AB160) TInfest.visible = false
local TAssis = drawMgr:CreateRect(-10,-60,26,26,0xFF8AB160) TAssis.visible = false
local TKicon = drawMgr:CreateRect(0,0,18,18,0x000000ff) TKicon.visible = false
local TCharge1 = drawMgr:CreateRect(-10,-60,26,26,0xFF8AB160) TCharge1.visible = false
local TCharge2 = drawMgr:CreateRect(0,0,18,18,0xFF8AB160) TCharge2.visible = false

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
Start = {1374,1274,1174,1074},
End = {1280,1170,1060,950},
Count = 10,
Range = {70,90,110,130},
},
npc_dota_hero_windrunner =
{
Spell = 2,
Start = {874,874,874,874},
End = {710,710,710,710},
Count = 15,
Range = {122,122,122,122},
}
}

heroes = {
--name, status
{CDOTA_Unit_Hero_Mirana,0},
{CDOTA_Unit_Hero_SpiritBreaker,0},
{CDOTA_Unit_Hero_Life_Stealer,0},
{CDOTA_Unit_Hero_Sniper,0},
{CDOTA_Unit_Hero_Windrunner,0},
{CDOTA_Unit_Hero_Pudge,0},
{CDOTA_Unit_Hero_Rubick,0},
{CDOTA_Unit_Hero_Kunkka,0},
{CDOTA_Unit_Hero_AncientApparition,0},
{CDOTA_Unit_Hero_PhantomAssassin,0},
{CDOTA_Unit_Hero_PhantomLancer,0},
{CDOTA_Unit_Hero_Tinker,0},
}

function Main(tick)

	if not client.connected or client.loading or client.console or not SleepCheck() then return end

	local me = entityList:GetMyHero() if not me then return end

	local cast = entityList:GetEntities({classId=CDOTA_BaseNPC})
	local hero = entityList:GetEntities({type=LuaEntity.TYPE_HERO, illusion = false})
	
	if check then
		if #hero > 9 then
			if #enemy == 0 then
				for i,v in ipairs(hero) do
					if v.team ~= me.team then
						table.insert(enemy,v.classId)
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

	DirectBase(cast,me)	Sleep(125)
	if heroes[1][2] ~= 1 then Arrow(cast,me,hero,"mirana") end
	if heroes[2][2] ~= 1 then Charge(cast,me,hero,"spirit_breaker") end
	if heroes[3][2] ~= 1 then Infest(me,hero,tick,"life_stealer") end
	if heroes[4][2] ~= 1 then Snipe(me,hero,tick,"sniper") end
	if heroes[5][2] ~= 1 or heroes[6][2] ~= 1 then print("RangeCast") RangeCast(me,hero) end
	if heroes[7][2] ~= 1 then WhatARubick(hero,me,cast,tick) end
	if heroes[8][2] ~= 1 then Boat(cast,me) end
	if heroes[9][2] ~= 1 then Ancient(cast,me,hero,"ancient_apparition") end
	if heroes[10][2] ~= 1 then PhantomKa(me,hero) end
	if heroes[11][2] ~= 1 then PhantomL(me,hero) end
	if heroes[12][2] ~= 1 then Tinker(me,hero,cast) end

end

function GenerateSideMessage(heroName,spellName)
	local test = sideMessage:CreateMessage(200,60)
	test:AddElement(drawMgr:CreateRect(10,10,72,40,0xFFFFFFFF,drawMgr:GetTextureId("NyanUI/heroes_horizontal/"..heroName)))
	test:AddElement(drawMgr:CreateRect(85,16,62,31,0xFFFFFFFF,drawMgr:GetTextureId("NyanUI/other/arrow_usual")))
	test:AddElement(drawMgr:CreateRect(150,11,40,40,0xFFFFFFFF,drawMgr:GetTextureId("NyanUI/spellicons/"..spellName)))
end

function RoshanSideMessage(title,sms)
	local F25 = drawMgr:CreateFont("defaultFont","Arial",25,500)
	local F20 = drawMgr:CreateFont("defaultFont","Arial",22,500)
	local test = sideMessage:CreateMessage(200,60)	
	test:AddElement(drawMgr:CreateRect(5,5,80,50,0xFFFFFFFF,drawMgr:GetTextureId("NyanUI/heroes_horizontal/roshan")))
	test:AddElement(drawMgr:CreateText(90,3,-1,title,F20) )
	test:AddElement(drawMgr:CreateText(100,25,-1,""..sms.."",F25) )
end

function WhatARubick(hero,me,cast,tick)
	for i,v in ipairs(hero) do
		if v.team ~= me.team then
			if v.classId == CDOTA_Unit_Hero_Rubick then
				local stolen = v:GetAbility(5)
				if stolen then
					local name = stolen.name
					local mename = v.name:gsub("npc_dota_hero_","")
					if name == "mirana_arrow" then
						Arrow(cast,me,hero,mename)
					elseif name == "spirit_breaker_charge_of_darkness" then
						Charge(cast,me,hero,mename)
					elseif name == "life_stealer_infest" then
						Infest(me,hero,tick,mename)
					elseif name == "sniper_assassinate" then
						Snipe(me,hero,tick,mename)
					elseif name == "kunkka_ghostship" then
						Boat(cast,me)
					elseif name == "ancient_apparition_ice_blast" then
						Ancient(cast,me,hero,mename)
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
						if Spell then
						local Range = GetSpecial(Spell,k[4],Spell.level+0)
						local entry = { Effect(v, k[2]),Effect(v, k[3]),  Effect( v, "range_display") }
						entry[3]:SetVector(1, Vector( Range, 0, 0) )
						table.insert(effects, entry)
					end
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
						if math.floor(spell.cd*100) >= srart[spell.level] and not ss[v.handle] then
							ss[v.handle] = true
							for a = 1, count do
								local pss = RCVector(v, range[spell.level]* a)
								RC[a] = Effect(pss, "blueTorch_flame" )
								RC[a]:SetVector(1,Vector(0,0,0))
								RC[a]:SetVector(0, pss)
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
	local arrow = FindArrow(cast,me)
	if arrow then
		if not start then
			GenerateSideMessage(heroName,"mirana_arrow")
			start = arrow.position
			POTMMinimap = MapToMinimap(start.x,start.y)
			icon.x = POTMMinimap.x-20/2
			icon.y = POTMMinimap.y-20/2
			icon.textureId = drawMgr:GetTextureId("NyanUI/miniheroes/"..heroName)
		end
		if arrow.visibleToEnemy and not vec then
			vec = arrow.position
			if GetDistance2D(vec,start) < 50 then
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
			if v.name:gsub("npc_dota_hero_","") == heroName then
				if arrow then
					icon.visible = not v.visible
				else
					POTMMinimap = nil
					icon.visible = false
				end
			end
		end
	end
end

function Charge(cast,me,hero,heroName)
	for i,v in ipairs(hero) do
		if v.team ~= me.team then
			if v.name:gsub("npc_dota_hero_","") == heroName then
				ISeeBara = not v.visible
				local beg = v:GetAbility(1)
				if not ISeeBara then time = client.gameTime end
				if beg and beg.level ~= 0 then
					speeed = speed[beg.level]
				end
			end
		end
	end
	local target = FindByModifierS(hero,"modifier_spirit_breaker_charge_of_darkness_vision",me)
	if target then
		local offset = target.healthbarOffset
		if offset == -1 then return end
		if not TCharge1.visible then
			GenerateSideMessage(target.name:gsub("npc_dota_hero_",""),"spirit_breaker_charge_of_darkness")
			TCharge1.entity = target
			TCharge1.entityPosition = Vector(0,0,offset)
			TCharge1.textureId = drawMgr:GetTextureId("NyanUI/miniheroes/"..heroName)
			TCharge1.visible = true
		end
		local Charged = FindCharge(cast)
		if Charged then
			if not aa then aa = true
				time = client.gameTime
			end
			local Ddistance = GetDistance2D(Charged,target) - (client.gameTime - time)*speeed
			local minimap = MapToMinimap((Charged.position.x - target.position.x) * Ddistance / GetDistance2D(Charged,target) + target.position.x,(Charged.position.y - target.position.y) * Ddistance / GetDistance2D(Charged,target) + target.position.y)
			TCharge2.x = minimap.x-20/2
			TCharge2.y = minimap.y-20/2
			TCharge2.textureId = drawMgr:GetTextureId("NyanUI/miniheroes/"..heroName)
			TCharge2.visible = ISeeBara
		end
	elseif TCharge1.visible then
		aa = nil
		TCharge1.visible = false
		TCharge2.visible = false
	end
end

function Infest(me,hero,tick,heroName)
	local target = FindByModifierI(hero,"modifier_life_stealer_infest_effect",me)
	if target then
		local offset = target.healthbarOffset
		if offset == -1 then return end
		if not TInfest.visible then
			GenerateSideMessage(target.name:gsub("npc_dota_hero_",""),"life_stealer_infest")
			TInfest.entity = target
			TInfest.entityPosition = Vector(0,0,offset)
			TInfest.textureId = drawMgr:GetTextureId("NyanUI/miniheroes/"..heroName)
			TInfest.visible = true			
		end
	elseif TInfest.visible then
		TInfest.visible = false
	end
end

function Snipe(me,hero,tick,heroName)
	local target = FindByModifierS(hero,"modifier_sniper_assassinate",me)
	if target then
		local offset = target.healthbarOffset
		if offset == -1 then return end
		if not TAssis.visible then
			GenerateSideMessage(target.name:gsub("npc_dota_hero_",""),"sniper_assassinate")
			TAssis.entity = target
			TAssis.entityPosition = Vector(0,0,offset)
			TAssis.textureId = drawMgr:GetTextureId("NyanUI/miniheroes/"..heroName)
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
			if GetDistance2D(vec1,start1) < 50 then
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
		collectgarbage("collect")
	end	
end

function PhantomKa(me,hero)
	for i,v in ipairs(hero) do
		if v.classId == CDOTA_Unit_Hero_PhantomAssassin then
			if v:DoesHaveModifier("modifier_phantom_assassin_blur_active") then				
				local PKMinimap = MapToMinimap(v.position.x,v.position.y)
				PKIcon.x = PKMinimap.x-20/2
				PKIcon.y = PKMinimap.y-20/2
				PKIcon.textureId = drawMgr:GetTextureId("NyanUI/miniheroes/phantom_assassin")
				PKIcon.visible = true
			else
				PKIcon.visible = false
			end
		end
	end
end

function PhantomL(me,tab)
	local pl = GetPL(me,tab)
	local illlus = entityList:FindEntities(function (v) return v.type==LuaEntity.TYPE_HERO and v.illusion and v.team ~= me.team and v.classId == CDOTA_Unit_Hero_PhantomLancer  and v.unitState == -1031241196 end)[1]

	if not pl and illlus then
		if not effPL then
			effPL = Effect(illlus,"phantomlancer_SpiritLance_target_slowparent")				
		end
	elseif effPL then
		effPL = nil
		collectgarbage("collect")
	end
 
end

function Tinker(me,tab,cast) 
	local march = FindMarch(cast,me)
	if march then
		for i,v in ipairs(tab) do
			if v.team ~= me.team and v.classId == CDOTA_Unit_Hero_Tinker then				
				TKicon.visible = not v.visible
			end
		end
		if not TKMinimap then
			TKpos = march.position
			TKMinimap = MapToMinimap(march.position.x,march.position.y)
			TKicon.x = TKMinimap.x-20/2
			TKicon.y = TKMinimap.y-20/2
			TKicon.textureId = drawMgr:GetTextureId("NyanUI/miniheroes/tinker")
		elseif TKpos ~= march.position then
			TKMinimap = nil
		end
	elseif TKMinimap then
		TKMinimap = nil
		TKicon.visible = false
	end	
end

function Roha()	
	local rosh = entityList:FindEntities({classId=CDOTA_Unit_Roshan})[1]
	if stage == 1 then
		RoshanSideMessage("Respawn in","8:00-11:00")
		stage = 2
		sleep = math.floor(client.gameTime)		
	elseif sleep + 300 <= math.floor(client.gameTime) and stage == 2 then
		RoshanSideMessage("Respawn in:","3:00-6:00")
		stage = 3
	elseif sleep + 360 <= math.floor(client.gameTime) and stage == 3 then
		RoshanSideMessage("Respawn in:","2:00-5:00")
		stage = 4
	elseif sleep + 420 <= math.floor(client.gameTime) and stage == 4 then	
		RoshanSideMessage("Respawn in:","1:00-4:00")
		stage = 5
	elseif rosh and rosh.alive and stage == 5 then
		stage = 1
		RoshanSideMessage("Respawn","00:00")	
		script:UnregisterEvent(Roha)
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

function RCVector(ent, dis)
	local reVector = Vector()
	reVector = Vector(ent.position.x + dis * math.cos(ent.rotR), ent.position.y + dis * math.sin(ent.rotR), 0)
	client:GetGroundPosition(reVector)
	reVector.z = reVector.z+100
	return reVector
end	

function GetPL(me,tab)
	for i,v in ipairs(tab) do
		if v.team ~= me.team and v.visible then
			if v.classId == CDOTA_Unit_Hero_PhantomLancer then
				return true
			end
		end
	end
	return false
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
		if v.team ~= me.team and v.dayVision == 550 and (v.unitState == 58753536 or v.unitState == 58753792) then
			return v
		end
	end
	return nil
end

function FindMarch(cast,me)
	for i, v in ipairs(cast) do
		if v.dayVision == 0 and v.unitState == 0 and v.team ~= me.team then
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

function Roshan( kill )
    if kill.name == "dota_roshan_kill" then		
		script:RegisterEvent(EVENT_TICK,Roha)		
    end
end

function GameClose()	
	if stage ~= 1 then
		script:UnregisterEvent(Roha)
		stage = 1
	end	
	effects = {} TArrow = {} TBoat = {}
	speeed = 600 aa = nil RC = {} ss = {}
	check = true enemy = {} hero = nil
	icon.visible = false
	PKIcon.visible = false
	TInfest.visible = false
	TAssis.visible = false
	TKicon.visible = false
	TCharge1.visible = false
	TCharge2.visible = false
	for l,k in ipairs(heroes) do		
		k[2] = 0
	end
	collectgarbage("collect")
end

script:RegisterEvent(EVENT_TICK,Main)
script:RegisterEvent(EVENT_CLOSE,GameClose)
script:RegisterEvent(EVENT_DOTA,Roshan)
