require("libs.Utils")
require("libs.Deadly")

------------------------[[Config]]-------------------------
			local toggleKey = string.byte("Z")
------------------------------------------------------------
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

local PreKill = 0 local hero = {} local global = {} local clear = nil
local activated = true local Draw = true local sleeptick = 0


--Draw function
local F14 = drawMgr:CreateFont("F14","Calibri",14,500)
local rect = drawMgr:CreateRect(xx-1,yy-1,26,26,0x00000090,true)
rect.visible = false
local icon = drawMgr:CreateRect(xx,yy,24,24,0x000000ff)
icon.visible = false
local dmgCalc = drawMgr:CreateText(xx, yy-18, 0x00000099,"Dmg",F14)
dmgCalc.visible = false
for a = 1, 5 do
global[a] = drawMgr:CreateRect(0,yy-5,18,18,0x000000FF)
global[a].visible = false
end

function Load()
	if not client.connected or client.loading or client.console then return end	
	local me = entityList:GetMyHero()
	if not me then return end	
	if not list[me.name] then script:Disable() return end
	reg = true
	script:RegisterEvent(EVENT_TICK,Tick)
	script:RegisterEvent(EVENT_KEY,Key)
	script:UnregisterEvent(Load)
end

function Tick(tick)

		if tick < sleeptick then return end		
		sleeptick = tick + 150		
		local me = entityList:GetMyHero()
		if not me then return end
		local Spell = list[me.name].Spell 
		local Skill = me:FindSpell(list[me.name].Spell)
		local Range = GetRange(Skill,me)
		local Dmg = GetDmg(me)	
		local Cast = list[me.name].Cast
		local Type = list[me.name].Type
		local Target = list[me.name].Target
		local DmgM = list[me.name].DmgM
		local Time = list[me.name].Time
		local Global = list[me.name].Global
		local DmgS = nil
		local real = {}
		
		dmgCalc.visible = Draw
		rect.visible = activated
		icon.visible = activated
		icon.textureId = drawMgr:GetTextureId("NyanUI/spellicons/"..list[me.name].Spell)

		if me.name == "npc_dota_hero_windrunner" and Skill.channelTime ~= 0 and Skill.channelTime > 0.6 then me:Move(me.position) end
		if Skill.level > 0 and me.alive and not me:IsChanneling() then
			local enemies = entityList:GetEntities({type=LuaEntity.TYPE_HERO,team = (5-me.team),illusion=false})
			for i = 1, #enemies do
				local v = enemies[i]
				local offset = v.healthbarOffset
				if offset == -1 then return end
				if not hero[v.handle] then
					hero[v.handle] = drawMgr:CreateText(20,0-45, 0xFFFFFFFF, "",F14) hero[v.handle].visible = false hero[v.handle].entity = v hero[v.handle].entityPosition = Vector(0,0,offset)
				end
				if v.visible and v.alive and v.health > 0 then
					hero[v.handle].visible = Draw
					if not Cast then
						local DmgF = math.floor(v.health - v:DamageTaken(Dmg[Skill.level], Type, me))
						hero[v.handle].text = " "..DmgF
						if EnemyCheck(me,v,Skill,DmgF,Range) then
							if not Time then		
								if Target == "target" then
									me:SafeCastAbility(Skill,v)
								elseif Target == "area" then
									me:SafeCastAbility(Skill,v.position)
								elseif Target == "nontarget" then
									me:SafeCastAbility(Skill)
								end
							else
								table.insert(real,v)									
							end
						end
					elseif me.name == "npc_dota_hero_life_stealer" then
						local DmgF = math.floor(v.health - v:DamageTaken(Dmg[Skill.level],DAMAGE_MAGC, me))
						hero[v.handle].text = " "..DmgF
					elseif me.name == "npc_dota_hero_doom_bringer" then
						local DmgS = v:GetProperty("CDOTA_BaseNPC","m_iCurrentLevel")
						local DmgF = math.floor(v.health - v:DamageTaken(math.floor((DmgS == 25 or DmgS % DmgM[Skill.level].levelMultiplier == 0) and (v.maxHealth * 0.20 + DmgM[Skill.level].dmg)	or	(DmgM[Skill.level].dmg)), Type, me))					
						hero[v.handle].text = " "..DmgF
						if EnemyCheck(me,v,Skill,DmgF,Range) then
							me:SafeCastAbility(Skill,v)
						end
					elseif me.name == "npc_dota_hero_necrolyte" then
						local DmgS = v.maxHealth - v.health
						local DmgF = math.floor(v.health - v:DamageTaken((DmgS) * Dmg[Skill.level], Type, me))
						hero[v.handle].text = " "..DmgF
						if EnemyCheck(me,v,Skill,DmgF,Range) then
							me:SafeCastAbility(Skill,v)
						end
					elseif me.name == "npc_dota_hero_antimage" then
						local DmgS = v.maxMana - v.mana
						local DmgF = math.floor(v.health - v:DamageTaken(DmgS * Dmg[Skill.level],Type, me))
						hero[v.handle].text = " "..DmgF
						if EnemyCheck(me,v,Skill,DmgF,Range) then
							me:SafeCastAbility(Skill,v)
						end						
					elseif me.name == "npc_dota_hero_morphling" then 
						local agi = math.floor(me.agilityTotal)
						local DmgS = agi/me.strengthTotal
						if DmgS > 1.5 then DmgM = 0.5*Skill.level elseif DmgS < 0.5 then DmgM = 0.25 elseif (DmgS >= 0.5 and DmgS <= 1.5) then DmgM = 0.25+((DmgS-0.5)*(0.5*Skill.level-0.25)) end
						local DmgF = math.floor(v.health - v:DamageTaken((DmgM)*agi + Dmg[Skill.level], Type, me))
						hero[v.handle].text = " "..DmgF
						if EnemyCheck(me,v,Skill,DmgF,Range) then
							me:SafeCastAbility(Skill,v)
						end
					elseif me.name == "npc_dota_hero_visage" then														
						local DmgM = math.floor(20 + (ModifierStacks("modifier_visage_soul_assumption",me) * 65))				
						local DmgF = math.floor(v.health - v:DamageTaken(DmgM, Type, me))
						hero[v.handle].text = " "..DmgF
						if EnemyCheck(me,v,Skill,DmgF,Range) then
							me:SafeCastAbility(Skill,v)
						end						
					elseif me.name == "npc_dota_hero_alchemist" then						
						if Elapsed("modifier_alchemist_unstable_concoction",me) < 4.6 then DmgS = Elapsed("modifier_alchemist_unstable_concoction",me) else DmgS = 4.6 end
						local DmgF = math.floor(v.health - v:DamageTaken((DmgS * DmgM[Skill.level]), list[me.name].Type, me))
						hero[v.handle].text = " "..DmgF
						if EnemyCheck(me,v,Skill,DmgF,Range) then
							me:SafeCastAbility(me:GetAbility(2),v)
						end
					elseif me.name == "npc_dota_hero_mirana" then													
						if GetDistance2D(v,me) < 200 then DmgM = Dmg[Skill.level]*1.75 else DmgM = Dmg[Skill.level] end
						local DmgF = math.floor(v.health - v:DamageTaken(DmgM, Type, me))
						hero[v.handle].text = " "..DmgF	
						if EnemyCheck(me,v,Skill,DmgF,Range) then
							me:SafeCastAbility(Skill)
						end
					elseif me.name == "npc_dota_hero_obsidian_destroyer" then
						local DmgS = math.floor(me.intellectTotal)
						if DmgS > v.intellectTotal then DmgM = math.floor((DmgS - v.intellectTotal)*Dmg[Skill.level]) else DmgM = 1 end
						local DmgF = math.floor(v.health - v:DamageTaken(DmgM, Type, me))
						hero[v.handle].text = " "..DmgF
						if EnemyCheck(me,v,Skill,DmgF,Range) then
							me:SafeCastAbility(Skill,v.position)
						end
					elseif me.name == "npc_dota_hero_elder_titan" then
						local passive = me:GetAbility(3).level
						if passive ~= 0 and not v:FindModifier("modifier_elder_titan_natural_order") then DmgS = DmgM[me:GetAbility(3).level]*Dmg[Skill.level] else DmgS = Dmg[Skill.level] end
						local DmgF = math.floor(v.health - v:DamageTaken(DmgS, list[me.name].Type, me))
						hero[v.handle].text = " "..DmgF
						if EnemyCheck(me,v,Skill,DmgF,Range) then
							me:SafeCastAbility(Skill,v.position)
						end
					elseif me.name == "npc_dota_hero_shadow_demon" then
						local Mod = ModifierStacks("modifier_shadow_demon_shadow_poison",v)
						if Mod ~= 0 and Mod < 6 then DmgS = (DmgM[ModifierStacks("modifier_shadow_demon_shadow_poison",v)]) * Dmg[Skill.level] elseif Mod > 5 then DmgS = ((Dmg[Skill.level]*16) + ((Mod-5)*50)) end
						if DmgS then
							local DmgF = math.floor(v.health - v:DamageTaken(DmgS, list[me.name].Type, me))
							hero[v.handle].text = " "..DmgF
							if EnemyCheck(me,v,Skill,DmgF,Range) then
								me:SafeCastAbility(Skill)
							end
						end
					elseif me.name == "npc_dota_hero_nyx_assassin" then					
						local DmgM = math.floor(Dmg[Skill.level] * math.floor(v.intellectTotal))
						local DmgF = math.floor(v.health -  v:ManaBurnDamageTaken(DmgM,1,DAMAGE_MAGC,me))
						hero[v.handle].text = " "..DmgF		
						if EnemyCheck(me,v,Skill,DmgF,Range) then
							me:SafeCastAbility(Skill,v)
						end
					elseif me.name == "npc_dota_hero_ogre_magi" then
						local musticast = me:FindSpell("ogre_magi_multicast").level
						local DmgM = math.floor(v:DamageTaken(Dmg[Skill.level],Type, me))
						if musticast == 1 then							
							local DmgF = math.floor(v.health - DmgM)
							hero[v.handle].x = -10
							hero[v.handle].text = " "..DmgF.."("..(DmgF-DmgM)..")"
							if EnemyCheck(me,v,Skill,DmgF,Range) then
								me:SafeCastAbility(Skill,v)
							end
						elseif musticast == 2 then
							local DmgF = math.floor(v.health - v:DamageTaken(Dmg[Skill.level],Type, me))
							hero[v.handle].x = -30
							hero[v.handle].text = " "..DmgF.."("..(DmgF-(DmgM*2))..";"..(DmgF-(DmgM*3))..")"
							if EnemyCheck(me,v,Skill,DmgF,Range) then
								me:SafeCastAbility(Skill,v)
							end
						elseif musticast == 3 then
							local DmgF = math.floor(v.health - v:DamageTaken(Dmg[Skill.level],Type, me))
							hero[v.handle].x = -50
							hero[v.handle].text = " "..DmgF.."("..(DmgF-(DmgM*2))..";"..(DmgF-(DmgM*3))..";"..(DmgF-(DmgM*4))..")"
							if EnemyCheck(me,v,Skill,DmgF,Range) then
								me:SafeCastAbility(Skill,v)
							end
						else
							local DmgF = math.floor(v.health - v:DamageTaken(Dmg[Skill.level],Type, me))
							hero[v.handle].text = " "..DmgF..""
							if EnemyCheck(me,v,Skill,DmgF,Range) then
								me:SafeCastAbility(Skill,v)
							end
						end
					elseif me.name == "npc_dota_hero_lina" then							
						if me:FindItem("item_ultimate_scepter") then
							local Range = 900
							local DmgF = math.floor(v.health - v:DamageTaken(Dmg[Skill.level],DAMAGE_UNIV, me))
							hero[v.handle].text = " "..DmgF
							if EnemyCheck(me,v,Skill,DmgF,Range) then
								me:SafeCastAbility(Skill,v)
							end
						else
							local Range = 600
							local DmgF = math.floor(v.health - v:DamageTaken(Dmg[Skill.level],DAMAGE_MAGC, me))
							hero[v.handle].text = " "..DmgF
							if EnemyCheck(me,v,Skill,DmgF,Range) then
								me:SafeCastAbility(Skill,v)
							end
						end								
					elseif me.name == "npc_dota_hero_nevermore" then
						local DmgF = math.floor(v.health - v:DamageTaken(Dmg[Skill.level],DAMAGE_MAGC, me))
						hero[v.handle].text = " "..DmgF
						if EnemyCheck(me,v,Skill,DmgF,Range) then
							local dis = GetDistance2D(v,me)
							if dis < 350 then
								me:Attack(v)
								me:SafeCastAbility(me:GetAbility(1))
							elseif dis < 550 and dis > 350 then
								me:Attack(v)
								me:SafeCastAbility(me:GetAbility(2))
							elseif dis < 800 and dis > 550 then
								me:Attack(v)
								me:SafeCastAbility(me:GetAbility(3))
							end
						end	
					elseif me.name == "npc_dota_hero_invoker" then
						local DmgM = Dmg[me:GetAbility(3).level]
						local DmgF = math.floor(v.health - v:DamageTaken(DmgM, Type, me))
						hero[v.handle].text = " "..DmgF
						if EnemyCheck(me,v,Skill,DmgF,Range) then
							table.insert(real,v)
						end
					elseif me.name == "npc_dota_hero_furion" then
						local DmgF = math.floor(v.health - v:DamageTaken(Dmg[Skill.level],DAMAGE_MAGC, me))
						hero[v.handle].text = " "..DmgF
						if EnemyCheck(me,v,Skill,DmgF,Range) then
							table.insert(real,v)
						end
					elseif me.name == "npc_dota_hero_zuus" then
						local hp = {.05,.07,.09,.11}
						local static = me:GetAbility(3).level
						local ult = me:GetAbility(4)
						local DmgU = {225,350,475}
						local DmgUA = {440,540,640}
						if static > 0 then DmgM = v.health*hp[static] else DmgM = 0 end
						local DmgF = math.floor(v.health - v:DamageTaken(Dmg[Skill.level] + DmgM,Type, me))
						hero[v.handle].text = " "..DmgF
						if GetDistance2D(me,v) < 600 then							
							if EnemyCheck(me,v,Skill,DmgF,Range) then
								me:SafeCastAbility(Skill,v)
							end
						end							
						if ult.level > 0 then 
							local DmgUlti = nil
							if me:FindItem("item_ultimate_scepter") then
								if GetDistance2D(me,v) < 1000 then
									DmgUlti = DmgUA[ult.level] + DmgM
								else
									DmgUlti = DmgUA[ult.level]
								end
							else
								if GetDistance2D(me,v) < 1000 then
									DmgUlti = DmgU[ult.level] + DmgM
								else
									DmgUlti = DmgU[ult.level]
								end
							end		
							if v.health + 1 < math.floor(v:DamageTaken(DmgUlti, Type, me)) and NotDieFromBM(v,ult,me) and CanDie(v,me) then
								table.insert(real,v)
							end
						end
					end
				else 		
					hero[v.handle].visible = false
				end
			end
		end
		if #real > 0 then
			clear = true
			if Time then
				if #real > 2 then
					table.sort(real, function (a,b) return GetDistance2D(a,me) < GetDistance2D(b,me) end )
				end
				local first = real[1]
				if first then
					local CastTime = list[me.name].CastTime
					local Speed = list[me.name].Speed
					if first.activity == 422 and first:CanMove() then
						if RangePred(Skill,first,Speed,CastTime,me) then
							me:CastAbility(Skill,Vector(first.position.x + first.movespeed * (GetDistance2D(first,me)/(Speed * math.sqrt(1 - math.pow(first.movespeed/Speed,2))) + CastTime) * math.cos(first.rotR), first.position.y + first.movespeed * (GetDistance2D(first,me)/(Speed * math.sqrt(1 - math.pow(first.movespeed/Speed,2))) + CastTime) * math.sin(first.rotR), first.position.z))
						end
					else
						me:CastAbility(Skill,Vector(first.position.x + first.movespeed * 0.05 * math.cos(first.rotR), first.position.y + first.movespeed* 0.05 * math.sin(first.rotR), first.position.z))
					end
				end
			elseif Global then	
				GlobKey = 1
				for a = 1, 5 do
					if real[a] ~= nil then
						global[a].visible = Draw
						global[a].x = xx+5+a*25
						global[a].textureId = drawMgr:GetTextureId("NyanUI/miniheroes/"..real[a].name:gsub("npc_dota_hero_",""))
					else
						global[a].visible = false
					end
				end
				if me.name == "npc_dota_hero_zuus" then
					if #real > 1 then
						me:SafeCastAbility(me:GetAbility(4))
					else	
						if PreKill ~= 0 then
							me:SafeCastAbility(me:GetAbility(4))
							PreKill = 0
						end
					end
				elseif me.name == "npc_dota_hero_furion" then
					if #real > 1 then
						me:SafeCastAbility(Skill,real[1])
					else
						for k,l in ipairs(real) do	
							if k == PreKill then
								me:SafeCastAbility(Skill,l)
								PreKill = 0
							end
						end
					end
				elseif me.name == "npc_dota_hero_invoker" then					
					for k,l in ipairs(real) do
						if k == PreKill then										
							if real[k].activity == 422 and real[k]:CanMove() then
								me:SafeCastAbility(Skill,Vector(l.position.x + l.movespeed * 1.75 * math.cos(l.rotR), l.position.y + l.movespeed* 1.75 * math.sin(l.rotR), l.position.z))
								PreKill = 0
							else
								me:SafeCastAbility(Skill,Vector(l.position.x + l.movespeed * 0.05 * math.cos(l.rotR), l.position.y + l.movespeed* 0.05 * math.sin(l.rotR), l.position.z))										
								PreKill = 0
							end
						end
					end					
				end
			end
		elseif clear then
			clear = false
			for a = 1, 5 do
				global[a].visible = false
			end
		end
			

