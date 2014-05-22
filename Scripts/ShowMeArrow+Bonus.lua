require("libs.Res")

local eff = {}
ch = {}
check = true
stage = 1

icon = drawMgr:CreateRect(0,0,16,16,0x000000ff)
icon.visible =false

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
			if (sleeptick and sleeptick >= tick) then
				icon.visible = not v.visible					
			else
				runeMinimap = nil
				icon.visible = false
			end
		end

	end

	local cast = entityList:GetEntities({classId=CDOTA_BaseNPC})

	for i,v in ipairs(cast) do
		local vision = v.dayVision
		if vision == 650 then
			if v.visibleToEnemy and start then
				if not vec then vec = v.position end
			end
			if not start then 
				start = v.position
				return
			end			
			if start ~= nil and vec ~= nil then
				local distance = GetDistancePosD(vec,start)
				local range = math.floor((3000-distance)/1000)
				for z = range,30 do
					if not eff[z] then
						local p = Vector((vec.x - start.x) * 100*z / distance + start.x,(vec.y - start.y) * 100*z / distance + start.y,v.position.z)
						eff[z] = Effect(p, "fire_torch" )
						eff[z]:SetVector(0,p)							
					end						
				end				
			end
			if runeMinimap == nil then
				runeMinimap = MapToMinimap(v.position.x,v.position.y)
				icon.x = runeMinimap.x-20/2
				icon.y = runeMinimap.y-20/2
				icon.textureId = drawMgr:GetTextureId("NyanUI/miniheroes/mirana")
				sleeptick = tick + 3500
			end
		end
	end
	if start ~= nil and vec ~= nil and sleeptick and tick > sleeptick then			
		eff = {}
		collectgarbage("collect")
		start,vec,sleeptick = nil,nil,nil
	end

end

function GetDistancePosD(a,b)
    return math.sqrt(math.pow(a.x-b.x,2)+math.pow(a.y-b.y,2))
end

function GameClose()
	ch = {}
	check = true
	eff = {}
	start,vec,runeMinimap,sleeptick = nil,nil,nil,nil
	collectgarbage("collect")
end

script:RegisterEvent(EVENT_CLOSE, GameClose)   
script:RegisterEvent(EVENT_TICK,Tick)
