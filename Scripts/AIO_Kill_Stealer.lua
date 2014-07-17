-- a lot of improve. (performance,calculation,prediction)
require("libs.ScriptConfig")
require("libs.Utils")
require("libs.SideMessage")

config = ScriptConfig.new()
config:SetParameter("Active", "Z", config.TYPE_HOTKEY)
config:SetParameter("Combokey", "H", config.TYPE_HOTKEY)
config:SetParameter("Auto", true)
config:Load()

local toggleKey = config.Active
local ComboKey = config.Combokey
local AutoGlobal = config.Auto
local xx = nil
local yy = nil

if math.floor(client.screenRatio*100) == 177 then
	xx = client.screenSize.x/300
	yy = client.screenSize.y/1.372
elseif math.floor(client.screenRatio*100) == 125 then
	xx = client.screenSize.x/512
	yy = client.screenSize.y/1.341
elseif math.floor(client.screenRatio*100) == 160 then
	xx = client.screenSize.x/512
	yy = client.screenSize.y/1.378
else
	xx = client.screenSize.x/512
	yy = client.screenSize.y/1.378
end

--Stuff
local hero = {} local note = {} local reg = false local combo = false
local activ = true local draw = true local myhero = nil

--Draw function
local shft = client.screenSize.x/1600
local F14 = drawMgr:CreateFont("F14","Calibri",14*shft,500*shft)
local rect = drawMgr:CreateRect(xx-1,yy-1,26,26,0x00000090,true) rect.visible = false
local icon = drawMgr:CreateRect(xx,yy,24,24,0x000000ff) icon.visible = false
local dmgCalc = drawMgr:CreateText(xx*shft, yy-18*shft, 0x00000099,"Dmg",F14) dmgCalc.visible = false

function Load()
	if PlayingGame() then
		local me = entityList:GetMyHero()
		if KillStealer(me) then 
			script:Disable() 
		else
			reg = true
			myhero = me.classId
			script:RegisterEvent(EVENT_TICK,Tick)
			script:RegisterEvent(EVENT_KEY,Key)
			script:UnregisterEvent(Load)
		end
	end
end

