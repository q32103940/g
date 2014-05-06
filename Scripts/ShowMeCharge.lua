require("libs.Utils")
require("libs.Res")

rect = {}
ch = {}
speed = {600,650,700,750}
sleeptick = 0
start = true
speeed = 600
aa = {}

function Tick(tick)

	if not client.connected or client.loading or client.console or tick < sleeptick then return end

	sleeptick = tick + 200

	local me = entityList:GetMyHero()
	
	if not me then return end

	local hero = entityList:FindEntities({type=LuaEntity.TYPE_HERO,illusion=false})

	for i,v in ipairs(hero) do
	
		if v.name == "npc_dota_hero_spirit_breaker" then
			if v.visible then time = client.gameTime end
			if v:GetAbility(1) and v:GetAbility(1).level ~= 0 then
				speeed = speed[v:GetAbility(1).level]
			end
		end
			
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
				rect[v.handle] = {}  rect[v.handle].main = drawMgr:CreateRect(-10,-60,26,26,0xFF8AB160,drawMgr:GetTextureId("NyanUI/miniheroes/spirit_breaker")) rect[v.handle].main.visible = false 
				rect[v.handle].main.entity = v rect[v.handle].main.entityPosition = Vector(0,0,offset)
				rect[v.handle].map = drawMgr:CreateRect(0,0,20,20,0xFF8AB160,drawMgr:GetTextureId("NyanUI/miniheroes/spirit_breaker")) rect[v.handle].map.visible = false 
			end
			
			if v.visible and v.alive then
				if v:DoesHaveModifier("modifier_spirit_breaker_charge_of_darkness_vision") then	
					rect[v.handle].main.visible = true
					rect[v.handle].map.visible = true
					local cast = entityList:GetEntities({classId=CDOTA_BaseNPC})
					for _,k in ipairs(cast) do
						if k.dayVision == 0 and k.unitState == 59802112 then
							if not aa[v.handle] then
								aa[v.handle] = true
								time = client.gameTime
							end							
							local distance = GetDistance2D(v,k)
							local Ddistance = distance - (client.gameTime - time)*speeed
							local minimap = MapToMinimap((k.position.x - v.position.x) * Ddistance / GetDistance2D(k,v) + v.position.x,(k.position.y - v.position.y) * Ddistance / GetDistance2D(k,v) + v.position.y)
							rect[v.handle].map.x = minimap.x-20/2
							rect[v.handle].map.y = minimap.y-20/2
						end
					end					
				else
					aa[v.handle] = nil
					rect[v.handle].main.visible = false
					rect[v.handle].map.visible = false
				end
			else	
				aa[v.handle] = nil
				rect[v.handle].main.visible = false
				rect[v.handle].map.visible = false
			end
		end
	end	
		

end

function GameClose()
	rect = {}	
	ch = {}
	hero = nil
	start = true
	eff.visible = false
	showme = false
	aa = nil
end
 
script:RegisterEvent(EVENT_CLOSE,GameClose)
script:RegisterEvent(EVENT_TICK,Tick)
