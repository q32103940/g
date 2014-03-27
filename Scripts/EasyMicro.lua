--Test(mb some bugs)
--[[  Caps Lock - neutral controlled units cast spells on the nearest to mouse target.
      Если нажать на капс, то подконтрольные юниты используют спелы на ближайшего к курсору вражеского героя.
]]--


require("libs.Utils")
require("libs.Creeps")

function Tick(tick)
 
	if not client.connected or client.loading or client.console or not entityList:GetMyHero() then return end

	me = entityList:GetMyHero() 
	real = {}

	local creep = entityList:GetEntities({classId = {CDOTA_BaseNPC_Creep_Neutral,284},alive=true,visible=true})
	local enemy = entityList:GetEntities({type=LuaEntity.TYPE_HERO,illusion = false,alive=true,visible=true})

	if Cast then
		for i,creep in ipairs(creep) do
			if creep.controllable then
				if list[creep.name] then
					if SleepCheck(creep.name) then
						local Spell = creep:GetAbility(list[creep.name].Spell)
						local Range = list[creep.name].Range
						if list[creep.name].Type == 0 then																																	
							if GetDistance2D(creep,hero) < Range and Spell.state == -1 then
								local t_ = GetLastMouseOver(Range)
								if t_ ~= nil then
									SmartCast(Spell,creep,t_)
									Sleep(list[creep.name].Sleep,creep.name)
								end
							end							
						elseif	list[creep.name].Type == 1 then								
							if Spell.state == -1  then
								if me:IsHexed() or me:IsSilenced() or me:IsDisarmed() or me:IsRooted() then										
									SmartCast(Spell,creep,me)
									Sleep(list[creep.name].Sleep,creep.name)
								end
							end
						elseif	list[creep.name].Type == 2 then								
							if Spell.state == -1  then																			
								SmartCast(Spell,creep,me)
								Sleep(list[creep.name].Sleep,creep.name)
							end
						end						
					end
				end
			end		
		end	
	end

end

function Key()
	if IsKeyDown(0x14) then
		Cast = true
	else
		Cast = false
	end
end


function SmartCast(Spell,Sourse,v_)
	local target = list[Sourse.name].Target
	if target == "target" then
		Sourse:SafeCastAbility(Spell,v_)
	elseif target == "area" then
		Sourse:SafeCastAbility(Spell,v_.position)
	elseif target == "nontarget" then
		Sourse:SafeCastAbility(Spell)
	end
end

function GetClosestToMouse(range)
	local lowenemy = nil
	local enemies = entityList:FindEntities({type=LuaEntity.TYPE_HERO, distance = {entityList:GetMyHero(),range}})
	for i,v in ipairs(enemies) do
		if v.GetDistance2D ~= nil and v.team ~= entityList:GetMyHero().team and v.team ~= 0 and v.team ~= 1 and v.team ~= 5 then
			local distance = v:GetDistance2D(client.mousePosition)
			local distance2 = v:GetDistance2D(entityList:GetMyHero())
			if  v.alive and v.visible and not v.illusion and distance2 <= range then 
				if lowenemy == nil then
					lowenemy = v
				elseif distance < lowenemy:GetDistance2D(client.mousePosition) then
					lowenemy = v
				end
			end
		end
	end
	return lowenemy
end

function GetLastMouseOver(range)

	local _enemies = entityList:FindEntities({type=LuaEntity.TYPE_HERO, team = TEAM_ENEMY, distance = {entityList:GetMyHero(),range}})
	local real = {}
	for i,v in ipairs(_enemies) do
		if not v.illusion and v.visible and v.alive then
			table.insert(real,v)
		end
	end
	if #real == 1 then
		return real[1]
	else
		return GetClosestToMouse(range)
	end

end

function RangePred(sourse,spell,t,speed,cast,range)
	print(GetDistance2D(sourse,Vector(t.position.x + t.movespeed * (GetDistance2D(t,sourse)/(speed * math.sqrt(1 - math.pow(t.movespeed/speed,2))) + cast) * math.cos(t.rotR), t.position.y + t.movespeed * (GetDistance2D(t,sourse)/(speed * math.sqrt(1 - math.pow(t.movespeed/speed,2))) + cast) * math.sin(t.rotR), t.position.z)))
	if GetDistance2D(sourse,Vector(t.position.x + t.movespeed * (GetDistance2D(t,sourse)/(speed * math.sqrt(1 - math.pow(t.movespeed/speed,2))) + cast) * math.cos(t.rotR), t.position.y + t.movespeed * (GetDistance2D(t,sourse)/(speed * math.sqrt(1 - math.pow(t.movespeed/speed,2))) + cast) * math.sin(t.rotR), t.position.z)) < range then return true end return false
end

function CastPred(who,spell,t,speed,cast)
who:SafeCastAbility(spell,Vector(t.position.x + t.movespeed * (GetDistance2D(t,me)/(speed * math.sqrt(1 - math.pow(t.movespeed/speed,2))) + cast) * math.cos(t.rotR), t.position.y + t.movespeed * (GetDistance2D(t,me)/(speed * math.sqrt(1 - math.pow(t.movespeed/speed,2))) + cast) * math.sin(t.rotR), t.position.z))
end
script:RegisterEvent(EVENT_TICK,Tick)
script:RegisterEvent(EVENT_KEY,Key)
