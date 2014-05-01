filename = ""
MapLeft = -8000
MapTop = 7350
MapRight = 7500
MapBottom = -7200
MapWidth = math.abs(MapLeft - MapRight)
MapHeight = math.abs(MapBottom - MapTop)

cours = {}

minimapRune = drawMgr:CreateRect(0,0,20,20,0x000000ff) 
minimapRune.visible = false

ResTable = 
{
	-- Settings for 4:3
	{800,600,{
		rune       = {x = 730, y = 3},
		minimap    = {px = 4, py = 5, h = 146, w = 151},
		}
	},
	{1024,768,{
		rune       = {x = 820 , y = 13},
		minimap    = {px = 5, py = 7, h = 186, w = 193},
		}
	}, 
	{1152,864,{
		rune       = {x = 930 , y = 16},
		minimap    = {px = 6, py = 7, h = 211, w = 217},
		}
	},
	{1280,960,{
		rune       = {x = 1030 , y = 19},
		minimap    = {px = 6, py = 9, h = 233, w = 241},
		}
	},
	{1280,1024,{
		rune       = {x = 1030 , y = 21},
		minimap    = {px = 6, py = 9, h = 233, w = 241},
		}
	},
	{1600,1200,{
		rune       = {x = 1395 , y = 24},
		minimap    = {px = 8, py = 14, h = 288, w = 304},
		}
	},
	-- Settings for 16:9
	{1280,720,{
		rune       = {x = 241 , y = 4},
		minimap    = {px = 8, py = 8, h = 174, w = 181},
		}
	},
	{1360,768,{
		rune       = {x = 258 , y = 6},
		minimap    = {px = 8, py = 8, h = 186, w = 193},
		}
	},
	{1366,768,{
		rune       = {x = 258 , y = 6},
		minimap    = {px = 8, py = 8, h = 186, w = 193},
		}
	},
	{1600,900,{
		rune       = {x = 293 , y = 9},
		minimap    = {px = 9, py = 9,  h = 217, w = 227},
		}
	},
	{1920,1080,{
		rune       = {x = 212 , y = 21},
		minimap    = {px = 11, py = 11, h = 261, w = 272},
		}
	},
	-- Settings for 16:10
	{1280,768,{
		rune       = {x = 236 , y = 6},
		minimap    = {px = 8, py = 8, h = 186, w = 193},
		}
	},
	{1280,800,{
		rune       = {x = 1110 , y = 6},
		minimap    = {px = 8, py = 10, h = 192, w = 203},
		}
	},
	{1440,900,{
		rune       = {x = 262 , y = 9},
		minimap    = {px = 9, py = 9, h = 217, w = 227},
		}
	},
	{1680,1050,{
		rune       = {x = 212 , y = 21},
		minimap    = {px = 10, py = 11, h = 252, w = 267},
		}
	},
	{1920,1200,{
		rune       = {x = 242 , y = 24},
		minimap    = {px = 12, py = 14, h = 288, w = 304},
		}
	},
}

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
			if v.visible and v.alive then
				local courMinimap = MapToMinimap(v)
				local flying = v:GetProperty("CDOTA_Unit_Courier","m_bFlyingCourier")
				if flying then
					if not cours[v.handle] then
						cours[v.handle] = {}
						cours[v.handle].icon = drawMgr:CreateRect(courMinimap.x-10,courMinimap.y-6,24,12,0x000000FF,drawMgr:GetTextureId("AIOGUI/courier_flying"))											
					else
						cours[v.handle].icon.x,cours[v.handle].icon.y = courMinimap.x-10,courMinimap.y-6
					end
				else
					if not cours[v.handle] then
						cours[v.handle] = {}
						cours[v.handle].icon = drawMgr:CreateRect(courMinimap.x-6,courMinimap.y-6,12,12,0x000000FF,drawMgr:GetTextureId("AIOGUI/courier"))											
					else
						cours[v.handle].icon.x,cours[v.handle].icon.y = courMinimap.x-6,courMinimap.y-6
					end
				end
			elseif cours[v.handle] then
				cours[v.handle].icon.visible = false
				cours[v.handle] = nil
			end
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

function GetDistance2D(a,b)
    return math.sqrt(math.pow(a.position.x-b.position.x,2)+math.pow(a.position.y-b.position.y,2))
end

function GameClose()
	cours = {}
	minimapRune.visible = false
	collectgarbage("collect")	
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

script:RegisterEvent(EVENT_CLOSE,GameClose)
script:RegisterEvent(EVENT_TICK,Tick)
script:RegisterEvent(EVENT_TICK,CourierTick)
