require("libs.Res")

local eff = {}
ch = {}
check = true

icon = drawMgr:CreateRect(0,0,16,16,0x000000ff)
icon.visible = false 

function Tick(tick)
 
	if not client.connected or client.loading or client.console then return end

	local me = entityList:GetMyHero()

	if not me then return end

	local hero = entityList:GetEntities({type=LuaEntity.TYPE_HERO, illusion = false})
	for i,v in ipairs(hero) do
		if check and #hero == 10 then
			if v.team ~= me.team then
				table.insert(ch,v.name)
				if #ch == 5 then
					if ch[1] ~= "npc_dota_hero_mirana" and ch[2] ~= "npc_dota_hero_mirana" and ch[3] ~= "npc_dota_hero_mirana" and ch[4] ~= "npc_dota_hero_mirana" and ch[5] ~= "npc_dota_hero_mirana" then
						script:Disable()
					else
						check = false						
					end
				end
			end			
		end	

		if v.name == "npc_dota_hero_mirana" then
			if not sleeptick or (sleeptick and sleeptick >= tick) then
				icon.visible = not v.visible					
			else
				runeMinimap = nil
				icon.visible = false
			end
		end

	end
	
	local arrow = entityList:GetEntities(function (ar) return ar.classId == 282 and ar.dayVision == 650 end)[1]

	if arrow ~= nil then
		clear = true
		if not start then 
			start = arrow.position
			return
		end
		if arrow.visibleToEnemy then
			if not vec then 
				vec = arrow.position 
				if GetDistancePosD(vec,start) < 75 then
					vec = nil
				end
			end
		end
		if start ~= nil and vec ~= nil and #eff == 0 then
			for z = 1,29 do	
				local p = FindAB(start,vec,100*z+100)
				eff[z] = Effect(p, "candle_flame_medium" ) --lamp_fire_glow
				eff[z]:SetVector(0,p)											
			end				
		end			
					
		if runeMinimap == nil then
			runeMinimap = MapToMinimap(start.x,start.y)
			icon.x = runeMinimap.x-20/2
			icon.y = runeMinimap.y-20/2
			icon.textureId = drawMgr:GetTextureId("NyanUI/miniheroes/mirana")
			sleeptick = tick + 3500
		end
	elseif clear then
		clear = false
		eff = {}
		collectgarbage("collect")
		start,vec = nil,nil
	end

	if start ~= nil and vec ~= nil and sleeptick and tick > sleeptick then			
		eff = {}
		collectgarbage("collect")
		start,vec = nil,nil
	end

end

function FindAB(first, second, distance)
	local xAngle = math.deg(math.atan(math.abs(second.x - first.x)/math.abs(second.y - first.y)))
	local retValue = nil
	local retVector = Vector()
				
        if first.x <= second.x and first.y >= second.y then
                retValue = 270 + xAngle
        elseif first.x >= second.x and first.y >= second.y then
                retValue = (90-xAngle) + 180
        elseif first.x >= second.x and first.y <= second.y then
                retValue = 90+xAngle
        elseif first.x <= second.x and first.y <= second.y then
                retValue = 90 - xAngle 
        end

	retVector = Vector(first.x + math.cos(math.rad(retValue))*distance,first.y + math.sin(math.rad(retValue))*distance,0)
	client:GetGroundPosition(retVector)
	retVector.z = retVector.z+100
	
	return retVector
end


function GetDistancePosD(a,b) 
    return math.sqrt(math.pow(a.x-b.x,2)+math.pow(a.y-b.y,2))
end

function GameClose()
	ch = {}
	check = true
	eff = {}
	start,vec,runeMinimap = nil,nil,nil
	collectgarbage("collect")
end

script:RegisterEvent(EVENT_CLOSE, GameClose)   
script:RegisterEvent(EVENT_TICK,Tick)
