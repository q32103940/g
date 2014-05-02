require("libs.Utils")

rect = {}
ch = {}
sleeptick = 0
start = true

function Tick(tick)

	if not client.connected or client.loading or client.console or tick < sleeptick then return end

	sleeptick = tick + 250

	local me = entityList:GetMyHero()
	
	if not me then return end

	local hero = entityList:FindEntities({type=LuaEntity.TYPE_HERO,illusion=false})

	for i,v in ipairs(hero) do
			
		if start and #hero == 10 then
			if v.team ~= me.team then
				table.insert(ch,v.name)
				if #ch == 5 then
					if ch[1] ~= "npc_dota_hero_spirit_breaker" and ch[2] ~= "npc_dota_hero_spirit_breaker" and ch[3] ~= "npc_dota_hero_spirit_breaker" and ch[4] ~= "npc_dota_hero_spirit_breaker" and ch[5] ~= "npc_dota_hero_spirit_breaker" then
						script:Disable()
					else
						start = false						
					end
				end
			end			
		end
			
		if v.team == me.team then
			local offset = v.healthbarOffset
			if offset == -1 then return end

			if not rect[v.handle] then 
				rect[v.handle] = {}  rect[v.handle] = drawMgr:CreateRect(-10,-60,26,26,0xFF8AB160,drawMgr:GetTextureId("NyanUI/miniheroes/spirit_breaker")) rect[v.handle].visible = false 
				rect[v.handle].entity = v rect[v.handle].entityPosition = Vector(0,0,offset)
			end
			
			if v.visible and v.alive then
				if v:DoesHaveModifier("modifier_spirit_breaker_charge_of_darkness_vision") then	
					rect[v.handle].visible = true
				else
					rect[v.handle].visible = false
				end
			else
				rect[v.handle].visible = false
			end
		end
	end

end

function GameClose()
	rect = {}	
	ch = {}
	hero = nil
	start = true
end
 
script:RegisterEvent(EVENT_CLOSE,GameClose)
script:RegisterEvent(EVENT_TICK,Tick)