end

function Key(msg,code)

	if client.chat then return end

	if IsKeyDown(toggleKey) then
		activated = not activated
	end

	if IsMouseOnButton(xx,yy,24,24) then
		if msg == LBUTTON_DOWN then
			activated = (not activated)
		end
	end

	if IsMouseOnButton(xx,yy-18,24,24) then
		if msg == LBUTTON_DOWN then
			Draw = (not Draw)
		end
	end

	if activated then
		if GlobKey == 1 then
			for k = 1, 5 do
				if IsMouseOnButton(xx+5+k*25,yy-5,18,18) then
					if msg == LBUTTON_DOWN or msg == LBUTTON_UP then
						PreKill = k
					else
						PreKill = 0
					end
				end
			end
		end
	end

end

function IsMouseOnButton(x,y,h,w)
	local mx = client.mouseScreenPosition.x
	local my = client.mouseScreenPosition.y
	return mx > x and mx <= x + w and my > y and my <= y + h
end

function EnemyCheck(me,v,Skill,DmgF,Range)
	if activated then
		if GetDistance2D(me,v) < Range and CanDie(v,me) and NotDieFromSpell(Skill,v,me) and not v:DoesHaveModifier("modifier_nyx_assassin_spiked_carapace") and DmgF < -1 then
			return true
		else
			return false
		end
	else
		return false
	end
