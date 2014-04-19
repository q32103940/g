require("libs.Utils")

rect = {}
sleeptick = 0

function Tick(tick)

	if not client.connected or client.loading or client.console or tick < sleeptick then return end

	sleeptick = tick + 250

	local me = entityList:GetMyHero()
	
	if not me then return end

	local hero = entityList:FindEntities({type=LuaEntity.TYPE_HERO,illusion=false})

	for i,v in ipairs(hero) do

		if v.team == me.team then

			local offset = v.healthbarOffset

			if offset == -1 then return end

			if not rect[v.handle] then 
				rect[v.handle] = {}  rect[v.handle] = drawMgr:CreateRect(-10,-80,22,22,0xFF8AB160,drawMgr:GetTextureId("NyanUI/miniheroes/spiritbreaker")) rect[v.handle].visible = false 
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
end
 
script:RegisterEvent(EVENT_CLOSE,GameClose)
script:RegisterEvent(EVENT_TICK,Tick)
