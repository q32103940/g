--config
key =  string.byte("0")

activated = true 
xx = client.screenSize.x/300 
yy = client.screenSize.y/1.45
icon = drawMgr:CreateRect(xx,yy,24,16,0x000000ff)
icon.visible = false
rect = drawMgr:CreateRect(xx-1,yy-1,18,17,0xFF0D0D90,true)
rect.visible = false

dmg = {400,500,600,700,800}

 
--Главная функция
function Tick(tick)
 
	if not client.connected or client.loading or client.console or not entityList:GetMyHero() then return end

	me = entityList:GetMyHero() 
       
	local dagon = me:FindItem("item_dagon_5")
    dagon = dagon or me:FindItem("item_dagon_4")
    dagon = dagon or me:FindItem("item_dagon_3")
    dagon = dagon or me:FindItem("item_dagon_2")
    dagon = dagon or me:FindItem("item_dagon")
 
	if not dagon then
		rect.visible = false
		icon.visible = false
		return 
	end
	
	rect.visible = true
	icon.visible = true

	local lvl = string.match (dagon.name, "%d+")
	if not lvl then lvl = 1 end dmgD = dmg[lvl*1]

	if activated then
		rect.color = 0xFFFFFF90		
		icon.textureId = drawMgr:GetTextureId("NyanUI/items/dagon")
		local enemy = entityList:GetEntities({type=LuaEntity.TYPE_HERO,illusion = false,alive=true,visible=true})
		for i, v in ipairs(enemy) do
			if  v.health > 0 and GetDistance2D(v,me) < dagon.castRange and v:CanDie() and SleepCheck() and not me:IsChanneling() then
				if not v:DoesHaveModifier("modifier_nyx_assassin_spiked_carapace") then
					if v.health < v:DamageTaken(dmgD, DAMAGE_MAGC, me) then
						me:SafeCastAbility(dagon,v)
						Sleep(250)
					end
				end
			end                                    
		end  
	else
		rect.color = 0xFF0D0D90		
	end


end

function Key()

	if IsKeyDown(key) then
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
