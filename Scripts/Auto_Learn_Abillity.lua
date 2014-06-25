require("libs.ScriptConfig")

config = ScriptConfig.new()
config:SetParameter("Hotkey", "57", config.TYPE_HOTKEY)
config:Load()

toggleKey = config.Hotkey

start = false activated = false aa = 0 draw = true
icon = {} rect = {} table1 = {} table2 = {} table3 = {} spellS = {} spellL = {} text = {} textR = {}

F16 = drawMgr:CreateFont("F14","Arial",16,500)

icon[1] = drawMgr:CreateRect(140,100,16,16,0x000000FF,drawMgr:GetTextureId("NyanUI/spellicons/".."shadow_demon_shadow_poison_release"))
icon[1].visible = false
rect[1] = drawMgr:CreateRect(139,99,18,18,0xFFFFFF90,true)
rect[1].visible = false
icon[2] = drawMgr:CreateRect(170,100,16,16,0x000000FF,drawMgr:GetTextureId("NyanUI/spellicons/".."shadow_demon_shadow_poison"))
icon[2].visible = false
rect[2] = drawMgr:CreateRect(169,99,18,18,0xFFFFFF90,true)
rect[2].visible = false
icon[3] = drawMgr:CreateRect(200,100,16,16,0x000000FF,drawMgr:GetTextureId("NyanUI/spellicons/".."kunkka_return"))
icon[3].visible = false
rect[3] = drawMgr:CreateRect(199,99,18,18,0xFFFFFF90,true)
rect[3].visible = false
rect[4] = drawMgr:CreateRect(62,123,754,176,0x00000090)
rect[4].visible = false
rect[5] = drawMgr:CreateRect(30,123,786,176,0xFFFFFF30,true)
rect[5].visible = false
for a = 6,9 do rect[a] = drawMgr:CreateRect(31,123+35*(a-5),784,1,0xFFFFFF30,true) rect[a].visible = false end
for a = 10,35 do rect[a] = drawMgr:CreateRect(36+(a-10)*30,123,1,175,0xFFFFFF30,true) rect[a].visible = false end
rect[36] = drawMgr:CreateRect(0,124,1,174,0xFFFFFF70,true)
rect[36].visible = false
rect[37] = drawMgr:CreateRect(0,124,1,174,0xFFFFFF70,true)
rect[37].visible = false
rect[38] = drawMgr:CreateRect(0,0,29,34,0x000000ff,true)
rect[38].visible = false
for a = 39, 44 do rect[a] = drawMgr:CreateRect(31,89+35*(a-38),34,34,0x00000FF,true) rect[a].visible = false end
for a = 5, 10 do icon[a] = drawMgr:CreateRect(32,90+35*(a-4),32,32,0x000000FF) icon[a].visible = false end
icon[4] = drawMgr:CreateRect(32,90+35*5,32,32,0x000000FF,drawMgr:GetTextureId("NyanUI/spellicons/doom_bringer_empty1"))
icon[4].visible = false
for a = 1,25 do textR[a] = drawMgr:CreateRect(0,0,29,34,0x000000ff,true) textR[a].visible = false end
for a = 1,25 do text[a] = drawMgr:CreateText(0,90, 0x000000ff, "",F16) text[a].visible = false end


