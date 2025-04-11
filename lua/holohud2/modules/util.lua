---
--- Utilitary functions and values.
---

HOLOHUD2.DIR    = "holohud2"

HOLOHUD2.util = {}

if SERVER then

    --- Returns the name shown on the death notice of the given entity.
    --- Taken from https://github.com/Facepunch/garrysmod/blob/master/garrysmod/gamemodes/base/gamemode/npc.lua#L48-L75
    --- @param ent Entity
    --- @return string
    function HOLOHUD2.util.GetDeathNoticeEntityName( ent )

        if isstring( ent ) then return ent end
        if not IsValid( ent ) then return "" end

        if ent:IsPlayer() then

            return ent:Name()

        end

        -- Some specific HL2 NPCs, just for fun
        if ent:GetClass() == "npc_citizen" then

            if ent:GetName() == "griggs" then return "Griggs" end
            if ent:GetName() == "sheckley" then return "Sheckley" end
            if ent:GetName() == "tobias" then return "Tobias" end
            if ent:GetName() == "stanley" then return "Sandy" end

        end

        if ent:GetClass() == "npc_sniper" and ( ent:GetName() == "alyx_sniper" or ent:GetName() == "sniper_alyx" ) then

            return "#npc_alyx"

        end

        -- Custom vehicle and NPC names from spawnmenu
        if ent:IsVehicle() and ent.VehicleTable and ent.VehicleTable.Name then

            return ent.VehicleTable.Name

        end

        if ent:IsNPC() and ent.NPCTable and ent.NPCTable.Name then

            return ent.NPCTable.Name

        end

        if ent:GetClass() == "npc_antlion" and ent:GetModel() == "models/antlion_worker.mdl" then

            return list.Get( "NPC" )[ "npc_antlion_worker" ].Name

        end

        -- Fallback to old behavior
        return "#" .. ent:GetClass()

    end

    return

end


local math = math
local LocalPlayer = LocalPlayer
local EyePos = EyePos
local EyeAngles = EyeAngles
local WorldToLocal = WorldToLocal

HOLOHUD2.LAYER_FRAME        = 1
HOLOHUD2.LAYER_BACKGROUND   = 2
HOLOHUD2.LAYER_FOREGROUND   = 3
HOLOHUD2.LAYER_SCANLINES    = 4

HOLOHUD2.DISTANCE_HAMMER    = 1
HOLOHUD2.DISTANCE_METRIC    = 2
HOLOHUD2.DISTANCE_IMPERIAL  = 3
HOLOHUD2.DISTANCEUNITS      = { "#holohud2.option.hammer_units", "#holohud2.option.metric", "#holohud2.option.imperial" }

HOLOHUD2.HU_TO_M    = .01904
HOLOHUD2.HU_TO_FT   = .0625

HOLOHUD2.UNIT_HAMMER    = "#holohud2.common.hammer_units"
HOLOHUD2.UNIT_METRIC    = "#holohud2.common.meters"
HOLOHUD2.UNIT_IMPERIAL  = "#holohud2.common.feet"

local SHORTNUMBER_ABBREVIATIONS = { "M", "B", "T", "Qa", "Qi", "Sx", "Sp", "Oc", "No", "De", "e" }
local SHORTNUMBER_SCALE         = 1e3 -- every how much do we change abbreviations
local SHORTNUMBER_MIN           = 1e6 -- when do numbers start to get shortened
local SHORTNUMBER_MAX           = 1e36
local SHORTNUMBER_INF           = "∞"
local SHORTNUMBER_INF_NEG       = "-∞"
local SHORTNUMBER_FORMAT        = "%.2f"
local SHORTNUMBER_STRFORMAT     = "%s%s"

local DATEFORMAT_TOKENS         = {
    [ "{time}" ] = "%X",
    [ "{24h}" ] = "%H",
    [ "{12h}" ] = "%I",
    [ "{min}" ] = "%M",
    [ "{sec}" ] = "%S",
    [ "{ampm}" ] = "%p",
    [ "{date}" ] = "%x",
    [ "{day}" ] = "%d",
    [ "{ordinal}" ] = "%o",
    [ "{weekday}" ] = "%A",
    [ "{shortweekday}" ] = "%a",
    [ "{monthnumber}" ] = "%m",
    [ "{month}" ] = "%B",
    [ "{shortmonth}" ] = "%b",
    [ "{year}" ] = "%Y",
    [ "{shortyear}" ] = "%y",
    [ "{yearweek}" ] = "%W"
}
local DATEFORMAT_TOKEN_ORDINAL  = "%o"

