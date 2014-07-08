require("libs.ScriptConfig")

config = ScriptConfig.new()
config:SetParameter("Hotkey", "I", config.TYPE_HOTKEY)
config:Load()

local key = config.Hotkey

local activated = true
local item = {} local hero = {}
local xx = 50
local yy = 300
local clear = true
local move = false
local sleeptick = 0
local F12 = drawMgr:CreateFont("F11","Arial",12,500)
local F10 = drawMgr:CreateFont("F11","Arial",10,500)

function Tick(tick)

	if not client.connected or client.loading or client.console or tick < sleeptick then return end

	sleeptick = tick + 250 

	local me = entityList:GetMyHero()

	if not me then return end	

	if activated then clear = true

		if xx == 50 and yy == 300 then LoadGUIConfig() end
		if xx == nil and yy == nil then xx=50 yy = 300 end

		if move then
			xx = client.mouseScreenPosition.x - 10 yy = client.mouseScreenPosition.y - 32 Clear()	
		end	

		local enemies = entityList:GetEntities({type=LuaEntity.TYPE_HERO ,illusion=false,team = (5-me.team)})
		table.sort( enemies, function (a,b) return a.playerId < b.playerId end )

		for i = 1,#enemies do
			v = enemies[i]

			if not hero[i] then hero[i] = {}
				hero[i].he = drawMgr:CreateRect(xx+1, yy+26*i,18,18,0x000000D0)
			end

			hero[i].he.textureId = drawMgr:GetTextureId("NyanUI/miniheroes/"..v.name:gsub("npc_dota_hero_",""))	

			for c= 1, 7 do
				if not item[c] then item[c] = {} end
				if not hero[i].item then hero[i].item = {} end				

				if not hero[i].item[c] then hero[i].item[c] = {}		
					hero[i].item[c].bg = drawMgr:CreateRect(xx+26*c, yy+26*i,32,18,0x000000D0) hero[i].item[c].bg.visible = true
					hero[i].item[c].ko = drawMgr:CreateRect(xx-1+26*c, yy-1+26*i,24,20,0xFFFFFF40,true) hero[i].item[c].ko.visible = true
					hero[i].item[c].txt = drawMgr:CreateText(xx+6+26*c,yy+4+26*i,0xFFFFFFff,"",F12) hero[i].item[c].txt.visible = false
					hero[i].item[c].rcr = drawMgr:CreateRect(xx+26*c, yy+26*i,22,18,0x00000030) hero[i].item[c].rcr.visible = false
					hero[i].item[c].charg = drawMgr:CreateText(xx+18+26*c,yy+9+26*i,0xFFFFFFff,"",F10) hero[i].item[c].charg.visible = false
				end	
				local Items = v:GetItem(c)
				if Items then
					if string.find(Items.name, "recipe") then
						hero[i].item[c].bg.textureId = drawMgr:GetTextureId("NyanUI/items/recipe")
					elseif Items.stashItems then
						hero[i].item[c].bg.textureId = drawMgr:GetTextureId("NyanUI/items/"..Items.name:gsub("item_",""))
					else
						hero[i].item[c].bg.textureId = drawMgr:GetTextureId("NyanUI/items/"..Items.name:gsub("item_",""))

						if Items.charges > 0 then
							hero[i].item[c].charg.text = ""..math.ceil(Items.charges) hero[i].item[c].charg.visible = true
						else
							hero[i].item[c].charg.visible = false
						end

						if Items.cd ~= 0 then
							local cd = math.ceil(Items.cd)
							hero[i].item[c].txt.text = ""..cd hero[i].item[c].txt.visible = true
							hero[i].item[c].rcr.color  = 0xA1A4A120 hero[i].item[c].rcr.visible = true						
						elseif v.mana - Items.manacost < 0 then					
							hero[i].item[c].rcr.color  = 0x047AFF20 hero[i].item[c].rcr.visible = true
							hero[i].item[c].txt.visible = false
						else
							hero[i].item[c].rcr.visible = false
							hero[i].item[c].txt.visible = false
						end
					end					
				else
					hero[i].item[c].bg.textureId = drawMgr:GetTextureId("NyanUI/items/emptyitembg")
					hero[i].item[c].charg.visible = false
					hero[i].item[c].txt.visible = false
					hero[i].item[c].rcr.visible = false					
				end				
			end	
		end
	else
		if clear then
		Clear()
		clear = false
		end
	end

end

function Key(msg,code)

	if not client.chat then

		if IsKeyDown(key) then
			activated = not activated
		end

		if activated then
			if IsMouseOnButton(xx+1, yy+26*1,20,20) then
				if msg == LBUTTON_UP then              
					move = not move
				end
				SaveGUIConfig()
			end
		end
	end

end

function IsMouseOnButton(x,y,h,w)
        local mx = client.mouseScreenPosition.x
        local my = client.mouseScreenPosition.y
        return mx > x and mx <= x + w and my > y and my <= y + h
end
 
function SaveGUIConfig()
		local file = io.open(SCRIPT_PATH.."/libs/ItemPanelConfig.txt", "w+")
        if file then
                file:write(xx.."\n"..yy)
                file:close()
        end
end
 
function LoadGUIConfig()
        local file = io.open(SCRIPT_PATH.."/libs/ItemPanelConfig.txt", "r")
        if file then
                xx, yy = file:read("*number", "*number")
                file:close()   
        end
end

function Clear()
	item = {} hero = {}
	collectgarbage("collect")
end

function GameClose()
	Clear()
end


script:RegisterEvent(EVENT_CLOSE,GameClose)				
script:RegisterEvent(EVENT_TICK,Tick)
script:RegisterEvent(EVENT_KEY,Key)
