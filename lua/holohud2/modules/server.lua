---
--- Admin submitted overrides
---

if game.SinglePlayer() then return end -- NOTE: this makes no sense in singleplayer

HOLOHUD2.server = {}

local NET_DEFAULT   = "holohud2_server_default"
local NET_OVERRIDE  = "holohud2_server_override"

local default   = {}
local override  = {}

--- Returns the default values set by the server.
--- @return table default
function HOLOHUD2.server.Defaults()

    return default

end

--- Returns the settings set by the server.
--- @return table settings
function HOLOHUD2.server.Get()

    return override

end

if SERVER then

    util.AddNetworkString( NET_DEFAULT )
    util.AddNetworkString( NET_OVERRIDE )

    local DEFAULT_PATH  = "/default.json"
    local SETTINGS_PATH = "/settings.json"

    local superadmin = CreateConVar( "holohud2_superadminonly", 1, { FCVAR_ARCHIVE }, "Limits server-wide override changes to super admins only (instead of admins only)" )

    ---
    --- Receive defaults.
    ---
    net.Receive( NET_DEFAULT, function( len, ply )
    

        if not ply:IsAdmin() then return end
        if superadmin:GetBool() and not ply:IsSuperAdmin() then return end

        default = net.ReadTable()

        net.Start( NET_DEFAULT )
        net.WriteTable( default )
        net.Broadcast()

        if not file.Exists( HOLOHUD2.DIR, "DATA" ) then
            
            file.CreateDir( HOLOHUD2.DIR )

        end

        file.Write( HOLOHUD2.DIR .. DEFAULT_PATH, util.TableToJSON( default ) )

    end)

    ---
    --- Receive settings.
    ---
    net.Receive( NET_OVERRIDE, function( len, ply )
    
        if not ply:IsAdmin() then return end
        if superadmin:GetBool() and not ply:IsSuperAdmin() then return end

        override = net.ReadTable()

        net.Start( NET_OVERRIDE )
        net.WriteTable( override )
        net.Broadcast()

        if not file.Exists( HOLOHUD2.DIR, "DATA" ) then
            
            file.CreateDir( HOLOHUD2.DIR )

        end

        file.Write( HOLOHUD2.DIR .. SETTINGS_PATH, util.TableToJSON( override ) )

    end)

    ---
    --- Load last saved settings.
    ---
    hook.Add( "Initialize", "holohud2_server", function()
    
        local default_file = file.Read( HOLOHUD2.DIR .. DEFAULT_PATH )

        if default_file then

            default = util.JSONToTable( default_file )

        end

        local settings_file = file.Read( HOLOHUD2.DIR .. SETTINGS_PATH )

        if settings_file then

            override = util.JSONToTable( settings_file )

        end

    end)

    ---
    --- Send settings to new players.
    ---
    hook.Add( "PlayerInitialSpawn", "holohud2_server", function( ply )
    
        net.Start( NET_DEFAULT )
        net.WriteTable( default )
        net.Send( ply )

        net.Start( NET_OVERRIDE )
        net.WriteTable( override )
        net.Send( ply )

    end)

    return

end

HOLOHUD2.settings.Register( default, HOLOHUD2.SETTINGS_SERVERDEFAULT )
HOLOHUD2.settings.Register( override, HOLOHUD2.SETTINGS_SERVER )

--- Submits the given default settings to the server.
--- @param settings table
--- @param modifiers table
function HOLOHUD2.server.SubmitDefaults( settings, modifiers )

    net.Start( NET_DEFAULT )
    net.WriteTable( table.Merge( HOLOHUD2.modifier.Call( HOLOHUD2.element.GetDefaultValues(), modifiers ) , settings ) )
    net.SendToServer()

end

--- Submits a defaults reset to the server.
function HOLOHUD2.server.ClearDefaults()

    net.Start( NET_DEFAULT )
    net.WriteTable( {} )
    net.SendToServer()

end

--- Submits the given settings to the server.
--- @param settings table
--- @param modifiers table
--- @param force boolean
function HOLOHUD2.server.Submit( settings, modifiers, force )

    local defaults = HOLOHUD2.element.GetDefaultValues()
    local values = table.Merge( HOLOHUD2.modifier.Call( defaults, modifiers ), settings )

    if force then

        values = table.Merge( table.Copy( defaults ), values )

    end

    net.Start( NET_OVERRIDE )
    net.WriteTable( values )
    net.SendToServer()

end

--- Submits an override reset to the server.
function HOLOHUD2.server.Clear()

    net.Start( NET_OVERRIDE )
    net.WriteTable( {} )
    net.SendToServer()

end

---
--- Receive defaults.
---
net.Receive( NET_DEFAULT, function( len )

    table.CopyFromTo( net.ReadTable(), default )
    HOLOHUD2.settings.Merge()

end)

---
--- Receive settings.
---
net.Receive( NET_OVERRIDE, function( len )

    table.CopyFromTo( net.ReadTable(), override )
    HOLOHUD2.settings.Merge()

end)