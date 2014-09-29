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
local hero = {} local heroG = {} local note = {} local reg = false local combo = false
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
		if me.name and KillStealer(me) then 
			--script:Disable() 
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
		Kill(true,me,1,{100, 150, 200, 250},nil,nil,1)
	elseif ID == CDOTA_Unit_Hero_Axe then	
		KillAxe(me,{250,350,450},{300,450,625})
	elseif ID == CDOTA_Unit_Hero_Bane then
		Kill(true,me,2,{90, 160, 230, 300},nil,nil,1)
		elseif ID == CDOTA_Unit_Hero_Disruptor then
		Kill(true,me,1,{40, 60, 80, 100},nil,800,1)
	elseif ID == CDOTA_Unit_Hero_BountyHunter then
		Kill(true,me,1,{100, 200, 250, 325},nil,700,1)
	elseif ID == CDOTA_Unit_Hero_Broodmother then
		Kill(true,me,1,{75, 150, 225, 300},nil,nil,1)
	elseif ID == CDOTA_Unit_Hero_Centaur then
		Kill(true,me,2,{175, 250, 325, 400},nil,300,1)
	elseif ID == CDOTA_Unit_Hero_Chen then
		Kill(true,me,2,{50, 100, 150, 200},nil,nil,1)
	elseif ID == CDOTA_Unit_Hero_CrystalMaiden then		
		Kill(false,me,1,{100, 150, 200, 250},nil,700,2)
	elseif ID == CDOTA_Unit_Hero_DeathProphet then		
		Kill(false,me,1,{100, 175, 250, 300},nil,nil,1)
	elseif ID == CDOTA_Unit_Hero_DragonKnight then
		Kill(false,me,1,{90, 170, 240, 300},nil,nil,1)
	elseif ID == CDOTA_Unit_Hero_EarthSpirit then
		Kill(true,me,1,{125, 125, 125, 125},nil,250,1)
	elseif ID == CDOTA_Unit_Hero_Earthshaker then
		Kill(false,me,1,{125, 175, 225, 275},nil,nil,2)
	elseif ID == CDOTA_Unit_Hero_Leshrac then
		Kill(true,me,3,{80, 140, 200, 260},nil,nil,1)
	elseif ID == CDOTA_Unit_Hero_Lich then		
		Kill(true,me,1,{115, 200, 275, 350},nil,nil,1)
	elseif ID == CDOTA_Unit_Hero_Lion then
		Kill(true,me,4,{600, 725, 850},{725, 875, 1025},nil,1)
	elseif ID == CDOTA_Unit_Hero_Luna then		
		Kill(true,me,1,{75, 150, 210, 260},nil,nil,1)	
	elseif ID ==CDOTA_Unit_Hero_NightStalker then
		Kill(true,me,1,{90, 160, 225, 335},nil,nil,1)
	elseif ID == CDOTA_Unit_Hero_PhantomLancer then
		Kill(true,me,1,{100, 150, 200, 250},nil,nil,1)
	elseif ID == CDOTA_Unit_Hero_Puck then
		Kill(false,me,2,{70, 140, 210, 280},nil,400,3)
	elseif ID == CDOTA_Unit_Hero_QueenOfPain then
		Kill(false,me,3,{85, 165, 225, 300},nil,475,3)
	elseif ID == CDOTA_Unit_Hero_Rattletrap then
		Kill(false,me,3,{80, 120, 160, 200},nil,1000,2)
	elseif ID == CDOTA_Unit_Hero_Rubick then
		Kill(true,me,3,{70, 140, 210, 280},nil,nil,1)
	elseif ID == CDOTA_Unit_Hero_SkeletonKing then
		Kill(true,me,1,{80, 160, 230, 300},nil,nil,1)
	elseif ID == CDOTA_Unit_Hero_Shredder then
		Kill(false,me,1,{100, 150, 200, 250},nil,300,3)
	elseif ID == CDOTA_Unit_Hero_Spectre then
		Kill(true,me,1,{50, 100, 150, 200},nil,2000,1)
	elseif ID == CDOTA_Unit_Hero_ShadowShaman then
		Kill(true,me,1,{140, 200, 260, 320},nil,nil,1)	
	elseif ID == CDOTA_Unit_Hero_Sniper then
		Kill(true,me,4,{350, 500, 650},nil,nil,1)
	elseif ID == CDOTA_Unit_Hero_Sven then
		Kill(true,me,1,{100, 175, 250, 325},nil,650,1)
	elseif ID == CDOTA_Unit_Hero_Tidehunter then
		Kill(true,me,1,{110, 160, 210, 260},nil,750,1)
	elseif ID == CDOTA_Unit_Hero_Tinker then
		if me:GetAbility(1).state == LuaEntityAbility.STATE_READY then
			Kill(true,me,1,{80, 160, 240, 320},nil,nil,1)
		elseif me:GetAbility(2).state == LuaEntityAbility.STATE_READY then
			Kill(false,me,2,{80, 160, 240, 320},nil,2500,3)
		else	
			Kill(true,me,1,{80, 160, 240, 320},nil,nil,1)
		end
	elseif ID == CDOTA_Unit_Hero_VengefulSpirit then
		Kill(true,me,1,{100, 175, 250, 325},nil,nil,1)
	elseif ID == CDOTA_Unit_Hero_Lina then
		Kill(true,me,4,{450,675,950},nil,nil,1)
	elseif ID == CDOTA_Unit_Hero_Alchemist then
		SmartKill(false,me,2,{24,35,46,57},nil,800,1,ID)
	elseif ID == CDOTA_Unit_Hero_Morphling then
		SmartKill(true,me,2,{20, 40, 60, 80},nil,nil,1,ID)
	elseif ID == CDOTA_Unit_Hero_Visage then
		SmartKill(true,me,2,{20,20,20,20},nil,nil,1,ID)
	elseif ID == CDOTA_Unit_Hero_Undying then
		SmartKill(true,me,2,{5,10,15,20},nil,nil,1,ID)
	--complex spells
	--Kill(linkin block,me,ability,damage,scepter damage,range,target,classId,damage type)
	elseif me.classId == CDOTA_Unit_Hero_AntiMage then
		ComplexKill(true,me,4,{.6,.85,1.1},nil,nil,1,ID)
	elseif me.classId == CDOTA_Unit_Hero_DoomBringer then
		ComplexKill(true,me,3,{1,1,1,1},nil,nil,1,ID)
	elseif me.classId == CDOTA_Unit_Hero_Legion_Commander then
		ComplexKill(false,me,1,{40,80,120,160},nil,nil,2,ID)
	elseif me.classId == CDOTA_Unit_Hero_Mirana then
		ComplexKill(false,me,1,{75,150,225,300},nil,625,3,ID)
	elseif ID == CDOTA_Unit_Hero_Necrolyte then
		ComplexKill(true,me,4,{0.4,0.6,0.9},{0.6,0.9,1.2},nil,1,ID)	
	elseif ID == CDOTA_Unit_Hero_Nyx_Assassin then
		ComplexKill(true,me,2,{3.5,4,4.5,5},nil,nil,1,ID)	
	elseif ID == CDOTA_Unit_Hero_Techies then
		Kill(false,me,3,{500,650,850,1150},nil,300,1)
		KillGlobal(me,6,{300,450,600},{450,600,750},2,true,ID)
	--[[elseif ID == CDOTA_Unit_Hero_Tusk then
		local tkdmg = (me.dmgMin + me.dmgBonus)*3.5
		ComplexKill(false,me,4,{tkdmg, tkdmg, tkdmg, tkdmg},nil,300,5,ID,DAMAGE_PHYS)]]
	elseif ID == CDOTA_Unit_Hero_Obsidian_Destroyer then
		ComplexKill(false,me,4,{8,9,10},{9,10,11},nil,2,ID)	
	elseif ID == CDOTA_Unit_Hero_Elder_Titan then
		ComplexKill(false,me,2,{60,100,140,180},nil,nil,2,ID)
	elseif ID == CDOTA_Unit_Hero_Shadow_Demon then
		ComplexKill(false,me,3,{20, 35, 60, 65},nil,nil,4,ID)
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
		Kill(true,me,2,{100,175,275,350},nil,nil,1,ID)
	--other
	-------------------develop--------------------
	--elseif ID == CDOTA_Unit_Hero_Invoker then
	--	SmartSS(me)
	--elseif ID == CDOTA_Unit_Hero_Nevermore then
	--	SmartKoils(me)
	end

