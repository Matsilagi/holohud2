---
--- Lambda Players
--- https://steamcommunity.com/sharedfiles/filedetails/?id=2947828836
---

if SERVER then return end

if not LAMBDAFS then return end

local useplayercolor = GetConVar( "lambdaplayers_useplayermodelcolorasdisplaycolor" )
local displaycolor_r, displaycolor_g, displaycolor_b = GetConVar( "lambdaplayers_displaycolor_r" ), GetConVar( "lambdaplayers_displaycolor_g" ), GetConVar( "lambdaplayers_displaycolor_b" )
local element_radar = HOLOHUD2.element.Get( "radar" )

local cache = Color( 255, 255, 255 )

HOLOHUD2.hook.Add( "VisibleOnRadar", "lambdaplayers", function( ent, visible )

    if not ent.IsLambdaPlayer and not ent.IsLambdaAntlion then return end

    return visible

end)

HOLOHUD2.hook.Add( "GetRadarBlipColor", "lambdaplayers", function( ent )

    if ent.IsLambdaPlayer then

        if useplayercolor:GetBool() then
            
            return ent:GetPlyColor():ToColor()

        end

        cache:SetUnpacked( displaycolor_r:GetInt(), displaycolor_g:GetInt(), displaycolor_b:GetInt() )

        return cache

    end

    if ent.IsLambdaAntlion then
        
        return element_radar.components.hudradar.colorfoe

    end

end)