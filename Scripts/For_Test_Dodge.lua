--for test

require("libs.Utils")
require("libs.Dodge")

sleep = {}

function Tick(tick)

	if not client.connected or client.loading or client.console or not entityList:GetMyHero() or not SleepCheck() or not LatSleepCheck(lat) then return end
	
	me = entityList:GetMyHero()
	
	local enemy = entityList:GetEntities({type=LuaEntity.TYPE_HERO,alive=true,illusion=false,visible=true})

	for i,v in ipairs(enemy) do
		if v.team ~= me.team then
			--conter spell before cast
			--print(v:GetProperty("CBaseAnimating","m_nSequence")) -- show animation flag
			if AnimationList[v.name] then
				SpellA = MySpell(AnimationList[v.name].ability)
				ItemsA = MyItem(AnimationList[v.name].items)
				if (SpellA and SpellA.state == -1) or (ItemsA and ItemsA.state == -1) then		
					if v:GetProperty("CBaseAnimating","m_nSequence") == AnimationList[v.name].animation then						
						if not AnimationList[v.name].toface or (AnimationList[v.name].toface and ToFace(me,v)) then
							if GetDistance2D(v,me) < AnimationList[v.name].range then
								if AnimationList[v.name].spellLat or AnimationList[v.name].itemLat then
									if (SpellA and SpellA.state == -1) then 
										latency = AnimationList[v.name].spellLat 
									elseif (ItemsA and ItemsA.state == -1) then 
										latency = AnimationList[v.name].itemLat
									end
									me:Attack(v)								
									if not sleep[v.handle] then									
										SmartSleep(latency,v)
										sleep[v.handle] = true
										return
									else
										sleep[v.handle] = false		
										if SpellA and SpellA.state == -1 then
											SmartCast(SpellA,AnimationList[v.name].ability,AnimationList[v.name].vector,v) Sleep(500)
										elseif ItemsA and ItemsA.state == -1 then
											SmartCast(ItemsA,AnimationList[v.name].items,AnimationList[v.name].vectors,v) Sleep(500)
										end
									end
								else 
									if SpellA and SpellA.state == -1 then
										SmartCast(SpellA,AnimationList[v.name].ability,AnimationList[v.name].vector,v) Sleep(500)
									elseif ItemsA and ItemsA.state == -1 then
										SmartCast(ItemsA,AnimationList[v.name].items,AnimationList[v.name].vectors,v) Sleep(500)
									end
								end		
							else
								sleep[v.handle] = false
							end
						end
					else
						sleep[v.handle] = false	
					end
				end
			--counter spell based on modifier
			elseif ModifierList[v.name] then
				SpellM = MySpell(ModifierList[v.name].ability)
				ItemsM = MyItem(ModifierList[v.name].items)
				if me.name == "npc_dota_hero_phoenix" or me.name == "npc_dota_hero_abaddon" or (ItemsM and ItemsM.name == "item_bloodstone") then					
					if v:GetAbility(4).level ~= 0 then
						if v:FindItem("item_ultimate_scepter") then dmg = "damage_scepter" else dmg = "damage" end
						local Dmg = v:GetAbility(4):GetSpecialData(dmg,v:GetAbility(4).level)
						if me.health < v:DamageTaken(Dmg, DAMAGE_MAGC, me) then							
							if me:DoesHaveModifier(ModifierList[v.name].modifier) then							
								if SpellM and SpellM.state == - 1 then
									SmartCast(SpellM,ModifierList[v.name].ability,ModifierList[v.name].vector,v)
									Sleep(250)
								elseif ItemsM then									
									SmartCast(ItemsM,ModifierList[v.name].items,ModifierList[v.name].vectors,v)
									Sleep(250)
								end
							end
						end
					end
				end
				if me.name ~= "npc_dota_hero_phoenix" or me.name ~= "npc_dota_hero_abaddon" then
					if me:DoesHaveModifier(ModifierList[v.name].modifier) then
						if SpellM and SpellM.state == - 1 then
							SmartCast(SpellM,ModifierList[v.name].ability,ModifierList[v.name].vector,v)
							Sleep(250)
						elseif ItemsM and ItemsM.name ~= "item_bloodstone" then							
							SmartCast(ItemsM,ModifierList[v.name].items,ModifierList[v.name].vectors,v)
							Sleep(250)
						end
					end
				end			
			--counter any iniciate
			elseif InitiativeList[v.name] then
				local SpellI = MySpell(InitiativeList[v.name].ability)
				local blink = v:FindItem("item_blink")
				if blink and blink.cd > 11 then					
					Skill = v:FindSpell(InitiativeList[v.name].spells)
					if Skill and Skill.state == -1 then
						if GetDistance2D(v,me) < SpellM.castRange then
							SmartCast(SpellI,InitiativeList[v.name].ability,InitiativeList[v.name].vector,v)
							Sleep(250)
						end
					end
				end
			end						
		end			
	end	
	
end

function SmartSleep(ms,target)

	if type(ms) == "string" then
		LatSleep(tonumber(ms)+(GetDistance2D(me,target)/9),lat)
	elseif type(ms) == "number" then
		LatSleep(ms,lat)
	end
	
end

function MySpell(tab)
	for i,v in ipairs(tab) do
		local abilities = me.abilities
		for _,spell in ipairs(abilities) do
			if spell and spell.name == v then
				return spell
			end
		end
	end
	return nil
end

function MyItem(tab)
	for i,v in ipairs(tab) do
		local items = me.items
		for _,item in ipairs(me.items) do
			if item and item.name == v then
				return item
			end
		end
	end
	return nil
end

function SmartCast(spell,tab1,tab2,target)
	for i,v in ipairs(tab2) do		
		for a, ability in ipairs(tab1) do
			if ability == spell.name then
				local vector = tab2[a]
				if vector == "aoe" then
					me:CastAbility(spell,target.position)
				elseif vector == "me" then
					me:CastAbility(spell,me.position)
				elseif vector == "target" then
					me:CastAbility(spell,target)
				elseif vector == "non" then
					me:CastAbility(spell)
				elseif vector == "specialE" then
					EmberSpecialCast(spell,target)
				end
			end
		end
	end
end

function EmberSpecialCast(spell,target)
	local bonusRange = {250,350,450,550}
	if GetDistance2D(me,target) < 750 + bonusRange[spell.level] and GetDistance2D(me,target) > 750 then
		LongCast(spell,me,target,bonusRange[spell.level])
	elseif GetDistance2D(me,target) < 750 then
		me:CastAbility(spell,target.position)
	end
end

function LongCast(spell,my,target,range)
	me:CastAbility(spell,Vector((my.position.x - target.position.x) * range / GetDistance2D(target,my) + target.position.x,(my.position.y - target.position.y) * range / GetDistance2D(target,my) + target.position.y,target.position.z))
end

function FrontCast(spell,my,target,range)
	me:CastAbility(spell,Vector(my.position.x + range * math.cos(alfa), my.position.y + range * math.sin(alfa),my.position.z))
end

function ToFace(my,t_)
	if ((FindAngle(my,t_)) % (2 * math.pi)) * 180 / math.pi >= 350 or ((FindAngle(my,t_)) % (2 * math.pi)) * 180 / math.pi <= 10 then
		return true
	end
	return false
end

function FindAngle(my,t_)
	return ((math.atan2(my.position.y-t_.position.y,my.position.x-t_.position.x) - t_.rotR + math.pi) % (2 * math.pi)) - math.pi
end

function GameClose()
	sleep = {}
end

script:RegisterEvent(EVENT_CLOSE,GameClose)
script:RegisterEvent(EVENT_TICK,Tick)
