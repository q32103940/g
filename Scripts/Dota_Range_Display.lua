require("libs.drd")
require("libs.ScriptConfig")

config = ScriptConfig.new()
config:SetParameter("Hotkey", "56", config.TYPE_HOTKEY)
config:Load()

local sleep = 0
local toggleKey = config.Hotkey
local activated = false local move = false
local xx = 180 local yy = 80
local effect = {}
local ranges = {}
local range = {}
local spellname = {}
local spell = {}
local img = {}
local rect = {}
local myFont = drawMgr:CreateFont("manabarsFont","Arial",14,500)
local text = drawMgr:CreateText(0,0,0xFFFFFFff,"Range Display",myFont)
text.visible = false

for a = 1, 7 do
        img[a] = drawMgr:CreateRect(0,0,32,32,0x000000FF)
        img[a].visible = false
        rect[a] = drawMgr:CreateRect(0,0,36,36,0xFFFFFFff,true)
        rect[a].visible = false
        spellname[a] = false
end

function Tick(tick)

        if not client.connected or client.loading or client.console or tick < sleep then return end
		
		sleep = tick + 300

		local me = entityList:GetMyHero()

		if not me then return end
		
		local ability = me.abilities
		local num = rangelist[me.name]
        for a,spells in ipairs(ability) do
			if spells.name ~= "attribute_bonus" and not spells.hidden then
				spell[a] = spells.name
				if spells.level ~= 0 then
					range[a] = spells.castRange
					if rangelist[me.name] then
						range[num.spell] = num.ran[me:GetAbility(num.spell).level]
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

	local count = #spell
	if count == 0 then return end
	if activated then vis = true
		if xx == 180 and yy == 80 then LoadGUIConfig() end
        if xx == nil and yy == nil then xx=180 yy = 80 end
		if move == true then
			xx = client.mouseScreenPosition.x - 39*#spell/2 - 20 yy = client.mouseScreenPosition.y + 15
		end
		text.visible = true
		text.x = xx + 39*count/2
		text.y = yy-18
		for a = 1,count do
			img[a].visible = true
			if spell[a] == nil then
				img[a].x = xx+38*a
				img[a].y = yy
				img[a].textureId = drawMgr:GetTextureId("NyanUI/spellicons/doom_bringer_empty1")
			elseif spell[a] ~= nil then
				img[a].x = xx+38*a
				img[a].y = yy
				img[a].textureId = drawMgr:GetTextureId("NyanUI/spellicons/"..spell[a])
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
	else
		if vis then
			for a = 1,7 do
					img[a].visible = false
					rect[a].visible = false
					text.visible = false
			end
			vis = false
		end
	end
end


function Key(msg,code)

	local count = #spell

	if count == 0 or client.chat then return end

	if IsKeyDown(toggleKey) then
		activated = not activated
	end

	if activated then
		if IsMouseOnButton(xx+39*count/2,yy-20,20,100) then
			if msg == LBUTTON_UP then
					move = (not move)
			end
			SaveGUIConfig(xx,yy)
		end
		for a = 1,count do
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

function SaveGUIConfig(xx,yy)
		local file = io.open(SCRIPT_PATH.."/libs/DRDConfig.txt", "w+")
        if file then
                file:write(xx.."\n"..yy)
                file:close()
        end
end

function LoadGUIConfig()
		local file = io.open(SCRIPT_PATH.."/libs/DRDConfig.txt", "r")
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
	spell = {} activated = false move = false
end

script:RegisterEvent(EVENT_CLOSE, GameClose)
script:RegisterEvent(EVENT_TICK,Tick)
script:RegisterEvent(EVENT_KEY,Key)
script:RegisterEvent(EVENT_TICK,Frame)
