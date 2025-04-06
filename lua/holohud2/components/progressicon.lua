local BaseClass = HOLOHUD2.component.Get( "Icon" )

HOLOHUD2.ICONRENDERMODE_STATIC              = 1
HOLOHUD2.ICONRENDERMODE_PROGRESS            = 2
HOLOHUD2.ICONRENDERMODE_STATICBACKGROUND    = 3
HOLOHUD2.ICONRENDERMODE_PROGRESSBACKGROUND  = 4
HOLOHUD2.ICONRENDERMODES                    = { "#holohud2.option.progressicon_0", "#holohud2.option.progressicon_1", "#holohud2.option.progressicon_2", "#holohud2.option.progressicon_3" }

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

    self:CalcScissorRect()

    self.invalid_progress_layout = false

end

function COMPONENT:Think()

    if not self.visible then return end
    
    self:PerformLayout()
    self:PerformProgressLayout()

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
    self._value = value
    self:InvalidateProgressLayout()

    return true

end

function COMPONENT:Paint( x, y )

    if not self.visible then return end

    self:StartScissorRect( x, y )
    BaseClass.Paint( self, x, y )
    self:EndScissorRect()
    
end

HOLOHUD2.component.Register("ProgressIcon", COMPONENT, "Icon", "BaseProgressBar")
