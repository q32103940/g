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
local speed = {600,650,700,750}
--pudge and wr
local RC = {} local ss = {}
--all
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
-- modifier name, effect name, second effect, aoe-range
{"modifier_invoker_sun_strike", "invoker_sun_strike_team","invoker_sun_strike_ring_b",175},
{"modifier_lina_light_strike_array", "lina_spell_light_strike_array_ring_collapse","lina_spell_light_strike_array_sphere",225},
{"modifier_kunkka_torrent_thinker", "kunkka_spell_torrent_pool","kunkka_spell_torrent_bubbles_b",225},
--{"modifier_leshrac_split_earth_thinker", "leshrac_split_earth_b","leshrac_split_earth_c","radius","leshrac_split_earth"}
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

function Main(tick)

	if not client.connected or client.loading or client.console or not SleepCheck() then return end

	local me = entityList:GetMyHero() if not me then return end

	local cast = entityList:GetEntities({classId=CDOTA_BaseNPC})
	local hero = entityList:GetEntities({type=LuaEntity.TYPE_HERO, illusion = false})
	local team = me.team
	
	for i,v in ipairs(hero) do
		if v.team ~= team then
			local id = v.classId
			if id == CDOTA_Unit_Hero_Mirana then Arrow(cast,team,v.visible,"mirana") end
			if id == CDOTA_Unit_Hero_SpiritBreaker then Charge(cast,team,v.visible,v:GetAbility(1),hero,"spirit_breaker") end
			if id == CDOTA_Unit_Hero_Life_Stealer then Infest(team,hero,"life_stealer") end
			if id == CDOTA_Unit_Hero_Sniper then Snipe(team,hero,"sniper") end
			if id == CDOTA_Unit_Hero_Windrunner or id == CDOTA_Unit_Hero_Pudge then RangeCast(v) end
			if id == CDOTA_Unit_Hero_Rubick then WhatARubick(hero,team,v.visible,v:GetAbility(5),cast) end			
			if id == CDOTA_Unit_Hero_AncientApparition then Ancient(cast,team,hero,"ancient_apparition") end
			if id == CDOTA_Unit_Hero_PhantomAssassin then PhantomKa(v) end
			if id == CDOTA_Unit_Hero_PhantomLancer then PhantomL(team,v.visible) end
			if id == CDOTA_Unit_Hero_Tinker then Tinker(team,v.visible,cast) end
			if id == CDOTA_Unit_Hero_Kunkka then Boat(cast,team) end
		end
	end
	
	DirectBase(cast,team)	
	
	Sleep(125)

end

function GenerateSideMessage(heroName,spellName)
	local test = sideMessage:CreateMessage(200,60)
	test:AddElement(drawMgr:CreateRect(10,10,72,40,0xFFFFFFFF,drawMgr:GetTextureId("NyanUI/heroes_horizontal/"..heroName)))
	test:AddElement(drawMgr:CreateRect(85,16,62,31,0xFFFFFFFF,drawMgr:GetTextureId("NyanUI/other/arrow_usual")))
	test:AddElement(drawMgr:CreateRect(150,11,40,40,0xFFFFFFFF,drawMgr:GetTextureId("NyanUI/spellicons/"..spellName)))
end

function RoshanSideMessage(title,sms)
	local test = sideMessage:CreateMessage(200,60)	
	test:AddElement(drawMgr:CreateRect(5,5,80,50,0xFFFFFFFF,drawMgr:GetTextureId("NyanUI/heroes_horizontal/roshan")))
	test:AddElement(drawMgr:CreateText(90,3,-1,title,drawMgr:CreateFont("defaultFont","Arial",22,500)))
	test:AddElement(drawMgr:CreateText(100,25,-1,""..sms.."",drawMgr:CreateFont("defaultFont","Arial",25,500)))
end

function WhatARubick(hero,team,status,spell,cast)
	if spell then
		local name = spell.name
		local mename = "rubick"
		if name == "mirana_arrow" then
			Rarrow = true
			Arrow(cast,team,status,mename)
		elseif name == "spirit_breaker_charge_of_darkness" then
			Rcharge = true
			Charge(cast,team,status,spell,hero,mename)
		elseif name == "life_stealer_infest" then
			Rinfest = true
			Infest(team,hero,mename)
		elseif name == "sniper_assassinate" then
			Rassist = true
			Snipe(team,hero,mename)
		elseif name == "kunkka_ghostship" then
			Boat(cast,team)
		elseif name == "ancient_apparition_ice_blast" then
			Ancient(cast,team,hero,mename)
		elseif Rcharge and TCharge1.visible then
			TCharge1.visible = false TCharge2.visible = false Rcharge = false
		elseif Rarrow and icon.visible then
			icon.visible = false Rarrow = false
			TArrow = {}
			collectgarbage("collect")
		elseif Rinfest and TInfest.visible then
			TInfest.visible = false Rinfest = false
		elseif Rassist and TAssis.visible then
			TAssis.visible = false Rassist = false
		end
	end
end

function DirectBase(cast,team)
	for i,v in ipairs(cast) do
		if v.team ~= team and #v.modifiers > 0 then
			local modifiers = v.modifiers
			for i,k in ipairs(spells) do
				if modifiers[1].name == k[1] and (not k.handle or k.handle ~= v.handle) then
					k.handle = v.handle
					local entry = { Effect(v, k[2]),Effect(v, k[3]),  Effect( v, "range_display") }
					entry[3]:SetVector(1, Vector( k[4], 0, 0) )
					table.insert(effects, entry)
				end
			end
		end
	end
end

function RangeCast(v)
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

