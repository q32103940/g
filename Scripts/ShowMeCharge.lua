require("libs.Utils")
require("libs.Res")

rect = {}
ch = {}
speed = {600,650,700,750}
sleeptick = 0
start = true
eff = drawMgr:CreateRect(0,0,20,20,0x000000ff,drawMgr:GetTextureId("NyanUI/miniheroes/spirit_breaker"))
eff.visible = false

function Tick(tick)

	if not client.connected or client.loading or client.console or tick < sleeptick then return end

	sleeptick = tick + 200

	local me = entityList:GetMyHero()
	
	if not me then return end

	local hero = entityList:FindEntities({type=LuaEntity.TYPE_HERO,illusion=false})

	for i,v in ipairs(hero) do
	
		if v.name == "npc_dota_hero_spirit_breaker" then
			eff.visible = not v.visible
			if aa and v.visible then time = client.gameTime end
			if v:GetAbility(1) and v:GetAbility(1).level ~= 0 then
				speeed = speed[v:GetAbility(1).level]
			else
				speeed = 600
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
				rect[v.handle] = {}  rect[v.handle] = drawMgr:CreateRect(-10,-60,26,26,0xFF8AB160,drawMgr:GetTextureId("NyanUI/miniheroes/spirit_breaker")) rect[v.handle].visible = false 
				rect[v.handle].entity = v rect[v.handle].entityPosition = Vector(0,0,offset)
			end
			
			if v.visible and v.alive then
				if v:DoesHaveModifier("modifier_spirit_breaker_charge_of_darkness_vision") then	
					rect[v.handle].visible = true
					showme = true
					pos = v.position
				else
					rect[v.handle].visible = false					
					showme = false
					if aa then aa = nil end
				end
			else
				showme = false
				rect[v.handle].visible = false
			end
		end
	end
	
	if showme then
		local cast = entityList:GetEntities({classId=CDOTA_BaseNPC})
		for _,v in ipairs(cast) do
			if v.dayVision == 0 and v.unitState == 59802112 then
				if not aa then
					aa = true
					time = client.gameTime					
				end
				local distance = GetDistance2D(me,v)
				local Ddistance = distance - (client.gameTime - time)*speeed
				local minimap = MapToMinimap((v.position.x - me.position.x) * Ddistance / GetDistance2D(v,me) + me.position.x,(v.position.y - me.position.y) * Ddistance / GetDistance2D(v,me) + me.position.y)
				eff.x = minimap.x-20/2
				eff.y = minimap.y-20/2
			else				
				eff.visible = false
			end
		end
	else
		aa = nil
		eff.visible = false
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
