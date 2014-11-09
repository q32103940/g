require("libs.ScriptConfig")
require("libs.Utils")
require("libs.HeroInfo")
require("libs.TargetFind")
require("libs.SkillShot")

local config = ScriptConfig.new()
config:SetParameter("Move", 32, config.TYPE_HOTKEY)
config:SetParameter("Hotkey", "N", config.TYPE_HOTKEY)
config:SetParameter("LasthitToggleKey", "V", config.TYPE_HOTKEY)
config:SetParameter("AutoChase", "B", config.TYPE_HOTKEY)
config:SetParameter("ActiveFromStart", true)
config:SetParameter("ShowSign", true)
config:SetParameter("DontOrbwalkWhenIdle", true)
config:Load()
	
movetomouse = config.Move
hotkey = config.Hotkey
active = config.ActiveFromStart
showsign = config.ShowSign
noorbwalkidle = config.DontOrbwalkWhenIdle
lhkey = config.LasthitToggleKey
autochasekey = config.AutoChase

local myAttackTickTable = {} local creepTable = {}

local sleep = 0 myAttackTickTable.attackRateTick = 0 myAttackTickTable.attackRateTick2 = 0 myAttackTickTable.attackPointTick = nil

local myhero = nil local reg = false local myId = nil local victim = nil local moveposition = nil local psivictim = nil local attacking = false local harras = false local lhcreep = nil local lhcreepclass = nil local lh = nil local lhtime = 0 local lasthitting = false
local autochase = false local chasevictim = nil local invisibletime = nil

local monitor = client.screenSize.x/1600
local F14 = drawMgr:CreateFont("F14","Tahoma",14*monitor,550*monitor) 
local statusText = drawMgr:CreateText(10*monitor,600*monitor,-1,'Templar Assassin Script: ON "' .. string.char(hotkey) .. '", Lasthitting/Farming: ON "' .. string.char(lhkey) .. '"',F14) statusText.visible = false
local chaseText = drawMgr:CreateText(-80*monitor,-20*monitor,-1,'ManualChase',F14) chaseText.visible = false

armorTypeModifiers = { Normal = {Unarmored = 1.00, Light = 1.00, Medium = 1.50, Heavy = 1.25, Fortified = 0.70, Hero = 0.75}, Pierce = {Unarmored = 1.50, Light = 2.00, Medium = 0.75, Heavy = 0.75, Fortified = 0.35, Hero = 0.50},	Siege = {Unarmored = 1.00, Light = 1.00, Medium = 0.50, Heavy = 1.25, Fortified = 1.50, Hero = 0.75}, Chaos = {Unarmored = 1.00, Light = 1.00, Medium = 1.00, Heavy = 1.00, Fortified = 0.40, Hero = 1.00},	Hero = {Unarmored = 1.00, Light = 1.00, Medium = 1.00, Heavy = 1.00, Fortified = 0.50, Hero = 1.00}, Magic = {Unarmored = 1.00, Light = 1.00, Medium = 1.00, Heavy = 1.00, Fortified = 1.00, Hero = 0.75} }

function Key(msg, code)
	if msg ~= KEY_UP or client.chat or client.console then return end
	if code == hotkey then 
		active = not active
	elseif code == lhkey then
		lasthitting = not lasthitting 
	elseif code == autochasekey then
		autochase = not autochase 
		lasthitting = false
	end
end