end

function Key(msg,code)
	if client.chat then return end
	if IsKeyDown(toggleKey) then
		activ = not activ
	elseif IsKeyDown(ComboKey) then
		combo = not combo
	end	
	if IsMouseOnButton(xx,yy,24,24) then
		if msg == LBUTTON_DOWN then
			activ = (not activ)
		end
	elseif IsMouseOnButton(xx*shft, yy-18*shft,24,24) then
		if msg == LBUTTON_DOWN then
			draw = (not draw)
		end
	end
end

function Kill(lsblock,me,ability,damage,adamage,range,target)
	local Spell = me:GetAbility(ability)
	icon.textureId = drawMgr:GetTextureId("NyanUI/spellicons/"..Spell.name)
	if Spell.level > 0 then
		local Dmg = GetDmg(Spell.level,me,damage,adamage)
		local DmgT = GetDmgType(Spell)
		local Range = GetRange(Spell,range)
		local CastPoint = Spell:FindCastPoint() + client.latency/1000
		local enemies = entityList:GetEntities({type=LuaEntity.TYPE_HERO,team = 5-me.team})
		for i,v in ipairs(enemies) do
			if v.healthbarOffset ~= -1 and not v:IsIllusion() then
				if not hero[v.handle] then
					hero[v.handle] = drawMgr:CreateText(20,0-45, 0xFFFFFF99, "",F14) hero[v.handle].visible = false hero[v.handle].entity = v hero[v.handle].entityPosition = Vector(0,0,v.healthbarOffset)
				end
				if v.visible and v.alive and v.health > 0 then
					hero[v.handle].visible = draw
					local DmgS = math.floor(v:DamageTaken(Dmg,DmgT,me))
					local DmgF = math.floor(v.health - DmgS + CastPoint*v.healthRegen+MorphMustDie(v,CastPoint))
					--hero[v.handle].text = " "..DmgF
					if activ and not me:IsChanneling() then
						if DmgF < 0 and GetDistance2D(me,v) < Range and KSCanDie(v,me,Spell,DmgS) then								
							if target == 1 then
								KSCastSpell(Spell,v,me,lsblock)	break
							elseif target == 2 then
								KSCastSpell(Spell,v.position,me,lsblock) break
							elseif target == 3 then
								KSCastSpell(Spell,nil,me,nil) break
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