function Tick(tick)
	
	if not SleepCheck() then return end	Sleep(200)
	local me = entityList:GetMyHero()	
	if not me then return end
	local ID = me.classId
	if ID ~= myhero then GameClose() end

	dmgCalc.visible = draw
	rect.visible,icon.visible = activ,activ
	
	--Kill(false,linkin block,me,ability,damage,scepter damage,range,target(1-target,2-target.position,3-non target),classId,damage type)
	if ID == CDOTA_Unit_Hero_Abaddon then
		Kill(false,true,me,1,{100, 150, 200, 250},nil,nil,1)
	elseif ID == CDOTA_Unit_Hero_Axe then		
		Kill(false,false,me,4,{250,350,450},{300,450,625},400,1,nil,DAMAGE_HPRM)
	elseif ID == CDOTA_Unit_Hero_Bane then
		Kill(false,true,me,2,{90, 160, 230, 300},nil,nil,1)
	elseif ID == CDOTA_Unit_Hero_BountyHunter then
		Kill(false,true,me,1,{100, 200, 250, 325},nil,700,1)
	elseif ID == CDOTA_Unit_Hero_Broodmother then
		Kill(false,true,me,1,{75, 150, 225, 300},nil,nil,1)
	elseif ID == CDOTA_Unit_Hero_Centaur then
		Kill(false,true,me,2,{175, 250, 325, 400},nil,300,1)
	elseif ID == CDOTA_Unit_Hero_Chen then
		Kill(false,true,me,2,{50, 100, 150, 200},nil,nil,1)
	elseif ID == CDOTA_Unit_Hero_CrystalMaiden then		
		Kill(false,false,me,1,{100, 150, 200, 250},nil,700,2)
	elseif ID == CDOTA_Unit_Hero_DeathProphet then		
		Kill(false,false,me,1,{100, 175, 250, 300},nil,nil,1)
	elseif ID == CDOTA_Unit_Hero_DragonKnight then
		Kill(false,false,me,1,{90, 170, 240, 300},nil,nil,1)
	elseif ID == CDOTA_Unit_Hero_EarthSpirit then
		Kill(false,true,me,1,{125, 125, 125, 125},nil,250,1)
	elseif ID == CDOTA_Unit_Hero_Earthshaker then
		Kill(false,true,me,1,{125, 175, 225, 275},nil,nil,1)
	elseif ID == CDOTA_Unit_Hero_Leshrac then
		Kill(false,true,me,3,{80, 140, 200, 260},nil,nil,1)
	elseif ID == CDOTA_Unit_Hero_Lich then		
		Kill(false,true,me,1,{115, 200, 275, 350},nil,nil,1)
	elseif ID == CDOTA_Unit_Hero_Lion then
		Kill(false,true,me,4,{600, 725, 850},{725, 875, 1025},nil,1)
	elseif ID == CDOTA_Unit_Hero_Luna then		
		Kill(false,true,me,1,{75, 150, 210, 260},nil,nil,1)	
	elseif ID ==CDOTA_Unit_Hero_NightStalker then
		Kill(false,true,me,1,{90, 160, 225, 335},nil,nil,1)
	elseif ID == CDOTA_Unit_Hero_PhantomLancer then
		Kill(false,true,me,1,{100, 150, 200, 250},nil,nil,1)
	elseif ID == CDOTA_Unit_Hero_Puck then
		Kill(false,false,me,2,{70, 140, 210, 280},nil,400,3)
	elseif ID == CDOTA_Unit_Hero_QueenOfPain then
		Kill(false,false,me,3,{85, 165, 225, 300},nil,475,3)
	elseif ID == CDOTA_Unit_Hero_Rattletrap then
		Kill(false,false,me,3,{80, 120, 160, 200},nil,1000,2)
	elseif ID == CDOTA_Unit_Hero_Rubick then
		Kill(false,true,me,3,{70, 140, 210, 280},nil,nil,1)
	elseif ID == CDOTA_Unit_Hero_SkeletonKing then
		Kill(false,true,me,1,{80, 160, 230, 300},nil,nil,1)
	elseif ID == CDOTA_Unit_Hero_Shredder then
		Kill(false,false,me,1,{100, 150, 200, 250},nil,300,3)
	elseif ID == CDOTA_Unit_Hero_ShadowShaman then
		Kill(false,true,me,1,{140, 200, 260, 320},nil,nil,1)	
	elseif ID == CDOTA_Unit_Hero_Sniper then
		Kill(false,true,me,4,{350, 500, 650},nil,nil,1)
	elseif ID == CDOTA_Unit_Hero_Sven then
		Kill(false,true,me,1,{100, 175, 250, 325},nil,650,1)
	elseif ID == CDOTA_Unit_Hero_Tidehunter then
		Kill(false,true,me,1,{110, 160, 210, 260},nil,750,1)
	elseif ID == CDOTA_Unit_Hero_Tinker then
		if me:GetAbility(1).state == LuaEntityAbility.STATE_READY then
			Kill(false,true,me,1,{80, 160, 240, 320},nil,nil,1)
		elseif me:GetAbility(2).state == LuaEntityAbility.STATE_READY then
			Kill(false,false,me,2,{80, 160, 240, 320},nil,2500,3)
		else	
			Kill(false,true,me,1,{80, 160, 240, 320},nil,nil,1)
		end
	elseif ID == CDOTA_Unit_Hero_VengefulSpirit then
		Kill(false,true,me,1,{100, 175, 250, 325},nil,nil,1)
	elseif ID == CDOTA_Unit_Hero_Lina then
		if not me:AghanimState() then Kill(false,true,me,4,{450,675,950},nil,nil,1) else Kill(false,true,me,4,{600,925,1250},nil,900,1,nil,DAMAGE_UNIV) end	
	elseif ID == CDOTA_Unit_Hero_Alchemist then
		Kill(false,false,me,2,{32,47,63,78},nil,800,1,ID)
	elseif ID == CDOTA_Unit_Hero_Morphling then
		Kill(false,true,me,2,{20, 40, 60, 80},nil,nil,1,ID)
	elseif ID == CDOTA_Unit_Hero_Visage then
		Kill(false,true,me,2,{20,20,20,20},nil,nil,1,ID)
	elseif ID == CDOTA_Unit_Hero_Undying then
		Kill(false,true,me,2,{5,10,15,20},nil,nil,1,ID)
	--complex spells
	--Kill(true,me,ability,damage,scepter damage,range,target,classId,damage type)
	elseif me.classId == CDOTA_Unit_Hero_AntiMage then
		Kill(true,true,me,4,{.6,.85,1.1},nil,nil,1,ID)
	elseif me.classId == CDOTA_Unit_Hero_DoomBringer then
		Kill(true,true,me,3,{1,1,1,1},nil,nil,1,ID)
	--[[elseif me.classId == CDOTA_Unit_Hero_Legion_Commander then
		Kill(true,me,1,{60,100,140,180},nil,nil,2,ID)]]
	elseif me.classId == CDOTA_Unit_Hero_Mirana then
		Kill(true,false,me,1,{75,150,225,300},nil,625,3,ID)
	elseif ID == CDOTA_Unit_Hero_Necrolyte then
		Kill(true,true,me,4,{0.4,0.6,0.9},{0.6,0.9,1.2},nil,1,ID)	
	elseif ID == CDOTA_Unit_Hero_Nyx_Assassin then
		Kill(true,true,me,2,{3.5,4,4.5,5},nil,nil,1,ID)	
	elseif ID == CDOTA_Unit_Hero_Obsidian_Destroyer then
		Kill(true,false,me,4,{8,9,10},{9,10,11},nil,2,ID)	
	elseif ID == CDOTA_Unit_Hero_Elder_Titan then
		Kill(true,false,me,2,{60,100,140,180},nil,nil,2,ID)	
	elseif ID == CDOTA_Unit_Hero_Shadow_Demon then
		Kill(true,false,me,3,{20, 35, 60, 65},nil,nil,4,ID)
	--prediction
	elseif ID == CDOTA_Unit_Hero_Magnataur then
		KillPrediction(me,1,{75, 150, 225, 300},0.3,1050)
	elseif ID == CDOTA_Unit_Hero_Windrunner then
		local PowerTime = me:GetAbility(2).channelTime
		if PowerTime ~= 0 and PowerTime > 0.6 then me:Move(me.position) end
		KillPrediction(me,2,{108, 180, 252, 334},1.2,3000)
	--global
	elseif ID == CDOTA_Unit_Hero_Furion then
		KillGlobal(me,4,{140,180,225},{155,210,275},1)
	elseif ID == CDOTA_Unit_Hero_Zuus then
		KillGlobal(me,4,{225,350,475},{440,540,640},3)
		Kill(false,true,me,true,2,{100,175,275,350},nil,nil,1)
	--other
	--------------------develop--------------------
	elseif ID == CDOTA_Unit_Hero_Invoker then
		SmartSS(me)
	elseif ID == CDOTA_Unit_Hero_Nevermore then
		SmartKoils(me)
	end

