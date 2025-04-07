
HOLOHUD2.persistence = {}

local hardcoded = {}

local TEMP  = HOLOHUD2.DIR .. "\\_temp.json"
local DIR   = HOLOHUD2.DIR .. "\\presets"

--- Returns the path of the given file.
--- @param name string
--- @return string path
local function get_path( name )

    return DIR .. "\\" .. string.StripExtension( name ) .. ".json"

end

--- Adds a hardcoded configuration set.
--- @param name string
--- @param settings table
--- @param modifiers table
--- @return number i
function HOLOHUD2.persistence.Add( name, settings, modifiers )

    return table.insert( hardcoded, { name = name, settings = settings, modifiers = modifiers } )

end

--- Returns a single hardcoded configuration set.
--- @param i number
--- @return table
function HOLOHUD2.persistence.Get( i )

    return hardcoded[ i ]

end

--- Returns all hardcoded configuration sets.
--- @return table
function HOLOHUD2.persistence.All()

    return hardcoded

end

--- Reads the temporary settings file.
--- @return table settings
--- @return table modifiers
function HOLOHUD2.persistence.ReadTemp()

    local contents = file.Read( TEMP, "DATA" )

    if not contents then return {}, {} end

    contents = util.JSONToTable( contents )

    return contents.settings, contents.modifiers

end

--- Writes the given settings into the temporary file.
--- @param settings table
--- @param modifiers table
function HOLOHUD2.persistence.WriteTemp( settings, modifiers )

    file.Write( TEMP, util.TableToJSON( { settings = settings, modifiers = modifiers }, true ) )

end

--- Returns whether there's a preset file with that name.
--- @param name string
--- @return boolean exists
function HOLOHUD2.persistence.Exists( name )

    return file.Exists( get_path( name ) )

end

--- Returns the list of settings files
--- @return table files
function HOLOHUD2.persistence.Find()

    return file.Find( DIR .. "\\*.json", "DATA" )

end

--- Reads the given file and returns its contents.
--- @param name string
--- @return table settings
--- @return table modifiers
function HOLOHUD2.persistence.Read( name )

    local contents = file.Read( get_path( name ), "DATA" )

    if not contents then return {}, {} end

    contents = util.JSONToTable( contents )

    return contents.settings, contents.modifiers

end

--- Saves the given configuration in a file.
--- @param settings table
--- @param modifiers table
--- @param name string
--- @return boolean success
function HOLOHUD2.persistence.Write( settings, modifiers, name )

    local contents = { settings = settings, modifiers = modifiers }
    local path = get_path( name )

    if not file.Exists( DIR, "DATA" ) then file.CreateDir( DIR ) end

    file.Write( path, util.TableToJSON( contents, true ) )

    return file.Exists( path, "DATA" )

end

--- Deletes a configuration set.
--- @param name string
function HOLOHUD2.persistence.Delete( name )

    file.Delete( get_path( name ) )

end

--- Renames a preset file.
---@param origin string
---@param target string
function HOLOHUD2.persistence.Rename( origin, target )

    file.Rename( get_path( origin ), get_path( target ) )

end