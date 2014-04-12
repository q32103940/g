require("libs.Utils")
require("libs.Creeps")

key = 0x14 --caps lock

function Key(msg,code)
	-- check if ingame and not chatting
    if msg ~= KEY_UP or code ~= key or client.chat or not client.connected or client.loading or client.console then
    	return
    end

    -- check if we already picked a hero
    local me = entityList:GetMyHero()
    if not me then
    	return
    end
	
	local creep = entityList:GetEntities({classId = {CDOTA_BaseNPC_Creep_Neutral,284},alive=true,visible=true})

	for i,creep in ipairs(creep) do
		if creep.controllable then
			if list[creep.name] then
				local Spell = creep:GetAbility(list[creep.name].Spell)
				local Range = list[creep.name].Range
				local Type = list[creep.name].Type
				local t_ = GetLastMouseOver(1000)
				if Type == 0 then
					if t_ then
						if GetDistance2D(creep,t_) < Range + 250 and Spell.state == -1 then						
							SmartCast(Spell,creep,t_)							
						end
					end
				elseif	Type == 1 then								
					if Spell.state == -1  then
						if me:IsHexed() or me:IsSilenced() or me:IsDisarmed() or me:IsRooted() then										
							SmartCast(Spell,creep,me)							
						end
					end
				elseif Type == 3 then				
					if Spell.state == -1 then						
						SmartCast(Spell,creep,t_)							
					end								
				elseif Type == 2 then								
					if Spell.state == -1  then																			
						SmartCast(Spell,creep,me)						
					end					
				end
			end
		end		
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
	local enemies = entityList:FindEntities({type=LuaEntity.TYPE_HERO, illusion = false, alive = true , visible = true, distance = {entityList:GetMyHero(),range}})
	for i,v in ipairs(enemies) do
		if v.GetDistance2D ~= nil and v.team ~= entityList:GetMyHero().team then
			local distance = v:GetDistance2D(client.mousePosition)
			local distance2 = v:GetDistance2D(entityList:GetMyHero())
			if v.team ~= entityList:GetMyHero().team and distance2 <= range then 
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

	local _enemies = entityList:FindEntities({type=LuaEntity.TYPE_HERO, illusion = false, alive = true , visible = true, distance = {entityList:GetMyHero(),range}})
	local real = {}
	for i,v in ipairs(_enemies) do
		if v.team ~= entityList:GetMyHero().team then
			table.insert(real,v)
		end
	end
	if #real == 1 then
		return real[1]
	else
		return GetClosestToMouse(range)
	end

end

script:RegisterEvent(EVENT_KEY,Key)