end

function Key(msg,code)
	if client.chat or client.console then return end
	if IsKeyDown(toggleKey) then
		activ = not activ
	end
	if IsKeyDown(ComboKey) then
		combo = not combo
	end	
	if IsMouseOnButton(xx,yy,24,24) then
		if msg == LBUTTON_DOWN then
			activ = (not activ)
		end
	end
	if IsMouseOnButton(xx*shft, yy-18*shft,24,24) then
		if msg == LBUTTON_DOWN then
			draw = (not draw)
		end
	end
end

function Kill(comp,lsblock,me,ability,damage,adamage,range,target,id,tdamage)
	local Spell = me:GetAbility(ability)
	icon.textureId = drawMgr:GetTextureId("NyanUI/spellicons/"..Spell.name)
	if Spell.level > 0 then
		local Dmg = SmartGetDmg(comp,Spell.level,me,damage,adamage,id)
		local DmgT = GetDmgType(Spell,tdamage)
		local Range = GetRange(Spell,range)
		local CastPoint = Spell:FindCastPoint() + client.latency/1000		
		if me.alive and not me:IsChanneling() then
			local enemies = entityList:GetEntities({type=LuaEntity.TYPE_HERO,team = 5-me.team})
			for i,v in ipairs(enemies) do
				if v.healthbarOffset ~= -1 and not v:IsIllusion() then
					if not hero[v.handle] then
						hero[v.handle] = drawMgr:CreateText(20,0-45, 0xFFFFFF99, "",F14) hero[v.handle].visible = false hero[v.handle].entity = v hero[v.handle].entityPosition = Vector(0,0,v.healthbarOffset)
					end
					if v.visible and v.alive and v.health > 0 then
						hero[v.handle].visible = draw
						local DmgM = ComplexGetDmg(comp,Spell.level,me,v,Dmg,id)
						local DmgS = math.floor(v:DamageTaken(DmgM,DmgT,me))
						local DmgF = math.floor(v.health - DmgS + CastPoint*v.healthRegen+MorphMustDie(v,CastPoint))
						hero[v.handle].text = " "..DmgF
						if activ then
							if DmgF < 0 and GetDistance2D(me,v) < Range and KSCanDie(v,me,Spell,DmgS) then								
								if target == 1 then
									KSCastSpell(Spell,v,me,lsblock)	break
								elseif target == 2 then
									KSCastSpell(Spell,v.position,me,false) break
								elseif target == 3 then
									KSCastSpell(Spell,nil,me,nil) break
								elseif target == 4 then
									KSCastSpell(me:GetAbility(4),nil,me,nil)																	
								end								
							end
						end
					elseif hero[v.handle].visible then
						hero[v.handle].visible = false
					end
				end
			end
		end
	end
end

