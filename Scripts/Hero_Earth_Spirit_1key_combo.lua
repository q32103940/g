require("libs.Utils")
require("libs.ScriptConfig")

config = ScriptConfig.new()
config:SetParameter("Hotkey", "1", config.TYPE_HOTKEY)
config:Load()

local key = string.byte(config.Hotkey)
local ulti = true

local stage = 0
local sleep = nil
local remnants = {}
local ultistate = {}
local xx,yy = -30,-40


function Key(msg,code)

    if msg ~= KEY_UP or code ~= key or client.chat or not client.connected or client.loading or client.console then	return end

	local me = entityList:GetMyHero() 
	
	if not me then return end

	if me.classId ~= CDOTA_Unit_Hero_EarthSpirit then
		script:Disable()		
	elseif not start then
		sleep = nil
		start = true
	else
		sleep,start = nil
		stage = 0
	end

end

function Combo(tick)

	local me = entityList:GetMyHero() 
	
	if not me then return end
	
	Track()
		
	if start then
		
		local remnant = me:GetAbility(4)
		local grip = me:GetAbility(3)
		local roll = me:GetAbility(2)
		local smash = me:GetAbility(1)
		
		local stunned = entityList:GetEntities(function (ent) return ent.type == LuaEntity.TYPE_HERO and ent:DoesHaveModifier("modifier_stunned") == true end)[1]

		if me:CanCast() then
			if stage == 0 then			
				if me.activity == LuaEntityNPC.ACTIVITY_MOVE then
					me:Stop()
					sleep = GetTick() + client.latency + 25
				end	
				stage = 1
			elseif stage == 1 then
				if remnant:CanBeCasted() and smash:CanBeCasted() then
					local t_ = client.mousePosition
					me:CastAbility(remnant,(t_ - me.position) * 150 / GetDistance2D(t_,me) + me.position,false)
					me:CastAbility(smash,(t_ - me.position) * 150 / GetDistance2D(t_,me) + me.position,true)	
					sleep = GetTick() + 1000
					stage = 2
				end
			elseif stage == 2 and stunned and grip:CanBeCasted() and GetDistance2D(stunned,me) < grip.castRange then
				local last = Last()
				if last then
					me:CastAbility(grip,last.position)
					stage = 3
					sleep = GetTick() + 500
				end
			elseif stage == 3 and roll:CanBeCasted() and stunned and stunned:DoesHaveModifier("modifier_earth_spirit_boulder_smash_silence") then			
				me:CastAbility(roll,(stunned.position - me.position) * 150 / GetDistance2D(stunned,me) + me.position)
				stage = 0
				start = nil
			end			
		end
		
		if sleep and GetTick() > sleep then
			sleep,start = nil
			stage = 0
		end
	end
	
	if SleepCheck("ulti") and ulti and me:GetAbility(5).cd ~= 0 then
		local enemy = entityList:GetEntities({type=LuaEntity.TYPE_HERO, illusion=false})
		for i,v in ipairs(enemy) do

			local offset = v.healthbarOffset
			if offset == -1 then return end
		
			if not ultistate[v.handle] then	ultistate[v.handle] = {}
				ultistate[v.handle].fon = drawMgr:CreateRect(xx,yy,60,6,0x000000D0) ultistate[v.handle].fon.visible = false ultistate[v.handle].fon.entity = v ultistate[v.handle].fon.entityPosition = Vector(0,0,offset)
				ultistate[v.handle].im = drawMgr:CreateRect(xx,yy,60,6,0x008000FF) ultistate[v.handle].im.visible = false ultistate[v.handle].im.entity = v ultistate[v.handle].im.entityPosition = Vector(0,0,offset)
				ultistate[v.handle].bo = drawMgr:CreateRect(xx-1,yy-1,62,8,0x000000FF,true) ultistate[v.handle].bo.visible = false ultistate[v.handle].bo.entity = v ultistate[v.handle].bo.entityPosition = Vector(0,0,offset)				
			end
			
			if v.alive and v.visible then
				local mag = v:FindModifier("modifier_earth_spirit_magnetize")
				if mag then
					ultistate[v.handle].im.w = 60 - (mag.elapsedTime*10)					
					ultistate[v.handle].bo.visible = true
					ultistate[v.handle].fon.visible = true
					ultistate[v.handle].im.visible = true
				elseif ultistate[v.handle].im.visible then
					ultistate[v.handle].im.visible = false
					ultistate[v.handle].bo.visible = false
					ultistate[v.handle].fon.visible = false
				end
			elseif ultistate[v.handle].im.visible then
				ultistate[v.handle].im.visible = false
				ultistate[v.handle].bo.visible = false
				ultistate[v.handle].fon.visible = false
			end

		end	Sleep(200,"ulti")
	end
	
end

function Last()
	local remn = entityList:GetEntities({classId = CDOTA_Unit_Earth_Spirit_Stone})
	if #remn > 0 then
		table.sort(remn, function(a,b) return remnants[a.handle]>remnants[b.handle] end)
		return remn[1]
	end
end

function Track()	
	local remn = entityList:GetEntities({classId = CDOTA_Unit_Earth_Spirit_Stone})
	for i,v in ipairs(remn) do
		if not remnants[v.handle] then
			remnants[v.handle] = client.totalGameTime
		end
	end
end

function GameClose()
	stage = 0
	sleep,start = nil,nil
	remnants = {}
end

script:RegisterEvent(EVENT_TICK,Combo)
script:RegisterEvent(EVENT_CLOSE,GameClose)
script:RegisterEvent(EVENT_KEY,Key)
