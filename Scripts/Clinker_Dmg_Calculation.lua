--Подключение библиотеки
require("libs.Utils")

--создаем таблицу
hero = {}

--Шрифт
F16 = drawMgr:CreateFont("F16","Arial",16,500)

--Таблицы урона
dmgL = {80,160,240,320}
dmgR = {100,175,250,325}
dmg = {400,500,600,700,800}

--Главная функция
function Frame( tick )

-- Проверка играем ли мы
	if not client.connected or client.loading or client.console then return end
	
-- Мой герой

	local me = entityList:GetMyHero() 
	
	if not me then return end
	
-- Проверка на героя
	if me.name ~= "npc_dota_hero_tinker" then
		script:Disable()
		return
	end

-- Позиция экрана и назначения скилов
	local laser = me:GetAbility(1)
	local rocket = me:GetAbility(2)
	
-- Проверка спеллов
	if laser.level == 0 and rocket.level == 0 then
		return
	end

-- Определение дагона
	local dagon = me:FindDagon()
	
-- Модификатор урона с дагона
	if dagon then
		local lvl = string.match (dagon.name, "%d+")
		if not lvl then lvl = 1 end dmgD = dmg[lvl*1]
	end

-- Таблица героев
	local enemies = entityList:GetEntities({type=LuaEntity.TYPE_HERO,illusion = false})
	
	--Калькулятор урона
		for i,v in ipairs(enemies) do
			if v.team ~= me.team then
			
			test = v.position
			test.z = test.z + v.healthbarOffset
			local OnScreen, pos = client:ScreenPosition(test)
			
		--Динамическая прорисовка текста
				if not hero[v.handle] then hero[v.handle] = {}			
					hero[v.handle].txt = drawMgr:CreateText(0, 0, 0xFFFFFFFF, "",F16) hero[v.handle].txt.visible = false 				
				end	
			
				if v.health > 0 and OnScreen and v.alive and v.visible then
					if laser.level == 0 then
						if v.health >  ((dmgR[rocket.level]) * (1 - v.magicDmgResist)) then
							local hits = math.floor(v.health -  ((dmgR[rocket.level]) * (1 - v.magicDmgResist)))
							hero[v.handle].txt.visible = true hero[v.handle].txt.x = pos.x -20  hero[v.handle].txt.y = pos.y - 45 hero[v.handle].txt.text = "No kill :" ..hits
						elseif v.health < ((dmgR[rocket.level]) * (1 - v.magicDmgResist)) then
							hero[v.handle].txt.visible = true hero[v.handle].txt.x = pos.x -20  hero[v.handle].txt.y = pos.y - 45 hero[v.handle].txt.text = "Ezy kill"							
						end
					elseif rocket.level == 0 then
						if v.health >  dmgL[laser.level] then
							local hits = math.floor(v.health -  dmgL[laser.level])
							hero[v.handle].txt.visible = true hero[v.handle].txt.x = pos.x -20  hero[v.handle].txt.y = pos.y - 45 hero[v.handle].txt.text = "No kill :" ..hits
						elseif v.health < dmgL[laser.level] then
							hero[v.handle].txt.visible = true hero[v.handle].txt.x = pos.x -20  hero[v.handle].txt.y = pos.y - 45 hero[v.handle].txt.text = "Ezy kill"
						end
					elseif dagon then
						if me:FindItem("item_ethereal_blade") then
							if v.health > (dmgL[laser.level] + 1.4*((dmgD + (me.intellectTotal*2+75) + dmgR[rocket.level]) * (1 - v.magicDmgResist))) then		
								local hits = math.floor(v.health - (dmgL[laser.level] + 1.4*((dmgD + (me.intellectTotal*2+75) + dmgR[rocket.level]) * (1 - v.magicDmgResist))))
								hero[v.handle].txt.visible = true hero[v.handle].txt.x = pos.x -20  hero[v.handle].txt.y = pos.y - 45 hero[v.handle].txt.text = "No kill :" ..hits
								elseif v.health < (dmgL[laser.level] + 1.4*((dmgD + (me.intellectTotal*2+75) + dmgR[rocket.level]) * (1 - v.magicDmgResist))) then
								hero[v.handle].txt.visible = true hero[v.handle].txt.x = pos.x -20  hero[v.handle].txt.y = pos.y - 45 hero[v.handle].txt.text = "Ezy kill"
							end
						else
							if v.health > (dmgL[laser.level] + ((dmgD + dmgR[rocket.level]) * (1 - v.magicDmgResist))) then		
								local hits = math.floor(v.health - (dmgL[laser.level] + ((dmgD+dmgR[rocket.level]) * (1 - v.magicDmgResist))))
								hero[v.handle].txt.visible = true hero[v.handle].txt.x = pos.x -20  hero[v.handle].txt.y = pos.y - 45 hero[v.handle].txt.text = "No kill :" ..hits
							elseif v.health < (dmgL[laser.level] + ((dmgD + dmgR[rocket.level]) * (1 - v.magicDmgResist))) then
								hero[v.handle].txt.visible = true hero[v.handle].txt.x = pos.x -20  hero[v.handle].txt.y = pos.y - 45 hero[v.handle].txt.text = "Ezy kill"
							end
						end
					elseif laser.level ~= 0 and rocket.level ~= 0 then
						if v.health > (dmgL[laser.level] + (dmgR[rocket.level] * (1 - v.magicDmgResist))) then		
							local hits = math.floor(v.health - (dmgL[laser.level] + (dmgR[rocket.level] * (1 - v.magicDmgResist))))
							hero[v.handle].txt.visible = true hero[v.handle].txt.x = pos.x -20  hero[v.handle].txt.y = pos.y - 45 hero[v.handle].txt.text = "No kill :" ..hits
						elseif v.health < (dmgL[laser.level] + (dmgR[rocket.level] * (1 - v.magicDmgResist))) then
							hero[v.handle].txt.visible = true hero[v.handle].txt.x = pos.x -20  hero[v.handle].txt.y = pos.y - 45 hero[v.handle].txt.text = "Ezy kill"
						end
					else
						hero[v.handle].txt.visible = false
					end			
				else
					hero[v.handle].txt.visible = false
				end
			end
		end
end

function GameClose()
	hero = {}
	collectgarbage("collect")	
end
 
script:RegisterEvent(EVENT_CLOSE,GameClose)
script:RegisterEvent(EVENT_FRAME,Frame)