function KillGlobal(me,ability,damage,adamage,target)
	local Spell = me:GetAbility(ability)
	icon.textureId = drawMgr:GetTextureId("NyanUI/spellicons/"..Spell.name)
	local count = {}
	if Spell.level > 0 then
		local Dmg = SmartGetDmg(comp,Spell.level,me,damage,adamage)
		local DmgT = GetDmgType(Spell,tdamage)
		local CastPoint = Spell:FindCastPoint() + client.latency/1000
		if me.alive and not me:IsChanneling() then
			local enemies = entityList:GetEntities({type=LuaEntity.TYPE_HERO,team = 5-me.team})
			for i,v in ipairs(enemies) do				
				if v.healthbarOffset ~= -1 and not v:IsIllusion() then
					if not hero[v.handle] then
						hero[v.handle] = drawMgr:CreateText(20,0-45, 0xFFFFFF99, "",F14) hero[v.handle].visible = false hero[v.handle].entity = v hero[v.handle].entityPosition = Vector(0,0,v.healthbarOffset)
					end
					if v.visible and v.alive and v.health > 1 then
						hero[v.handle].visible = Drawning(draw,me)
						local DmgS = math.floor(v:DamageTaken(Dmg,DmgT,me))						
						local DmgF = math.floor(v.health - DmgS + CastPoint*v.healthRegen + MorphMustDie(v,CastPoint))
						hero[v.handle].text = " "..DmgF	
						if DmgF < 0 and KSCanDie(v,me,Spell,DmgS) then
							if not note[v.handle] then
								note[v.handle] = true
								GenerateSideMessage(v.name,Spell.name)
							end
							if activ then
								if v.meepoIllusion == nil then
									table.insert(count,v)
								end
								if AutoGlobal or combo then
									if target == 1 then
										KSCastSpell(Spell,v,me,true)
										combo = false break
									elseif target == 3 then
										KSCastSpell(Spell,nil,me,nil)
										me:SafeCastAbility(Spell)
										combo = false break
									end
								end
							end
						elseif note[v.handle] then
							note[v.handle] = false
						end						
					elseif hero[v.handle].visible then
						hero[v.handle].visible = false
					end
				end
			end
		end
	end
	if #count > 1 then
		if target == 1 then
			KSCastSpell(Spell,count[1],me,true)
		elseif target == 3 then
			KSCastSpell(Spell,nil,me,nil)						
		end
	end
	
end

function KillPrediction(me,ability,damage,cast,project)
	local Spell = me:GetAbility(ability)
	icon.textureId = drawMgr:GetTextureId("NyanUI/spellicons/"..Spell.name)
	if Spell.level > 0 then
		local Dmg = SmartGetDmg(COMPLEX,Spell.level,me,damage,adamage,id)
		local DmgT = GetDmgType(Spell,tdamage)
		local CastPoint = Spell:FindCastPoint() + client.latency/1000
		if me.alive and not me:IsChanneling() then
			local enemies = entityList:GetEntities({type=LuaEntity.TYPE_HERO,team = 5-me.team})
			for i,v in ipairs(enemies) do
				if v.healthbarOffset ~= -1 and not v:IsIllusion() then
					if not hero[v.handle] then
						hero[v.handle] = drawMgr:CreateText(20,0-45, 0xFFFFFF99, "",F14) hero[v.handle].visible = false hero[v.handle].entity = v hero[v.handle].entityPosition = Vector(0,0,v.healthbarOffset)
					end
					if v.visible and v.alive and v.health > 1 then
						hero[v.handle].visible = draw
						local DmgS = math.floor(v:DamageTaken(Dmg,DmgT,me))
						local DmgF = math.floor(v.health - DmgS + CastPoint*v.healthRegen + MorphMustDie(v,CastPoint))
						hero[v.handle].text = " "..DmgF
						if activ then
							if DmgF < 0 and KSCanDie(v,me,Spell,DmgS) then
								local move = v.movespeed local pos = v.position	local distance = GetDistance2D(v,me)
								if v.activity == LuaEntityNPC.ACTIVITY_MOVE and v:CanMove() then																		
									local range = Vector(pos.x + move * (distance/(project * math.sqrt(1 - math.pow(move/project,2))) + cast) * math.cos(v.rotR), pos.y + move * (distance/(project * math.sqrt(1 - math.pow(move/project,2))) + cast) * math.sin(v.rotR), pos.z)
									if GetDistance2D(me,range) < Spell.castRange + 25 then	
										 KSCastSpell(Spell,range,me,nil) break
									end
								elseif distance < Spell.castRange + 25 then
									local range1 = Vector(pos.x + move * 0.05 * math.cos(v.rotR), pos.y + move* 0.05 * math.sin(v.rotR), pos.z)									
									KSCastSpell(Spell,range1,me,nil) break
								end
							end
						end
					elseif hero[v.handle].visible then
						hero[v.handle].visible = false
					end
				end
			end
		end
	end	