local shortnumbers          = CreateClientConVar( "holohud2_shortnumbers", 1, true, false, "Shortens large numbers using abbreviations.", 0, 1 )
local shortnumbers_decimals = CreateClientConVar( "holohud2_shortnumbers_decimals", 2, true, false, "How many decimals are there in a shortened number.", 0, 5 )

local localplayer
local weapon
local clip1, max_clip1, ammo1, max_ammo1, primary = 0, 0, 0, 0, 0
local clip2, max_clip2, ammo2, max_ammo2, secondary = 0, 0, 0, 0, 0

--- Starts a stencil operation to scissor a portion of the screen.
--- @param x number
--- @param y number
--- @param w number
--- @param h number
function HOLOHUD2.util.StartStencilScissor( x, y, w, h )

    render.SetStencilWriteMask( 0xFF )
    render.SetStencilTestMask( 0xFF )
    render.SetStencilReferenceValue( 0 )
    render.SetStencilPassOperation( STENCIL_KEEP )
    render.SetStencilZFailOperation( STENCIL_KEEP )
    render.ClearStencil()

    render.SetStencilEnable( true )
    render.SetStencilReferenceValue( 1 )
    render.SetStencilCompareFunction( STENCIL_NEVER )
    render.SetStencilFailOperation( STENCIL_REPLACE )

    surface.SetDrawColor( 255, 255, 255 )
    surface.DrawRect( x, y, w, h )

    render.SetStencilCompareFunction( STENCIL_EQUAL )
    render.SetStencilFailOperation( STENCIL_KEEP )

end

--- Alias of render.SetStencilEnable( false )
function HOLOHUD2.util.EndStencilScissor()

    render.SetStencilEnable( false )

end

--- Safely parses a human interface format to the os.date format.
--- @param format string
--- @return string result
function HOLOHUD2.util.ParseDateFormat( format )

    for input, token in pairs( DATEFORMAT_TOKENS ) do

        format = string.Replace( format, input, token )

    end

    return format

end

--- Returns a formatted date string supporting the custom token %o.
--- @param format string
--- @param date number
--- @return string|osdate formatted_date
function HOLOHUD2.util.DateFormat( format, date )

    format = string.Replace( format, DATEFORMAT_TOKEN_ORDINAL, string.CardinalToOrdinal( os.date( "%d", date ) ) )

    return os.date( format, date )

end

--- Converts a file path to human-readable text.
--- @param path string
--- @return string readable_path
function HOLOHUD2.util.NicePath( path )

    local pos = string.find( path, "/" )

    while pos do

        path = string.sub( path, pos + 1 )
        pos = string.find( path, "/" )

    end

    pos = string.find( path, "_" )

    while pos do

        path = string.sub( path, 1, pos - 1 ) .. " " .. string.upper( string.sub( path, pos + 1, pos + 1 ) ) .. string.sub( path, pos + 2 )
        pos = string.find( path, "_" )

    end

    path = string.upper( string.sub( path, 1, 1 ) ) .. string.sub( path, 2 )
    path = string.StripExtension( path )

    return path

end

--- Whether we can see the given entity.
--- @param ent Entity
--- @param fov number
--- @return boolean sighted
function HOLOHUD2.util.IsInSight( ent, fov )

    localplayer = localplayer or LocalPlayer()
    
    if not localplayer:IsLineOfSightClear( ent ) then return false end

    local yaw = WorldToLocal( ent:EyePos(), angle_zero, EyePos(), EyeAngles() ):Angle().y

    return yaw < fov or yaw > ( 360 - fov )

end

