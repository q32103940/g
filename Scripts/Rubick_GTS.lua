require("libs.Utils")

herotab = {} hero = {} ls = {} ult = {} icon = {}
BM = {124,102, 80}
zxc = {true,true,true,true,true,true,true,true}

xx = client.screenSize.x/1.33 yy = client.screenSize.y/100

function Tick( tick )

        if not client.connected or client.loading or client.console then return	end	
		
		local me = entityList:GetMyHero()	
		
		if not me then
			return 
		end
		
		if me.name ~= "npc_dota_hero_rubick" then
			return
		end	
	
		herotab = {}
		
		if me:FindItem("item_ultimate_scepter") then
			range = 1600
		else 
			range = 1000
		end
		
        local enemies = entityList:FindEntities({type=LuaEntity.TYPE_HERO,illusion = false})		
        for i = 1, #enemies do
			local h = enemies[i]
			if h.team ~= me.team then				
				table.insert(herotab, h)
			end
        end
       
        local steal = me:GetAbility(7)
		local stealing = me:GetAbility(5)

		for i,v in ipairs(herotab) do			
			for d = 4,8 do
				if v.name ~= hero[v.handle] then					
					local spell = v:GetAbility(d)
					if spell ~= nil and spell.abilityType == 1 then						
						ult[v.handle] = spell.name
					end
				else 
					ult[v.handle] = nil
				end
			end

			if v.alive and v.health > 0 then
			
				if v.visible then
					for g,h in ipairs(v.abilities) do
						local spell = v:GetAbility(g)
						if spell ~= nil and spell.cd > 0 then
							 if v.name ~= "npc_dota_hero_brewmaster" then
								if math.ceil(spell.cd) ==  math.ceil(spell:GetCooldown(spell.level)) then										
									ls[v.handle] = v:GetAbility(g).name
								end
							elseif v.name == "npc_dota_hero_brewmaster" then								
								if math.ceil(spell.cd) == BM[spell.level] then
									ls[v.handle] = spell.name
								end									
							end
						end								
					end
				else 
					ls[v.handle] = nil
				end

				if SleepCheck() and steal.state == -1 and me:CanCast() and not me:IsChanneling() then
					if v.visible then
						if v.name ~= hero[v.handle] then
							if GetDistance2D(v,me) < range then
								for d = 4,8 do									
									local spell = v:GetAbility(d)
									if spell ~= nil and spell.abilityType == 1 then
										if ls[v.handle] == spell.name and spell.name ~= stealing.name then												
											if not v:IsLinkensProtected() then
												if stealing.name ~= ult[v.handle] and stealing.cd ~= 0 then													
													me:CastAbility(steal,v)
													Sleep(100)
												elseif stealing.abilityType ~= 1 then
													me:CastAbility(steal,v)
													Sleep(100)
												end
											end
										end
									end
								end
							end
						end
					end
				end	
			end
			
			if #herotab < 5 then
				for z = 1,4 do
					if #herotab == z then						
						if zxc[z] == true then icon[v.handle] = {} Clear() zxc[z] = false end
						if not icon[v.handle] then icon[v.handle] = {}
						icon[v.handle].board = drawMgr:CreateRect(xx-6+i*27,yy-3,27,23,0x000000FF) 
						icon[v.handle].mini = drawMgr:CreateRect(xx-2+i*27,yy,16,16,0x000000FF)						
						
						end
					end
				end
			else
				if zxc[#herotab] == true then icon[v.handle] = {} Clear() zxc[#herotab] = false end
				if not icon[v.handle] then icon[v.handle] = {}
					icon[v.handle].board = drawMgr:CreateRect(xx-6+i*27,yy-3,27,23,0x000000FF) 
					icon[v.handle].mini = drawMgr:CreateRect(xx-2+i*27,yy,16,16,0x000000FF)					
				end							
			end
			
			if hero[v.handle] ~= v.name then
				icon[v.handle].mini.textureId = drawMgr:GetTextureId("NyanUI/miniheroes/"..v.name:gsub("npc_dota_hero_",""))				
			else
				icon[v.handle].mini.textureId = drawMgr:GetTextureId("NyanUI/spellicons/doom_bringer_empty1")
			end	
			
		end			

end

function Key(msg,code)

	if client.chat then 
		return
	end
	
	for i,v in ipairs(herotab) do
		if IsMouseOnButton(xx-2+i*27,yy,16,16) then
			if msg == LBUTTON_DOWN and hero[v.handle] == nil then
				hero[v.handle] = v.name
			elseif msg == LBUTTON_DOWN and hero[v.handle] ~= nil then
				hero[v.handle] = nil
			end
		end
	end	

end

function IsMouseOnButton(x,y,h,w)
	local mx = client.mouseScreenPosition.x
	local my = client.mouseScreenPosition.y
	return mx > x and mx <= x + w and my > y and my <= y + h
end

function GetSpecial(spell,name,lvl)
	local specials = spell.specials
	for _,v in ipairs(specials) do
		if v.name == name then
			return v:GetData(lvl)
		else
			return 0
		end
	end
end

function Clear()
	icon = {}
	collectgarbage("collect")
end

function GameClose()
	Clear()
	herotab = {} hero = {} ls = {} ult = {}
	collectgarbage("collect")
	script:Reload()
end

script:RegisterEvent(EVENT_CLOSE, GameClose)
script:RegisterEvent(EVENT_TICK,Tick)
script:RegisterEvent(EVENT_KEY,Key)