end

function SmartGetDmg(complex,lvl,me,tab1,tab2,id)
	local baseDmg = tab1[lvl]
	if complex or not id then		
		if not tab2 then 
			return baseDmg			
		elseif me:AghanimState() then
			return tab2[lvl]
		end
		return baseDmg
	else	
		if id == CDOTA_Unit_Hero_Alchemist then
			local stun = me:FindModifier("modifier_alchemist_unstable_concoction")
			if stun then
				if stun.elapsedTime < 4.6 then 
					return math.floor(stun.elapsedTime*baseDmg)
				end
				return math.floor(4.6*baseDmg)
			end
			return 0
		elseif id == CDOTA_Unit_Hero_Morphling then
			local agi = math.floor(me.agilityTotal)
			local dmg = agi/math.floor(me.strengthTotal)
			if dmg > 1.5 then 
				return math.floor(0.5*lvl*agi+ baseDmg)
			elseif dmg < 0.5 then 
				return math.floor(0.25*agi + baseDmg)
			elseif (dmg >= 0.5 and dmg <= 1.5) then 
				return math.floor(0.25+((dmg-0.5)*(0.5*lvl-0.25))*agi+baseDmg)
			end			
		elseif id == CDOTA_Unit_Hero_Visage then
			local soul = me:FindModifier("modifier_visage_soul_assumption")
			if soul then
				return 20 + 65 * soul.stacks
			end
			return 20
		elseif id == CDOTA_Unit_Hero_Undying then
			local count = entityList:GetEntities(function (v) return (v.courier or v.hero or v.classId == CDOTA_BaseNPC_Creep_Neutral or 
			v.classId == CDOTA_BaseNPC_Creep_Lane or v.classId == CDOTA_Unit_VisageFamiliar or v.classId == CDOTA_Unit_Undying_Zombie or v.classId == 
			CDOTA_Unit_SpiritBear or v.classId == CDOTA_Unit_Broodmother_Spiderling or v.classId == CDOTA_Unit_Hero_Beastmaster_Boar or v.classId ==
			CDOTA_BaseNPC_Creep or v.classId == CDOTA_BaseNPC_Invoker_Forged_Spirit) and v.alive and v.health~=0 and me:GetDistance2D(v) < 1300 end)
			local num = #count-2
			if num < baseDmg then
				return num * 24
			else
				return baseDmg*24
			end
		end
	end
end

function ComplexGetDmg(complex,lvl,me,ent,damage,id)
	local baseDmg = damage
	if not complex then
		return baseDmg
	else
		if id == CDOTA_Unit_Hero_AntiMage then
			return  math.floor((ent.maxMana - ent.mana) * baseDmg)
		elseif id == CDOTA_Unit_Hero_DoomBringer then
			local lvldeath = {{lvlM = 6, dmg = 125}, {lvlM = 5, dmg = 175}, {lvlM = 4, dmg = 225}, {lvlM = 3, dmg = 275}}
			return math.floor((ent.level == 25 or ent.level % lvldeath[lvl].lvlM == 0) and (ent.maxHealth * 0.20 + lvldeath[lvl].dmg) or (lvldeath[lvl].dmg))	
		elseif id == CDOTA_Unit_Hero_Mirana then
			if GetDistance2D(ent,me) < 200 then
				return baseDmg*1.75
			end
			return baseDmg
		elseif id == CDOTA_Unit_Hero_Necrolyte then
			return  math.floor((ent.maxHealth - ent.health) * baseDmg)		
		elseif id == CDOTA_Unit_Hero_Nyx_Assassin then
			local tempBurn =  baseDmg * math.floor(ent.intellectTotal)
			if ent.mana < tempBurn then
				return ent.mana
			end
			return tempBurn
		elseif id == CDOTA_Unit_Hero_Obsidian_Destroyer then
			if me.intellectTotal > ent.intellectTotal then			
				return (math.floor(me.intellectTotal) - math.floor(ent.intellectTotal))*baseDmg
			end
			return 0
		elseif id == CDOTA_Unit_Hero_Elder_Titan then
			local pasDmg = {1.08,1.16,1.25,1.33}
			local pas = me:GetAbility(3).level
			if pas ~= 0 then
				if not ent:FindModifier("modifier_elder_titan_natural_order") then
					return pasDmg[pas]*baseDmg
				end
				return baseDmg
			end
			return baseDmg	
		elseif id == CDOTA_Unit_Hero_Shadow_Demon then	
			local actDmg = {1, 2, 4, 8, 16}
			local poison = ent:FindModifier("modifier_shadow_demon_shadow_poison")
			if poison then
				local Mod = poison.stacks
				if Mod ~= 0 and Mod < 6 then 
					return (actDmg[Mod]) * baseDmg
				elseif Mod > 5 then 
					return (baseDmg*16) + ((Mod-5)*50)					
				end
			end
			return 0
		end
	end