function SmartKill(lsblock,me,ability,damage,adamage,range,target,id)
	local Spell = me:GetAbility(ability)
	icon.textureId = drawMgr:GetTextureId("NyanUI/spellicons/"..Spell.name)
	if Spell.level > 0 then
		local Dmg = GetSmartDmg(Spell.level,me,damage,id)
		local DmgT = GetDmgType(Spell)
		local Range = GetRange(Spell,range)
		local CastPoint = Spell:FindCastPoint() + client.latency/1000
		local enemies = entityList:GetEntities({type=LuaEntity.TYPE_HERO,team = 5-me.team})
		for i,v in ipairs(enemies) do
			if v.healthbarOffset ~= -1 and not v:IsIllusion() then
				if not hero[v.handle] then
					hero[v.handle] = drawMgr:CreateText(20,0-45, 0xFFFFFF99, "",F14) hero[v.handle].visible = false hero[v.handle].entity = v hero[v.handle].entityPosition = Vector(0,0,v.healthbarOffset)
				end
				if v.visible and v.alive and v.health > 0 then
					hero[v.handle].visible = draw
					local DmgS = math.floor(v:DamageTaken(Dmg,DmgT,me))
					local DmgF = math.floor(v.health - DmgS + CastPoint*v.healthRegen+MorphMustDie(v,CastPoint))
					--hero[v.handle].text = " "..DmgF
					if activ and not me:IsChanneling() then
						if DmgF < 0 and GetDistance2D(me,v) < Range and KSCanDie(v,me,Spell,DmgS) then								
							if target == 1 then
								KSCastSpell(Spell,v,me,lsblock)	break
							elseif target == 2 then
								KSCastSpell(Spell,v.position,me,lsblock) break
							elseif target == 3 then
								KSCastSpell(Spell,nil,me,nil) break
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