function Tick(tick)

	if not client.connected or client.loading or client.console or not entityList:GetMyHero() then start = false return end
	
	me = entityList:GetMyHero()
		
	if sleepTick and sleepTick > tick then return end	
	
	if start == false then
		for i = 1,25 do spellS[i] = 0 spellL[i] = 0 end
		for a,spells in ipairs(me.abilities) do			
			if not me:GetAbility(a).hidden then		
				if me:GetAbility(a).name ~= "elder_titan_return_spirit" and me:GetAbility(a).name ~= "wisp_tether_break" and me:GetAbility(a).name ~= "earth_spirit_stone_caller"  and me:GetAbility(a).name ~= "wisp_empty1" and me:GetAbility(a).name ~= "kunnka kunkka_return" and me:GetAbility(a).name ~= "wisp_spirits_in" and me:GetAbility(a).name ~= "wisp_empty2" and me:GetAbility(a).name ~= "nevermore_shadowraze2" and me:GetAbility(a).name ~= "nevermore_shadowraze3" and me:GetAbility(a).name ~= "morphling_morph_str" and me:GetAbility(a).name ~= "puck_ethereal_jaunt" and me:GetAbility(a).name ~= "chen_test_of_faith_teleport" and me:GetAbility(a).name ~= "shadow_demon_shadow_poison_release" and me:GetAbility(a).name ~= "rubick_empty1"and me:GetAbility(a).name ~= "rubick_empty2" and me:GetAbility(a).name ~= "doom_bringer_empty1" and me:GetAbility(a).name ~= "doom_bringer_empty2" and me:GetAbility(a).name ~= "ogre_magi_unrefined_fireblast" and me:GetAbility(a).name ~= "keeper_of_the_light_recall" and me:GetAbility(a).name ~= "keeper_of_the_light_blinding_light" and me:GetAbility(a).name ~= "keeper_of_the_light_illuminate_end" and me:GetAbility(a).name ~= "keeper_of_the_light_spirit_form_illuminate_end" and me:GetAbility(a).name ~= "lone_druid_true_form_battle_cry"and me:GetAbility(a).name ~= "invoker_empty1"and me:GetAbility(a).name ~= "invoker_empty2" and  me:GetAbility(a).name ~= "invoker_cold_snap" and  me:GetAbility(a).name ~= "invoker_ghost_walk" and  me:GetAbility(a).name ~= "invoker_tornado" and  me:GetAbility(a).name ~= "invoker_emp" and  me:GetAbility(a).name ~= "invoker_alacrity" and  me:GetAbility(a).name ~= "invoker_chaos_meteor" and  me:GetAbility(a).name ~= "invoker_sun_strike" and  me:GetAbility(a).name ~= "invoker_forge_spirit" and  me:GetAbility(a).name ~= "invoker_ice_wall" and me:GetAbility(a).name ~= "spectre_reality"  and me:GetAbility(a).name ~= "templar_assassin_trap"  and me:GetAbility(a).name ~= "ember_spirit_activate_fire_remnant"  and me:GetAbility(a).name ~= "beastmaster_call_of_the_wild_boar" and me:GetAbility(a).name ~= "naga_siren_song_of_the_siren_cansel" and me:GetAbility(a).name ~= "phoenix_sun_ray_toggle_move_empty" then					
					table.insert(table1, me:GetAbility(a))
					start = true
					sleepTick = tick + 100		
				end
			end			
		end
	end
	

	for i,v in ipairs(table1) do
		local sum
		if table1[5] ~= nil then
			sum = table1[1].level+table1[2].level+table1[3].level+table1[4].level+table1[5].level 
		else	
			sum = table1[1].level+table1[2].level+table1[3].level+table1[4].level 
		end
		for a = 1,25 do
			if spellL[a] ~= 0 then
				local level = me:GetProperty("CDOTA_BaseNPC","m_iCurrentLevel")
				if sum ~= level then
					if sum + 1 == level then
						if level == spellS[a] and i == spellL[a] then							
							entityList:GetMyPlayer():LearnAbility(v)
							sleepTick = tick + 200
						end
					elseif sum + 2 == level then
						if (level - 1) == spellS[a] and i == spellL[a] then
							entityList:GetMyPlayer():LearnAbility(v)
							sleepTick = tick + 200
						end
					end
				end
			end
		end
	end

end

