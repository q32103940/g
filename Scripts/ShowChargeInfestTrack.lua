require("libs.Utils")

infest = {} charge = {} snipe = {} track = {} cold = {}

list = {
{infest,"modifier_life_stealer_infest_effect","life_stealer_infested_unit_icon",250},
{charge,"modifier_spirit_breaker_charge_of_darkness_vision","spirit_breaker_charge_target_mark",250},
{snipe,"modifier_sniper_assassinate","fire_torch",250},
{track,"modifier_bounty_hunter_track","bounty_hunter_track_Shield",250},
{cold,"modifier_cold_feet","range_display",0,740}
}

function Tick(tick)

	if not client.connected or client.loading or client.console or not entityList:GetMyHero() or not SleepCheck() then return end
	
	local hero = entityList:FindEntities({type=LuaEntity.TYPE_HERO,illusion=false})	
	for i,v in ipairs(hero) do local OnScreen = client:ScreenPosition(v.position)
		if OnScreen then
			for _,k in ipairs(list) do			
				if v.visible and v.alive and OnScreen then
					if v:FindModifier(k[2]) then					
						if k[1][v.handle] == nil then
							k[1][v.handle] = Effect(Vector(v.position.x, v.position.y, v.position.z),k[3])						
							if k[5] then
								k[1][v.handle]:SetVector(1,Vector(k[5],0,0))
								k[1][v.handle]:SetVector(0,Vector(v.position.x, v.position.y, v.position.z))							
							end					
						end
					else
						if not k[1][v.handle] ~= nil then
							k[1][v.handle] = nil
							collectgarbage("collect")						
						end					
					end
				end
			end
		end
	end
	Sleep(100)	
end

function Frame(tick)

	local hero = entityList:FindEntities({type=LuaEntity.TYPE_HERO,illusion=false})	
	if #hero > 0 then
		for i,v in ipairs(hero) do
			for _,k in ipairs(list) do	
				if k[1][v.handle] ~= nil and k[5] == nil then					
					k[1][v.handle]:SetVector(0, Vector(v.position.x, v.position.y, v.position.z+k[4]) )
				end	
			end
		end
	end
	
end

function GameClose()
	infest = {} charge = {} 
	snipe = {} track = {} cold = {}
end
 
script:RegisterEvent(EVENT_CLOSE,GameClose)
script:RegisterEvent(EVENT_FRAME,Frame)
script:RegisterEvent(EVENT_TICK,Tick)