function Arrow(cast,team,status,heroName)
	local arrow = FindArrow(cast,team)
	if arrow then
		icon.visible = not status
		if not start then
			GenerateSideMessage(heroName,"mirana_arrow")
			start = arrow.position
			POTMMinimap = MapToMinimap(start.x,start.y)
			icon.x = POTMMinimap.x-10
			icon.y = POTMMinimap.y-10
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
	elseif start then
		TArrow = {}		
		start,vec,POTMMinimap = nil,nil,nil
		icon.visible = false
		collectgarbage("collect")
	end
end

function Charge(cast,team,status,spell,hero,heroName)
	
	local target = FindByModifierS(hero,"modifier_spirit_breaker_charge_of_darkness_vision",team)
	if target then
		local ISeeBara = not status
		local clock = client.gameTime
		if not ISeeBara then time = clock end
		if spell and spell.level ~= 0 then speeed = speed[spell.level] end
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
			if not time then
				time = clock
			end
			local distance = GetDistance2D(Charged,target)
			local Ddistance = distance - (clock - time)*speeed
			local minimap = MapToMinimap((Charged.position.x - target.position.x) * Ddistance / distance + target.position.x,(Charged.position.y - target.position.y) * Ddistance / distance + target.position.y)
			TCharge2.x = minimap.x-10
			TCharge2.y = minimap.y-10
			TCharge2.textureId = drawMgr:GetTextureId("NyanUI/miniheroes/"..heroName)
			TCharge2.visible = ISeeBara
		end
	elseif TCharge1.visible then
		time = nil
		TCharge1.visible = false
		TCharge2.visible = false
	end
	
end

function Infest(team,hero,heroName)
	local target = FindByModifierI(hero,"modifier_life_stealer_infest_effect",team)
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

function Snipe(team,hero,heroName)
	local target = FindByModifierS(hero,"modifier_sniper_assassinate",team)
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

function Boat(cast,team)
	local ship = FindBoat(cast,team)
	if ship then
		if not start1 then
			start1 = ship.position
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
	elseif start1 then
		TBoat = {}		
		start1,vec1 = nil,nil
		collectgarbage("collect")
	end
end

function Ancient(cast,team,hero,heroName)
	local blast = FindBlast(cast,team)
	if blast then
		if not blastmsg then
			blastmsg = true
			GenerateSideMessage(heroName,"ancient_apparition_ice_blast")
		end		
	elseif blastmsg then
		blastmsg = false
	end
	local cold = FindByModifierS(hero,"modifier_cold_feet",team)
	if cold then
		if not TCold then
			local vpos = Vector(cold.position.x,cold.position.y,cold.position.z)
			TCold = Effect(vpos,"range_display")
			TCold:SetVector(0,vpos)
			TCold:SetVector(1,Vector(740,0,0))
		end
	elseif TCold then
		TCold = nil
		collectgarbage("collect")
	end	
end

function PhantomKa(v)
	if v:DoesHaveModifier("modifier_phantom_assassin_blur_active") then				
		local PKMinimap = MapToMinimap(v.position.x,v.position.y)
		PKIcon.x = PKMinimap.x-10
		PKIcon.y = PKMinimap.y-10
		PKIcon.textureId = drawMgr:GetTextureId("NyanUI/miniheroes/phantom_assassin")
		PKIcon.visible = true
	elseif PKIcon.visible then
		PKIcon.visible = false
	end
end

function PhantomL(team,status)
	local illlus = entityList:FindEntities(function (v) return v.type==LuaEntity.TYPE_HERO and v.illusion and v.team ~= team and v.classId == CDOTA_Unit_Hero_PhantomLancer  and v.unitState == -1031241196 end)[1]
	if not status and illlus then
		if not effPL then
			effPL = Effect(illlus,"phantomlancer_SpiritLance_target_slowparent")				
		end
	elseif effPL then
		effPL = nil
		collectgarbage("collect")
	end 
end

function Tinker(team,status,cast) 
	local march = FindMarch(cast,team)
	if march then			
		TKicon.visible = not status
		if not TKMinimap then
			TKpos = march.position
			TKMinimap = MapToMinimap(march.position.x,march.position.y)
			TKicon.x = TKMinimap.x-10
			TKicon.y = TKMinimap.y-10
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

function FindByModifierS(target,mod,team)
	for i,v in ipairs(target) do
		if v.team == team and v.visible and v.alive and v:DoesHaveModifier(mod) then
			return v
		end
	end
	return nil
end

function FindByModifierI(target,mod,team)
	for i,v in ipairs(target) do
		if v.team ~= team and v.visible and v.alive and v:DoesHaveModifier(mod) then
			return v
		end
	end
	return nil
end

function FindBlast(cast,team)
	for i, v in ipairs(cast) do
		if v.team ~= team and v.dayVision == 550 and (v.unitState == 58753536 or v.unitState == 58753792) then
			return v
		end
	end
	return nil
end

function FindMarch(cast,team)
	for i, v in ipairs(cast) do
		if v.dayVision == 0 and v.unitState == 0 and v.team ~= team then
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

function FindBoat(cast,team)
	for i,v in ipairs(cast) do
		if v.team ~= team and v.dayVision == 400 and v.unitState == 59802112 then
			return v
		end
	end
	return nil
end

function FindArrow(cast,team)
	for i, v in ipairs(cast) do
		if v.team ~= team and v.dayVision == 650 then
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
	speeed = 600 RC = {} ss = {}	
	icon.visible = false
	PKIcon.visible = false
	TInfest.visible = false
	TAssis.visible = false
	TKicon.visible = false
	TCharge1.visible = false
	TCharge2.visible = false
	collectgarbage("collect")
end

script:RegisterEvent(EVENT_TICK,Main)
script:RegisterEvent(EVENT_CLOSE,GameClose)
script:RegisterEvent(EVENT_DOTA,Roshan)