function ComplexKill(lsblock,me,ability,damage,adamage,range,target,id)
	local Spell = me:GetAbility(ability)
	local Level = Spell.level
	icon.textureId = drawMgr:GetTextureId("NyanUI/spellicons/"..Spell.name)
	if Level > 0 then
		local Dmg = GetDmg(Spell.level,me,damage,adamage)
		local DmgT = GetDmgType(Spell)
		local Range = GetRange(Spell,range)
		local CastPoint = Spell:FindCastPoint() + client.latency/1000
		local enemies = entityList:GetEntities({type=LuaEntity.TYPE_HERO,team = 5-me.team})
		for i,v in ipairs(enemies) do
			if v.healthbarOffset ~= -1 and not v:IsIllusion() then
				if not hero[v.handle] then
					hero[v.handle] = drawMgr:CreateText(20,0-45, 0xFFFFFF99, "",F14) hero[v.handle].visible = false hero[v.handle].entity = v hero[v.handle].entityPosition = Vector(0,0,v.healthbarOffset)
				end
				if v.visible and v.alive and v.health > 0 then
					hero[v.handle].visible = draw
					local DmgM = ComplexGetDmg(Level,me,v,Dmg,id)
					local DmgS = math.floor(v:DamageTaken(DmgM,DmgT,me))
					local DmgF = math.floor(v.health - DmgS + CastPoint*v.healthRegen+MorphMustDie(v,CastPoint))
					--hero[v.handle].text = " "..DmgF
					if activ and not me:IsChanneling() then
						if DmgF < 0 and GetDistance2D(me,v) < Range and KSCanDie(v,me,Spell,DmgS) then								
							if target == 1 then
								KSCastSpell(Spell,v,me,lsblock)	break
							elseif target == 2 then
								KSCastSpell(Spell,v.position,me,lsblock) break
							elseif target == 3 then
								KSCastSpell(Spell,nil,me,nil) break
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

function KillGlobal(me,ability,damage,adamage,target,comp,id)
	local Spell = me:GetAbility(ability)
	icon.textureId = drawMgr:GetTextureId("NyanUI/spellicons/"..Spell.name)
	local count = {}
	if Spell.level > 0 then
		local Dmg = GetDmg(Spell.level,me,damage,adamage)
		local DmgT = GetDmgType(Spell)
		local CastPoint = Spell:FindCastPoint() + client.latency/1000
		local enemies = entityList:GetEntities({type=LuaEntity.TYPE_HERO,team = 5-me.team})
		for i,v in ipairs(enemies) do				
			if v.healthbarOffset ~= -1 and not v:IsIllusion() then
				if not heroG[v.handle] then
					heroG[v.handle] = drawMgr:CreateText(20,0-45, 0xFFFFFF99, "",F14) heroG[v.handle].visible = false heroG[v.handle].entity = v heroG[v.handle].entityPosition = Vector(0,0,v.healthbarOffset)
				end
				if v.visible and v.alive and v.health > 1 then
					heroG[v.handle].visible = Drawning(draw,me)
					local DmgS = math.floor(v:DamageTaken(Dmg,DmgT,me))						
					local DmgF = math.floor(v.health - DmgS + CastPoint*v.healthRegen + MorphMustDie(v,CastPoint))
					--heroG[v.handle].text = " "..DmgF	
					if DmgF < 0 and KSCanDie(v,me,Spell,DmgS) then
						if not note[v.handle] then
							note[v.handle] = true
							GenerateSideMessage(v.name,Spell.name)
						end
						if activ and not me:IsChanneling() then
							if v.meepoIllusion == nil then
								table.insert(count,v)
							end
							if AutoGlobal or combo then
								if target == 1 then
									KSCastSpell(Spell,v,me,true)
									combo = false break
								elseif target == 2 then
									KSCastSpell(me:GetAbility(4),v.position,me,false)
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
				elseif heroG[v.handle].visible then
					heroG[v.handle].visible = false
				end
			end
		end
	end
	if #count > 1 then
		if target == 1 then
			KSCastSpell(Spell,count[1],me,true)
		elseif target == 2 then
			KSCastSpell(me:GetAbility(4),count[1].position,me,nil)
		elseif target == 3 then
			KSCastSpell(Spell,nil,me,nil)						
		end
	end
	
end

function KillPrediction(me,ability,damage,cast,project)
	local Spell = me:GetAbility(ability)
	icon.textureId = drawMgr:GetTextureId("NyanUI/spellicons/"..Spell.name)
	if Spell.level > 0 then
		local Dmg = GetDmg(Spell.level,me,damage,adamage)
		local DmgT = GetDmgType(Spell)
		local CastPoint = Spell:FindCastPoint() + client.latency/1000
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
					--hero[v.handle].text = " "..DmgF
					if activ and not me:IsChanneling() then
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

