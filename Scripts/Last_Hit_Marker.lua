--lash hit market
rect = {}

function Tick( tick )

	if not client.connected or client.loading or client.console then return end
	
	local me = entityList:GetMyHero()
	
	if not me then return end
	
	function Damage()
		dmg =  me.dmgMin + me.dmgBonus
		for qb = 1,6 do		
			if me:HasItem(qb) then
				local item = me:GetItem(qb)
				if item and item.name == "item_quelling_blade" then
					return dmg*1.32
				end
			end
		end
		return dmg
	end

	local creeps = entityList:GetEntities({classId=CDOTA_BaseNPC_Creep_Lane})	
	for i,v in ipairs(creeps) do
	
		local offset = v.healthbarOffset
		
		if offset == -1 then return end
	
		if not rect[v.handle] then 
			rect[v.handle] = {}  rect[v.handle] = drawMgr:CreateRect(-4,-22,8*size,8*size,0xFF8AB160) rect[v.handle].visible = false 
			rect[v.handle].entity = v rect[v.handle].entityPosition = Vector(0,0,offset)
		end
				
		if offset ~= -1 and v.visible and v.alive then
			if v.health > 0 and v.health < (Damage()*(1-v.dmgResist)+1) then				
				rect[v.handle].visible = true
				rect[v.handle].color = 0xFF8AB160
			elseif v.health > (Damage()*(1-v.dmgResist)) and v.health < ((Damage()*(1-v.dmgResist))+88) then
				rect[v.handle].visible = true
				rect[v.handle].color = 0xA5E8FF60
			else
				rect[v.handle].visible = false
			end		
		else
			rect[v.handle].visible = false
		end
	end

end


function GameClose()
	rect = {}
end
 
script:RegisterEvent(EVENT_CLOSE, GameClose)
script:RegisterEvent(EVENT_TICK,Tick)
