F10 = drawMgr:CreateFont("F10","Arial",10,500)
F11 = drawMgr:CreateFont("F11","Arial",11,500)
F12 = drawMgr:CreateFont("F12","Arial",12,500)
F13 = drawMgr:CreateFont("F13","Arial",13,500)
F14 = drawMgr:CreateFont("F14","Arial",14,500)
item = {} hero = {} spell = {} panel = {} mana = {}

print(math.floor(client.screenRatio*100))


--Config. 
--If u have some problem with positioning u can add screen ration(64 line) and create config for yourself.
if math.floor(client.screenRatio*100) == 177 then
testX = 1600
testY = 900
tpanelHeroSize = 55
tpanelHeroDown = 25.714
tpanelHeroSS = 22
tmanaSize = 83
tmanaX = 42
tmanaY = 18
tglyphX = 1.0158
tglyphY = 1.03448
txxB = 2.527
txxG = 3.47
elseif math.floor(client.screenRatio*100) == 166 then
testX = 1280
testY = 768
tpanelHeroSize = 47
tpanelHeroDown = 25.714
tpanelHeroSS = 22
tmanaSize = 70
tmanaX = 36
tmanaY = 14
tglyphX = 1.0180
tglyphY = 1.03448
txxB = 2.558
txxG = 3.62
elseif math.floor(client.screenRatio*100) == 160 then
testX = 1280
testY = 768
tpanelHeroSize = 48.5
tpanelHeroDown = 25.714
tpanelHeroSS = 22
tmanaSize = 72
tmanaX = 37
tmanaY = 15
tglyphX = 1.0180
tglyphY = 1.03448
txxB = 2.579
txxG = 3.735
elseif math.floor(client.screenRatio*100) == 133 then
testX = 1024
testY = 768
tpanelHeroSize = 47
tpanelHeroDown = 25.714
tpanelHeroSS = 22
tmanaSize = 72
tmanaX = 37
tmanaY = 14
tglyphX = 1.021
tglyphY = 1.03448
txxB = 2.747
txxG = 4.54
else
testX = 1600
testY = 900
tpanelHeroSize = 55
tpanelHeroDown = 25.714
tpanelHeroSS = 22
tmanaSize = 83
tmanaX = 42
tmanaY = 18
tglyphX = 1.0158
tglyphY = 1.03448
txxB = 2.527
txxG = 3.47
end

--top panel coordinate
x_ = tpanelHeroSize*(client.screenSize.x/testX)
y_ = client.screenSize.y/tpanelHeroDown
ss = tpanelHeroSS*(client.screenSize.x/testX)

--manabar coordinate
manaSizeW = client.screenSize.x/testX*tmanaSize
manaX = client.screenSize.x/testX*tmanaX
manaY = client.screenSize.y/testY*tmanaY

--gliph coordinate
glyph = drawMgr:CreateText(client.screenSize.x/tglyphX,client.screenSize.y/tglyphY,0xFFFFFF60,"",F13)
glyph.visible = false