--- Returns a more readable version of a number with its abbreviation.
--- @param number number
--- @param raw boolean should be returned unformatted
--- @return string readable version of the number
--- @return string|number|nil if unformatted, returns the abbreviation
function HOLOHUD2.util.ShortenNumber( number, raw )
    
    if not shortnumbers:GetBool() then return number end
    if number < SHORTNUMBER_MIN then return number end
    if number == math.huge then return SHORTNUMBER_INF end
    if number == -math.huge then return SHORTNUMBER_INF_NEG end

    local order = math.floor( math.log10( number ) / 3 ) - 1
    local abbreviation = SHORTNUMBER_ABBREVIATIONS[ order ]
    local decimal = string.format( SHORTNUMBER_FORMAT, number / ( SHORTNUMBER_SCALE ^ ( order + 1 ) ) )

    if number >= SHORTNUMBER_MAX then
        
        abbreviation = SHORTNUMBER_ABBREVIATIONS[ #SHORTNUMBER_ABBREVIATIONS ] .. math.floor( math.log10( number ) )

    end

    if raw then return decimal, abbreviation end

    return string.format( SHORTNUMBER_STRFORMAT, decimal, abbreviation )

end

--- Checks for illegal characters on the given filename.
--- @param filename string
--- @return boolean found
function HOLOHUD2.util.ContainsIllegalCharacters( filename )

    return string.len( filename ) <= 0 or string.match( filename, "[#%%&{}\\<>*?¿/$!¡\'\":@+`|=]" )

end

--- Returns the stored information about the current weapon's primary ammunition.
--- @return number clip1
--- @return number max_clip1
--- @return number ammo1
--- @return number max_ammo1
--- @return number primary
--- @return Weapon weapon
function HOLOHUD2.util.GetPrimaryAmmo()

    return clip1, max_clip1, ammo1, max_ammo1, primary, weapon

end

--- Returns the stored information about the current weapon's secondary ammunition.
--- @return number clip2
--- @return number max_clip2
--- @return number ammo2
--- @return number max_ammo2
--- @return number secondary
--- @return Weapon weapon
function HOLOHUD2.util.GetSecondaryAmmo()

    return clip2, max_clip2, ammo2, max_ammo2, secondary, weapon

end

---
--- Precache active weapon information.
---
hook.Add( "PreDrawHUD", "holohud2_util", function()

    localplayer = localplayer or LocalPlayer()
    weapon = localplayer:GetActiveWeapon()

    clip1, max_clip1 = -1, 0
    ammo1, max_ammo1 = 0, 1
    primary = 0

    clip2, max_clip2 = -1, 0
    ammo2, max_ammo2 = 0, 1
    secondary = 0

    if localplayer:InVehicle() then

        local vehicle = localplayer:GetVehicle()

        if IsValid( vehicle ) and vehicle.GetAmmo then

            local ammotype, max_ammo, ammo = vehicle:GetAmmo()

            if ammo ~= -1 then

                if max_ammo == -1 then max_ammo = 100 end -- HACK: it returns -1 on the airboat
                
                ammo1, max_ammo1 = ammo, max_ammo
                primary = ammotype
                return

            else

                if not localplayer:GetAllowWeaponsInVehicle() then return end

            end

        end

    end

    if not IsValid( weapon ) then return end

    if weapon:IsScripted() and weapon.CustomAmmoDisplay then

        local ammo = weapon:CustomAmmoDisplay()

        if ammo then

            if not ammo.Draw then return end

            primary = weapon:GetPrimaryAmmoType()
            
            -- if only the clip has been specified but not the reserve ammo, show clip as reserve
            if ( not ammo.PrimaryAmmo or ammo.PrimaryAmmo == -1 ) and ammo.PrimaryClip then

                if ammo.PrimaryClip == -1 then return end

                ammo1, max_ammo1 = ammo.PrimaryClip, weapon:GetMaxClip1()

            else

                clip1, max_clip1 = ammo.PrimaryClip or weapon:Clip1(), weapon:GetMaxClip1()
                ammo1, max_ammo1 = ammo.PrimaryAmmo or localplayer:GetAmmoCount( primary ), ammo.PrimaryAmmo and 1 or game.GetAmmoMax( primary )
            
            end

            secondary = weapon:GetSecondaryAmmoType()
            ammo2, max_ammo2 = ammo.SecondaryAmmo or localplayer:GetAmmoCount( secondary ), ammo.SecondaryAmmo and 1 or game.GetAmmoMax( secondary )

            return

        end

    end

    primary = weapon:GetPrimaryAmmoType()
    clip1, max_clip1 = weapon:Clip1(), weapon:GetMaxClip1()
    ammo1, max_ammo1 = localplayer:GetAmmoCount( primary ), game.GetAmmoMax( primary )

    secondary = weapon:GetSecondaryAmmoType()
    clip2, max_clip2 = weapon:Clip2(), weapon:GetMaxClip2()
    ammo2, max_ammo2 = localplayer:GetAmmoCount( secondary ), game.GetAmmoMax( secondary )
    
    if max_clip2 == -1 then clip2 = -1 end -- HACK: the SLAM fix

end)

---
--- Refresh settings if any of the shorten numbers parameters change.
---
cvars.AddChangeCallback( "holohud2_shortnumbers", function()

    HOLOHUD2.element.OnScreenSizeChanged()

end)
cvars.AddChangeCallback( "holohud2_shortnumbers_decimals", function( _, _, value )

    SHORTNUMBER_FORMAT = "%." .. value .. "f"
    timer.Create( "holohud2_shortnumbers", .1, 1, HOLOHUD2.element.OnScreenSizeChanged )

end)