end

function GetRange(skill,range)
	if range then
		return range
	end
	return skill.castRange + 50
end

function GetDmgType(skill,tip)
	if tip then
		return tip
	else	
		local typ = skill.dmgType
		if typ == LuaEntityAbility.DAMAGE_TYPE_MAGICAL then
			return DAMAGE_MAGC	
		elseif typ == LuaEntityAbility.DAMAGE_TYPE_PHYSICAL then
			return DAMAGE_PHYS
		elseif typ == LuaEntityAbility.DAMAGE_TYPE_HPREMOVAL then
			return DAMAGE_HPRM
		elseif typ == LuaEntityAbility.DAMAGE_TYPE_PURE then
			return DAMAGE_PURE
		elseif typ == LuaEntityAbility.DAMAGE_TYPE_COMPOSITE then
			return	DAMAGE_COMP
		else
			return DAMAGE_UNIV
		end
	end
end		

function IsMouseOnButton(x,y,h,w)
	local mx = client.mouseScreenPosition.x
	local my = client.mouseScreenPosition.y
	return mx > x and mx <= x + w and my > y and my <= y + h
end

function GenerateSideMessage(heroName,spellName)
	local test = sideMessage:CreateMessage(200,60)
	test:AddElement(drawMgr:CreateRect(10,10,72,40,0xFFFFFFFF,drawMgr:GetTextureId("NyanUI/heroes_horizontal/"..heroName:gsub("npc_dota_hero_",""))))
	test:AddElement(drawMgr:CreateRect(85,16,62,31,0xFFFFFFFF,drawMgr:GetTextureId("NyanUI/other/arrow_usual")))
	test:AddElement(drawMgr:CreateRect(150,10,40,40,0xFFFFFFFF,drawMgr:GetTextureId("NyanUI/spellicons/"..spellName)))
end

function KSCastSpell(spell,target,me,lsblock)
	if spell and spell:CanBeCasted() and me:CanCast() and not (target and lsblock == true and target.IsLinkensProtected and target:IsLinkensProtected()) then
		local prev = SelectUnit(me)
		if not target then
			entityList:GetMyPlayer():UseAbility(spell)
		else
			entityList:GetMyPlayer():UseAbility(spell,target)
		end
		SelectBack(prev)
	end
end

function KSCanDie(hero,me,skill,dmgs)
	if me.classId == CDOTA_Unit_Hero_Axe then
		if me:IsMagicDmgImmune() then
			return true
		elseif NotDieFromSpell(skill,hero,me) and NotDieFromBM(hero,me,dmgs) then
			return true
		end
	elseif hero:CanDie() then
		if me:IsMagicDmgImmune() then
			return true	
		elseif NotDieFromSpell(skill,hero,me) and not hero:DoesHaveModifier("modifier_nyx_assassin_spiked_carapace") and NotDieFromBM(hero,me,dmgs) then
			return true
		end
	end
	return false
end

function NotDieFromSpell(skill,hero,me)
	if me:DoesHaveModifier("modifier_pugna_nether_ward_aura") then
		if me.health < me:DamageTaken((skill.manacost*1.75), DAMAGE_MAGC, hero) then
			return false
		end		
	end
	return true
end

function NotDieFromBM(hero,me,dmg)
	if hero:DoesHaveModifier("modifier_item_blade_mail_reflect") and me.health < me:DamageTaken(dmg, DAMAGE_PURE, hero) then
		return false
	end
	return true
end

function MorphMustDie(target,value)
	if target.classId == CDOTA_Unit_Hero_Morphling then
		local gain = target:GetAbility(3)
		local hp = {38,76,114,190}
		if gain and gain.level > 0 then
			if target:DoesHaveModifier("modifier_morphling_morph_agi") and target.strength > 1 then
				return value*(0 - hp[gain.level] + 1)
			elseif target:DoesHaveModifier("modifier_morphling_morph_str") and target.agility > 1 then
				return value*hp[gain.level]
			end
		end
	end
	return 0
end

