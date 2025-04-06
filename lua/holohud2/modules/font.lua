---
--- Automatically scaling fonts.
---

HOLOHUD2.font = {}

local fonts = {}

--- Registers an automatically generated font.
--- @param name string
--- @param font table
local function register( name, font )
    
    fonts[ name ] = font

end
HOLOHUD2.font.Register = register

--- Creates the given registered font.
--- @param name string
local function create( name )

    local font = fonts[ name ]

    surface.CreateFont(name, {

        font    = font.font,
        size    = math.ceil( font.size * HOLOHUD2.scale.Get() ),
        weight  = font.weight,
        italic  = font.italic,
        extended= true

    })

end
HOLOHUD2.font.Create = create

--- Generates all registered fonts.
local function generate()

    for name, _ in pairs( fonts ) do

        create( name )

    end

end
HOLOHUD2.font.Generate = generate

--- Gets a singular font.
--- @param name string
--- @return table font
function HOLOHUD2.font.Get( name )

    return fonts[ name ]

end

--- Gets all registered fonts.
--- @return table fonts
function HOLOHUD2.font.All()

    return fonts

end