require("libs.drd")
 
toggleKey = string.byte("8")

activated = false move = false

xx = 180 yy = 80

effect = {} ranges = {} range = {} spellcount = {} spellname = {} spell = {} img = {} rect = {}

myFont = drawMgr:CreateFont("manabarsFont","Arial",14,500)

for a = 1, 7 do
        text = drawMgr:CreateText(0,0,0xFFFFFFff,"Range Display",myFont)
        text.visible = false
        img[a] = drawMgr:CreateRect(0,0,32,32,0x000000FF)
        img[a].visible = false
        rect[a] = drawMgr:CreateRect(0,0,36,36,0xFFFFFFff,true)
        rect[a].visible = false
        spellname[a] = false
end
 
function Tick()
 
        if not client.connected or client.loading or client.console or not entityList:GetMyHero() then return end
       
        if xx == 180 and yy == 80 then LoadGUIConfig() end
        if xx == nil and yy == nil then xx=180 yy = 80 end
 
        me = entityList:GetMyHero()
 
        for a,spells in ipairs(me.abilities) do			
			if me:GetAbility(a).name ~= "attribute_bonus" and not me:GetAbility(a).hidden then
				spellcount[a] = a
				if me:GetAbility(a).level ~= 0 then
					spell[a] = me:GetAbility(a).name
					range[a] = me:GetAbility(a).castRange
					if rangelist[me.name] then
					range[rangelist[me.name].spell] = rangelist[me.name].ran[me:GetAbility(rangelist[me.name].spell).level]
					end
					if spellname[a] == true then
						local dirty = false
						if not effect[a] or ranges[a] ~= range[a] then
								effect[a] = Effect(me,"range_display")
								effect[a]:SetVector( 1,Vector(range[a],0,0) )
								ranges[a] = range[a]
								dirty = true
						end
						if dirty then
								collectgarbage("collect")
						end
					else
						local dirty = false
						if effect[a] then
								effect[a] = nil
								dirty = true
						end
						if dirty then
								collectgarbage("collect")
						end
					end
				end
			end			
        end
 
end
 
function Frame()
 
        if #spellcount < 1 then return end
               
        if activated then
 
                if move == true then
                        xx = client.mouseScreenPosition.x - 39*#spellcount/2 - 20 yy = client.mouseScreenPosition.y + 15
                end
               
                if #spellcount > 0 then
                        for a = 1,#spellcount do               
                                text.visible = true
                                text.x = xx + 39*#spellcount/2
                                text.y = yy-18
                               
                                if spellcount[a] == nil then
                                        img[a].visible = true
                                        img[a].x = xx+38*a
                                        img[a].y = yy
                                        img[a].textureId = drawMgr:GetTextureId("NyanUI/spellicons/doom_bringer_empty1")                                       
                                end
                               
                                if spellcount[a] ~= nil then
                                        if me:GetAbility(spellcount[a]).name ~= nil then
                                                img[a].visible = true
                                                img[a].x = xx+38*a
                                                img[a].y = yy
                                                img[a].textureId = drawMgr:GetTextureId("NyanUI/spellicons/"..me:GetAbility(spellcount[a]).name)
                                               
                                                if spellname[a] == true then
                                                        rect[a].visible = true
                                                        rect[a].x = xx-2+38*a
                                                        rect[a].y = yy-2
                                                        rect[a].color = 0xFFFFFFff                                                     
                                                else
                                                        rect[a].visible = true
                                                        rect[a].x = xx-2+38*a
                                                        rect[a].y = yy-2
                                                        rect[a].color = 0x000000ff                                                     
                                                end
                                        end
                                end
                        end
                end
               
        else
			for a = 1,7 do
					img[a].visible = false
					rect[a].visible = false
					text.visible = false
			end
        end
       
end
 
 
function Key(msg,code)
 
	if #spellcount < 1 or client.chat then return end

	if IsKeyDown(toggleKey) then
		activated = not activated       
	end

	if activated then
   
			if IsMouseOnButton(xx+39*#spellcount/2,yy-20,20,100) then                      
					if msg == LBUTTON_UP then              
							move = (not move)
					end
					SaveGUIConfig()
			end

			for a = 1,#spellcount do
					if IsMouseOnButton(xx+38*a,yy,32,32) then                              
							if msg == LBUTTON_UP then                                      
									spellname[a] = (not spellname[a])
							end
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
		file = io.open(SCRIPT_PATH.."/libs/DRDConfig.txt", "w+")
        if file then
                file:write(xx.."\n"..yy)
                file:close()
        end
end
 
function LoadGUIConfig()
        file = io.open(SCRIPT_PATH.."/libs/DRDConfig.txt", "r")
        if file then
                xx, yy = file:read("*number", "*number")
                file:close()   
        end
end
 
function GameClose()
        for a = 1, 7 do        
                img[a].visible = false
                rect[a].visible = false
                text.visible = false
                spellname[a] = false
        end
        effect = {} ranges = {} range = {}
        spell = {} spellcount = {}
        activated = false move = false
end
 
script:RegisterEvent(EVENT_CLOSE, GameClose)
script:RegisterEvent(EVENT_TICK,Tick)
script:RegisterEvent(EVENT_KEY,Key)
script:RegisterEvent(EVENT_FRAME,Frame)
