require("libs.Utils")

local mod = {}
local xx,yy = -30,-50
local stuncolor = 0xFFFFFFFF
local hexcolor =  0xFFFF00FF
local silencecolor = 0xD50000FF
local HexList = {"modifier_sheepstick_debuff","modifier_lion_voodoo","modifier_shadow_shaman_voodoo"}
local SilenceList = {"modifier_skywrath_mage_ancient_seal","modifier_earth_spirit_boulder_smash_silence","modifier_orchid_malevolence_debuff","modifier_night_stalker_crippling_fear",
"modifier_silence","modifier_silencer_last_word_disarm","modifier_silencer_global_silence","modifier_bloodseeker_bloodrage","modifier_doom_bringer_doom","modifier_legion_commander_duel"}

function Tick(tick)

	if not (IsIngame() or SleepCheck()) then return end
	
	local me  = entityList:GetMyHero()
	
	if not me then return end

	local enemy = entityList:GetEntities({type=LuaEntity.TYPE_HERO, illusion = false, team = me:GetEnemyTeam()})
	
	for i,v in ipairs(enemy) do

		local offset = v.healthbarOffset
		if offset == -1 then return end
	
		if not mod[v.handle] then
			mod[v.handle] = drawMgr:CreateText(xx,yy,stuncolor,"",drawMgr:CreateFont("F13","Arial",20,500)) mod[v.handle].visible = false mod[v.handle].entity = v mod[v.handle].entityPosition = Vector(0,0,offset)			
		end
		
		if v.alive and v.visible and v.health > 0 then
			if v:IsStunned() then
				local stun = FindStunModifier(v)
				if stun then
					mod[v.handle].text = ""..stun
					mod[v.handle].color = stuncolor
					mod[v.handle].visible = true
				end
			elseif v:IsHexed() then
				local hex = FindHexOrSilenceModifier(v,HexList)
				if hex then
					mod[v.handle].text = ""..hex
					mod[v.handle].color = hexcolor
					mod[v.handle].visible = true
				end
			elseif v:IsSilenced() then
				local silence = FindHexOrSilenceModifier(v,SilenceList)
				if silence then
					mod[v.handle].text = ""..silence
					mod[v.handle].color = silencecolor
					mod[v.handle].visible = true
				end
			elseif mod[v.handle].visible then
				mod[v.handle].visible = false
			end
		elseif mod[v.handle].visible then
			mod[v.handle].visible = false
		end
		
	end	
	
	Sleep(250)

end

function FindStunModifier(v)
	local modifier = v.modifiers
	for i = #modifier, 1, -1 do
		local v = v.modifiers[i]
		if v.stunDebuff then
			return math.floor(v.remainingTime*10)/10
		end
	end
	return false
end

function FindHexOrSilenceModifier(v,tab)
	local modifier = v.modifiers
	for i = #modifier, 1, -1 do
		local v = v.modifiers[i]
		if v.debuff then
			for k,l in ipairs(tab) do
				if v.name == l then
					return math.floor(v.remainingTime*10)/10
				end
			end
		end
	end
	return false
end

script:RegisterEvent(EVENT_TICK,Tick)
