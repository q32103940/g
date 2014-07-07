require("libs.Utils")
require("libs.ScriptConfig")

config = ScriptConfig.new()
config:SetParameter("Hotkey", "48", config.TYPE_HOTKEY)
config:Load()

local key =  config.Hotkey
local xx = client.screenSize.x/300 
local yy = client.screenSize.y/1.55

local activated = true 
local sleep = 250
local icon = drawMgr:CreateRect(xx,yy,36,24,0x000000ff,drawMgr:GetTextureId("NyanUI/items/dagon")) icon.visible = false
local rect = drawMgr:CreateRect(xx-1,yy-1,26,25,0xFFFFFF90,true) rect.visible = false
local dmg = {400,500,600,700,800}
 
--Главная функция
function Tick(tick)
 
	if not client.connected or client.loading or client.console or tick < sleep then return end
	
	sleep = tick + 150

	local me = entityList:GetMyHero() 
	
	if not me then return end
       
	local dagon = me:FindDagon()
	local visible = Draw(activated,dagon) 
	
	rect.visible = visible
	icon.visible = visible
	
	if visible then
		local lvl = string.match (dagon.name, "%d+")
		if not lvl then lvl = 1 end local dmgD = dmg[lvl*1]
		local enemy = entityList:GetEntities({type=LuaEntity.TYPE_HERO,alive=true,visible=true,team = (5-me.team)})
		if not me:IsChanneling() and Nyx(me) then
			for i = 1,#enemy do
				local v = enemy[i]
				if not v:IsIllusion() then
					if v.health > 0 and GetDistance2D(v,me) < dagon.castRange and v:CanDie() then
						if not v:DoesHaveModifier("modifier_nyx_assassin_spiked_carapace") then
							if v.health < v:DamageTaken(dmgD, DAMAGE_MAGC, me) then
								me:SafeCastAbility(dagon,v)
							end
						end
					end
				end
			end
		end	
	end

end

function Nyx(target)
	if target.classId == CDOTA_Unit_Hero_Nyx_Assassin and target:DoesHaveModifier("modifier_nyx_assassin_vendetta") then
		return false
	end
	return true
end

function Draw(one,two)
	if one and two then
		return true
	end
	return false
end

function Key()

	if not client.chat and IsKeyDown(key) then
		activated = not activated
	end

end

function GameClose()
	rect.visible = false
	icon.visible = false	
end
 
script:RegisterEvent(EVENT_CLOSE,GameClose) 
script:RegisterEvent(EVENT_KEY,Key)
script:RegisterEvent(EVENT_TICK,Tick)
