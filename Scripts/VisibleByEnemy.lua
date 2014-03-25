eff = {}
 
function Tick()
 
	if not client.connected or client.loading or client.console or not entityList:GetMyHero() then return end 

	me = entityList:GetMyHero()
		local hero = entityList:FindEntities({type=LuaEntity.TYPE_HERO, alive = true, illusion = false})
		for i, v in ipairs(hero) do local OnScreen = client:ScreenPosition(v.position)	
			if OnScreen and v.team == me.team then
			
				if v.name == me.name then 
					effect = "aura_shivas" 
				else 
					effect = "ambient_gizmo_model" 
				end
				
				local visible = v.visibleToEnemy
				if eff[v.handle] == nil and visible then	
					if v:GetProperty("CDOTA_BaseNPC","m_iTaggedAsVisibleByTeam") == 30 then						    
						eff[v.handle] = Effect(v,effect)
						eff[v.handle]:SetVector(1,Vector(0,0,0))
					end
				elseif not visible and eff[v.handle] ~= nil then
					eff[v.handle] = nil
					collectgarbage("collect")					
				end					
			end
		end

end

function GameClose()
	eff = {}
	collectgarbage("collect")
end


script:RegisterEvent(EVENT_CLOSE, GameClose)
script:RegisterEvent(EVENT_TICK,Tick)
