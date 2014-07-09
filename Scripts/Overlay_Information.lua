require("libs.Res")
require("libs.ScriptConfig")

config = ScriptConfig.new()
config:SetParameter("manaBar", true)
config:SetParameter("overlaySpell", true)
config:SetParameter("overlayItem", true)
config:SetParameter("topPanel", true)
config:SetParameter("glypPanel", true)
config:SetParameter("ShowRune", true)
config:SetParameter("ShowCourier", true)
config:Load()

local manaBar = config.manaBar
local overlaySpell = config.overlaySpell
local overlayItem = config.overlayItem
local topPanel = config.topPanel
local glypPanel = config.glypPanel
local ShowRune = config.ShowRune
local ShowCourier = config.ShowCourier

local F10 = drawMgr:CreateFont("F10","Arial",10,500)
local F11 = drawMgr:CreateFont("F11","Arial",11,500)
local F12 = drawMgr:CreateFont("F12","Arial",12,500)
local F13 = drawMgr:CreateFont("F13","Arial",13,500)
local F14 = drawMgr:CreateFont("F14","Arial",14,500)
local item = {} local hero = {} local spell = {} local panel = {} local mana = {} local cours = {}

local minimapRune = drawMgr:CreateRect(0,0,20,20,0x000000ff) 
minimapRune.visible = false

local sleeptick = 0

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
tmanaSize = 74
tmanaX = 38
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
elseif math.floor(client.screenRatio*100) == 125 then
testX = 1280
testY = 1024
tpanelHeroSize = 58
tpanelHeroDown = 25.714
tpanelHeroSS = 23
tmanaSize = 97
tmanaX = 48
tmanaY = 21
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
local x_ = tpanelHeroSize*(client.screenSize.x/testX)
local y_ = client.screenSize.y/tpanelHeroDown
local ss = tpanelHeroSS*(client.screenSize.x/testX)

--manabar coordinate
local manaSizeW = client.screenSize.x/testX*tmanaSize
local manaX = client.screenSize.x/testX*tmanaX
local manaY = client.screenSize.y/testY*tmanaY

--gliph coordinate
local glyph = drawMgr:CreateText(client.screenSize.x/tglyphX,client.screenSize.y/tglyphY,0xFFFFFF60,"",F13)
glyph.visible = false

