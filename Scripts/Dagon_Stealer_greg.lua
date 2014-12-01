require("libs.Utils")
require("libs.ScriptConfig")

config = ScriptConfig.new()
--config:SetParameter("Hotkey", "48", config.TYPE_HOTKEY)
config:Load()

local key = config.Hotkey
local xx = client.screenSize.x/300
local yy = client.screenSize.y/1.55

local activated = true
local sleep = 250
local icon = drawMgr:CreateRect(xx,yy,36,24,0x000000ff,drawMgr:GetTextureId("NyanUI/items/dagon")) icon.visible = false
local rect = drawMgr:CreateRect(xx-1,yy-1,26,25,0xFFFFFF90,true) rect.visible = false
local dmg = {400,500,600,700,800}

local monitor     = client.screenSize.x/1600
local F14         = drawMgr:CreateFont("F14","Tahoma",14*monitor,550*monitor) 
local debugText1  = drawMgr:CreateText(10*monitor,475*monitor,-1,"debug1",F14) debugText1.visible = true
--local debugText2  = drawMgr:CreateText(10*monitor,460*monitor,-1,"debug2",F14) debugText2.visible = true
--local debugText3  = drawMgr:CreateText(10*monitor,445*monitor,-1,"debug3",F14) debugText3.visible = true 
--Главная функция
function Tick(tick)
 
if not client.connected or 

client.loading or client.console or tick < sleep then return end

sleep = tick + 10

local me = entityList:GetMyHero()

if not me then return 

end
       
local dagon = me:FindDagon()
local ethereal= me:FindItem("item_ethereal_blade")
local visible = Draw(activated,dagon)
local attribute = GetAttribute(me)
local purify = me:FindSpell("oracle_purifying_flames")
local fortune= me:FindSpell("oracle_fortunes_end")

rect.visible = visible
icon.visible = visible

if visible then 
local lvl = string.match (dagon.name, "%d+")
if not lvl then lvl = 1 end 
dmgD = dmg[lvl*1]
else dmgD=0
end


local enemy = entityList:GetEntities({type=LuaEntity.TYPE_HERO,alive=true,visible=true,team = (5-me.team)})

debugText1.text=""..(fortune.level*75+purify.level*90+dmgD)*0.75

for i = 1,#enemy do
local v = enemy[i]
if not v:IsIllusion() then
if v.health > 0 and v:CanDie() and GetDistance2D(v,me) < 1000  then
if not v:DoesHaveModifier("modifier_nyx_assassin_spiked_carapace") then

--for fortune's end channel detection (debug)
--relativeangle=me:FindRelativeAngle(v)
--debugText2.text=""..relativeangle
--calculates raw dmg from fortunes end if you released the channeling
if fortune and me:IsChanneling(fortune) and me:FindRelativeAngle(v)<0.05  then 
fortunedmg=fortune.level*75
else fortunedmg=0
end


--calculates raw dmg from purify flames if you could cast it on the current target
if purify and purify.cd==0 and GetDistance2D(v,me) < purify.castRange  then
purifydmg=purify.level*90
else purifydmg=0
end
--debugText3.text=""..purifydmg



--dagon only
if dagon and dagon.cd==0 and GetDistance2D(v,me) < dagon.castRange and v.health < v:DamageTaken(dmgD, DAMAGE_MAGC, me) then
me:SafeCastAbility(dagon,v, false)

--fortunes + purify
elseif v.health < v:DamageTaken(fortunedmg+purifydmg, DAMAGE_MAGC, me) then
me:SafeCastAbility(purify,v, false)

--fortunes + dagon
elseif dagon and dagon.cd==0 and GetDistance2D(v,me) < 
dagon.castRange and v.health < v:DamageTaken(dmgD+fortunedmg, DAMAGE_MAGC, me) then
me:SafeCastAbility(dagon,v, false)

--fortunes + purify + dagon
elseif dagon and dagon.cd==0 and GetDistance2D(v,me) < dagon.castRange and GetDistance2D(v,me) < purify.castRange and relativeangle<0.05 and v.health < v:DamageTaken(dmgD+fortunedmg+purifydmg, DAMAGE_MAGC,me) then
me:SafeCastAbility(dagon,v, false)


--[[
elseif dagon.cd==0 and purify and purify.cd==0 and 

v.health  < v:DamageTaken(dmgD+90*purify.level, DAMAGE_MAGC, me) then
me:SafeCastAbility(dagon,v)

elseif ethereal and 

ethereal.cd==0 and purify and purify.cd==0 and v.health < v:DamageTaken(((90*purify.level+75+2*attribute)*1.4), DAMAGE_MAGC, me)  then


me:SafeCastAbility(ethereal,v)

elseif ethereal and ethereal.cd==0 and dagon.cd==0 and v.health < v:DamageTaken(((dmgD

+75+2*attribute)*1.4), DAMAGE_MAGC, me)  then
me:SafeCastAbility(ethereal,v)

elseif ethereal and ethereal.cd==0 and 

dagon.cd==0 and purify and purify.cd==0 and v.health < v:DamageTaken(((dmgD+75+2*attribute+90*purify.level)*1.4), DAMAGE_MAGC, me) then


me:SafeCastAbility(ethereal,v)
--]]
	end
        

end
end
end	
end

end


function Draw(one,two)
if one and two then
return true
end
return 

false
end


function GameClose()
rect.visible = false
icon.visible = false	
end

function GetAttribute(me)
	local stat = 

{{me.agility,me.agilityTotal},{me.intellect,me.intellectTotal},{me.strength,me.strengthTotal}}	
	local abtibute = math.max(stat

[1][1],stat[2][1],stat[3][1])
	for i,v in ipairs(stat) do
		if abtibute == v[1] then
			return 

math.floor(v[2])
		end
	end	
end
 
script:RegisterEvent(EVENT_CLOSE,GameClose)
script:RegisterEvent(EVENT_TICK,Tick)
