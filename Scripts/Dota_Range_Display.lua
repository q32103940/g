require("libs.drd")
require("libs.ScriptConfig")

config = ScriptConfig.new()
config:SetParameter("Hotkey", "56", config.TYPE_HOTKEY)
config:Load()

local sleep = 0
local toggleKey = config.Hotkey
local activated,move = false,false
local xx,yy = 180,80
local spellList = {}
local spells = {}
local myFont = drawMgr:CreateFont("manabarsFont","Arial",14,500)
local text = drawMgr:CreateText(0,0,0xFFFFFFff,"Range Display",myFont)
text.visible = false

function Tick(tick)

	if not client.connected or client.loading or client.console or tick < sleep then return end
	
	sleep = tick + 250

	local me = entityList:GetMyHero()

	if not me then return end
	
	local ability = me.abilities
	local num = rangelist[me.name]
	local spellList = {}
	for a,spell in ipairs(ability) do
		if spell.name ~= "attribute_bonus" and not spell.hidden then
			table.insert(spellList,spell)
		end
	end
	global = #spellList
	local count = #spellList
	
	if activated then
		if xx == 180 and yy == 80 then LoadGUIConfig() end
		if xx == nil and yy == nil then xx=180 yy = 80 end
		if move == true then
			xx,yy = client.mouseScreenPosition.x - 39*count/2 - 20,client.mouseScreenPosition.y + 15
		end
		text.x,text.y,text.visible = xx + 39*count/2,yy-18,true		
		for a,v in ipairs(spellList) do
			if not spells[a] then spells[a] = {} end
			if not spells[a].img then
				spells[a].img = drawMgr:CreateRect(0,0,32,32,0x000000FF) spells[a].img.visible = false
				spells[a].rect = drawMgr:CreateRect(0,0,36,36,0xFFFFFFff,true) spells[a].rect.visible = false
			end
			spells[a].img.x,spells[a].img.y = xx+38*a,yy
			spells[a].rect.x,spells[a].rect.y = xx+38*a-2,yy - 2
			spells[a].img.textureId = drawMgr:GetTextureId("NyanUI/spellicons/"..v.name)
			if spells[a].state then					
				spells[a].rect.color = 0xFFFFFFff
			else
				spells[a].rect.color = 0x000000ff
			end
			spells[a].img.visible,spells[a].rect.visible = true,true
		end
	elseif text.visible then
		for a,v in ipairs(spellList) do
			spells[a].img.visible,spells[a].rect.visible = false,false		
		end
		text.visible = false
	end

	for a,v in ipairs(spellList) do
		if v.level ~= 0 and #spells ~= 0 then
			spells[a].range = v.castRange
			if rangelist[me.name] then
				spells[a].range = num.ran[me:GetAbility(num.spell).level]
			end
			local dirty = false
			if spells[a].state then
				if not spells[a].effect or spells[a].ranges ~= spells[a].range then
					spells[a].effect = Effect(me,"range_display")
					spells[a].effect:SetVector( 1,Vector(spells[a].range,0,0) )
					spells[a].ranges = spells[a].range
					dirty = true
				end						
			elseif spells[a].effect then
				spells[a].effect = nil
				dirty = true
			end
			if dirty then
				collectgarbage("collect")
			end
		end
	end

end

function Key(msg,code)

	local count = global

	if not count or client.chat then return end

	if IsKeyDown(toggleKey) then
		activated = not activated
	end

	if activated then
		if msg == LBUTTON_UP then
			if IsMouseOnButton(xx+39*count/2,yy-20,20,100) then
				move = (not move)
				SaveGUIConfig(xx,yy)
			end			
		end
		if msg == LBUTTON_UP then
			for a = 1,count do
				if IsMouseOnButton(xx+38*a,yy,32,32) then
					spells[a].state = (not spells[a].state)
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
	text.visible = false
	spellList = {}
	spells = {}
	activated = false 
	move = false
	create = true
	collectgarbage("collect")
end

script:RegisterEvent(EVENT_CLOSE, GameClose)
script:RegisterEvent(EVENT_TICK,Tick)
script:RegisterEvent(EVENT_KEY,Key)