function Tick(tick)

	if not client.connected or client.loading or client.console or tick < sleeptick then return end

	sleeptick = tick + 200

	local me = entityList:GetMyHero()

	if not me then return end
	
	if ShowRune then
		Rune()
	end
	
	if ShowCourier then
		Courier(me)
	end
	
	local enemies = entityList:GetEntities({type=LuaEntity.TYPE_HERO, illusion=false})
	for i,v in ipairs(enemies) do
		if v.team ~= me.team then
			local offset = v.healthbarOffset

			if offset == -1 then return end

			--ManaBar
			if manaBar then
				if not hero[v.handle] then hero[v.handle] = {}
					hero[v.handle].manar1 = drawMgr:CreateRect(-manaX-1,-manaY,manaSizeW+2,6,0x010102ff,true) hero[v.handle].manar1.visible = false hero[v.handle].manar1.entity = v hero[v.handle].manar1.entityPosition = Vector(0,0,offset)
					hero[v.handle].manar2 = drawMgr:CreateRect(-manaX,-manaY+1,0,4,0x5279FFff) hero[v.handle].manar2.visible = false hero[v.handle].manar2.entity = v hero[v.handle].manar2.entityPosition = Vector(0,0,offset)
					hero[v.handle].manar3 = drawMgr:CreateRect(0,-manaY+1,0,4,0x00175Fff) hero[v.handle].manar3.visible = false hero[v.handle].manar3.entity = v hero[v.handle].manar3.entityPosition = Vector(0,0,offset)
				end

				for d= 1, v.maxMana/100 do
					if not not mana[d] then mana[d] = {} end
					if not hero[v.handle].mana then hero[v.handle].mana = {} end
					if not hero[v.handle].mana[d] then hero[v.handle].mana[d] = {}
					hero[v.handle].mana[d].cage = drawMgr:CreateRect(0,-manaY+1,1,5,0x0D1453ff,true) hero[v.handle].mana[d].cage.visible = false hero[v.handle].mana[d].cage.entity = v hero[v.handle].mana[d].cage.entityPosition = Vector(0,0,v.healthbarOffset)
					end
					if offset ~= -1 and v.visible and v.alive then
						hero[v.handle].mana[d].cage.visible = true hero[v.handle].mana[d].cage.x = -manaX+manaSizeW/v.maxMana*100*d
					else
						hero[v.handle].mana[d].cage.visible = false
					end
				end

				if v.visible and v.alive then
					local manaPercent = v.mana/v.maxMana
					local printMe = string.format("%i",math.floor(v.mana))
					hero[v.handle].manar1.visible = true
					hero[v.handle].manar2.visible = true hero[v.handle].manar2.w = manaSizeW*manaPercent
					hero[v.handle].manar3.visible = true hero[v.handle].manar3.x = -manaX+manaSizeW*manaPercent hero[v.handle].manar3.w = manaSizeW*(1-manaPercent)
				elseif hero[v.handle].manar1.visible then
					hero[v.handle].manar1.visible = false
					hero[v.handle].manar2.visible = false
					hero[v.handle].manar3.visible = false
				end
			end
			if overlaySpell then
			--Spell
				for a= 1, 7 do
					if not spell[a] then spell[a] = {} end
					if not hero[v.handle].spell then hero[v.handle].spell = {} end

					if not hero[v.handle].spell[a] then hero[v.handle].spell[a] = {}
						hero[v.handle].spell[a].bg = drawMgr:CreateRect(a*18-54,81,16,14,0x00000095) hero[v.handle].spell[a].bg.visible = false hero[v.handle].spell[a].bg.entity = v hero[v.handle].spell[a].bg.entityPosition = Vector(0,0,offset)
						hero[v.handle].spell[a].nl = drawMgr:CreateRect(a*18-55,80,18,16,0xCE131399,true) hero[v.handle].spell[a].nl.visible = false hero[v.handle].spell[a].nl.entity = v hero[v.handle].spell[a].nl.entityPosition = Vector(0,0,offset)
						hero[v.handle].spell[a].lvl1 = drawMgr:CreateRect(a*18-52,92,2,2,0xFFFF00FF) hero[v.handle].spell[a].lvl1.visible = false hero[v.handle].spell[a].lvl1.entity = v hero[v.handle].spell[a].lvl1.entityPosition = Vector(0,0,offset)
						hero[v.handle].spell[a].lvl2 = drawMgr:CreateRect(a*18-49,92,2,2,0xFFFF00FF) hero[v.handle].spell[a].lvl2.visible = false hero[v.handle].spell[a].lvl2.entity = v hero[v.handle].spell[a].lvl2.entityPosition = Vector(0,0,offset)
						hero[v.handle].spell[a].lvl3 = drawMgr:CreateRect(a*18-46,92,2,2,0xFFFF00FF) hero[v.handle].spell[a].lvl3.visible = false hero[v.handle].spell[a].lvl3.entity = v hero[v.handle].spell[a].lvl3.entityPosition = Vector(0,0,offset)
						hero[v.handle].spell[a].lvl4 = drawMgr:CreateRect(a*18-43,92,2,2,0xFFFF00FF) hero[v.handle].spell[a].lvl4.visible = false hero[v.handle].spell[a].lvl4.entity = v hero[v.handle].spell[a].lvl4.entityPosition = Vector(0,0,offset)
						hero[v.handle].spell[a].textT = drawMgr:CreateText(0,80,0xFFFFFFAA,"",F13) hero[v.handle].spell[a].textT.visible = false hero[v.handle].spell[a].textT.entity = v hero[v.handle].spell[a].textT.entityPosition = Vector(0,0,offset)
					end

					local Spell = v:GetAbility(a)

					if v.alive and v.visible and Spell ~= nil and Spell.name ~= "attribute_bonus" and not Spell.hidden then
						hero[v.handle].spell[a].bg.visible = true
						if Spell.state == 16 then
							hero[v.handle].spell[a].nl.visible = true hero[v.handle].spell[a].nl.textureId = drawMgr:GetTextureId("NyanUI/other/spell_nolearn")
							hero[v.handle].spell[a].textT.visible = false
						elseif Spell.state == -1 then
							hero[v.handle].spell[a].nl.visible = true hero[v.handle].spell[a].nl.textureId = drawMgr:GetTextureId("NyanUI/other/spell_ready")
							hero[v.handle].spell[a].textT.visible = false					
						elseif Spell.cd > 0 then
							local cooldown = math.ceil(Spell.cd)
							local shift1 = nil
							if cooldown > 99 then cooldown = "99" shift1 = 1 elseif cooldown < 10 then shift1 = 4 else shift1 = 2 end
							hero[v.handle].spell[a].nl.visible = true hero[v.handle].spell[a].nl.textureId = drawMgr:GetTextureId("NyanUI/other/spell_cooldown")
							hero[v.handle].spell[a].textT.visible = true hero[v.handle].spell[a].textT.x = a*18-53+shift1 hero[v.handle].spell[a].textT.text = ""..cooldown hero[v.handle].spell[a].textT.color = 0xFFFFFFff
						elseif Spell.state == 17 then
							hero[v.handle].spell[a].nl.visible = true hero[v.handle].spell[a].nl.textureId = drawMgr:GetTextureId("NyanUI/other/spell_passive")
							hero[v.handle].spell[a].textT.visible = false
						elseif v.mana - Spell.manacost < 0 and Spell.cd == 0 then
							local ManaCost = math.floor(math.ceil(Spell.manacost) - v.mana)
							local shift2 = nil
							if ManaCost > 99 then ManaCost = "99" shift2 = 1 elseif ManaCost < 10 then shift2 = 4 else shift2 = 2 end
							hero[v.handle].spell[a].nl.visible = true hero[v.handle].spell[a].nl.textureId = drawMgr:GetTextureId("NyanUI/other/spell_nomana")
							hero[v.handle].spell[a].textT.visible = true hero[v.handle].spell[a].textT.x = a*18-53+shift2 hero[v.handle].spell[a].textT.text = ""..ManaCost hero[v.handle].spell[a].textT.color = 0xBBA9EEff
						elseif hero[v.handle].spell[a].nl.visible then
							hero[v.handle].spell[a].nl.visible = false
							hero[v.handle].spell[a].textT.visible = false
						end

						if Spell.level == 1 then
							hero[v.handle].spell[a].lvl1.visible = true
						elseif Spell.level == 2 then
							hero[v.handle].spell[a].lvl1.visible = true
							hero[v.handle].spell[a].lvl2.visible = true
						elseif Spell.level == 3 then
							hero[v.handle].spell[a].lvl1.visible = true
							hero[v.handle].spell[a].lvl2.visible = true
							hero[v.handle].spell[a].lvl3.visible = true
						elseif Spell.level >= 4 then
							hero[v.handle].spell[a].lvl1.visible = true
							hero[v.handle].spell[a].lvl2.visible = true
							hero[v.handle].spell[a].lvl3.visible = true
							hero[v.handle].spell[a].lvl4.visible = true
						elseif hero[v.handle].spell[a].lvl1.visible then
							hero[v.handle].spell[a].lvl1.visible = false
							hero[v.handle].spell[a].lvl2.visible = false
							hero[v.handle].spell[a].lvl3.visible = false
							hero[v.handle].spell[a].lvl4.visible = false
						end
					elseif hero[v.handle].spell[a].bg.visible then
							hero[v.handle].spell[a].bg.visible = false
							hero[v.handle].spell[a].nl.visible = false
							hero[v.handle].spell[a].lvl1.visible = false
							hero[v.handle].spell[a].lvl2.visible = false
							hero[v.handle].spell[a].lvl3.visible = false
							hero[v.handle].spell[a].lvl4.visible = false
							hero[v.handle].spell[a].textT.visible = false
						end
					end
				end
			if v.classId == CDOTA_Unit_Hero_DoomBringer and v.visible then				
				hero[v.handle].spell[4].bg.textureId =  drawMgr:GetTextureId("NyanUI/spellicons/"..v:GetAbility(4).name)
				hero[v.handle].spell[5].bg.textureId =  drawMgr:GetTextureId("NyanUI/spellicons/"..v:GetAbility(5).name)
			end
			if v.classId == CDOTA_Unit_Hero_Rubick and v.visible then
				hero[v.handle].spell[5].bg.textureId =  drawMgr:GetTextureId("NyanUI/spellicons/"..v:GetAbility(5).name)
				hero[v.handle].spell[6].bg.textureId =  drawMgr:GetTextureId("NyanUI/spellicons/"..v:GetAbility(6).name)
			end
			--Items
			if overlayItem then
				enemies[v.classId] = 0

				for c = 1, 6 do

					if not item[c] then item[c] = {} end
					if not hero[v.handle].item then hero[v.handle].item = {} end

					if not hero[v.handle].item[c] then hero[v.handle].item[c] = {}
						hero[v.handle].item[c].gem = drawMgr:CreateRect(0,-manaY+7,18,16,0x7CFC0099) hero[v.handle].item[c].gem.visible = false hero[v.handle].item[c].gem.entity = v hero[v.handle].item[c].gem.entityPosition = Vector(0,0,offset)
						hero[v.handle].item[c].dust = drawMgr:CreateRect(0,-manaY+6,18,16,0x7CFC0099) hero[v.handle].item[c].dust.visible = false hero[v.handle].item[c].dust.entity = v hero[v.handle].item[c].dust.entityPosition = Vector(0,0,offset)
						hero[v.handle].item[c].sentryImg = drawMgr:CreateRect(0,-manaY+7,16,14,0x7CFC0099) hero[v.handle].item[c].sentryImg.visible = false hero[v.handle].item[c].sentryImg.entity = v hero[v.handle].item[c].sentryImg.entityPosition = Vector(0,0,offset)
						hero[v.handle].item[c].sentryTxt = drawMgr:CreateText(0,-manaY+10,0xffffffFF,"",F11) hero[v.handle].item[c].sentryTxt.visible = false hero[v.handle].item[c].sentryTxt.entity = v hero[v.handle].item[c].sentryTxt.entityPosition = Vector(0,0,offset)					
						hero[v.handle].item[c].sphereImg = drawMgr:CreateRect(0,-manaY+7,16,14,0x7CFC0099) hero[v.handle].item[c].sphereImg.visible = false hero[v.handle].item[c].sphereImg.entity = v hero[v.handle].item[c].sphereImg.entityPosition = Vector(0,0,offset)
						hero[v.handle].item[c].sphereTxt = drawMgr:CreateText(0,-manaY+7,0xffffffFF,"",F13) hero[v.handle].item[c].sphereTxt.visible = false hero[v.handle].item[c].sphereTxt.entity = v hero[v.handle].item[c].sphereTxt.entityPosition = Vector(0,0,offset)						
					end

					local Items = v:GetItem(c)

					if v.alive and v.visible and Items ~= nil then
						
						if Items.name == "item_gem" then
							enemies[v.classId] = enemies[v.classId]  + 20
							hero[v.handle].item[c].gem.visible = true hero[v.handle].item[c].gem.x = enemies[v.classId]-manaX-18 hero[v.handle].item[c].gem.textureId = drawMgr:GetTextureId("NyanUI/other/O_gem")						
						else
							hero[v.handle].item[c].gem.visible = false
						end
						if Items.name == "item_dust" then
							enemies[v.classId] = enemies[v.classId]  + 20
							hero[v.handle].item[c].dust.visible = true hero[v.handle].item[c].dust.x = enemies[v.classId]-manaX-18 hero[v.handle].item[c].dust.textureId = drawMgr:GetTextureId("NyanUI/other/O_dust")	
						else
							hero[v.handle].item[c].dust.visible = false
						end
						if Items.name == "item_ward_sentry" then
							enemies[v.classId] = enemies[v.classId]  + 20
							local charg = Items.charges
							hero[v.handle].item[c].sentryImg.visible = true hero[v.handle].item[c].sentryImg.x = enemies[v.classId]-manaX-18 hero[v.handle].item[c].sentryImg.textureId = drawMgr:GetTextureId("NyanUI/other/O_sentry")
							hero[v.handle].item[c].sentryTxt.visible = true hero[v.handle].item[c].sentryTxt.x = enemies[v.classId]-manaX-8 hero[v.handle].item[c].sentryTxt.text = ""..charg
						else
							hero[v.handle].item[c].sentryImg.visible = false
							hero[v.handle].item[c].sentryTxt.visible = false
						end

						if Items.name == "item_sphere" then
							enemies[v.classId] = enemies[v.classId]  + 20
							hero[v.handle].item[c].sphereImg.visible = true hero[v.handle].item[c].sphereImg.x = enemies[v.classId]-manaX-16 hero[v.handle].item[c].sphereImg.textureId = drawMgr:GetTextureId("NyanUI/other/O_sphere")
							if Items.cd ~= 0 then
								local cdL = math.ceil(Items.cd)
								local shift4 = nil
								if cdL < 10 then shift4 = 2 else shift4 = 0 end
								hero[v.handle].item[c].sphereTxt.visible = true hero[v.handle].item[c].sphereTxt.x = enemies[v.classId]-manaX-14 + shift4 hero[v.handle].item[c].sphereTxt.text = ""..cdL
							else
								hero[v.handle].item[c].sphereTxt.visible = false
							end
						else
							hero[v.handle].item[c].sphereTxt.visible = false
							hero[v.handle].item[c].sphereImg.visible = false
						end

					else					
						hero[v.handle].item[c].gem.visible = false
						hero[v.handle].item[c].dust.visible = false
						hero[v.handle].item[c].sentryImg.visible = false
						hero[v.handle].item[c].sentryTxt.visible = false
						hero[v.handle].item[c].sphereTxt.visible = false
						hero[v.handle].item[c].sphereImg.visible = false						
					end

				end
			end
		end
		--ulti panel
		if topPanel then
		
			local xx = GetXX(v)
			local color = Color(v,me)
			
			if not panel[v.playerId] then panel[v.playerId] = {}
				panel[v.playerId].hpINB = drawMgr:CreateRect(0,y_,x_-1,8,0x000000D0) panel[v.playerId].hpINB.visible = false
				panel[v.playerId].hpIN = drawMgr:CreateRect(0,y_,0,8,color) panel[v.playerId].hpIN.visible = false				
				panel[v.playerId].hpB = drawMgr:CreateRect(0,y_,x_-1,8,0x000000ff,true) panel[v.playerId].hpB.visible = false
				
				panel[v.playerId].ulti = drawMgr:CreateRect(0,y_-9,14,14,0x0EC14A80) panel[v.playerId].ulti.visible = false		
				panel[v.playerId].ultiCDT = drawMgr:CreateText(0,y_-9,0xFFFFFF99,"",F13) panel[v.playerId].ultiCDT.visible = false				
			end			

			for d = 4,8 do
				local ult = v:GetAbility(d)
				if ult ~= nil then
					if ult.abilityType == 1 then						
						panel[v.playerId].ulti.x = xx-3+x_*v.playerId
						if ult.cd > 0 then
							local cooldownUlti = math.ceil(ult.cd)
							if cooldownUlti > 99 then cooldownUlti = "99" shift3 = -2 elseif cooldownUlti < 10 then shift3 = 0 else shift3 = -2 end							
							panel[v.playerId].ulti.visible = true 
							panel[v.playerId].ulti.textureId = drawMgr:GetTextureId("NyanUI/other/ulti_cooldown")
							panel[v.playerId].ultiCDT.visible = true panel[v.playerId].ultiCDT.x = xx+x_*v.playerId + shift3 panel[v.playerId].ultiCDT.text = ""..cooldownUlti
						elseif ult.state == LuaEntityAbility.STATE_READY or ult.state == 17 then
							panel[v.playerId].ulti.visible = true 
							panel[v.playerId].ulti.textureId = drawMgr:GetTextureId("NyanUI/other/ulti_ready")
							panel[v.playerId].ultiCDT.visible = false						
						elseif ult.state == LuaEntityAbility.STATE_NOMANA then								
							panel[v.playerId].ulti.textureId = drawMgr:GetTextureId("NyanUI/other/ulti_nomana")
							panel[v.playerId].ultiCDT.visible = false						
						end
					end
				end
			end
			if v.respawnTime == 0 then
				local health = string.format("%i",math.floor(v.health))
				local healthPercent = v.health/v.maxHealth
				local manaPercent = v.mana/v.maxMana
				panel[v.playerId].hpINB.visible = true panel[v.playerId].hpINB.x = xx-ss+x_*v.playerId
				panel[v.playerId].hpIN.visible = true panel[v.playerId].hpIN.x = xx-ss+x_*v.playerId panel[v.playerId].hpIN.w = (x_-2)*healthPercent
				panel[v.playerId].hpB.visible = true panel[v.playerId].hpB.x = xx-ss+x_*v.playerId
			elseif panel[v.playerId].hpINB.visible then
				panel[v.playerId].hpINB.visible = false
				panel[v.playerId].hpIN.visible = false
				panel[v.playerId].hpB.visible = false
			end
		end
	end
	--gliph cooldown
	local team = 5 - me.team
	local Time = client:GetGlyphCooldown(team)
	local sms = nil
	if Time == 0 then sms = "Ry" else sms = Time end
	glyph.visible = true glyph.text = ""..sms

