local math = math
local render = render
local surface = surface
local util_StartStencilScissor = HOLOHUD2.util.StartStencilScissor
local util_EndStencilScissor = HOLOHUD2.util.EndStencilScissor

local GROWDIRECTION_LEFT                = 1
local GROWDIRECTION_CENTER_HORIZONTAL   = 2
local GROWDIRECTION_RIGHT               = 3
local GROWDIRECTION_UP                  = 4
local GROWDIRECTION_CENTER_VERTICAL     = 5
local GROWDIRECTION_DOWN                = 6

local COMPONENT = {
    visible     = true,
    direction   = GROWDIRECTION_RIGHT,
    _value      = 0,
    _x          = 0,
    _y          = 0,
    _w          = 0,
    _h          = 0,
    _x0         = 0,
    _y0         = 0,
    _x1         = 0,
    _y1         = 0
}

function COMPONENT:CalcScissorRect()

    local x, y, w, h = self._x, self._y, self._w, self._h
    local value = self._value
    local direction = self.direction

    if direction == GROWDIRECTION_RIGHT then

        self._x0, self._y0, self._x1, self._y1 = x, y, x + math.Round( w * value ), y + h

    elseif direction == GROWDIRECTION_LEFT then

        self._x0, self._y0, self._x1, self._y1 = x + math.Round( w * ( 1 - value ) ), y, x + w, y + h
    
    elseif direction == GROWDIRECTION_UP then
    
        self._x0, self._y0, self._x1, self._y1 = x, y + math.Round( h * ( 1 - value ) ), x + w, y + h
    
    elseif direction == GROWDIRECTION_DOWN then
    
        self._x0, self._y0, self._x1, self._y1 = x, y, x + w, y + math.Round( h * value )
    
    elseif direction == GROWDIRECTION_CENTER_HORIZONTAL then
    
        local center = math.Round( w / 2 )
        local size = math.Round( ( w * value ) / 2 )
        self._x0, self._y0, self._x1, self._y1 = x + center - size, y, x + center + size, y + h
    
    elseif direction == GROWDIRECTION_CENTER_VERTICAL then
    
        local center = math.Round( h / 2 )
        local size = math.Round( ( h * value ) / 2 )
        self._x0, self._y0, self._x1, self._y1 = x, y + center - size, x + w, y + center + size
    
    else
    
        self._x0, self._y0, self._x1, self._y1 = x, y, x + w, y + h
    
    end

end

function COMPONENT:StartScissorRect( x, y )

    util_StartStencilScissor( x + self._x0, y + self._y0, self._x1 - self._x0, self._y1 - self._y0 )

end

function COMPONENT:EndScissorRect()

    util_EndStencilScissor()

end

HOLOHUD2.component.Register( "BaseProgressBar", COMPONENT )

HOLOHUD2.GROWDIRECTION_LEFT                 = GROWDIRECTION_LEFT
HOLOHUD2.GROWDIRECTION_CENTER_HORIZONTAL    = GROWDIRECTION_CENTER_HORIZONTAL
HOLOHUD2.GROWDIRECTION_RIGHT                = GROWDIRECTION_RIGHT
HOLOHUD2.GROWDIRECTION_UP                   = GROWDIRECTION_UP
HOLOHUD2.GROWDIRECTION_CENTER_VERTICAL      = GROWDIRECTION_CENTER_VERTICAL
HOLOHUD2.GROWDIRECTION_DOWN                 = GROWDIRECTION_DOWN