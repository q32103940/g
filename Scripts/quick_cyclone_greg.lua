require("libs.Utils")
require("libs.ScriptConfig")
require("libs.Stuff")
local config = ScriptConfig.new()
config:SetParameter("Active", "Q", config.TYPE_HOTKEY)
config:SetParameter("doubletapInterval", 280)
config:Load()

local toggleKey   = config.Active
local doubletapInterval= config.doubletapInterval
local activ       = false
local monitor     = client.screenSize.x/1600
local F14         = drawMgr:CreateFont("F14","Tahoma",14*monitor,550*monitor) 
local statusText  = drawMgr:CreateText(10*monitor,515*monitor,-1,"(" .. string.char(toggleKey) .. ") Auto Cyclone: Off",F14) statusText.visible = true
local debugText  = drawMgr:CreateText(10*monitor,485*monitor,-1,"debug",F14) debugText.visible = true
local start = 0

local hotkeyText
if string.byte("A") <= toggleKey and toggleKey <= string.byte("Z") then
	hotkeyText = string.char(toggleKey)
else
	hotkeyText = ""..toggleKey
end

function Key(msg,code)
	if client.chat or client.console or client.loading then return end
	
		if IsKeyDown(toggleKey) and GetTick() < (start+doubletapInterval) and not activ then
			entityList:GetMyHero():SafeCastItem("item_cyclone",entityList:GetMyHero())
		end
		if IsKeyDown(toggleKey) and not activ then
			start=GetTick()
			activ = true
			statusText.text = "(" .. hotkeyText .. ") Auto Cyclone: Active"
		end	
		
		
		if code==toggleKey and msg==KEY_UP then 
			statusText.text = "(" .. hotkeyText .. ") Auto Cyclone: Off"
			activ=false
			
			
		end
		
end


	

function Tick(tick)

	
	if not SleepCheck(main) then return end Sleep(30,main)
	local me    = entityList:GetMyHero()
	local ID    = me.classId
	local sheep = me:FindItem("item_cyclone")
	if sheep then statusText.visible = true end
	if PlayingGame() and me.alive and not (client.paused or me:IsChanneling()) then
		if ID == CDOTA_Unit_Hero_Lion then
			statusText.visible = true
			Disable(me,2,"lion_voodoo",nil)
		elseif ID == CDOTA_Unit_Hero_ShadowShaman then
			statusText.visible = true
			Disable(me,2,"shadow_shaman_voodoo",nil)
		else
			Disable(me,nil,nil,sheep)
		end
	end
end

function Disable(me,abilityHex,abilityHexName,sheep)
	local enemies = entityList:GetEntities({type=LuaEntity.TYPE_HERO,team = 5-me.team,alive=true,visible=true,illusion=false})
	for i,v in ipairs(enemies) do
		local blink = v:FindItem("item_blink")
		local SI    = v:IsSilenced()
		local MI    = v:IsMagicImmune()
		local invis = me:IsInvisible()
		if GetDistance2D(v,me) < 800 and not (SI or MI or invis) then
			if sheep and sheep:CanBeCasted() then
				if blink and blink.cd > 11 then
					me:SafeCastItem("item_cyclone",v)
					break
				end
				
				if activ then
					me:SafeCastItem("item_cyclone",v)
					break
				end
				
				if Initiation[v.name] then
					local eleven = v:FindSpell(Initiation[v.name].Spell)
					local twelve = eleven.level 
					if eleven.level > 0 and eleven.cd > eleven:GetCooldown(twelve) - 1 then
						me:SafeCastItem("item_cyclone",v)
						break
					end
				end
			elseif abilityHex and abilityHexName then
				local five = me:GetAbility(abilityHex)
				local six  = me:FindAbility(abilityHexName)
				if GetDistance2D(v,me) < six.castRange and six and six:CanBeCasted() then
					if blink and blink.cd > 11 then
						me:SafeCastAbility(five,v)
						break
					end
					
					if activ then
						me:SafeCastAbility(five,v)
						break
					end
					
					if Initiation[v.name] then
						local eleven = v:FindSpell(Initiation[v.name].Spell)
						local twelve = eleven.level 
						if eleven.level > 0 and eleven.cd > eleven:GetCooldown(twelve) - 1 then
							me:SafeCastAbility(five,v)
							break
						end
					end
				end
			end
		end
	end
end

function Load()
	if PlayingGame() then
		local me    = entityList:GetMyHero()
		if not me then
			script:Disable()

		else
			reg = true
			script:RegisterEvent(EVENT_TICK,Tick)
			script:RegisterEvent(EVENT_KEY,Key)
			script:UnregisterEvent(Load)
		end
	end
end

function GameClose()
	collectgarbage("collect")
	if reg then
		script:UnregisterEvent(Tick)
		script:UnregisterEvent(Key)
		script:RegisterEvent(EVENT_TICK,Load)
		reg = false
		statusText.visible = false
	end
end

script:RegisterEvent(EVENT_CLOSE,GameClose)
script:RegisterEvent(EVENT_TICK,Load)
