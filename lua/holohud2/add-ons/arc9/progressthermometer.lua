
local BaseClass = HOLOHUD2.component.Get( "ARC9_Thermometer" )

local util_StartStencilScissor = HOLOHUD2.util.StartStencilScissor
local util_EndStencilScissor = HOLOHUD2.util.EndStencilScissor

local COMPONENT = {
    invalid_progress_layout = false,
    value                   = 0,
    _x0                     = 0,
    _y0                     = 0,
    _x1                     = 0,
    _y1                     = 0
}

function COMPONENT:InvalidateLayout()

    BaseClass.InvalidateLayout( self )
    self:InvalidateProgressLayout()

end

function COMPONENT:InvalidateProgressLayout()

    self.invalid_progress_layout = true

end

function COMPONENT:PerformProgressLayout( force )
    
    if ( not self.visible or not self.invalid_progress_layout ) and not force then return end

    if self.vertical then

        self._x0 = self._x - self._bottom_size / 2
        self._x1 = self._x + self._bottom_size / 2
        self._y0 = self._y + ( self._h + self._bottom_size / 2 ) * ( 1 - self.value )
        self._y1 = self._y + self._h + self._bottom_size / 2

    else

        self._x0 = self._x - self._bottom_size
        self._x1 = self._x + self._w - ( self._w + self._bottom_size ) * ( 1 - self.value )
        self._y0 = self._y - self._bottom_size / 2
        self._y1 = self._y + self._h + self._bottom_size / 2

    end

    self.invalid_progress_layout = false

end

function COMPONENT:SetValue( value )

    if self.value == value then return end

    self.value = value
    self:InvalidateProgressLayout()

    return true

end

function COMPONENT:Paint( x, y )

    util_StartStencilScissor( x + self._x0, y + self._y0, self._x1 - self._x0, self._y1 - self._y0 )
    BaseClass.Paint( self, x, y )
    util_EndStencilScissor()

end

HOLOHUD2.component.Register( "ARC9_ProgressThermometer", COMPONENT, "ARC9_Thermometer" )