function KillStealer(hero)
	local hId = hero.classId
	if hId == CDOTA_Unit_Hero_AncientApparition or hId == CDOTA_Unit_Hero_Legion_Commander or hId == CDOTA_Unit_Hero_Batrider or hId == CDOTA_Unit_Hero_Beastmaster or hId == CDOTA_Unit_Hero_Brewmaster or hId == CDOTA_Unit_Hero_Bristleback or hId == CDOTA_Unit_Hero_ChaosKnight or hId == CDOTA_Unit_Hero_Clinkz or hId == CDOTA_Unit_Hero_DarkSeer or hId == CDOTA_Unit_Hero_Dazzle or hId == CDOTA_Unit_Hero_Disruptor or hId == CDOTA_Unit_Hero_DrowRanger or hId == CDOTA_Unit_Hero_EmberSpirit or hId == CDOTA_Unit_Hero_Enchantress or hId == CDOTA_Unit_Hero_Enigma or hId == CDOTA_Unit_Hero_FacelessVoid or hId == CDOTA_Unit_Hero_Gyrocopter or hId == CDOTA_Unit_Hero_Huskar or hId == CDOTA_Unit_Hero_Jakiro or hId == CDOTA_Unit_Hero_Juggernaut or hId == CDOTA_Unit_Hero_KeeperOfTheLight or hId == CDOTA_Unit_Hero_Kunkka or hId == CDOTA_Unit_Hero_LoneDruid or hId == CDOTA_Unit_Hero_Lycan or hId == CDOTA_Unit_Hero_Medusa or hId == CDOTA_Unit_Hero_Meepo or hId == CDOTA_Unit_Hero_Meepo or hId == CDOTA_Unit_Hero_Oracle or hId == CDOTA_Unit_Hero_Phoenix or hId == CDOTA_Unit_Hero_Pudge or hId == CDOTA_Unit_Hero_Pugna or hId == CDOTA_Unit_Hero_Razor or hId == CDOTA_Unit_Hero_Riki or hId == CDOTA_Unit_Hero_SandKing or hId == CDOTA_Unit_Hero_Silencer or hId == CDOTA_Unit_Hero_Skywrath_Mage or hId == CDOTA_Unit_Hero_Slardar or hId == CDOTA_Unit_Hero_Slark or hId == CDOTA_Unit_Hero_SpiritBreaker or hId == CDOTA_Unit_Hero_StormSpirit or hId == CDOTA_Unit_Hero_Techies or hId == CDOTA_Unit_Hero_TemplarAssassin or hId == CDOTA_Unit_Hero_Terrorblade or hId == CDOTA_Unit_Hero_Tiny or hId == CDOTA_Unit_Hero_Treant or hId == CDOTA_Unit_Hero_TrollWarlord or hId == CDOTA_Unit_Hero_Tusk or hId == CDOTA_Unit_Hero_Ursa or hId == CDOTA_Unit_Hero_Venomancer or hId == CDOTA_Unit_Hero_Viper or hId == CDOTA_Unit_Hero_Warlock or hId == CDOTA_Unit_Hero_Weaver or hId == CDOTA_Unit_Hero_Wisp or hId == CDOTA_Unit_Hero_WitchDoctor or hId == CDOTA_Unit_Hero_AbyssalUnderlord or hId == CDOTA_Unit_Hero_PhantomAssassin then 
		return true
	end
	return false
end

function SmartSS(me)
	local Spell = me:FindSpell("invoker_sun_strike")
	local Exort = me:GetAbility(3)
	icon.textureId = drawMgr:GetTextureId("NyanUI/spellicons/"..Spell.name)
	if Exort.level > 0 then
		local SSDmg = {100,162,225,287,350,412,475}
		local Dmg = SSDmg[Exort.level]
		local CastPoint = 1.7 + client.latency/1000
		if me.alive and not me:IsChanneling() then
			local enemies = entityList:GetEntities({type=LuaEntity.TYPE_HERO,team = 5-me.team,illusion=false})			
			for i,v in ipairs(enemies) do
				if v.healthbarOffset ~= -1 then
					if not hero[v.handle] then
						hero[v.handle] = drawMgr:CreateText(20,0-45, 0xFFFFFF99, "",F14) hero[v.handle].visible = false hero[v.handle].entity = v hero[v.handle].entityPosition = Vector(0,0,v.healthbarOffset)
					end
					if v.visible and v.alive and v.health > 1 then
						hero[v.handle].visible = draw
						local DmgS = math.floor(v:DamageTaken(Dmg,DAMAGE_PURE,me))
						local DmgF = math.floor(v.health - DmgS + CastPoint*v.healthRegen + MorphMustDie(v,CastPoint))
						hero[v.handle].text = " "..DmgF						
						if DmgF < 0 and KSCanDie(v,me) and (not me:IsMagicDmgImmune() and NotDieFromSpell(Spell,v,me) and not v:DoesHaveModifier("modifier_nyx_assassin_spiked_carapace") and NotDieFromBM(v,me,DmgS)) then
							if not note[v.handle] then
								note[v.handle] = true
								GenerateSideMessage(v.name,Spell.name)
							end
							if activ and IsKeyDown(ComboKey) then
								if v.activity == LuaEntityNPC.ACTIVITY_MOVE and v:CanMove() then
									me:SafeCastAbility(Spell,Vector(v.position.x + v.movespeed * 1.75 * math.cos(v.rotR), v.position.y + v.movespeed* 1.75 * math.sin(v.rotR), v.position.z)) break
								else								
									me:SafeCastAbility(Spell,Vector(v.position.x + v.movespeed * 0.05 * math.cos(v.rotR), v.position.y + v.movespeed* 0.05 * math.sin(v.rotR), v.position.z)) break
								end
							end
						else
							note[v.handle] = nil
						end
					else
						hero[v.handle].visible = false
					end
				end
			end
		end
	end