function Main(tick)
	if not PlayingGame() or client.paused then return end	
	local me = entityList:GetMyHero() if not me then return end	
	local ID = me.classId if ID ~= myId then Close() end
	statusText.visible = true
	if victim and not lasthitting and GetDistance2D(victim,me) <2000 then
		chaseText.entity = me
		chaseText.entityPosition = Vector(0,0,me.healthbarOffset)
		if autochase then
			chaseText.text = "Auto-Chasing: "..client:Localize(victim.name)
		else
			chaseText.text = "Manual-Chasing: "..client:Localize(victim.name)
		end
		chaseText.visible = true
	else
		chaseText.visible = false
	end
	statusText.text = 'Templar Assassin Script: '..IsActive()..' "' .. string.char(hotkey) .. '", Lasthitting/Farming: ' .. IsActive(true) .. ' "' .. string.char(lhkey) .. '"'
	if active and not me:IsChanneling() then
		if not myhero then
			myhero = Hero(me)
		else		
			UpdateMyHero(me)
			if SleepCheck("update") then
				GetCreeps(me)
				Sleep(250, "update")
			end
			--combo
			local dmg = me.dmgMin + me.dmgBonus
			local refraction = me:GetAbility(1)
			local refdmg = refraction:GetSpecialData("bonus_damage", refraction.level)
			local blink = me:FindItem("item_blink")
			local meld = me:GetAbility(2)	
			local meldDmg = meld:GetSpecialData("bonus_damage", meld.level)			
			local enemies = entityList:GetEntities({type=LuaEntity.TYPE_HERO,team = me:GetEnemyTeam(),visible=true,alive=true})
			if me.alive and meld and meld.level > 0 and meld.state == LuaEntityAbility.STATE_READY then
				for i, v in ipairs(enemies) do
					if GetDistance2D(v,me) <= 1200+myhero.attackRange and not v:IsIllusion() and v.health <= ((dmg + meldDmg + refdmg)*(1-v.dmgResist)+1) then
						if SleepCheck("meld2") and me:CanAttack() and not v:IsAttackImmune() then
							if blink and blink.cd == 0 and GetDistance2D(me,v) > myhero.attackRange+25 then
								local bpos = (v.position - me.position) * 1100 / GetDistance2D(me,v) + me.position
								local turn = (math.max(math.abs(FindAngleR(me) - math.rad(FindAngleBetween(me, v))) - 0.69, 0)/(0.5*(1/0.03)))*1000 + client.latency
								if GetDistance2D(me, v) <= 1100 then
									me:SafeCastAbility(blink, v.position)
								elseif v:CanMove() and v.activity == LuaEntityNPC.ACTIVITY_MOVE then
									me:SafeCastAbility(blink, bpos)
								else
									me:SafeCastAbility(blink, bpos)
								end
								Sleep(turn+client.latency/1000+blink:FindCastPoint(), "move")
							end
							if GetDistance2D(me, v) <= myhero.attackRange-25 then
								if v.health > ((dmg)*(1-v.dmgResist)+1) then
									if refraction and refraction.state == LuaEntityAbility.STATE_READY then
										me:SafeCastAbility(refraction)
									end
									me:SafeCastAbility(meld)
								end
								entityList:GetMyPlayer():Attack(v)
								Sleep(myhero.attackRate*1000, "meld2")
								Sleep(client.latency/1000+myhero.attackRate*1000, "move")
							end
						end
					end
				end
			end
			if IsKeyDown(movetomouse) and not client.chat then				
				--detect if we already have traps active and if there is any close to enemy
				local traps = entityList:GetEntities({classId=CDOTA_BaseNPC_Additive,alive=true,team=me.team,visible=true})
				local closestTrap = nil
				for i,v in ipairs(traps) do
					if (v:GetAbility(1) and v:GetAbility(1).name == "templar_assassin_self_trap" and v:GetAbility(1).state == LuaEntityAbility.STATE_READY) then
						if not closestTrap or GetDistance2D(closestTrap, victim) > GetDistance2D(v, victim) then
							if GetDistance2D(v, victim) <= 400 then
								closestTrap = v
							end
							if closestTrap and GetDistance2D(closestTrap, victim) > 400 then
								closestTrap = nil
							end
						end
					end
				end
				local trap = me:GetAbility(5)
				if not lhcreep and ((me:DoesHaveModifier("modifier_templar_assassin_meld") and not attacking) or not me:DoesHaveModifier("modifier_templar_assassin_meld")) and (((not victim or GetDistance2D(me, victim) > (myhero.attackRange + 50)) and (not psivictim or GetDistance2D(me, psivictim) > (myhero.attackRange + 50))) or (not noorbwalkidle and not attacking) or (not attacking and (victim and (victim.activity ~= LuaEntityNPC.ACTIVITY_IDLE and victim.activity ~= LuaEntityNPC.ACTIVITY_IDLE1) or (victim and victim:CanMove() and victim.activity == LuaEntityNPC.ACTIVITY_MOVE)))) then
					--blink to enemy
					if not harras and blink and blink.cd == 0 and (victim and (victim.courier or victim.hero) and GetDistance2D(me,victim) > myhero.attackRange+200 and GetDistance2D(me,victim) < 1500) then
						local bpos = (victim.position - me.position) * 1100 / GetDistance2D(me,victim) + me.position
						local turn = (math.max(math.abs(FindAngleR(me) - math.rad(FindAngleBetween(me, victim))) - 0.69, 0)/(0.5*(1/0.03)))*1000 + client.latency
						if victim.visible then
							if GetDistance2D(me, victim) <= 1100 then
							if victim and victim.hero and GetDistance2D(me,victim) <= trap.castRange+375 and CanBeSlowed(victim) then
						local trapslow = victim:FindModifier("modifier_templar_assassin_trap_slow")
						if not lasthitting and (victim:CanMove() and victim.activity == LuaEntityNPC.ACTIVITY_MOVE and (not trapslow or trapslow.remainingTime <= (trap:FindCastPoint()*1.5 + client.latency/1000))) and ((closestTrap and GetDistance2D(closestTrap, victim) <= 400) or trap.state == LuaEntityAbility.STATE_READY) then
							if closestTrap then
								closestTrap:SafeCastAbility(closestTrap:GetAbility(1))
								Sleep(trap:FindCastPoint() + client.latency/1000, "move")
								Sleep(100+trap:FindCastPoint() + client.latency/1000, "trap")
								return
							end
							if SleepCheck("trap") then
								local p = Vector(victim.position.x + (victim.movespeed * (trap:FindCastPoint() + client.latency/1000) + 100) * math.cos(victim.rotR), victim.position.y + (victim.movespeed * (trap:FindCastPoint() + client.latency/1000) + 100) * math.sin(victim.rotR), victim.position.z)
								if victim.visible then
									me:SafeCastAbility(trap, p)
								else
									local blind = SkillShot.BlindSkillShotXYZ(me,victim,1100,trap:FindCastPoint()+client.latency/1000)
									if blind then
										me:SafeCastAbility(trap, blind)
									else
										me:SafeCastAbility(trap, Vector(victim.position.x + (victim.movespeed * (trap:FindCastPoint() + client.latency/1000) + 100) * math.cos(victim.rotR), victim.position.y + (victim.movespeed * (trap:FindCastPoint() + client.latency/1000) + 100) * math.sin(victim.rotR), victim.position.z))
									end
								end
								Sleep(trap:FindCastPoint() + client.latency/1000, "move")
								Sleep(100+trap:FindCastPoint() + client.latency/1000, "trap")
								return
							end
						end
					end
								me:SafeCastAbility(blink, victim.position)
							elseif victim:CanMove() and victim.activity == LuaEntityNPC.ACTIVITY_MOVE then
								me:SafeCastAbility(blink, bpos)
							else
								me:SafeCastAbility(blink, bpos)
							end
						else
							local blind = SkillShot.BlindSkillShotXYZ(me,victim,1200,meld:FindCastPoint()+client.latency/1000)
							if blind then
								bpos = (blind - me.position) * 1100 / GetDistance2D(me,blind) + me.position
								if GetDistance2D(me, blind) <= 1100 then
									me:SafeCastAbility(blink, blind)
								else
									me:SafeCastAbility(blink, bpos)
								end
							else
								me:SafeCastAbility(blink, Vector(victim.position.x + (victim.movespeed * (meld:FindCastPoint() + client.latency/1000) + 100) * math.cos(victim.rotR), victim.position.y + (victim.movespeed * (meld:FindCastPoint() + client.latency/1000) + 100) * math.sin(victim.rotR), victim.position.z))
							end
						end
						sleep = tick + turn
						Sleep(blink:FindCastPoint() + client.latency/1000 + turn, "move")
					end
					--activate close trap or put another
					if victim and victim.hero and GetDistance2D(me,victim) <= trap.castRange+375 and CanBeSlowed(victim) then
						local trapslow = victim:FindModifier("modifier_templar_assassin_trap_slow")
						if not lasthitting and (victim:CanMove() and victim.activity == LuaEntityNPC.ACTIVITY_MOVE and (not trapslow or trapslow.remainingTime <= (trap:FindCastPoint()*1.5 + client.latency/1000))) and ((closestTrap and GetDistance2D(closestTrap, victim) <= 400) or trap.state == LuaEntityAbility.STATE_READY) then
							if closestTrap then
								closestTrap:SafeCastAbility(closestTrap:GetAbility(1))
								Sleep(trap:FindCastPoint() + client.latency/1000, "move")
								Sleep(100+trap:FindCastPoint() + client.latency/1000, "trap")
								return
							end
							if SleepCheck("trap") then
								local p = Vector(victim.position.x + (victim.movespeed * (trap:FindCastPoint() + client.latency/1000) + 100) * math.cos(victim.rotR), victim.position.y + (victim.movespeed * (trap:FindCastPoint() + client.latency/1000) + 100) * math.sin(victim.rotR), victim.position.z)
								if victim.visible then
									me:SafeCastAbility(trap, p)
								else
									local blind = SkillShot.BlindSkillShotXYZ(me,victim,1100,trap:FindCastPoint()+client.latency/1000)
									if blind then
										me:SafeCastAbility(trap, blind)
									else
										me:SafeCastAbility(trap, Vector(victim.position.x + (victim.movespeed * (trap:FindCastPoint() + client.latency/1000) + 100) * math.cos(victim.rotR), victim.position.y + (victim.movespeed * (trap:FindCastPoint() + client.latency/1000) + 100) * math.sin(victim.rotR), victim.position.z))
									end
								end
								Sleep(trap:FindCastPoint() + client.latency/1000, "move")
								Sleep(100+trap:FindCastPoint() + client.latency/1000, "trap")
								return
							end
						end
					end
					if tick > sleep then
						--move to mouse position
						if SleepCheck("move") then
							local phaseboots = me:FindItem("item_phase_boots")
								if phaseboots and phaseboots:CanBeCasted() then
								me:SafeCastItem("item_phase_boots") end
						
							if victim and (GetDistance2D(client.mousePosition, victim) <= 10 or entityList:GetMouseover() == victim or autochase) then
								if victim.visible then
									me:Move(victim.position)
								else
									local blind = SkillShot.BlindSkillShotXYZ(me,victim,1200,meld:FindCastPoint()+client.latency/1000)
									if blind then
										me:Move(blind)
									else
										me:Move(Vector(victim.position.x + (victim.movespeed * (meld:FindCastPoint() + client.latency/1000) + 100) * math.cos(victim.rotR), victim.position.y + (victim.movespeed * (meld:FindCastPoint() + client.latency/1000) + 100) * math.sin(victim.rotR), victim.position.z))
									end
								end
							else
								if GetDistance2D(me, client.mousePosition) > 50 then 
									me:Move(client.mousePosition)
								end
							end
							sleep = tick + 30 + client.latency
						end
					end
				end
				--perfect meld strikes
				if victim and victim.visible then	
					if GetDistance2D(me,victim) <= myhero.attackRange-50 then
						if refraction and refraction.state == LuaEntityAbility.STATE_READY then
							me:SafeCastAbility(refraction)
						end
					end
					if (GetTick() >= (myAttackTickTable.attackRateTick - meld:FindCastPoint()*1000)) and me:CanAttack() and (not lhcreep or (lhcreep.classId == CDOTA_BaseNPC_Creep_Siege and lhcreep.team ~= me.team)) and (victim.classId ~= CDOTA_BaseNPC_Tower and victim.classId ~= CDOTA_BaseNPC_Barracks and victim.classId ~= CDOTA_BaseNPC_Building) and meld and meld.state == LuaEntityAbility.STATE_READY and GetDistance2D(me, victim) <= myhero.attackRange-25 and not isAttacking(me) and SleepCheck("meld2") and me:CanAttack() and not victim:IsAttackImmune() and victim.health > ((dmg)*(1-victim.dmgResist)+1) then
						if refraction and refraction.state == LuaEntityAbility.STATE_READY then
							me:SafeCastAbility(refraction)
						end
						me:SafeCastAbility(meld)
						entityList:GetMyPlayer():Attack(victim)
						attacking = true
						Sleep(myhero.attackRate*1000, "meld2")
					end
					if (GetTick() >= myAttackTickTable.attackRateTick) and not attacking and me:DoesHaveModifier("modifier_templar_assassin_meld") and SleepCheck("meld") and me:CanAttack() and not victim:IsAttackImmune() then
						entityList:GetMyPlayer():Attack(victim)
						attacking = true
						Sleep(myhero.attackRate*1000, "meld")
					end
				end
				OrbWalk(me)	
				if lasthitting then
					GetLasthit(me)
				end
			else
				myAttackTickTable.attackRateTick = 0 
				myAttackTickTable.attackPointTick = nil 
				attacking = false 
				victim = nil
				psivictim = nil
			end
		end
	end