end

function Rune()
	local runes = entityList:GetEntities({classId=CDOTA_Item_Rune})
	if #runes == 0 then
			if minimapRune.visible == true then
			minimapRune.visible = false				
			end
		return
	end	
	local rune = runes[1]
	local runeType = rune.runeType
	local filename = ""	
	if runeType == 0 then
			filename = "doubledamage"
	elseif runeType == 1 then
			filename = "haste"
	elseif runeType == 2 then
			filename = "illusion"
	elseif runeType == 3 then
			filename = "invis"
	elseif runeType == 4 then
			filename = "regen"
	end	
	if minimapRune.visible == false then
        local runeMinimap = MapToMinimap(rune)
		minimapRune.visible = true
        minimapRune.x = runeMinimap.x-20/2
		minimapRune.y = runeMinimap.y-20/2
		minimapRune.textureId = drawMgr:GetTextureId("NyanUI/minirunes/"..filename)         
    end	
end

function Courier(me)		
	local enemyCours = entityList:FindEntities({classId = CDOTA_Unit_Courier,team = (5-me.team)})
	for i,v in ipairs(enemyCours) do
	
		if not cours[v.handle] then
			cours[v.handle] = {} cours[v.handle] = drawMgr:CreateRect(0,0,location.minimap.px+3,location.minimap.px+3,0x000000FF) cours[v.handle].visible = false
		end
	
		if v.visible and v.alive then	
			cours[v.handle].visible = true
			local courMinimap = MapToMinimap(v)
			cours[v.handle].x,cours[v.handle].y = courMinimap.x-10,courMinimap.y-6
			local flying = v:GetProperty("CDOTA_Unit_Courier","m_bFlyingCourier")
			if flying then
				cours[v.handle].textureId = drawMgr:GetTextureId("NyanUI/other/courier_flying")
				cours[v.handle].size = Vector2D(location.minimap.px+9,location.minimap.px+1)
			else
				cours[v.handle].textureId = drawMgr:GetTextureId("NyanUI/other/courier")		
			end
		else
			cours[v.handle].visible = false
		end
	end  
end

function GetXX(ent)
	local team = ent.team
	if team == 2 then		
		return client.screenSize.x/txxG + 1
	elseif team == 3 then
		return client.screenSize.x/txxB 
	end
end

function Color(ent,me)
	local team = ent.team
	if team ~= me.team then
		return 0x960018FF
	else
		return 0x008000FF
	end
end
	
function GameClose()
	mana = {}
	spell = {}
	item = {}
	hero = {}
	panel = {}
	cours = {}
	minimapRune.visible = false	
	glyph.visible = false
	collectgarbage("collect")
end

script:RegisterEvent(EVENT_CLOSE, GameClose)
script:RegisterEvent(EVENT_TICK,Tick)