function Frame()

	if start == false then return end
	
	if activated == true then draw = true
	
		for a = 1, 3 do
			icon[a].visible = true		
			rect[a].visible = true
		end		

		if IsMouseOnButton(139,99,18,18) then			
			if save == true and aa == 0 then
				for a = 1,25 do
					table2[a] = spellS[a]..":"..spellL[a]
				end
				WriteLines(SCRIPT_PATH.."/libs/"..me.name..".txt",table2)
				save = false aa = 1
			elseif save == true and aa == 1 then aa = 0
			end
		end

		if IsMouseOnButton(169,99,18,18) then
			if loat == true then
				local lines = ReadLines(SCRIPT_PATH.."/libs/"..me.name..".txt")
				for i,line in ipairs(lines) do
					table3 = split(lines[i],":")
					if table3[1] ~= nil and table3[2] ~= nil then
					spellS[i] = table3[1] + 0 spellL[i] = table3[2] + 0
					end
				end
				loat = false
			end
		end

		if IsMouseOnButton(199,99,18,18) then 
			for a = 1, 25 do
				spellL[a] = 0 spellS[a] = 0	
				for a = 1,25 do
					text[a].visible = false
					textR[a].visible = false
				end
			end
		end

		for a = 4, 35 do
			rect[a].visible = true
		end

		rect[36].visible = true
		rect[36].x = 36+me:GetProperty("CDOTA_BaseNPC","m_iCurrentLevel")*30
		rect[37].visible = true
		rect[37].x = 36+(me:GetProperty("CDOTA_BaseNPC","m_iCurrentLevel")+1)*30

		for a = 1,25 do
			if spellS[a] ~= 0 and spellS[a] ~= 0 then
				b = spellL[a]
				z = spellS[a]
				if b ~= nil and z ~= nil then
					if b==1 then col = 0x3399FFFF elseif b==2 then col = 0x00FFD5AA elseif b==3 then col = 0xFFFFFFFF elseif b==4 then col = 0xFF7676FF elseif b==5 then col = 0xFFFF66FF end
					text[a].visible = true
					text[a].x = 44+z*30
					text[a].y = 97+35*b
					text[a].color = col
					text[a].text = ""..z
					textR[a].visible = true
					textR[a].x = 37+z*30
					textR[a].y = 89+35*b
					textR[a].color = col
				end
			end
		end
		for i,v in ipairs(table1) do
			icon[i+4].visible = true
			icon[i+4].textureId = drawMgr:GetTextureId("NyanUI/spellicons/"..v.name)
			rect[i+38].visible = true
		end
		if me.name == "npc_dota_hero_invoker" then
			icon[4].visible = true
		end
		
	else	
		if draw then
			for a = 1, 44 do
				rect[a].visible = false
			end				
			for a = 1,10 do
				icon[a].visible = false
			end
			for a = 1,25 do
				text[a].visible = false
				textR[a].visible = false
			end
			draw = false
		end		
	end

end

function Key(msg,code)

	if start == false or client.chat then return end
	
	if IsKeyDown(toggleKey) then
		activated = not activated       
	end

	if activated then
	
		for a = 1, 25 do
			for i,v in ipairs(table1) do
				if IsMouseOnButton(31+a*30,89+35*i,32,32) then
					if msg == LBUTTON_DOWN then
						spellL[a] = i
						spellS[a] = a
					elseif msg == RBUTTON_DOWN then
						spellL[a] = 0
						spellS[a] = 0
						text[a].visible = false
						textR[a].visible = false
					end
				end
			end
		end
		
		if msg == LBUTTON_DOWN then	
			save = true loat = true
		else 
			save = false loat = false 
		end
		
	end
	
end

function ReadLines(sPath)
  local file = io.open(sPath, "r")
  if file then
        local tLines = {}
        for line in file:lines() do
                        table.insert(tLines, line)
        end
        file.close()
        return tLines
          else
                  WriteLines(sPath,{})
                  return {}
          end
end

function WriteLines(sPath, tLines)
  local file = io.open(sPath, "w")
  if file then
                  local text = ""
                  local lastline = nil
        for _, sLine in ipairs(tLines) do
                        text = text..sLine.."\n"
        end
        file:write(text)
        file:close()
        end
end

function split(str, pat)
   local t = {}
   local fpat = "(.-)" .. pat
   local last_end = 1
   local s, e, cap = str:find(fpat, 1)
   while s do
      if s ~= 1 or cap ~= "" then
         table.insert(t,cap)
      end
      last_end = e+1
      s, e, cap = str:find(fpat, last_end)
   end
   if last_end <= #str then
      cap = str:sub(last_end)
      table.insert(t, cap)
   end
   return t
end

function IsMouseOnButton(x,y,h,w)
        local mx = client.mouseScreenPosition.x
        local my = client.mouseScreenPosition.y
        return mx > x and mx <= x + w and my > y and my <= y + h
end

function GameClose()
	spellS = {} spellL = {} table1 = {} 
	table2= {} table3 = {}
	start = false
	activated = false
	aa = 0
	collectgarbage("collect")
end


script:RegisterEvent(EVENT_CLOSE, GameClose)
script:RegisterEvent(EVENT_TICK,Tick)
script:RegisterEvent(EVENT_TICK,Frame)
script:RegisterEvent(EVENT_KEY,Key)