function KillAxe(me,damage,adamage)
	local Spell = me:GetAbility(4)
	icon.textureId = drawMgr:GetTextureId("NyanUI/spellicons/"..Spell.name)
	if Spell.level > 0 then
		local Dmg = GetDmg(Spell.level,me,damage,adamage)
		local CastPoint = Spell:FindCastPoint() + client.latency/1000
		local enemies = entityList:GetEntities({type=LuaEntity.TYPE_HERO,team = 5-me.team})
		for i,v in ipairs(enemies) do
			if v.healthbarOffset ~= -1 and not v:IsIllusion() then
				if not hero[v.handle] then
					hero[v.handle] = drawMgr:CreateText(20,0-45, 0xFFFFFF99, "",F14) hero[v.handle].visible = false hero[v.handle].entity = v hero[v.handle].entityPosition = Vector(0,0,v.healthbarOffset)
				end
				if v.visible and v.alive and v.health > 0 then
					hero[v.handle].visible = draw
					local DmgF = math.floor(v.health - Dmg + CastPoint*v.healthRegen+MorphMustDie(v,CastPoint))
					--hero[v.handle].text = " "..DmgF
					if activ and not me:IsChanneling() then
						if me:IsMagicDmgImmune() or (NotDieFromSpell(Spell,v,me) and not v:DoesHaveModifier("modifier_nyx_assassin_spiked_carapace") and NotDieFromBM(v,me,Dmg)) then
							if DmgF < 0 and GetDistance2D(me,v) < 400 then	
								KSCastSpell(Spell,v,me,true) break
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

function GetDmg(lvl,me,tab1,tab2)
	local baseDmg = tab1[lvl]
	if not tab2 then 
		return baseDmg
	elseif me:AghanimState() then
		return tab2[lvl]
	end
	return baseDmg		
end

function GetSmartDmg(lvl,me,tab1,id)
	local baseDmg = tab1[lvl]
	if id == CDOTA_Unit_Hero_Alchemist then
		local stun = me:FindModifier("modifier_alchemist_unstable_concoction")
		if stun then
			if stun.elapsedTime < 4.8 then 
				return math.floor(stun.elapsedTime*baseDmg)
			end
			return math.floor(4.8*baseDmg)
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
		local count = entityList:GetEntities(function (v) return ((v.type == LuaEntity.TYPE_CREEP and v.classId ~= 292 and not v.ancient) or v.classId == CDOTA_Unit_Undying_Zombie or v.classId == CDOTA_Unit_SpiritBear or v.classId == CDOTA_Unit_Broodmother_Spiderling or v.classId == CDOTA_Unit_Hero_Beastmaster_Boar or v.classId == CDOTA_Unit_Hero_Beastmaster_Hawk or v.classId == CDOTA_BaseNPC_Invoker_Forged_Spirit or v.courier or v.hero) and v.alive and v.visible and v.health > 0 and GetDistance2D(v,me) < 1300 end)
		local num = #count-2
		if num < baseDmg then
			return num * 24
		else
			return baseDmg*24
		end
	end
end

