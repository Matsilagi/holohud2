--- 
--- DyaMetR's unintrusive key bind press
--- March 14th, 2025
--- 
--- Custom KeyBindPress hook used by HUDs that want to ease compatibility
--- by giving priority to any other addon.
--- 

local version = 3 -- current version of the bind press replacer

-- check whether there's a newer version of this script
if UnintrusiveBindPress and UnintrusiveBindPress.version >= version then return end

-- only create table once
if not UnintrusiveBindPress then UnintrusiveBindPress = { hooks = {}, priorities = {} } end

-- update version
UnintrusiveBindPress.version = version

---
--- Replaces the PlayerBindPress hook, initializing our system.
---
function UnintrusiveBindPress.init()

    -- do not replace again
    if not UnintrusiveBindPress.bindPress then

        UnintrusiveBindPress.bindPress = GAMEMODE.PlayerBindPress -- get original bind press

    end

    -- create a replacement function
    GAMEMODE.PlayerBindPress = function( self, _player, bind, pressed, code )

        -- go through each priority in order
        for _, hooks in ipairs( UnintrusiveBindPress.priorities ) do

            -- go through each hook without order
            for _, func in pairs( hooks ) do

                -- run hook
                local result = func( _player, bind, pressed, code )

                -- if this hook has returned a value, override the rest
                if result ~= nil then

                    return result

                end

            end

        end

        -- call original function
        return UnintrusiveBindPress.bindPress( self, _player, bind, pressed, code )

    end

end

--- Adds an unintrusive bind press hook
--- @param id string
--- @param func function
--- @param priority number|nil
function UnintrusiveBindPress.add( id, func, priority )

    priority = math.max( priority or 1, 1 )

    -- create priority table entry if does not exist
    if not UnintrusiveBindPress.priorities[ priority ] then

        UnintrusiveBindPress.priorities[ priority ] = {}

    end

    -- remove from previous priority list if it already existed
    local previous = UnintrusiveBindPress.hooks[ id ]

    if previous then

        UnintrusiveBindPress.priorities[ previous ][ id ] = nil

    end

    -- insert hook into priority
    UnintrusiveBindPress.priorities[ priority ][ id ] = func
    UnintrusiveBindPress.hooks[ id ] = priority
end

--- Removes the given bind press hook
--- @param id string
function UnintrusiveBindPress.remove( id )
    
    local priority = UnintrusiveBindPress.hooks[ id ]
    UnintrusiveBindPress.priorities[ priority ][ id ] = nil
    UnintrusiveBindPress.hooks[ id ] = nil

end

--- Returns the registered hooks
--- @param priority number
--- @return table
function UnintrusiveBindPress.getTable(priority)

    if priority then
        return UnintrusiveBindPress.hooks[ priority ]
    else
        return UnintrusiveBindPress.hooks
    end

end

-- do hook replace upon initializing every script
hook.Add( "PostGamemodeLoaded", "unintrusive_bind_press", UnintrusiveBindPress.init )

-- alternatively, if we're running this manually, initialize it
if GAMEMODE then

    UnintrusiveBindPress.init()

end