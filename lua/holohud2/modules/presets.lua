
HOLOHUD2.presets = {}

local groups = {}

--- Registers a preset group.
--- @param id string
--- @param folder string
--- @return table
function HOLOHUD2.presets.Register( id, folder )

    local group = {
        folder = folder,
        presets = {}, -- hardcoded presets
        files = {}
    }

    groups[ id ] = group

    return group

end

--- Returns where are the presets located of this group.
--- @param id string
--- @return string folder
function HOLOHUD2.presets.Location( id )

    local group = groups[ id ]

    if not group then return "" end

    return group.folder

end

--- Adds a hardcoded preset.
--- @param id string preset group
--- @param name string preset name
--- @param values table
function HOLOHUD2.presets.Add( id, name, values )

    if not groups[ id ] then return end

    local preset = {
        name = name,
        values = values
    }

    table.insert( groups[ id ].presets, preset )

end

--- Fetches all presets stored on disk.
--- @param id string
--- @return table presets
function HOLOHUD2.presets.Find( id )

    local group = groups[ id ]

    if not group then return {} end

    local presets = {}

    for _, filename in ipairs( file.Find( HOLOHUD2.DIR .. "/" .. group.folder .. "/*.json", "DATA" ) ) do

        local contents = util.JSONToTable( file.Read( HOLOHUD2.DIR .. "/" .. group.folder .. "/" .. filename, "DATA" ) )

        if not contents then continue end -- ignore malformed files

        table.insert( presets, {
            filename    = filename,
            name        = contents.name,
            values      = contents.values
        } )

    end

    return presets

end

--- Fetches all stored presets.
--- @param id string
--- @return table hardcoded
--- @return table disk
function HOLOHUD2.presets.Get( id )

    local group = groups[ id ]

    if not group then return {}, {} end

    return group.presets, HOLOHUD2.presets.Find( id )

end

--- Returns the final name for a preset.
--- @param id string
--- @param name string
--- @param ignore string|nil
--- @return string name
function HOLOHUD2.presets.ValidateName( id, name, ignore )

    local i = 0
    local presets = HOLOHUD2.presets.Find( id )
    local found = false

    if string.len( name ) == 0 then
        
        name = "Untitled"

    end

    local current = name

    while not found do

        local already = false

        for _, presets in ipairs( presets ) do

            if ignore and presets.filename == ignore then continue end
            if presets.name ~= current then continue end
            
            already = true
            break

        end

        if already then
            
            i = i + 1
            current = name .. " (" .. i .. ")"
            continue

        end

        found = true

    end

    return current

end

--- Writes a preset into the disk.
--- @param id string preset group
--- @param name string
--- @param values table
--- @return boolean success
function HOLOHUD2.presets.Write( id, name, values )

    local group = groups[ id ]

    if not group then return false end

    local path =  HOLOHUD2.DIR .. "/" .. group.folder

    if not file.Exists( path, "DATA" ) then

        file.CreateDir( path )

    end

    local filename = path .. "/" .. os.time() .. ".json"
    local preset = {
        name    = HOLOHUD2.presets.ValidateName( id, name ),
        values  = values
    }

    file.Write( filename, util.TableToJSON( preset, true ) )

    return file.Exists( filename, "DATA" )

end

--- Renames a stored preset.
--- @param id string
--- @param filename string
--- @param name string
--- @return boolean success
function HOLOHUD2.presets.Rename( id, filename, name )

    local group = groups[ id ]

    if not group then return false end

    local path = HOLOHUD2.DIR .. "/" .. group.folder .. "/" .. filename
    local preset = file.Read( path, "DATA" )

    if not preset then return false end

    preset = util.JSONToTable( preset )
    preset.name = HOLOHUD2.presets.ValidateName( id, name, filename )
    file.Write( path, util.TableToJSON( preset ) )

    return file.Exists( path, "DATA" )

end

--- Deletes the given preset from disk.
--- @param id string
--- @param filename string
--- @return boolean success
function HOLOHUD2.presets.Delete( id, filename )

    local group = groups[ id ]

    if not group then return false end

    local path = HOLOHUD2.DIR .. "/" .. group.folder .. "/" .. filename

    file.Delete( path )

    return not file.Exists( path, "DATA" )

end