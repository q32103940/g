require("libs.Res")

filename = ""

cours = {}

minimapRune = drawMgr:CreateRect(0,0,20,20,0x000000ff) 
minimapRune.visible = false

function Tick()

	if not client.connected or client.loading or client.console then return end
	
	local me = entityList:GetMyHero()
	
	if not me then return end

	local runes = entityList:GetEntities({classId=CDOTA_Item_Rune})
	if #runes == 0 then
			if minimapRune.visible == true then
			minimapRune.visible = false				
			end
		return
	end
	
		local rune = runes[1]
		local runeType = rune.runeType
		filename = ""		

		if runeType == 0 then
				filename = "doubledamage"
		elseif runeType == 1 then
				filename = "haste"
		elseif runeType == 2 then
				filename = "illusion"
		elseif runeType == 3 then
				filename = "invis"
		elseif runeType == 4 then
				filename = "regen"
		end
	
	if minimapRune.visible == false then
        local runeMinimap = MapToMinimap(rune)
		minimapRune.visible = true
        minimapRune.x = runeMinimap.x-20/2
		minimapRune.y = runeMinimap.y-20/2
		minimapRune.textureId = drawMgr:GetTextureId("NyanUI/minirunes/"..filename)         
    end	

end

function CourierTick()

        if not client.connected or client.loading or client.console then return end
	
		local me = entityList:GetMyHero()
	
		if not me then return end
		
        local enemyCours = entityList:FindEntities({classId = CDOTA_Unit_Courier,team = (5-me.team)})
        for i,v in ipairs(enemyCours) do
		
			if not cours[v.handle] then
				cours[v.handle] = {} cours[v.handle] = drawMgr:CreateRect(0,0,location.minimap.px+3,location.minimap.px+3,0x000000FF) cours[v.handle].visible = false
			end
		
			if v.visible and v.alive then	
				cours[v.handle].visible = true
				local courMinimap = MapToMinimap(v)
				cours[v.handle].x,cours[v.handle].y = courMinimap.x-10,courMinimap.y-6
				local flying = v:GetProperty("CDOTA_Unit_Courier","m_bFlyingCourier")
				if flying then
					cours[v.handle].textureId = drawMgr:GetTextureId("Stuff/courier_flying")
					cours[v.handle].size = Vector2D(location.minimap.px+9,location.minimap.px+1)
				else
					cours[v.handle].textureId = drawMgr:GetTextureId("Stuff/courier")		
				end
			else
				cours[v.handle].visible = false
			end
        end  
end

function GetDistance2D(a,b)
    return math.sqrt(math.pow(a.position.x-b.position.x,2)+math.pow(a.position.y-b.position.y,2))
end

function GameClose()
	cours = {}
	minimapRune.visible = false
	collectgarbage("collect")	
end

script:RegisterEvent(EVENT_CLOSE,GameClose)
script:RegisterEvent(EVENT_TICK,Tick)
script:RegisterEvent(EVENT_TICK,CourierTick)
