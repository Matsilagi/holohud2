---
--- Addon's exclusive event handling.
---

HOLOHUD2.hook = {}

local hooks = {}

--- Adds a hook for an event.
--- @param event string
--- @param hook string
--- @param func function
function HOLOHUD2.hook.Add( event, hook, func )

    if not hooks[ event ] then hooks[ event ] = {} end

    hooks[ event ][ hook ] = func

end

--- Removes a registered hook.
--- @param event string
--- @param hook string
function HOLOHUD2.hook.Remove( event, hook )

    if not hooks[ event ] then return end

    hooks[ event ][ hook ] = nil

end

--- Calls all hooked functions on an element event.
--- @param event string
--- @vararg any arguments
--- @return any a first returned value
--- @return any b second returned value
--- @return any c third returned value
--- @return any d fourth returned value
--- @return any e fifth returned value
--- @return any f sixth returned value
function HOLOHUD2.hook.Call( event, ... )

    if not hooks[ event ] then return end

    for _, func in pairs( hooks[ event ] ) do
        
        local a, b, c, d, e, f = func( ... )

        if a ~= nil then return a, b, c, d, e, f end

    end

end