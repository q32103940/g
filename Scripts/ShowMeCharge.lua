require("libs.Utils")
require("libs.Res")

--add map hack for sb

MapLeft = -8000
MapTop = 7350
MapRight = 7500
MapBottom = -7200
MapWidth = math.abs(MapLeft - MapRight)
MapHeight = math.abs(MapBottom - MapTop)
rect = {}
ch = {}
speed = {600,650,700,750}
sleeptick = 0
start = true
eff = drawMgr:CreateRect(0,0,20,20,0x000000ff,drawMgr:GetTextureId("NyanUI/miniheroes/spirit_breaker"))
eff.visible = false

function Tick(tick)

	if not client.connected or client.loading or client.console or tick < sleeptick then return end

	sleeptick = tick + 250

	local me = entityList:GetMyHero()
	
	if not me then return end

	local hero = entityList:FindEntities({type=LuaEntity.TYPE_HERO,illusion=false})

	for i,v in ipairs(hero) do
	
		if v.name == "npc_dota_hero_spirit_breaker" then
			showstate = v.visible
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
			if v.dayVision == 0 and showstate == false then
				if not aa then
					aa = true
					time = tick
					start = Vector(v.position.x,v.position.y,v.position.z)
					distance = GetDistance2D(me,v)
				end
				Ddistance = GetDistance2D(me,v) - (tick - time)/1000*speeed
				local minimap = MapToMinimap((v.position.x - me.position.x) * Ddistance / GetDistance2D(v,me) + me.position.x,(v.position.y - me.position.y) * Ddistance / GetDistance2D(v,me) + me.position.y)
				eff.x = minimap.x-20/2
				eff.y = minimap.y-20/2
				eff.visible = true
			else
				aa = nil
				eff.visible = false
			end
		end
	else
		eff.visible = false
	end
	
		

end


function MapToMinimap(x, y)
    if y == nil then
        if x.x then
            _x = x.x - MapLeft
            _y = x.y - MapBottom
        elseif x.position then
            _x = x.position.x - MapLeft
            _y = x.position.y - MapBottom
        else
            return {x = -640, y = -640}
        end
    else
            _x = x - MapLeft
            _y = y - MapBottom
    end
    
    local scaledX = math.min(math.max(_x * MinimapMapScaleX, 0), location.minimap.w)
    local scaledY = math.min(math.max(_y * MinimapMapScaleY, 0), location.minimap.h)
    
    local screenX = location.minimap.px + scaledX
    local screenY = screenSize.y - scaledY - location.minimap.py

    return Vector2D(math.floor(screenX),math.floor(screenY))
end

do
    screenSize = client.screenSize
    if screenSize.x == 0 and screenSize.y == 0 then
            script:Unload()
    end
    for i,v in ipairs(ResTable) do
            if v[1] == screenSize.x and v[2] == screenSize.y then
                    location = v[3]
                    break
            elseif i == #ResTable then
                    script:Unload()
            end
    end

end

MinimapMapScaleX = location.minimap.w / MapWidth
MinimapMapScaleY = location.minimap.h / MapHeight


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