function Frame()

	if not client.connected or client.loading or client.console or not entityList:GetMyHero() then return end
			
	local me = entityList:GetMyHero()
	
	if me.team == 2 then xx = client.screenSize.x/txxB
	elseif me.team == 3 then xx = client.screenSize.x/txxG
	end
	
	local t1,t2 = 0,0	
	
	local enemies = entityList:FindEntities({type=LuaEntity.TYPE_HERO ,illusion=false})
	for i,v in ipairs(enemies) do
			
		if v.team ~= me.team then
		
		test = v.position
		test.z = test.z + v.healthbarOffset
		local OnScreen, pos = client:ScreenPosition(test)
		
			--ManaBar	
			
			if not hero[v.handle] then hero[v.handle] = {}					
				hero[v.handle].manar1 = drawMgr:CreateRect(0,0,manaSizeW+2,6,0x010102ff,true) hero[v.handle].manar1.visible = false 
				hero[v.handle].manar2 = drawMgr:CreateRect(0,0,0,4,0x5279FFff) hero[v.handle].manar2.visible = false 			
				hero[v.handle].manar3 = drawMgr:CreateRect(0,0,manaSizeW,4,0x00175Fff) hero[v.handle].manar3.visible = false									
			end			
			
			for d= 1, v.maxMana/100 do
				if not not mana[d] then mana[d] = {} end
				if not hero[v.handle].mana then hero[v.handle].mana = {} end
				if not hero[v.handle].mana[d] then hero[v.handle].mana[d] = {}						
				hero[v.handle].mana[d].cage = drawMgr:CreateRect(0,0,1,5,0x0D1453ff,true) hero[v.handle].mana[d].cage.visible = false
				end
				if OnScreen and v.alive and v.visible then
					hero[v.handle].mana[d].cage.visible = true hero[v.handle].mana[d].cage.x = pos.x-manaX+manaSizeW/v.maxMana*100*d hero[v.handle].mana[d].cage.y = pos.y-manaY
				else
					hero[v.handle].mana[d].cage.visible = false
				end
			end
			
			if OnScreen and v.alive and v.visible then
				local manaPercent = v.mana/v.maxMana
				local printMe = string.format("%i",math.floor(v.mana))
				hero[v.handle].manar1.visible = true hero[v.handle].manar1.x = pos.x-manaX-1 hero[v.handle].manar1.y = pos.y-manaY-1			
				hero[v.handle].manar2.visible = true hero[v.handle].manar2.x = pos.x-manaX hero[v.handle].manar2.y = pos.y-manaY hero[v.handle].manar2.w = manaSizeW*manaPercent								
				hero[v.handle].manar3.visible = true hero[v.handle].manar3.x = pos.x-manaX+manaSizeW*manaPercent hero[v.handle].manar3.y = pos.y-manaY hero[v.handle].manar3.w = manaSizeW*(1-manaPercent)							
			else
				hero[v.handle].manar1.visible = false 
				hero[v.handle].manar2.visible = false 
				hero[v.handle].manar3.visible = false									
			end			
				
			--Spell	
			  for a= 1, 7 do
				if not spell[a] then spell[a] = {} end
				if not hero[v.handle].spell then hero[v.handle].spell = {} end
			
				if not hero[v.handle].spell[a] then hero[v.handle].spell[a] = {} 
					hero[v.handle].spell[a].bg = drawMgr:CreateRect(0,0,14,12,0x00000095) hero[v.handle].spell[a].bg.visible = false 
					hero[v.handle].spell[a].nl = drawMgr:CreateRect(0,0,16,14,0xCE131399,true) hero[v.handle].spell[a].nl.visible = false 							
					hero[v.handle].spell[a].rdy = drawMgr:CreateRect(0,0,16,14,0x00994C99,true) hero[v.handle].spell[a].rdy.visible = false 
					hero[v.handle].spell[a].pas = drawMgr:CreateRect(0,0,16,14,0xCC660099,true) hero[v.handle].spell[a].pas.visible = false 
					hero[v.handle].spell[a].cd = drawMgr:CreateRect(0,0,16,14,0xA1A4A199,true) hero[v.handle].spell[a].cd.visible = false
					hero[v.handle].spell[a].mp = drawMgr:CreateRect(0,0,16,14,0x047AFF99,true) hero[v.handle].spell[a].mp.visible = false
					hero[v.handle].spell[a].lvl1 = drawMgr:CreateRect(0,0,2,2,0xFFFF00FF) hero[v.handle].spell[a].lvl1.visible = false
					hero[v.handle].spell[a].lvl2 = drawMgr:CreateRect(0,0,2,2,0xFFFF00FF) hero[v.handle].spell[a].lvl2.visible = false
					hero[v.handle].spell[a].lvl3 = drawMgr:CreateRect(0,0,2,2,0xFFFF00FF) hero[v.handle].spell[a].lvl3.visible = false
					hero[v.handle].spell[a].lvl4 = drawMgr:CreateRect(0,0,2,2,0xFFFF00FF) hero[v.handle].spell[a].lvl4.visible = false
					hero[v.handle].spell[a].textCD = drawMgr:CreateText(0,0,0xFFFFFFff,"",F12) hero[v.handle].spell[a].textCD.visible = false
					hero[v.handle].spell[a].textMP = drawMgr:CreateText(0,0,0xBBA9EEff,"",F12) hero[v.handle].spell[a].textMP.visible = false					
				end
				
				if OnScreen and v.alive and v.visible and v:GetAbility(a) ~= nil then

					local Spell = v:GetAbility(a)
														
					if Spell.name ~= "attribute_bonus" and not Spell.hidden  then											
						hero[v.handle].spell[a].bg.visible = true hero[v.handle].spell[a].bg.x = pos.x+a*16-46 hero[v.handle].spell[a].bg.y = pos.y+81
						if Spell.state == 16 then
							hero[v.handle].spell[a].nl.visible = true hero[v.handle].spell[a].nl.x = pos.x+a*16-47 hero[v.handle].spell[a].nl.y = pos.y+80	
						else 
							hero[v.handle].spell[a].nl.visible = false
						end
							
						if Spell.state == -1 then
							hero[v.handle].spell[a].rdy.visible = true hero[v.handle].spell[a].rdy.x = pos.x+a*16-47 hero[v.handle].spell[a].rdy.y = pos.y+80
						else
							hero[v.handle].spell[a].rdy.visible = false
						end
							
						if Spell.state == 17 then
							hero[v.handle].spell[a].pas.visible = true hero[v.handle].spell[a].pas.x = pos.x+a*16-47 hero[v.handle].spell[a].pas.y = pos.y+80
						else
							hero[v.handle].spell[a].pas.visible = false
						end
							
						if Spell.cd > 0 then
							local cooldown = math.ceil(Spell.cd)
							if cooldown > 100 then shift1 = -3 elseif cooldown < 10 then shift1 = 2 else shift1 = 0 end
							hero[v.handle].spell[a].cd.visible = true hero[v.handle].spell[a].cd.x = pos.x+a*16-47 hero[v.handle].spell[a].cd.y = pos.y+80
							hero[v.handle].spell[a].textCD.visible = true hero[v.handle].spell[a].textCD.x = pos.x+a*16-44+shift1 hero[v.handle].spell[a].textCD.y = pos.y+80 hero[v.handle].spell[a].textCD.text = ""..cooldown							
						else
							hero[v.handle].spell[a].cd.visible = false
							hero[v.handle].spell[a].textCD.visible = false
						end
							
						if v.mana - Spell.manacost < 0 and Spell.cd == 0 then
							local ManaCost = math.floor(math.ceil(Spell.manacost) - v.mana)
							if ManaCost > 100 then shift2 = -3 elseif ManaCost < 10 then shift2 = 2 else shift2 = 0 end								
							hero[v.handle].spell[a].mp.visible = true hero[v.handle].spell[a].mp.x = pos.x+a*16-47 hero[v.handle].spell[a].mp.y = pos.y+80
							hero[v.handle].spell[a].textMP.visible = true hero[v.handle].spell[a].textMP.x = pos.x+a*16-44+shift2 hero[v.handle].spell[a].textMP.y = pos.y+80 hero[v.handle].spell[a].textMP.text = ""..ManaCost							
						else
							hero[v.handle].spell[a].mp.visible = false	
							hero[v.handle].spell[a].textMP.visible = false
						end						
						
						if Spell.level == 1 then
							hero[v.handle].spell[a].lvl1.visible = true hero[v.handle].spell[a].lvl1.x = pos.x+a*16-45 hero[v.handle].spell[a].lvl1.y = pos.y+91
						elseif Spell.level == 2 then
							hero[v.handle].spell[a].lvl1.visible = true hero[v.handle].spell[a].lvl1.x = pos.x+a*16-45 hero[v.handle].spell[a].lvl1.y = pos.y+91
							hero[v.handle].spell[a].lvl2.visible = true hero[v.handle].spell[a].lvl2.x = pos.x+a*16-42 hero[v.handle].spell[a].lvl2.y = pos.y+91
						elseif Spell.level == 3 then
							hero[v.handle].spell[a].lvl1.visible = true hero[v.handle].spell[a].lvl1.x = pos.x+a*16-45 hero[v.handle].spell[a].lvl1.y = pos.y+91
							hero[v.handle].spell[a].lvl2.visible = true hero[v.handle].spell[a].lvl2.x = pos.x+a*16-42 hero[v.handle].spell[a].lvl2.y = pos.y+91
							hero[v.handle].spell[a].lvl3.visible = true hero[v.handle].spell[a].lvl3.x = pos.x+a*16-39 hero[v.handle].spell[a].lvl3.y = pos.y+91
						elseif Spell.level >= 4 then
							hero[v.handle].spell[a].lvl1.visible = true hero[v.handle].spell[a].lvl1.x = pos.x+a*16-45 hero[v.handle].spell[a].lvl1.y = pos.y+91
							hero[v.handle].spell[a].lvl2.visible = true hero[v.handle].spell[a].lvl2.x = pos.x+a*16-42 hero[v.handle].spell[a].lvl2.y = pos.y+91
							hero[v.handle].spell[a].lvl3.visible = true hero[v.handle].spell[a].lvl3.x = pos.x+a*16-39 hero[v.handle].spell[a].lvl3.y = pos.y+91
							hero[v.handle].spell[a].lvl4.visible = true hero[v.handle].spell[a].lvl4.x = pos.x+a*16-36 hero[v.handle].spell[a].lvl4.y = pos.y+91
						else 
							hero[v.handle].spell[a].lvl1.visible = false 
							hero[v.handle].spell[a].lvl2.visible = false
							hero[v.handle].spell[a].lvl3.visible = false
							hero[v.handle].spell[a].lvl4.visible = false
						end
												
					else
						hero[v.handle].spell[a].bg.visible = false
						hero[v.handle].spell[a].bg.visible = false
						hero[v.handle].spell[a].nl.visible = false
						hero[v.handle].spell[a].rdy.visible = false
						hero[v.handle].spell[a].pas.visible = false
						hero[v.handle].spell[a].cd.visible = false
						hero[v.handle].spell[a].mp.visible = false	
						hero[v.handle].spell[a].lvl1.visible = false 
						hero[v.handle].spell[a].lvl2.visible = false
						hero[v.handle].spell[a].lvl3.visible = false
						hero[v.handle].spell[a].lvl4.visible = false
						hero[v.handle].spell[a].textCD.visible = false
						hero[v.handle].spell[a].textMP.visible = false
					end				
				else 
					hero[v.handle].spell[a].bg.visible = false
					hero[v.handle].spell[a].nl.visible = false
					hero[v.handle].spell[a].rdy.visible = false
					hero[v.handle].spell[a].pas.visible = false
					hero[v.handle].spell[a].cd.visible = false
					hero[v.handle].spell[a].mp.visible = false	
					hero[v.handle].spell[a].lvl1.visible = false 
					hero[v.handle].spell[a].lvl2.visible = false
					hero[v.handle].spell[a].lvl3.visible = false
					hero[v.handle].spell[a].lvl4.visible = false
					hero[v.handle].spell[a].textCD.visible = false
					hero[v.handle].spell[a].textMP.visible = false
				end
			end
		
			--some items			
			enemies[v.name] = 0
				for c= 1, 6 do
					
					if not item[c] then item[c] = {} end
					if not hero[v.handle].item then hero[v.handle].item = {} end				
				
					if not hero[v.handle].item[c] then hero[v.handle].item[c] = {}						
						hero[v.handle].item[c].gem = drawMgr:CreateText(0, 0,0x7CFC0099,"G",F12) hero[v.handle].item[c].gem.visible = false
						hero[v.handle].item[c].dust = drawMgr:CreateText(0, 0,0xFF00FF99,"D",F12) hero[v.handle].item[c].dust.visible = false
						hero[v.handle].item[c].sentry = drawMgr:CreateText(0, 0,0x00BFFF99,"S",F12) hero[v.handle].item[c].sentry.visible = false
						hero[v.handle].item[c].sphere = drawMgr:CreateText(0, 0,0x67C5EE99,"",F12) hero[v.handle].item[c].sphere.visible = false
						hero[v.handle].item[c].sword = drawMgr:CreateText(0, 0,0xC731F599,"",F12) hero[v.handle].item[c].sword.visible = false
					end	
				
					if OnScreen and v.alive and v.visible and v:GetItem(c) ~= nil then
						
						local Items = v:GetItem(c)
						
						if Items.name == "item_gem" then
							enemies[v.name] = enemies[v.name]  + 15
							hero[v.handle].item[c].gem.visible = true hero[v.handle].item[c].gem.x = pos.x + enemies[v.name] - 45  hero[v.handle].item[c].gem.y =  pos.y+95					
						else
							hero[v.handle].item[c].gem.visible = false
						end
						if Items.name == "item_dust" then
							enemies[v.name] = enemies[v.name]  + 15
							hero[v.handle].item[c].dust.visible = true hero[v.handle].item[c].dust.x = pos.x + enemies[v.name] - 45 hero[v.handle].item[c].dust.y = pos.y+95 hero[v.handle].item[c].dust.text = "D"..v:GetItem(c).charges
						else
							hero[v.handle].item[c].dust.visible = false
						end
						if Items.name == "item_ward_sentry" then
							enemies[v.name] = enemies[v.name]  + 15
							hero[v.handle].item[c].sentry.visible = true hero[v.handle].item[c].sentry.x = pos.x + enemies[v.name] - 45 hero[v.handle].item[c].sentry.y = pos.y+95 hero[v.handle].item[c].sentry.text = "S"..v:GetItem(c).charges
						else
							hero[v.handle].item[c].sentry.visible = false
						end
						
						if Items.name == "item_sphere" then
							enemies[v.name] = enemies[v.name]  + 15
							if Items.cd ~= 0 then
								local cdL = math.ceil(v:GetItem(c).cd)
								hero[v.handle].item[c].sphere.visible = true hero[v.handle].item[c].sphere.x = pos.x + enemies[v.name] - 45 hero[v.handle].item[c].sphere.y = pos.y+95 hero[v.handle].item[c].sphere.text = ""..cdL
							else
								hero[v.handle].item[c].sphere.visible = true hero[v.handle].item[c].sphere.x = pos.x + enemies[v.name] - 45 hero[v.handle].item[c].sphere.y = pos.y+95 hero[v.handle].item[c].sphere.text = "L"
							end
						else
							hero[v.handle].item[c].sphere.visible = false
						end
						
						if Items.name == "item_invis_sword" then
							enemies[v.name] = enemies[v.name]  + 15
							if Items.cd ~= 0 then
								local cdS = math.ceil(v:GetItem(c).cd)
								hero[v.handle].item[c].sword.visible = true hero[v.handle].item[c].sword.x = pos.x + enemies[v.name] - 45 hero[v.handle].item[c].sword.y = pos.y+95 hero[v.handle].item[c].sword.text = ""..cdS								
							else
								hero[v.handle].item[c].sword.visible = true hero[v.handle].item[c].sword.x = pos.x + enemies[v.name] - 45 hero[v.handle].item[c].sword.y = pos.y+95 hero[v.handle].item[c].sword.text = "SB"								
							end
						else
							hero[v.handle].item[c].sword.visible = false
						end
					else						
						hero[v.handle].item[c].gem.visible = false
						hero[v.handle].item[c].dust.visible = false
						hero[v.handle].item[c].sentry.visible = false
						hero[v.handle].item[c].sphere.visible = false
						hero[v.handle].item[c].sword.visible = false
					end
					
				end
				
			
			--ulti panel			
			if not panel[v.playerId] then panel[v.playerId] = {}
				panel[v.playerId].hpT = drawMgr:CreateText(0,y_,0xFF3333ff,"",F12) panel[v.playerId].hpT.visible = false
				panel[v.playerId].hpIN = drawMgr:CreateRect(0,y_,0,8,0xFF5151ff) panel[v.playerId].hpIN.visible = false
				panel[v.playerId].hpINB = drawMgr:CreateRect(0,y_,x_-1,8,0x00000070) panel[v.playerId].hpINB.visible = false
				panel[v.playerId].hpB = drawMgr:CreateRect(0,y_,x_-1,8,0x000000ff,true) panel[v.playerId].hpB.visible = false
				panel[v.playerId].ultiB = drawMgr:CreateRect(0,y_-7,14,12,0x00000080,true) panel[v.playerId].ultiB.visible = false
				panel[v.playerId].ultiR = drawMgr:CreateRect(0,y_-6,12,10,0x0EC14A80) panel[v.playerId].ultiR.visible = false
				panel[v.playerId].ultiCD = drawMgr:CreateRect(0,y_-6,12,10,0x4E4E4E80) panel[v.playerId].ultiCD.visible = false
				panel[v.playerId].ultiCDT = drawMgr:CreateText(0,y_-7,0xFFFFFFff,"",F11) panel[v.playerId].ultiCDT.visible = false
			end
				t1 = t1 + 1
				for d = 4,8 do
					if v:GetAbility(d) ~= nil then
						if v:GetAbility(d).abilityType == 1 then
							panel[v.playerId].ultiB.visible = true panel[v.playerId].ultiB.x = xx-1+x_*v.playerId
							if v:GetAbility(d).cd > 0 then
								local cooldownUlti = math.ceil(v:GetAbility(d).cd)
								if cooldownUlti > 100 then shift3 = -2 elseif cooldownUlti < 10 then shift3 = 3 else shift3 = 1 end
								panel[v.playerId].ultiR.visible = false
								panel[v.playerId].ultiCD.visible = true panel[v.playerId].ultiCD.x = xx+x_*v.playerId
								panel[v.playerId].ultiCDT.visible = true panel[v.playerId].ultiCDT.x = xx+x_*v.playerId + shift3 panel[v.playerId].ultiCDT.text = ""..cooldownUlti								
							elseif v:GetAbility(d).cd == 0 and v:GetAbility(d).state ~= 16 then
								panel[v.playerId].ultiCD.visible = false
								panel[v.playerId].ultiCDT.visible = false
								panel[v.playerId].ultiR.visible =true panel[v.playerId].ultiR.x = xx+x_*v.playerId
							elseif
								v:GetAbility(d).state == 16 then
								panel[v.playerId].ultiCD.visible = false
								panel[v.playerId].ultiCDT.visible = false
								panel[v.playerId].ultiR.visible = false
								panel[v.playerId].ultiB.visible = false
							end									
						end
					end
				end
			if v.alive then
				local health = string.format("%i",math.floor(v.health))			
				local healthPercent = v.health/v.maxHealth
				local manaPercent = v.mana/v.maxMana
				panel[v.playerId].hpINB.visible = true panel[v.playerId].hpINB.x = xx-ss+x_*v.playerId
				panel[v.playerId].hpIN.visible = true panel[v.playerId].hpIN.x = xx-ss+x_*v.playerId panel[v.playerId].hpIN.w = (x_-2)*healthPercent
				panel[v.playerId].hpB.visible = true panel[v.playerId].hpB.x = xx-ss+x_*v.playerId				
			else
				panel[v.playerId].hpINB.visible = false 
				panel[v.playerId].hpIN.visible = false 
				panel[v.playerId].hpB.visible = false			
			end
			
			--gliph cooldown		
			if me.team == 2 then team = 3 else team = 2 end
			local Time = client:GetGlyphCooldown(team)
			if Time == 0 then sms = "Ry" else sms = Time end
			glyph.visible = true glyph.text = ""..sms
		end
	end
end

function GameClose()
	mana = {}
	spell = {}
	item = {}
	hero = {}
	panel = {}
	glyph.visible = false
	collectgarbage("collect")
end


script:RegisterEvent(EVENT_CLOSE, GameClose)
script:RegisterEvent(EVENT_FRAME,Frame)
