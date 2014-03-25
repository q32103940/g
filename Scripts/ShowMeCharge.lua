require("libs.Utils")

charge = {}
bara = false

function Tick(tick)

	if not client.connected or client.loading or client.console or not entityList:GetMyHero() then return end
	
	local me = entityList:GetMyHero()
	local hero = entityList:FindEntities({type=LuaEntity.TYPE_HERO,illusion=false,alive = true})
		
	for i,v in ipairs(hero) do local OnScreen = client:ScreenPosition(v.position)

		if not bara then
			if #hero == 10 then
				allpick = true
			end
			if allpick then
				if v.team ~= me.team then
					if v.name ~= "npc_dota_hero_spirit_breaker" then				
					script:Disable()					
					else					
					bara = true
					end
				end
			end
		end
		
		if OnScreen and v.team == me.team then
			if charge[v.handle] ~= nil then
				charge[v.handle]:SetVector(0, Vector(v.position.x, v.position.y, v.position.z+250) )
			end		
			if SleepCheck(v.handle) then
				if v:DoesHaveModifier("modifier_spirit_breaker_charge_of_darkness_vision") then					
					if charge[v.handle] == nil then
						charge[v.handle] = Effect(Vector(v.position.x, v.position.y, v.position.z),"spirit_breaker_charge_target_mark")								
					end
				else
					if not charge[v.handle] ~= nil then
						charge[v.handle] = nil
						collectgarbage("collect")						
					end
				end	Sleep(125,v.handle)
			end
		end
	end
	
end

function GameClose()
	charge = {}
	bara = false
	allpick = false
end
 
script:RegisterEvent(EVENT_CLOSE,GameClose)
script:RegisterEvent(EVENT_TICK,Tick)
