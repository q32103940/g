-------config--------
Range = 500
key = string.byte("B")
----------------------
 
cc = true
AcOp = false  
a_ = nil
 
function Tick()
 
        if not client.connected or client.loading or client.console or not entityList:GetMyHero() then return end
       
        me = entityList:GetMyHero()
                       
        if AcOp then
                if a_ == nil then
                        a_ = Effect(me,"range_display")
                        a_:SetVector( 1, Vector(Range,0,0))
                end
        else
                if a_ ~= nil then
                        a_ = nil
                        collectgarbage("collect")
                end
        end
 
end
 
function Key(msg,code)
        if not client.chat then
                if IsKeyDown(key) and cc then                                  
                        AcOp = (not AcOp)                                      
                end
                        cc = (not cc)
        end            
end
 
function GameClose()
        AcOp = false
        a_ = nil
end
 
script:RegisterEvent(EVENT_CLOSE,GameClose)
script:RegisterEvent(EVENT_TICK,Tick)
script:RegisterEvent(EVENT_KEY,Key)
