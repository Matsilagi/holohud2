local math = math
local scale_Get = HOLOHUD2.scale.Get

local BaseClass = HOLOHUD2.component.Get( "Text" )

local COMPONENT = {
    is_rect = false,
    w       = 0,
    h       = 0
}

function COMPONENT:Init()

    self:SetText( "/" )

end

function COMPONENT:PerformLayout()

    if not self.invalid_layout then return end

    if self.is_rect then

        local scale = scale_Get()
        self._x, self._y = self.x * scale, self.y * scale
        self._w, self._h = self.w * scale, self.h * scale
        self.__w, self.__h = self.w, self.h
        return
    
    end

    BaseClass.PerformLayout(self)

    if self.align == TEXT_ALIGN_CENTER then

        self._x = self._x - self._w / 2

    elseif self.align == TEXT_ALIGN_RIGHT then

        self._x = self._x - self._w

    end

end

function COMPONENT:SetDrawAsRectangle( is_rect )

    if self.is_rect == is_rect then return end

    self.is_rect = is_rect

    self:InvalidateLayout()
    return true

end

function COMPONENT:SetSize( w, h )

    if self.w == w and self.h == h then return end

    self.w = w
    self.h = h

    self:InvalidateLayout()
    return true

end

function COMPONENT:Paint( x, y, scale )

    if not self.visible then return end

    if self.is_rect then

        surface.SetDrawColor( self.color.r, self.color.g, self.color.b, self.color.a )
        surface.DrawRect( x + self._x, y + self._y, self._w, self._h )
        return

    end

    BaseClass.Paint( self, x, y, scale )

end

HOLOHUD2.component.Register( "Separator", COMPONENT, "Text" )