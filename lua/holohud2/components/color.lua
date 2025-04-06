local math = math
local table = table
local FrameTime = FrameTime

local COMPONENT = {
    delay       = .4,
    color       = Color( 255, 255, 255, 255 ),
    target      = color_white,
    active      = false,
    amount      = 0,
    _prev       = color_white
}

function COMPONENT:SetColor( color )

    self.color:SetUnpacked( color.r, color.g, color.b, color.a )
    self.active = false

end

function COMPONENT:SetTarget( color )

    self.target = color

end

function COMPONENT:FadeTo( target )

    self._prev  = table.Copy(self.color)
    self.target = target
    self.amount = 0
    self.active = true

end

function COMPONENT:GetColor()

    return self.color

end

function COMPONENT:Think()

    if not self.active then return end

    self.amount = math.min( self.amount + FrameTime() / self.delay, 1 )

    for i, _ in pairs( self.color ) do
        
        self.color[ i ] = self._prev[ i ] * ( 1 - self.amount ) + self.target[ i ] * self.amount

    end

    -- if the animation ended, stop running
    if self.amount >= 1 then self.active = false end

end

HOLOHUD2.component.Register( "Color", COMPONENT )