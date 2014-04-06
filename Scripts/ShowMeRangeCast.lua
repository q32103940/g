require("libs.Utils")

list = 
{
npc_dota_hero_mirana = 
{
Spell = 2,
Start = {1690,1690,1690,1690},
End = {1350,1350,1350,1350},
Count = 20,
Range = {150,150,150,150},
},
npc_dota_hero_pudge = 
{
Spell = 1,
Start = {1390,1290,1190,1090},
End = {1280,1170,1060,950},
Count = 10,
Range = {70,90,110,130},
},
npc_dota_hero_windrunner = 
{
Spell = 2,
Start = {890,890,890,890},
End = {710,710,710,710},
Count = 10,
Range = {182,182,182,182},
}
}

eff = {}
ss = {}

function Tick(tick)

	if not client.connected or client.loading or client.console then return end
	
	local me = entityList:GetMyHero()
	
	if not me then return end
	
	local enemy = entityList:GetEntities({type=LuaEntity.TYPE_HERO,alive=true,illusion=false,visible=true})
	
	for i,v in ipairs(enemy) do
		if v.team ~= me.team then
			if list[v.name] then
				local number = list[v.name].Spell
				local spell = v:GetAbility(number)								
				if spell.cd ~= 0 then					
					local ind = list[v.name].End
					local count = list[v.name].Count
					local range = list[v.name].Range
					local srart = list[v.name].Start
					if math.floor(spell.cd*100) > srart[spell.level] and not ss[v.handle] then
						ss[v.handle] = true
						for z = 1, count do											
							local p = Vector(v.position.x + range[spell.level]*z * math.cos(v.rotR), v.position.y + range[spell.level]*z * math.sin(v.rotR), v.position.z+50)
							eff[z] = Effect(p, "fire_torch" )
							eff[z]:SetVector(1,Vector(0,0,0))
							eff[z]:SetVector(0, p )							
						end
						
					elseif math.floor(spell.cd*100) < ind[spell.level] and ss[v.handle] then
						ss[v.handle] = nil
						for z = 1, count do
							eff[z] = nil							
						end
						collectgarbage("collect")
					end
				end
			end
		end
	end
	
end

function GameClose()
	eff = {}
	ss = {}
	collectgarbage("collect")
end

script:RegisterEvent(EVENT_CLOSE,GameClose)		
script:RegisterEvent(EVENT_TICK,Tick)