end

function OrbWalk(me)
	victim = targetFind:GetClosestToMouse(700)	
	local dmg = me.dmgMin + me.dmgBonus	
	local enemies = entityList:GetEntities({type=LuaEntity.TYPE_HERO,team = me:GetEnemyTeam(),alive=true})
	local courier = entityList:GetEntities({classId=CDOTA_Unit_Courier,team=me:GetEnemyTeam(),alive=true,visible=true})[1]
	--get closest enemy
	table.sort( enemies, function (a,b) return GetDistance2D(a,me) < GetDistance2D(b,me) end )
	--find out if it is illusion or not
	for i=1,#enemies do
		if enemies[i]:IsIllusion() then
			if enemies[i+1] then
				enemies[i] = enemies[i+1]
			else
				enemies[i] = enemies[i-1]
			end
		end
	end	
	--if we got more enemies around and victim is far choose lowest HP target instead
	if ((victim and GetDistance2D(me,victim) > (myhero.attackRange + 25)) or harras) and #enemies > 1 and enemies[2] and GetDistance2D(enemies[2], me) < (myhero.attackRange + 1200) and not lhcreep then
		victim = targetFind:GetLowestEHP(1200 + myhero.attackRange, phys)
		if not harras then
			lasthitting = false
		end
	end	
	if autochase and victim and (not chasevictim or not chasevictim.alive or GetDistance2D(chasevictim,me) > (1200 + myhero.attackRange)) then
		chasevictim = victim
	end	
	local farm = {}
	local closecreeps = {}
	for i,v in pairs(creepTable) do if ((v.creepEntity.team ~= me.team and v.creepEntity.type ~= LuaEntityNPC.TYPE_HERO) or v.creepEntity.classId == CDOTA_BaseNPC_Creep_Neutral) then farm[#farm+1] = v.creepEntity end if v.creepEntity.team == me:GetEnemyTeam() and v.creepEntity.classId == CDOTA_BaseNPC_Creep_Lane and GetDistance2D(me,v.creepEntity) < 800 then closecreeps[#closecreeps+1] = v.creepEntity end end
	for i,v in pairs(farm) do if not v.alive then farm[i] = nil end end
	for i,v in pairs(closecreeps) do if not v.alive or GetDistance2D(me,v) > 800 then closecreeps[i] = nil end end
	if #closecreeps > 0 and dmg < 150 and not lh then
		harras = true 
	else
		harras = false
	end
	
	--if we spotted courier and it is close then kill him
	if courier and GetDistance2D(me, courier) < myhero.attackRange+1200 then
		victim = courier
	end
	if chasevictim and not chasevictim.visible and not invisibletime then invisibletime = client.gameTime elseif chasevictim and chasevictim.visible then invisibletime = nil end
	if chasevictim and autochase and (chasevictim.visible or (client.gameTime - invisibletime) < 5) then victim = chasevictim end
	--attacking our desired target
	local meld = me:GetAbility(2)	
	if not me:DoesHaveModifier("modifier_templar_assassin_meld") and lhcreep or ((victim and victim.visible and victim.alive and victim.health > 0 and GetDistance2D(me, victim) <= myhero.attackRange) or (psivictim and (victim and AngleBelow(me,psivictim,victim,5)) and psivictim.alive and psivictim.health > 0 and GetDistance2D(me, psivictim) <= myhero.attackRange)) and me.alive and (not meld or meld.state ~= LuaEntityAbility.STATE_READY or (victim and victim.health <= ((dmg)*(1-victim.dmgResist)+1)) or psivictim or (victim and (victim.classId == CDOTA_BaseNPC_Tower or victim.classId == CDOTA_BaseNPC_Barracks or victim.classId == CDOTA_BaseNPC_Building))) then			
		if (GetTick() >= myAttackTickTable.attackRateTick) and me:CanAttack() then
			if psivictim then
				myhero:Hit(psivictim)
				myAttackTickTable.attackRateTick = GetTick() + myhero.attackRate*1000 + (math.max((GetDistance2D(me, psivictim) - myhero.attackRange), 0)/me.movespeed)*1000 + (math.max(math.abs(FindAngleR(me) - math.rad(FindAngleBetween(me, psivictim))) - 0.69, 0))/(myhero.turnRate*(1/0.03))*1000	
			elseif victim then
				myhero:Hit(victim)
				myAttackTickTable.attackRateTick = GetTick() + myhero.attackRate*1000 + (math.max((GetDistance2D(me, victim) - myhero.attackRange), 0)/me.movespeed)*1000 + (math.max(math.abs(FindAngleR(me) - math.rad(FindAngleBetween(me, victim))) - 0.69, 0))/(myhero.turnRate*(1/0.03))*1000	
			elseif lhcreep then
				myhero:Hit(lhcreep)
				myAttackTickTable.attackRateTick = GetTick() + myhero.attackRate*1000 + (math.max((GetDistance2D(me, lhcreep) - myhero.attackRange), 0)/me.movespeed)*1000 + (math.max(math.abs(FindAngleR(me) - math.rad(FindAngleBetween(me, lhcreep))) - 0.69, 0))/(myhero.turnRate*(1/0.03))*1000	
			end						
			attacking = true
		end
	end
end	

function GetLasthit(me)	
	for creepHandle, creepClass in pairs(creepTable) do	
		if not creepClass.nolh and GetDistance2D(me, creepClass.creepEntity) < 800 then
			local Dmg = myhero:GetDamage(creepClass)
			local meld = me:GetAbility(2)	
			local meldDmg = meld:GetSpecialData("bonus_damage", meld.level)
			if creepClass.creepEntity.classId == CDOTA_BaseNPC_Creep_Siege and meld and meld.level > 0 and meld.state == LuaEntityAbility.STATE_READY then			
				Dmg = Dmg + (meldDmg*(1-creepClass.creepEntity.dmgResist)+1)
			end
			local timeToHealth = creepClass:GetTimeToHealth(Dmg)
			local nocritDmg = (myhero:GetDamage(creepClass))*2.5
			local nocrittimeToHealth = creepClass:GetTimeToHealth(nocritDmg)
			--if we can lasthit
			if (GetTick() >= myAttackTickTable.attackRateTick) and ((me.team ~= creepClass.creepEntity.team) or (not lh and me.team == creepClass.creepEntity.team and creepClass.creepEntity.health < creepClass.creepEntity.maxHealth*0.50)) then
				if creepClass.creepEntity.team ~= me.team and (nocrittimeToHealth and (nocrittimeToHealth) < (GetTick() + client.latency + myhero.attackPoint*1000 + (math.max(math.abs(FindAngleR(me) - math.rad(FindAngleBetween(me, creepClass.creepEntity))) - 0.69, 0)/(myhero.turnRate*(1/0.03)))*1000 + ((GetDistance2D(me, creepClass.creepEntity)-math.max((GetDistance2D(me, creepClass.creepEntity) - myhero.attackRange), 0))/myhero.projectileSpeed)*1000 + (math.max((GetDistance2D(me, creepClass.creepEntity) - myhero.attackRange), 0)/me.movespeed)*1000)) then
					lh = true
				end
				if Dmg > creepClass.creepEntity.health or (timeToHealth and timeToHealth <= (GetTick() + client.latency + myhero.attackPoint*1000 + ((GetDistance2D(me, creepClass.creepEntity)-math.max((GetDistance2D(me, creepClass.creepEntity) - myhero.attackRange), 0))/myhero.projectileSpeed)*1000 + (math.max((GetDistance2D(me, creepClass.creepEntity) - myhero.attackRange), 0)/me.movespeed)*1000)) then
					lhcreep = creepClass.creepEntity
					lhcreepclass = creepClass
					lhtime = timeToHealth
					if creepClass.creepEntity.team ~= me.team then
						lh = true
					end
				end
			end
		end
	end
	--check again if creep can be lasthitted, if not then stop attack
	if (isAttacking(me) or ((lhcreep and GetDistance2D(me, lhcreep) <= myhero.attackRange) or (psivictim and GetDistance2D(me, psivictim) <= myhero.attackRange))) then
		if lhcreep and lhcreep.alive and lhcreepclass then
			myhero:StopAttack(lhcreep,lhcreepclass)
		end
	end
end

class 'Hero'

	function Hero:__init(heroEntity)   
		self.heroEntity = heroEntity
		local name = heroEntity.name
		if not heroInfo[name] then
			return nil
		end
		self.projectileSpeed = heroInfo[name].projectileSpeed
		self.attackType = "Hero"
		self.armorType = "Hero"
		self.baseAttackRate = heroInfo[name].attackRate
		self.baseAttackPoint = heroInfo[name].attackPoint
		self.baseTurnRate = heroInfo[name].turnRate
		self.baseBackswing = heroInfo[name].attackBackswing
	end

	function Hero:Update()
		self:GetModifiers()		
		self.attackSpeed = self:GetAttackSpeed()
		self.attackRate = self:GetAttackRate()
		self.attackPoint = self:GetAttackPoint()
		self.attackRange = self:GetAttackRange()
		self.turnRate = self:GetTurnRate()
		self.attackBackswing = self:GetBackswing()
	end

	function Hero:GetTurnRate()
		turnRateModifiers = {modifier_batrider_sticky_napalm = .70}
		if self.modifierList then
			for modifierName, modifierPercent in pairs(turnRateModifiers) do
				if self.modifierList[modifierName] then
					return (1 - modifierPercent) * self.baseTurnRate
				end
			end
		end
		return self.baseTurnRate
	end

	function Hero:GetAttackRange()
		local bonus = 0
		local psy = self.heroEntity:GetAbility(3)
		psyrange = {60,120,180,240}		
		if psy and psy.level > 0 then		
			bonus = psyrange[psy.level]			
		end
		return self.heroEntity.attackRange + bonus + 25
	end
	
	function Hero:GetAttackSpeed()
		if self.heroEntity.attackSpeed > 500 then
			return 500
		end
		return self.heroEntity.attackSpeed
	end

	function Hero:GetAttackPoint()
		return self.baseAttackPoint / (1 + (self.heroEntity.attackSpeed) / 100)
	end

	function Hero:GetAttackRate()
		return self.heroEntity.attackBaseTime / (1 + (self.heroEntity.attackSpeed - 100) / 100)
	end
	
	function Hero:GetBackswing()
		return self.baseBackswing / (1 + (self.heroEntity.attackSpeed - 100) / 100)
	end
	
	function Hero:GetModifiers()
		local modifierCount = self.heroEntity.modifierCount
		if modifierCount == 0 then
				self.modifierList = nil
				return
		end
		self.modifierList = {}
		if self.heroEntity.modifiers then
			for i,v in ipairs(self.heroEntity.modifiers) do
				local name = v.name
				if name then
					self.modifierList[name] = true
				end
			end
		end
	end
	
	function Hero:GetDamage(target)
		local dmg
		dmg = self.heroEntity.dmgMin + self.heroEntity.dmgBonus
		if target.armorType == nil and target.creepEntity == nil then
			dmg = (math.floor(dmg * armorTypeModifiers["Hero"]["Hero"] * (1 - target.dmgResist)))	
		elseif target.armorType then 
			dmg = (math.floor(dmg * armorTypeModifiers["Hero"][target.armorType] * (1 - target.creepEntity.dmgResist)))		
		end		
		return dmg
	end

	function Hero:Hit(target)
		if target.team ~= self.heroEntity.team then
			local meld = self.heroEntity:GetAbility(2)
			if target.visible and (not lhcreep or (lhcreep.classId == CDOTA_BaseNPC_Creep_Siege and lhcreep.team ~= self.heroEntity.team)) and not psivictim and (target.classId ~= CDOTA_BaseNPC_Tower and target.classId ~= CDOTA_BaseNPC_Barracks and target.classId ~= CDOTA_BaseNPC_Building) and meld and meld.state == LuaEntityAbility.STATE_READY and GetDistance2D(self.heroEntity, target) <= self.attackRange-50 then
				self.heroEntity:SafeCastAbility(meld)
			else
				entityList:GetMyPlayer():Attack(target)
			end
		else
			entityList:GetMyPlayer():Attack(target)
		end
		attacking = true
	end
	
	function Hero:StopAttack(target,lhcreepclass)
		if target.alive and (GetDistance2D(entityList:GetMyHero(),target) <= self.attackRange or (psivictim and psivictim.alive and GetDistance2D(entityList:GetMyHero(),psivictim) <= self.attackRange)) then
			local me = entityList:GetMyHero()
			local Dmg2 = self:GetDamage(lhcreepclass)
			local meld = me:GetAbility(2)	
			local meldDmg = meld:GetSpecialData("bonus_damage", meld.level)
			if target.classId == CDOTA_BaseNPC_Creep_Siege and meld and meld.level > 0 and meld.state == LuaEntityAbility.STATE_READY then			
				Dmg2 = Dmg2 + (meldDmg*(1-target.dmgResist)+1)
			end
			local timeToHealth2 = lhcreepclass:GetTimeToHealth(Dmg2)
			if psivictim and AngleBelow(me,psivictim,target,5) then target = psivictim end
			if (lhtime and (lhtime) > (GetTick() + client.latency + self.attackPoint*1000 + ((GetDistance2D(self.heroEntity, target)-math.max((GetDistance2D(self.heroEntity, target) - self.attackRange), 0))/self.projectileSpeed)*1000)) and (lhcreep.health > Dmg2) then
				if GetTick() > myAttackTickTable.attackRateTick2 then
					entityList:GetMyPlayer():Stop()
					self:Hit(target)
					myAttackTickTable.attackRateTick = GetTick() + self.attackRate*1000 + (math.max((GetDistance2D(me, target) - self.attackRange), 0)/me.movespeed)*1000							
					myAttackTickTable.attackRateTick2 = GetTick() + self.attackPoint*500
				end
			end
		end
	end
	
class 'Creep'

	function Creep:__init(creepEntity)

		self.creepEntity = creepEntity
		self.HP = {}
		
		if self.creepEntity.classId == CDOTA_BaseNPC_Creep_Siege then
			self.creepType = "Siege Creep"
			self.attackType = "Siege"
			self.armorType = "Fortified"
			self.isRanged = true
			self.baseAttackPoint = 0.7
			self.baseAttackRate = 2.7
			self.attackRange = creepEntity.attackRange
			self.projectileSpeed = 1100
		elseif self.creepEntity.classId == CDOTA_BaseNPC_Creep_Lane and (self.creepEntity.armor == 0 or self.creepEntity.armor == 1) then
			self.creepType = "Ranged Creep"
			self.attackType = "Pierce"
			self.armorType = "Unarmored"
			self.isRanged = true
			self.baseAttackPoint = 0.5
			self.baseAttackRate = 1
			self.attackRange = creepEntity.attackRange
			self.projectileSpeed = 900
		elseif self.creepEntity.classId == CDOTA_BaseNPC_Creep_Lane and (self.creepEntity.armor == 2 or self.creepEntity.armor == 3) then
			self.creepType = "Melee Creep"
			self.attackType = "Normal"
			self.armorType = "Unarmored"
			self.isRanged = false
			self.baseAttackPoint = 0.467
			self.baseAttackRate = 1
			self.attackRange = creepEntity.attackRange
		elseif self.creepEntity.classId == CDOTA_BaseNPC_Venomancer_PlagueWard and self.creepEntity.armor == 0 then
			self.creepType = "Plague Ward"
			self.attackType = "Pierce"
			self.armorType = "Unarmored"
			self.isRanged = true
			self.baseAttackPoint = 0.3
			self.baseAttackRate = 1.5
			self.attackRange = creepEntity.attackRange
			self.projectileSpeed = 1900
		elseif self.creepEntity.classId == CDOTA_BaseNPC_Tower then
			self.creepType = "Tower"
			self.attackType = "Siege"
			self.armorType = "Fortified"
			self.isRanged = true
			self.baseAttackPoint = 0
			self.baseAttackRate = 1
			self.attackRange = creepEntity.attackRange
			self.projectileSpeed = 750
			self.nopsi = true
		elseif self.creepEntity.type == LuaEntity.TYPE_HERO then
			self.creepType = "Hero"
			self.attackType = "Hero"
			self.armorType = "Hero"
			if not heroInfo[self.creepEntity.name].projectileSpeed then
				self.isRanged = false
			else
				self.isRanged = true
				self.projectileSpeed = heroInfo[self.creepEntity.name].projectileSpeed
			end
			self.baseAttackRate = self.creepEntity.attackBaseTime
			self.baseAttackPoint = heroInfo[self.creepEntity.name].attackPoint
			self.attackRange = creepEntity.attackRange
		elseif self.creepEntity.classId == CDOTA_BaseNPC_Invoker_Forged_Spirit then
			self.creepType = "Forged Spirit"
			self.attackType = "Chaos"
			self.armorType = "Unarmored"
			self.isRanged = true
			self.baseAttackPoint = 0.2
			self.baseAttackRate = 1.5
			self.attackRange = creepEntity.attackRange
			self.projectileSpeed = 1000		
		elseif self.creepEntity.classId == CDOTA_BaseNPC_Barracks then
			self.nolh = true
			self.nopsi = true
		elseif self.creepEntity.classId == CDOTA_BaseNPC_Building then
			self.nopsi = true
			self.nolh = true
		elseif self.creepEntity.classId == CDOTA_BaseNPC_Creep then
			self.attackRange = creepEntity.attackRange
			self.attackType = "Normal"
			self.armorType = "Unarmored"
		elseif self.creepEntity.classId == CDOTA_BaseNPC_Warlock_Golem then
			self.attackRange = creepEntity.attackRange
			self.nolh = true
			self.attackType = "Chaos"
			self.armorType = "Fortified"
		end
		self.attackRate = self:GetAttackRate()
		self.attackPoint = self:GetAttackPoint()
		self.nextAttackTicks = {}

	end

	function Creep:GetTimeToHealth(health)
		numItems = 0
		for k,v in pairs(self.nextAttackTicks) do
			numItems = numItems + 1
		end
		if numItems > 0 then
			local sortedTable = { }
			for k, v in pairs(self.nextAttackTicks) do table.insert(sortedTable, v) end
			table.sort(sortedTable, function(a,b) return a[2] < b[2] end)
			
			local totalDamage = 0
			local totalTime = 0
			
			for i = 1, 8 do
				for _, nextAttackTickTable in ipairs(sortedTable) do					
					local hploss = (self.HP.previous - self.HP.current)
					if nextAttackTickTable[2] > GetTick() and nextAttackTickTable[1].creepEntity.alive and nextAttackTickTable[1].attackType and self.armorType then
						totalDamage = totalDamage + (math.floor((nextAttackTickTable[1].creepEntity.dmgMin + nextAttackTickTable[1].creepEntity.dmgBonus) * armorTypeModifiers[nextAttackTickTable[1].attackType][self.armorType] * (1 - self.creepEntity.dmgResist)))						
						if (self.creepEntity.health - totalDamage) < health then
							return (nextAttackTickTable[2]*i) + (nextAttackTickTable[4]/i)
						end
					end
				end
			end
		end
		return nil
	end

	function Creep:Update()
		if not self.nolh then
			self.attackRate = self:GetAttackRate()
			self.attackPoint = self:GetAttackPoint()

			self:UpdateHealth()

			for k, nextAttackTickTable in pairs(self.nextAttackTicks) do
				if (GetTick() > nextAttackTickTable[3]) or not nextAttackTickTable[1].creepEntity.alive then
					self.nextAttackTicks[k] = nil
				end
			end

			self:MapDamageSources()
		end
	end

	function Creep:GetAttackRate()
		return self.creepEntity.attackBaseTime / (1 + (self.creepEntity.attackSpeed - 100) / 100)
	end
	
	function Creep:GetAttackPoint()
		if self.baseAttackPoint then
			return self.baseAttackPoint / (1 + (self.creepEntity.attackSpeed - 100) / 100)
		else
			return 0
		end
	end

	function Creep:MapDamageSources()
		for creepHandle, creepClass in pairs(creepTable) do
			if not self.nolh and creepClass.attackRange and self.creepEntity.team ~= creepClass.creepEntity.team and creepClass.creepEntity.alive then
				local timeToDamageHit = 0
				local nextAttackTick = 0
				for k,z in ipairs(entityList:GetProjectiles({source=creepClass.creepEntity,target=self.creepEntity})) do
					if not self.nextAttackTicks[creepClass.creepEntity.handle] then
						nextAttackTick = creepClass.attackPoint*1000 + client.latency
						timeToDamageHit = (GetDistance2D(z.position, self.creepEntity)/z.speed)*1000 + GetTick()
						self.nextAttackTicks[creepClass.creepEntity.handle] = {creepClass, timeToDamageHit, GetTick() + nextAttackTick, nextAttackTick,true}						
					end
				end
				if math.abs(FindAngleR(creepClass.creepEntity) - math.rad(FindAngleBetween(creepClass.creepEntity, self.creepEntity))) < 0.014 then
					if not self.nextAttackTicks[creepClass.creepEntity.handle] then
						if GetDistance2D(creepClass.creepEntity, self.creepEntity) <= 153 and creepClass.attackRange then
							nextAttackTick = creepClass.attackPoint*1000 + client.latency
							timeToDamageHit = (math.max(GetDistance2D(creepClass.creepEntity, self.creepEntity) - creepClass.attackRange,0)/creepClass.creepEntity.movespeed)*1000 + (((creepClass.projectileSpeed) and ((GetDistance2D(creepClass.creepEntity, self.creepEntity)/creepClass.projectileSpeed)*1000)) or 0) + GetTick() + creepClass.attackPoint*1000 + client.latency
							self.nextAttackTicks[creepClass.creepEntity.handle] = {creepClass, timeToDamageHit, GetTick() + nextAttackTick, nextAttackTick,false}		
						elseif not creepClass.isRanged and GetDistance2D(creepClass.creepEntity, self.creepEntity) > 153 and not isAttacking(creepClass.creepEntity) and creepClass.attackRange then 
							nextAttackTick = creepClass.attackRate*1000 + (math.max(GetDistance2D(creepClass.creepEntity, self.creepEntity) - creepClass.attackRange,0)/creepClass.creepEntity.movespeed)*1000 + client.latency
							timeToDamageHit = (math.max(GetDistance2D(creepClass.creepEntity, self.creepEntity) - creepClass.attackRange,0)/creepClass.creepEntity.movespeed)*1000 + GetTick() + creepClass.attackPoint*1000
							self.nextAttackTicks[creepClass.creepEntity.handle] = {creepClass, timeToDamageHit, GetTick() + nextAttackTick, nextAttackTick,false}
						end
					end
				end
			end
		end
		
	end

	function Creep:UpdateHealth()

		self.HP.previous = self.HP.current or 0
		self.HP.current = self.creepEntity.health
		
	end

function FindAngleR(entity)
	if entity.rotR < 0 then
		return math.abs(entity.rotR)
	else
		return 2 * math.pi - entity.rotR
	end
end

function FindAngleBetween(first, second)
	if first and second then
		local xAngle = math.deg(math.atan(math.abs(second.position.x - first.position.x)/math.abs(second.position.y - first.position.y)))
		if first.position.x <= second.position.x and first.position.y >= second.position.y then
			return 90 - xAngle
		elseif first.position.x >= second.position.x and first.position.y >= second.position.y then
			return xAngle + 90
		elseif first.position.x >= second.position.x and first.position.y <= second.position.y then
			return 90 - xAngle + 180
		elseif first.position.x <= second.position.x and first.position.y <= second.position.y then
			return xAngle + 90 + 180
		end
	end
	return 0
end

function AngleBelow(myHero,nearestHero,targetHero,angle)
	local myPos = Vector2D(myHero.position.x,myHero.position.y)
	local nearestHeroPos = Vector2D(nearestHero.position.x,nearestHero.position.y)
	local targetHeroPos = Vector2D(targetHero.position.x,targetHero.position.y)
	local t1 = (nearestHeroPos - myPos)
	local t2 = (targetHeroPos - myPos)
	return math.abs(math.deg(math.atan2(t2.y, t2.x) - math.atan2(t1.y, t1.x))) <= angle
end

function UpdateMyHero(me)
	myhero:Update()	
	local myprojectiles = entityList:GetProjectiles({source=me})
	local attacked = false
	for k,z in ipairs(myprojectiles) do
		if lhcreep then									
			if lh then
				lh = false
			end
			attacked = true
			lhcreep = nil
			lhcreepclass = nil
			attacking = false
			myAttackTickTable.attackRateTick2 = 0
		end
		if myAttackTickTable.attackPointTick == nil and (myAttackTickTable.attackRateTick == 0 or myAttackTickTable.attackRateTick > GetTick()) then--and ((victim and GetDistance2D(z.position, victim) > GetDistance2D(z.position, me)) or (psivictim and GetDistance2D(z.position, psivictim) > GetDistance2D(z.position, me))) then
			myAttackTickTable.attackPointTick = GetTick()
			attacking = false
		end			
	end	
	if isAttacking(me) then
		if myAttackTickTable.attackRateTick == 0 then
			myAttackTickTable.attackRateTick = GetTick() + myhero.attackRate*1000
		end
	end
	if lhcreep and not lhcreep.alive then
		lhcreep = nil
		lhcreepclass = nil
		attacking = false
		if lh then
			lh = false
		end
		if not attacked then
			myAttackTickTable.attackRateTick = 0
		end
		myAttackTickTable.attackPointTick = GetTick()
		myAttackTickTable.attackRateTick2 = 0
	end
	if victim and not victim.alive then
		victim = nil
		attacking = false
		myAttackTickTable.attackPointTick = GetTick()
	end
	if psivictim and not psivictim.alive then
		psivictim = nil
		myAttackTickTable.attackPointTick = GetTick()
	end
	if myAttackTickTable.attackPointTick and GetTick() >= myAttackTickTable.attackPointTick then
		myAttackTickTable.attackPointTick = nil
		attacking = false
	end
end

function GetCreeps(me)
	local entities = {}
	local creeps, siege, neutrals, towers, barracks, others, heroes, spirits, summons, golems, wards 
	if lasthitting or victim or harras or psivictim then
		creeps = entityList:GetEntities({classId=CDOTA_BaseNPC_Creep_Lane,alive=true,visible=true})
		siege = entityList:GetEntities({classId=CDOTA_BaseNPC_Creep_Siege,alive=true,visible=true})
		towers = entityList:GetEntities({classId=CDOTA_BaseNPC_Tower,alive=true,visible=true})
		neutrals = entityList:GetEntities({classId=CDOTA_BaseNPC_Creep_Neutral,alive=true,visible=true})
		heroes = entityList:GetEntities({type=LuaEntity.TYPE_HERO,alive=true,visible=true})
		spirits = entityList:GetEntities({classId=CDOTA_BaseNPC_Invoker_Forged_Spirit,alive=true,team=me:GetEnemyTeam(),visible=true})
		summons = entityList:GetEntities({classId=CDOTA_BaseNPC_Creep,alive=true,team=me:GetEnemyTeam(),visible=true})
		wards = entityList:GetEntities({classId=CDOTA_BaseNPC_Venomancer_PlagueWard,alive=true,visible=true})
		golems = entityList:GetEntities({classId=CDOTA_BaseNPC_Warlock_Golem,alive=true,team=me:GetEnemyTeam(),visible=true})
		for _, dEntity in ipairs(creeps) do
		if dEntity.spawned and dEntity.alive and GetDistance2D(me, dEntity) < myhero.attackRange+800 and not creepTable[dEntity.handle] and not dEntity:IsInvul() and not dEntity:IsAttackImmune() then
			creepTable[dEntity.handle] = Creep(dEntity)
		end	
		end
		for _, dEntity in ipairs(siege) do
			if dEntity.spawned and dEntity.alive and GetDistance2D(me, dEntity) < myhero.attackRange+800 and not creepTable[dEntity.handle] and not dEntity:IsInvul() and not dEntity:IsAttackImmune() then
				creepTable[dEntity.handle] = Creep(dEntity)
			end	
		end
		for _, dEntity in ipairs(neutrals) do
			if dEntity.spawned and dEntity.alive and GetDistance2D(me, dEntity) < myhero.attackRange+800 and not creepTable[dEntity.handle] and not dEntity:IsInvul() and not dEntity:IsAttackImmune() then
				creepTable[dEntity.handle] = Creep(dEntity)
			end	
		end
		for _, dEntity in ipairs(towers) do
			if dEntity.alive and GetDistance2D(me, dEntity) < myhero.attackRange+800 and not creepTable[dEntity.handle] and not dEntity:IsInvul() and not dEntity:IsAttackImmune() then
				creepTable[dEntity.handle] = Creep(dEntity)
			end	
		end
		for _, dEntity in ipairs(heroes) do
		if dEntity.handle ~= me.handle and dEntity.alive and GetDistance2D(me, dEntity) < myhero.attackRange+800 and not creepTable[dEntity.handle] and not dEntity:IsInvul() and not dEntity:IsAttackImmune() then
			creepTable[dEntity.handle] = Creep(dEntity)
		end	
		end
		for _, dEntity in ipairs(spirits) do
			if dEntity.alive and GetDistance2D(me, dEntity) < myhero.attackRange+800 and not creepTable[dEntity.handle] and not dEntity:IsInvul() and not dEntity:IsAttackImmune() then
				creepTable[dEntity.handle] = Creep(dEntity)
			end	
		end
		for _, dEntity in ipairs(summons) do
			if dEntity.alive and GetDistance2D(me, dEntity) < myhero.attackRange+800 and not creepTable[dEntity.handle] and not dEntity:IsInvul() and not dEntity:IsAttackImmune() then
				creepTable[dEntity.handle] = Creep(dEntity)
			end	
		end
		for _, dEntity in ipairs(golems) do
			if dEntity.alive and GetDistance2D(me, dEntity) < myhero.attackRange+800 and not creepTable[dEntity.handle] and not dEntity:IsInvul() and not dEntity:IsAttackImmune() then
				creepTable[dEntity.handle] = Creep(dEntity)
			end	
		end
		for _, dEntity in ipairs(wards) do
			if dEntity.alive and GetDistance2D(me, dEntity) < myhero.attackRange+800 and not creepTable[dEntity.handle] and not dEntity:IsInvul() and not dEntity:IsAttackImmune() then
				creepTable[dEntity.handle] = Creep(dEntity)
			end	
		end
	end
	if not lasthitting and not victim and not harras and not psivictim then
		barracks = entityList:GetEntities({classId=CDOTA_BaseNPC_Barracks,alive=true,team=me:GetEnemyTeam(),visible=true})
		others = entityList:GetEntities({classId=CDOTA_BaseNPC_Building,alive=true,team=me:GetEnemyTeam(),visible=true})
			for _, dEntity in ipairs(barracks) do
		if dEntity.alive and GetDistance2D(me, dEntity) < myhero.attackRange+800 and not creepTable[dEntity.handle] and not dEntity:IsInvul() and not dEntity:IsAttackImmune() then
			creepTable[dEntity.handle] = Creep(dEntity)
		end	
		end
		for _, dEntity in ipairs(others) do
			if dEntity.alive and GetDistance2D(me, dEntity) < myhero.attackRange+800 and not creepTable[dEntity.handle] and not dEntity:IsInvul() and not dEntity:IsAttackImmune() then
				creepTable[dEntity.handle] = Creep(dEntity)
			end	
		end
	end
	for creepHandle, creepClass in pairs(creepTable) do
		if not creepClass.creepEntity.visible or not creepClass.creepEntity.alive or GetDistance2D(me, creepClass.creepEntity) > myhero.attackRange+800 then
			creepTable[creepHandle] = nil
		else
			creepClass:Update()
		end
	end
end

function isAttacking(ent)
	if ent.activity == LuaEntityNPC.ACTIVITY_ATTACK or ent.activity == LuaEntityNPC.ACTIVITY_ATTACK1 or ent.activity == LuaEntityNPC.ACTIVITY_ATTACK2 then
		return true
	end
	return false
end

function IsActive(lh)
	if lh then
		if lasthitting then
			return "ON"
		else
			return "OFF"
		end
	else
		if active then
			return "ON"
		else
			return "OFF"
		end
	end
end

function CanBeSlowed(target)
	return not target:IsMagicImmune() and not target:IsInvul() and not target:DoesHaveModifier("modifier_rune_haste") and not target:DoesHaveModifier("modifier_lycan_shapeshift") and not target:DoesHaveModifier("modifier_centaur_stampede")
end

function Load()
	if PlayingGame() then
		local me = entityList:GetMyHero()
		if not me or me.classId ~= CDOTA_Unit_Hero_TemplarAssassin then 
			script:Disable()
		else
			statusText.visible = false
			chaseText.visible = false
			myhero = nil
			reg = true
			myId = me.classId
			victim = nil
			psivictim = nil
			lhcreepclass = nil
			lhcreep = nil
			lh = false
			lasthitting = false
			creepTable = {}
			moveposition = nil
			autochase = false 
			chasevictim = nil
			invisibletime = nil
			script:RegisterEvent(EVENT_TICK, Main)
			script:RegisterEvent(EVENT_KEY, Key)
			script:UnregisterEvent(Load)
		end
	end	
end

function Close()
	statusText.visible = false
	chaseText.visible = false
	myhero = nil
	myId = nil
	victim = nil
	psivictim = nil
	lhcreepclass = nil
	lhcreep = nil
	lh = false
	lasthitting = false
	creepTable = {}
	moveposition = nil
	autochase = false 
	chasevictim = nil
	invisibletime = nil
	if reg then
		script:UnregisterEvent(Main)
		script:UnregisterEvent(Key)
		script:RegisterEvent(EVENT_TICK, Load)	
		reg = false
	end
end

script:RegisterEvent(EVENT_CLOSE, Close)
script:RegisterEvent(EVENT_TICK, Load)
