local math = math

local GROWDIRECTION_CENTER_HORIZONTAL = HOLOHUD2.GROWDIRECTION_CENTER_HORIZONTAL
local GROWDIRECTION_CENTER_VERTICAL = HOLOHUD2.GROWDIRECTION_CENTER_VERTICAL
local PROGRESSBAR_DOT = HOLOHUD2.PROGRESSBAR_DOT

local BaseClass = HOLOHUD2.component.Get( "Bar" )

local COMPONENT = {
    invalid_progress_layout = false,
    value                   = 0
}

function COMPONENT:InvalidateLayout()

    BaseClass.InvalidateLayout( self )
    self:InvalidateProgressLayout()

end

function COMPONENT:InvalidateProgressLayout()

    self.invalid_progress_layout = true

end

function COMPONENT:PerformProgressLayout( force )

    if not force and not self.invalid_progress_layout then return end

    local value = self.value * ( self.w / self.__w )

    if self.style == PROGRESSBAR_DOT then

        local dots = #self._metadata
        local segment = 1 / dots

        if self.direction == GROWDIRECTION_CENTER_HORIZONTAL or self.direction == GROWDIRECTION_CENTER_VERTICAL then
            
            local even = segment * math.Round( dots % 2 )
            value = math.Round( value / segment / 2 + even ) * segment * 2 - even
        
        else
           
            value = math.Round( value / segment ) * segment
        
        end

    end

    self._value = value
    self:CalcScissorRect()

    self.invalid_progress_layout = false
    return true

end

function COMPONENT:SetGrowDirection( direction )

    if self.direction == direction then return end
    
    self.direction = direction
    self:InvalidateProgressLayout()

    return true

end

function COMPONENT:SetValue( value )

    if self.value == value then return end

    self.value = value
    self:InvalidateProgressLayout()
    
    return true

end

function COMPONENT:Think()

    if not self.visible then return end

    self:PerformLayout()
    self:PerformProgressLayout()

end

function COMPONENT:Paint( x, y )

    if not self.visible then return end

    self:StartScissorRect( x, y )
    BaseClass.Paint( self, x, y )
    self:EndScissorRect()

end

HOLOHUD2.component.Register( "ProgressBar", COMPONENT, "Bar", "BaseProgressBar" )