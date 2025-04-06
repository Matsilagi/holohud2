---
--- Register contribution types for easily localizable credits.
---

HOLOHUD2.credits = {}

local contributions = {}

--- Registers a contribution type.
--- @param id string
--- @param icon string
--- @param tooltip string
function HOLOHUD2.credits.Register( id, icon, tooltip )

    contributions[ id ] = { icon = icon, tooltip = tooltip }

    return id

end

--- comment
--- @param id any
--- @return unknown
function HOLOHUD2.credits.Get( id )

    return contributions[ id ]

end