--lash hit market
require("libs.ScriptConfig")
require("libs.Utils")

config = ScriptConfig.new()
config:SetParameter("LastHitKey", "C", config.TYPE_HOTKEY)
config:SetParameter("DenayHitKey", "X", config.TYPE_HOTKEY)
config:SetParameter("LastHit", true)
config:Load()

local rect = {}
local sleep = 0
local ex = client.screenSize.x/1600*0.8

local lasthit = config.LastHit
local lasthitKey = config.LastHitKey
local denyKey = config.DenayHitKey

function Tick( tick )

	if not client.connected or client.loading or client.console or sleep > tick then return end	
	sleep = tick + 100

	local me = entityList:GetMyHero()	
	if not me then return end

	if client.gameTime > 1800 or me.dmgMin > 100 then
		GameClose()
		script:Disable()
	end

	local dmg = Damage(me)
	local creeps = entityList:GetEntities({classId=CDOTA_BaseNPC_Creep_Lane})	
	
	for i,v in ipairs(creeps) do
		local OnScreen = client:ScreenPosition(v.position)	
		if OnScreen then
			local offset = v.healthbarOffset
			if offset == -1 then return end			
			
			if not rect[v.handle] then 
				rect[v.handle] = {}  rect[v.handle] = drawMgr:CreateRect(-4*ex,-32*ex,0,0,0xFF8AB160) rect[v.handle].visible = false 
				rect[v.handle].entity = v rect[v.handle].entityPosition = Vector(0,0,offset)
			end

			if v.visible and v.alive and v.health > 0 and v.health < (dmg*(1-v.dmgResist)+1) then				
				rect[v.handle].visible = true	
				if v.team == me.team then
					rect[v.handle].w = 20*ex
					rect[v.handle].h = 20*ex
					rect[v.handle].textureId = drawMgr:GetTextureId("NyanUI/other/Active_Deny")
				else
					rect[v.handle].w = 15*ex
					rect[v.handle].h = 15*ex
					rect[v.handle].textureId = drawMgr:GetTextureId("NyanUI/other/Active_Coin")
				end
				--------------
				if lasthit then
					if IsKeyDown(lasthitKey) then
						if v.team ~= me.team and me:GetDistance2D(v) < me.attackRange + 200 then
							entityList:GetMyPlayer():Attack(v)
							break
						end
					elseif IsKeyDown(denyKey) then
						if v.team == me.team and me:GetDistance2D(v) < me.attackRange + 200 then
							entityList:GetMyPlayer():Attack(v)
							break
						end
					end
				end		
				---------------
			elseif v.visible and v.alive and v.health > (dmg*(1-v.dmgResist)) and v.health < (dmg*(1-v.dmgResist))+88 then
				rect[v.handle].visible = true
				if v.team == me.team then
					rect[v.handle].w = 20*ex
					rect[v.handle].h = 20*ex
					rect[v.handle].textureId = drawMgr:GetTextureId("NyanUI/other/Passive_Deny")
				else
					rect[v.handle].w = 15*ex
					rect[v.handle].h = 15*ex
					rect[v.handle].textureId = drawMgr:GetTextureId("NyanUI/other/Passive_Coin")
				end
			elseif rect[v.handle].visible then
				rect[v.handle].visible = false
			end			
		end
	end

end

function Damage(me)
	local dmg =  me.dmgMin + me.dmgBonus
	local items = me.items
	for i,item in ipairs(items) do
		if item and item.name == "item_quelling_blade" then
			return dmg*1.32
		end
	end
	return dmg
end


function GameClose()
	rect = {}
	collectgarbage("collect")
end
 
script:RegisterEvent(EVENT_CLOSE, GameClose)
script:RegisterEvent(EVENT_TICK,Tick)
