require("libs.Utils")
require("libs.ScriptConfig")

config = ScriptConfig.new()
--config:SetParameter("Hotkey", "48", config.TYPE_HOTKEY)
config:Load()

local key = config.Hotkey
local xx = client.screenSize.x/300
local yy = client.screenSize.y/1.55

local activated = true
local 

sleep = 250
local icon = drawMgr:CreateRect(xx,yy,36,24,0x000000ff,drawMgr:GetTextureId("NyanUI/items/dagon")) icon.visible = false
local 

rect = drawMgr:CreateRect(xx-1,yy-1,26,25,0xFFFFFF90,true) rect.visible = false
local dmg = {400,500,600,700,800}
 
--Главная функция
function Tick(tick)
 
if not client.connected or client.loading or client.console or tick < sleep then return end

sleep = tick + 10

local 

me = entityList:GetMyHero()

if not me then return end
       
local dagon = me:FindDagon()
local ethereal= me:FindItem

("item_ethereal_blade")
local visible = Draw(activated,dagon)
local attribute = GetAttribute(me)

rect.visible = visible
icon.visible = 

visible

if visible then
local lvl = string.match (dagon.name, "%d+")
if not lvl then lvl = 1 end 
local dmgD = dmg[lvl*1]
local enemy = 

entityList:GetEntities({type=LuaEntity.TYPE_HERO,alive=true,visible=true,team = (5-me.team)})
	local purify = me:FindSpell

("oracle_purifying_flames")
if not me:IsChanneling() and Nyx(me) then
for i = 1,#enemy do
local v = enemy[i]
if not v:IsIllusion() then
if 

v.health > 0 and GetDistance2D(v,me) < dagon.castRange and v:CanDie() then
if not v:DoesHaveModifier

("modifier_nyx_assassin_spiked_carapace") then
	
	if dagon.cd==0 and v.health < v:DamageTaken(dmgD, DAMAGE_MAGC, me) then
	

me:SafeCastAbility(dagon,v)
	
	elseif dagon.cd==0 and purify and purify.cd==0 and v.health  < v:DamageTaken(dmgD+360, 

DAMAGE_MAGC, me) then
	me:SafeCastAbility(purify,v)
	
	elseif ethereal and ethereal.cd==0 and purify and purify.cd==0 and 

v.health < v:DamageTaken(((360+75+2*attribute)*1.4), DAMAGE_MAGC, me)  then
	me:SafeCastAbility(ethereal,v)
	
	elseif ethereal 

and ethereal.cd==0 and dagon.cd==0 and v.health < v:DamageTaken(((dmgD+75+2*attribute)*1.4), DAMAGE_MAGC, me)  then
	

me:SafeCastAbility(ethereal,v)
	
	elseif ethereal and ethereal.cd==0 and dagon.cd==0 and purify and purify.cd==0 and v.health < 

v:DamageTaken(((dmgD+75+2*attribute+360)*1.4), DAMAGE_MAGC, me) then
	me:SafeCastAbility(ethereal,v)
	
	end
end
end
end
end
end	
end

end

function Nyx(target)
if target.classId == CDOTA_Unit_Hero_Nyx_Assassin and target:DoesHaveModifier

("modifier_nyx_assassin_vendetta") then
return false
end
return true
end

function Draw(one,two)
if one and two then
return true
end
return 

false
end

function Key()

if not client.chat and IsKeyDown(key) then
activated = not activated
end

end

function GameClose()
rect.visible = 

false
icon.visible = false	
end

function GetAttribute(me)
	local stat = {{me.agility,me.agilityTotal},

{me.intellect,me.intellectTotal},{me.strength,me.strengthTotal}}	
	local abtibute = math.max(stat[1][1],stat[2][1],stat

[3][1])
	for i,v in ipairs(stat) do
		if abtibute == v[1] then
			return math.floor(v[2])
		end
	

end	
end
 
script:RegisterEvent(EVENT_CLOSE,GameClose)
script:RegisterEvent(EVENT_KEY,Key)
script:RegisterEvent(EVENT_TICK,Tick)
