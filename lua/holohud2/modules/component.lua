---
--- Drawable components.
---

HOLOHUD2.component = {}

local components = {}

local COMPONENT = {

    --- Called upon instancing.
    Init = function() end

}

--- Registers a new component.
--- @param name string
--- @param component table
--- @vararg string parents
function HOLOHUD2.component.Register( name, component, ... )

    local parents = { ... }

    if #parents > 0 then -- WARNING: multi inheritance jumpscare

        for i=1, #parents do

            table.Inherit( component, components[ parents[ i ] ] )

        end

    else

        table.Inherit( component, COMPONENT )

    end

    components[ name ] = component

end

--- Creates an instance of a component.
--- @param name string component name
--- @return table instance
--- This will also call "Init" on the component during instancing.
function HOLOHUD2.component.Create( name )

    local instance = table.Copy( components[ name ] )
    instance:Init()
    return instance

end

--- Returns a registered component definition.
--- @param name string
--- @return table component
function HOLOHUD2.component.Get( name )

    return components[ name ]

end

--- Returns all registered components.
--- @return table components
function HOLOHUD2.component.All()

    return components

end
