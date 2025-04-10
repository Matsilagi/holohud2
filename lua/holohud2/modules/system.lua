
local SYSTEM_SUFFIX         = "[" .. HOLOHUD2.CodeName .. "] "
local SYSTEM_COLOR          = Color( 150, 200, 255 )
local INFO_COLOR            = Color( 230, 230, 230 )
local WARN_COLOR            = Color( 230, 230, 140 )
local ERROR_COLOR           = Color( 230, 80, 80 )
local SUCCESS_COLOR         = Color( 140, 230, 140 )

local LOG_SYSTEM    = 1
local LOG_INFO      = 2
local LOG_WARN      = 3
local LOG_ERROR     = 4
local LOG_SUCCESS   = 5

local LOG_COLORS    = {
    [ LOG_SYSTEM ]  = SYSTEM_COLOR,
    [ LOG_INFO ]    = INFO_COLOR,
    [ LOG_WARN ]    = WARN_COLOR,
    [ LOG_ERROR ]   = ERROR_COLOR,
    [ LOG_SUCCESS ] = SUCCESS_COLOR
}

HOLOHUD2.system = {}

--- Prints a message with the system suffix.
--- @param ... unknown
function HOLOHUD2.system.Message( ... )
    
    MsgC( SYSTEM_COLOR, SYSTEM_SUFFIX, INFO_COLOR, ..., "\n" )

end

--- Prints a color coded message.
--- @param type number
--- @param message string
function HOLOHUD2.system.Log( type, message )

    MsgC( SYSTEM_COLOR, SYSTEM_SUFFIX, LOG_COLORS[ math.Clamp( type, LOG_SYSTEM, LOG_SUCCESS ) ], message, "\n" )

end

HOLOHUD2.LOG_SYSTEM     = LOG_SYSTEM
HOLOHUD2.LOG_INFO       = LOG_INFO
HOLOHUD2.LOG_WARN       = LOG_WARN
HOLOHUD2.LOG_ERROR      = LOG_ERROR
HOLOHUD2.LOG_SUCCESS    = LOG_SUCCESS