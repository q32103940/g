-------Config--------
key = string.byte("O")
----------------------
activated = true
item = {} hero = {}
F12 = drawMgr:CreateFont("F11","Arial",12,500)
F10 = drawMgr:CreateFont("F11","Arial",10,500)
xx = 50
yy = 300
clear = true
move = false

function Tick()

	if not client.connected or client.loading or client.console then return end

	local me = entityList:GetMyHero()

	if not me then return end	

	herotab = {}

	if activated then clear = true

		if xx == 50 and yy == 300 then LoadGUIConfig() end
		if xx == nil and yy == nil then xx=50 yy = 300 end

		if move then
			xx = client.mouseScreenPosition.x - 10 yy = client.mouseScreenPosition.y - 32
			Clear()	
		end	

		local enemies = entityList:GetEntities({type=LuaEntity.TYPE_HERO ,illusion=false})
		for i = 1, #enemies do
			local h = enemies[i]
			if h ~= nil and h.team ~= me.team  then				
				table.insert(herotab, h)
			end
		end
		for i,v in ipairs(herotab) do
			
			if not hero[v.handle] then hero[v.handle] = {}
			hero[v.handle].her = drawMgr:CreateRect(xx+1, yy+26*i,18,18,0x000000D0,drawMgr:GetTextureId("NyanUI/miniheroes/"..v.name:gsub("npc_dota_hero_","")))
			end					

			for c= 1, 6 do					
				if not item[c] then item[c] = {} end
				if not hero[v.handle].item then hero[v.handle].item = {} end				

				if not hero[v.handle].item[c] then hero[v.handle].item[c] = {}						
					hero[v.handle].item[c].bg = drawMgr:CreateRect(xx+26*c, yy+26*i,32,18,0x000000D0) hero[v.handle].item[c].bg.visible = true
					hero[v.handle].item[c].ko = drawMgr:CreateRect(xx-1+26*c, yy-1+26*i,24,20,0xFFFFFF40,true) hero[v.handle].item[c].ko.visible = true
					hero[v.handle].item[c].txt = drawMgr:CreateText(xx+6+26*c,yy+4+26*i,0xFFFFFFff,"",F12) hero[v.handle].item[c].txt.visible = false
					hero[v.handle].item[c].rcr = drawMgr:CreateRect(xx+26*c, yy+26*i,22,18,0x00000030) hero[v.handle].item[c].rcr.visible = false
					hero[v.handle].item[c].charg = drawMgr:CreateText(xx+18+26*c,yy+9+26*i,0xFFFFFFff,"",F10) hero[v.handle].item[c].charg.visible = false
					hero[v.handle].item[c].vvv = true
				end	

				local Items = v:GetItem(c)

				if Items ~= nil then
					hero[v.handle].item[c].vvv = true
					if string.find(Items.name, "recipe") then
						hero[v.handle].item[c].bg.textureId = drawMgr:GetTextureId("NyanUI/items/recipe")
					else
						hero[v.handle].item[c].bg.textureId = drawMgr:GetTextureId("NyanUI/items/"..v:GetItem(c).name:gsub("item_",""))

						if Items.charges > 0 then
							hero[v.handle].item[c].charg.text = ""..math.ceil(Items.charges) hero[v.handle].item[c].charg.visible = true
						else
							hero[v.handle].item[c].charg.visible = false
						end

						if Items.cd ~= 0 then
							local cd = math.ceil(Items.cd)
							hero[v.handle].item[c].txt.text = ""..cd hero[v.handle].item[c].txt.visible = true
							hero[v.handle].item[c].rcr.color  = 0xA1A4A120 hero[v.handle].item[c].rcr.visible = true						
						elseif v.mana - Items.manacost < 0 then					
							hero[v.handle].item[c].rcr.color  = 0x047AFF20 hero[v.handle].item[c].rcr.visible = true
							hero[v.handle].item[c].txt.visible = false
						else
							hero[v.handle].item[c].rcr.visible = false
							hero[v.handle].item[c].txt.visible = false
						end
					end
				else	
					if hero[v.handle].item[c].vvv == true then
					hero[v.handle].item[c].bg.textureId = drawMgr:GetTextureId("NyanUI/items/emptyitembg")
					hero[v.handle].item[c].charg.visible = false
					hero[v.handle].item[c].txt.visible = false
					hero[v.handle].item[c].rcr.visible = false
					hero[v.handle].item[c].vvv = false
					end
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
		file = io.open(SCRIPT_PATH.."/libs/ItemPanelConfig.txt", "w+")
        if file then
                file:write(xx.."\n"..yy)
                file:close()
        end
end
 
function LoadGUIConfig()
        file = io.open(SCRIPT_PATH.."/libs/ItemPanelConfig.txt", "r")
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
	script:Reload()
end


script:RegisterEvent(EVENT_CLOSE, GameClose)				
script:RegisterEvent(EVENT_TICK,Tick)
script:RegisterEvent(EVENT_KEY,Key)
