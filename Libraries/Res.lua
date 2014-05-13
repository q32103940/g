MapLeft = -8000
MapTop = 7350
MapRight = 7500
MapBottom = -7200
MapWidth = math.abs(MapLeft - MapRight)
MapHeight = math.abs(MapBottom - MapTop)

ResTable = {
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
		minimap    = {px = 9, py = 9,  h = 217, w = 232},
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
