
local NET_DAMAGE        = "holohud2_damage"
local NET_HEALTH        = "holohud2_health"
local DAMAGETYPE_LEN    = 32

if SERVER then

    util.AddNetworkString( NET_DAMAGE )
    util.AddNetworkString( NET_HEALTH )
    
    ---
    --- On entity: Synchronize health value with all clients.
    --- On player: Send damage received to client.
    ---
    hook.Add( "PostEntityTakeDamage", "holohud2", function( ent, dmginfo, took )
        
        if not took or not IsValid( ent ) then return end

        -- force synchronization of non-player health values
        if not ent:IsPlayer() then

            net.Start( NET_HEALTH )
            net.WriteEntity( ent )
            net.WriteFloat( ent:Health() )
            net.Broadcast()

            return

        end

        local damage        = dmginfo:GetDamage()
        local damage_type   = dmginfo:GetDamageType()
        local damage_origin = IsValid( dmginfo:GetInflictor() ) and dmginfo:GetInflictor():GetPos() or dmginfo:GetDamagePosition()

        net.Start( NET_DAMAGE )
        net.WriteFloat( damage )
        net.WriteInt( damage_type, DAMAGETYPE_LEN )
        net.WriteVector( damage_origin )
        net.Send( ent )

    end)

    return

end

---
--- Receive damage taken.
---
net.Receive( NET_DAMAGE, function( len )

    local damage = net.ReadFloat()
    local damage_type = net.ReadInt( DAMAGETYPE_LEN )
    local damage_origin = net.ReadVector()
    
    if not HOLOHUD2.IsVisible() then return end

    HOLOHUD2.hook.Call( "OnTakeDamage", damage, damage_type, damage_origin )

end )

---
--- Receive entity health.
---
net.Receive( NET_HEALTH, function( len )

    local ent = net.ReadEntity()
    local health = net.ReadFloat()

    if not IsValid( ent ) then return end

    ent:SetHealth( health )
    
end )