--Auto Q after W.
--Hold W when ember uses fist.

require("libs.Utils")
require("libs.ScriptConfig")

config = ScriptConfig.new()
config:SetParameter("Hotkey", "W", config.TYPE_HOTKEY)
config:Load()

local key = config.Hotkey

function Key(msg,code)

	if code ~= key or client.chat or not client.connected or client.loading or client.console then	return end

	local me = entityList:GetMyHero() if not me then return end

	if me.classId ~= CDOTA_Unit_Hero_EmberSpirit then
		script:Disable()
	else
		local enemy = entityList:GetEntities({type=LuaEntity.TYPE_HERO,alive = true,team = (5-me.team),illusion = false})
		local w_ = me:GetAbility(1)
		if w_.state == -1 and me:DoesHaveModifier("modifier_ember_spirit_sleight_of_fist_caster") then
			for i,v in ipairs(enemy) do
				if v.health > 0 and not v:IsMagicDmgImmune() and me:GetDistance2D(v) < 400 then
					me:CastAbility(w_)
				end
			end
		end			
	end
end

script:RegisterEvent(EVENT_KEY,Key)