end

function SmartKoils(me)
	local Spell = me:GetAbility(3)
	local Spell2 = me:GetAbility(2)
	local Spell3 = me:GetAbility(1)
	local Dmg = {75,150,225,300}
	icon.textureId = drawMgr:GetTextureId("NyanUI/spellicons/"..Spell.name)
	if Spell.level > 0 then
		local DmgS = Dmg[Spell.level]
		local DmgS2 = Dmg[Spell.level]*2
		local DmgS3 = Dmg[Spell.level]*3
		if me.alive and not me:IsChanneling() then
			local enemies = entityList:GetEntities({type=LuaEntity.TYPE_HERO,team = me:GetEnemyTeam(),illusion=false})			
			for i,v in ipairs(enemies) do
				if v.healthbarOffset ~= -1 then
					if not hero[v.handle] then
						hero[v.handle] = drawMgr:CreateText(20,0-45, 0xFFFFFF99, "",F14) hero[v.handle].visible = false hero[v.handle].entity = v hero[v.handle].entityPosition = Vector(0,0,v.healthbarOffset)
					end
					if v.visible and v.alive and v.health > 1 then
						hero[v.handle].visible = draw
						local DmgF = math.floor(v.health - SFtarget(v,me) - v:DamageTaken(DmgS,DAMAGE_MAGC,me))
						hero[v.handle].text = " "..DmgF
						if activ then
							if DmgF < 0 and KSCanDie(v,me) and (not me:IsMagicDmgImmune() and NotDieFromSpell(Spell,v,me) and not v:DoesHaveModifier("modifier_nyx_assassin_spiked_carapace") and NotDieFromBM(v,me,DmgS)) then
								local distance = GetDistance2D(me,SFrange(v))
								if distance < 940 and distance > 690 then
									SF(me,v,Spell)
								elseif distance < 690 and distance > 440 then
									SF(me,v,Spell2)
								elseif distance < 440 then		
									SF(me,v,Spell3)
								end
							end
						end
					else
						hero[v.handle].visible = false
					end
				end
			end
		end
	end
end

function SF(me,ent,skill)
	if not stop then
		me:Attack(ent)
		stop = GetTick() + 900 - client.latency
		me:SafeCastAbility(skill)
	end
	if stop < GetTick() then
		me:Stop()
		stop = nil
	end
end

function SFrange(ent)
	if ent.activity == LuaEntityNPC.ACTIVITY_MOVE and ent:CanMove() then
		return Vector(ent.position.x + ent.movespeed * 0.9 * math.cos(ent.rotR), ent.position.y + ent.movespeed* 0.9 * math.sin(ent.rotR), ent.position.z)
	else
		return ent.position
	end
end

function SFtarget(ent,me)
	local project = entityList:GetProjectiles({name = "nevermore_base_attack"})
	for i,v in ipairs(project) do
		if ent.classId == v.target.classId then
			return ent:DamageTaken(me.dmgMin + me.dmgBonus,DAMAGE_PHYS,me)
		end
	end
	return 0 
end

function Drawning(draw,me)
	if me.classId ~= CDOTA_Unit_Hero_Zuus then
		return draw
	end
	return false
end

function GameClose()
	rect.visible = false
	icon.visible = false
	dmgCalc.visible = false
	hero = {}
	myhero = nil
	combo = false
	collectgarbage("collect")
	if reg then
		script:UnregisterEvent(Tick)
		script:UnregisterEvent(Key)
		script:RegisterEvent(EVENT_TICK,Load)
		reg = false
	end
end

script:RegisterEvent(EVENT_CLOSE,GameClose)
script:RegisterEvent(EVENT_TICK,Load)
