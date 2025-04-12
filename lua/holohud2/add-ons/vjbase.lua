---
--- VJ Base
--- https://steamcommunity.com/sharedfiles/filedetails/?id=131759821
---

if not VJ then return end

if SERVER then
    
    hook.Add( "OnEntityCreated", "holohud2_vjbase", function( ent )
    
        if not ent.IsVJBaseSNPC then return end

        for _, class in pairs( ent.VJ_NPC_Class ) do
            print(class)
            if class ~= "CLASS_PLAYER_ALLY" then continue end

            ent:SetNW2Bool( "holohud2_vjbase_ally", true )
            return

        end

    end)

    return

end

HOLOHUD2.hook.Add( "IsFriendEntity", "vjbase", function( ent )

    if not ent.IsVJBaseSNPC then return end

    return ent:GetNW2Bool( "holohud2_vjbase_ally" )

end)