function ComplexGetDmg(lvl,me,ent,damage,id)
	if id == CDOTA_Unit_Hero_AntiMage then
		return  math.floor((ent.maxMana - ent.mana) * damage)
	elseif id == CDOTA_Unit_Hero_DoomBringer then
		local lvldeath = {{lvlM = 6, dmg = 125}, {lvlM = 5, dmg = 175}, {lvlM = 4, dmg = 225}, {lvlM = 3, dmg = 275}}
		return math.floor((ent.level == 25 or ent.level % lvldeath[lvl].lvlM == 0) and (ent.maxHealth * 0.20 + lvldeath[lvl].dmg) or (lvldeath[lvl].dmg))	
	elseif id == CDOTA_Unit_Hero_Mirana then
		if GetDistance2D(ent,me) < 200 then
			return damage*1.75
		end
		return damage
	elseif id == CDOTA_Unit_Hero_Necrolyte then
		return  math.floor((ent.maxHealth - ent.health) * damage)		
	elseif id == CDOTA_Unit_Hero_Nyx_Assassin then
		local tempBurn =  damage * math.floor(ent.intellectTotal)
		if ent.mana < tempBurn then
			return ent.mana
		end
		return tempBurn
	elseif id == CDOTA_Unit_Hero_Obsidian_Destroyer then
		if me.intellectTotal > ent.intellectTotal then			
			return (math.floor(me.intellectTotal) - math.floor(ent.intellectTotal))*damage
		end
		return 0
	elseif id == CDOTA_Unit_Hero_Tusk then
		local des = me:FindItem("item_desolator")
		if des and not ent:DoesHaveModifier("modifier_desolator_buff") then
			local armor = ent.totalArmor - 7
			if armor > 0 then
				local temp = ((0.06 * armor) / (1 + 0.06 * armor))
				return damage*(1-((0.06 * armor) / (1 + 0.06 * armor)))/(1-ent.dmgResist)
			else
				local temp = math.floor((1 - math.pow(.94,-armor))*100)/100
				return damage/(math.pow(.955,-armor))/(1-ent.dmgResist)
			end
		else 
			return damage
		end
	elseif id == CDOTA_Unit_Hero_Elder_Titan then
		local pasDmg = {1.08,1.16,1.25,1.33}
		local pas = me:GetAbility(3).level
		if pas ~= 0 then
			if not ent:FindModifier("modifier_elder_titan_natural_order") then
				return pasDmg[pas]*damage
			end
			return damage
		end
		return damage	
	elseif id == CDOTA_Unit_Hero_Shadow_Demon then	
		local actDmg = {1, 2, 4, 8, 16}
		local poison = ent:FindModifier("modifier_shadow_demon_shadow_poison")
		if poison then
			local Mod = poison.stacks
			if Mod ~= 0 and Mod < 6 then 
				return (actDmg[Mod]) * damage
			elseif Mod > 5 then 
				return (damage*16) + ((Mod-5)*50)					
			end
		end
		return 0
	elseif id == CDOTA_Unit_Hero_Legion_Commander then
		local bonusCreep = {14,16,18,20}
		local bonusHero = {20,35,50,65}
		local heroDmg = #entityList:GetEntities(function (v) return v.type == LuaEntity.TYPE_HERO and v.alive and v.team ~= me.team and v.health > 0 and v.visible and GetDistance2D(ent,v) < 330 end)*bonusHero[lvl]
		local creepDmg = #entityList:GetEntities(function (v) return ((v.type == LuaEntity.TYPE_CREEP and v.classId ~= 292 and not v.ancient) or v.classId == CDOTA_Unit_VisageFamiliar or v.classId == CDOTA_Unit_Undying_Zombie or v.classId == CDOTA_Unit_SpiritBear or v.classId == CDOTA_Unit_Broodmother_Spiderling or v.classId == CDOTA_Unit_Hero_Beastmaster_Boar or v.classId == CDOTA_Unit_Hero_Beastmaster_Hawk or v.classId == CDOTA_BaseNPC_Invoker_Forged_Spirit) and v.team ~= me.team and v.alive and v.visible and v.health > 0 and GetDistance2D(ent,v) < 350 end)*bonusCreep[lvl]
		return  math.floor(baseDmg + heroDmg + creepDmg)
	elseif id == CDOTA_Unit_Hero_Zuus then	
		local hp = {.05,.07,.09,.11}
		local static = me:GetAbility(3).level
		if static > 0 and GetDistance2D(me,ent) < 1000 then 
			baseDmg = baseDmg + ((hp[static]) * ent.health)
		end
		return baseDmg			
	elseif id == CDOTA_Unit_Hero_Techies then
		local range = me:GetAbility(6):GetSpecialData("radius")
		local mines = entityList:GetEntities(function (v) return v.classId == CDOTA_NPC_TechiesMines and v.alive and v.GetDistance2D(v,ent) < range end)
		return baseDmg * #mines
	end
end

function GetRange(skill,range)
	if range then
		return range
	end
	return skill.castRange + 50
end

function GetDmgType(skill)
	local typ = skill.dmgType
	if typ == LuaEntityAbility.DAMAGE_TYPE_MAGICAL then
		return DAMAGE_MAGC	
	elseif typ == LuaEntityAbility.DAMAGE_TYPE_PHYSICAL then
		return DAMAGE_PHYS
	elseif typ == LuaEntityAbility.DAMAGE_TYPE_PURE then
		return DAMAGE_PURE
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
	if spell and spell:CanBeCasted() and me:CanCast() and not (target and lsblock == true and target:IsLinkensProtected()) then
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
	if hero:CanDie() then
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
	
	return false
end

function Drawning(draw,me)
	if me.classId ~= CDOTA_Unit_Hero_Zuus and me.classId ~= CDOTA_Unit_Hero_Techies then
		return draw
	end
	return false
end

function GameClose()
	rect.visible = false
	icon.visible = false
	dmgCalc.visible = false
	hero = {} heroG = {}
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