end

function GetRange(Skill,me)
	local range = list[me.name].Range
	if not range then
		return  Skill.castRange
	else 
		return range
	end
end

function GetDmg(me)	
	local DmgA = list[me.name].DmgA
	local DmgL = list[me.name].Dmg
	if DmgA then
		if me:FindItem("item_ultimate_scepter") then
			return DmgA
		else
			return DmgL
		end
	else 
		return DmgL
	end
end

function RangePred(spell,t,speed,cast,me)
	if GetDistance2D(me,Vector(t.position.x + t.movespeed * (GetDistance2D(t,me)/(speed * math.sqrt(1 - math.pow(t.movespeed/speed,2))) + cast) * math.cos(t.rotR), t.position.y + t.movespeed * (GetDistance2D(t,me)/(speed * math.sqrt(1 - math.pow(t.movespeed/speed,2))) + cast) * math.sin(t.rotR), t.position.z)) < spell.castRange then return true end return false
end

function CanDie(target,me)
	if me.name ~= "npc_dota_hero_axe" and target:CanReincarnate() then
		return false
	end
	if me.name ~= "npc_dota_hero_axe" and target:DoesHaveModifier("modifier_dazzle_shallow_grave") then
		return false
	end
	return true
end

function NotDieFromSpell(spell,target,me)
	local za = {1,1.25,1.5,1.75}
	if not me:IsMagicDmgImmune() then
		if me:DoesHaveModifier("modifier_pugna_nether_ward_aura") then
			if me.health < me:DamageTaken(spell.manacost*(za[target:GetAbility(3).level]), DAMAGE_MAGC, target) then
				return false
			end
		end
	end
	return true
end

function NotDieFromBM(target,me,dmg)
	if not me:IsMagicDmgImmune() and target:DoesHaveModifier("modifier_item_blade_mail_reflect") and target:DamageTaken(dmg, DAMAGE_PURE, me) + me.health < 0 then
		return false
	end
	return true
end

function ModifierStacks(name,target)
	local modifier = target.modifiers
	if modifier then
		for i,v in ipairs(modifier) do
			if v.name == name then
				return v.stacks
			end
		end
	end
	return 0
end

function Elapsed(name,target)
	local modifier = target.modifiers
	if modifier then
		for i,v in ipairs(modifier) do
			if v.name == name then
				return v.elapsedTime			
			end
		end
	end	
	return 0
end

function GameClose()
	rect.visible = false
	icon.visible = false
	dmgCalc.visible = false
	for a = 1,5 do
		global[a].visible = false
	end
	hero = {}
	real = {}
	GlobKey = nil
	collectgarbage("collect")
	if reg then
		script:UnregisterEvent(Tick)
		script:UnregisterEvent(Key)
		script:RegisterEvent(EVENT_TICK,Load)
		reg = nil
	end
end

script:RegisterEvent(EVENT_CLOSE,GameClose)
script:RegisterEvent(EVENT_TICK,Load)
