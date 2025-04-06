local math = math
local surface = surface
local scale_Get = HOLOHUD2.scale.Get

local FORMAT_INFLICTOR  = "[%s]"

local COMPONENT = {
    invalid_layout  = false,
    x               = 0,
    y               = 0,
    size            = 16,
    spacing         = 4,
    font            = "default",
    colorattacker   = color_white,
    colorinflictor  = color_white,
    colorvictim     = color_white,
    attacker        = "",
    inflictor_name  = "",
    inflictor_class = "",
    victim          = "",
    inflictor_upper = false,
    _attacker       = "",
    _attackerx      = 0,
    _attackery      = 0,
    _inflictor      = {

        texture     = surface.GetTextureID( "debug/debugempty" ),
        filew       = 16,
        fileh       = 16,
        u0          = 0,
        v0          = 0,
        u1          = 16,
        v1          = 16

    },
    _inflictorx     = 0,
    _inflictory     = 0,
    _inflictorw     = 8,
    _inflictorh     = 8,
    _inflictoricon  = true,
    _victimx        = 0,
    _victimy        = 0,
    _victim         = "",
    __w             = 0,
    __h             = 0
}

function COMPONENT:InvalidateLayout()

    self.invalid_layout = true

end

function COMPONENT:PerformLayout( force )

    if not force and not self.invalid_layout then return end

    local scale = scale_Get()
    local x, y = math.Round( self.x * scale ), math.Round( self.y * scale )
    local spacing = math.Round( self.spacing * scale )

    -- localize strings
    self._attacker = language.GetPhrase( self.attacker )
    self._inflictor = string.format( FORMAT_INFLICTOR, language.GetPhrase( self.inflictor_name ) )
    self._victim = language.GetPhrase( self.victim )

    if self.inflictor_upper then
        
        self._inflictor = string.upper( self._inflictor )
    
    end

    -- calculate sizes
    surface.SetFont( self.font )
    local attackerw = surface.GetTextSize( self._attacker )
    local victimw, h = surface.GetTextSize( self._victim )

    -- check if inflictor has an icon or not
    local inflictorw, inflictorh
    local icon

    if HOLOHUD2.killicon.Has( self.inflictor_class ) or utf8.len( self.inflictor_name ) == 0 then

        icon = HOLOHUD2.killicon.Get( self.inflictor_class )

        self._inflictor = {

            texture     = icon.texture,
            filew       = icon.filew,
            fileh       = icon.fileh,
            u0          = icon.x,
            v0          = icon.y,
            u1          = icon.w,
            v1          = icon.h

        }

        inflictorw = math.Round( icon.w / icon.h * self.size * scale )
        inflictorh = math.Round( self.size * scale )

        self._inflictorw = inflictorw
        self._inflictorh = inflictorh

    else

        inflictorw, inflictorh = surface.GetTextSize( self._inflictor )

    end

    self._inflictoricon = icon

    -- calculate horizontal offset
    self._attackerx = x
    self._inflictorx = self._attackerx + attackerw + ( attackerw > 0 and spacing or 0 )
    self._victimx = self._inflictorx + inflictorw + spacing

    -- calculate vertical offset
    if self._inflictoricon then

        if inflictorw > h then

            self._inflictory = y
            y = y + ( inflictorh - h ) / 2

        else

            self._inflictory = y + ( h - inflictorh ) / 2

        end

    else

        self._inflictory = y

    end

    self._attackery = y
    self._victimy = y

    -- calculate total size
    self.__w = self.spacing + math.Round( ( attackerw + inflictorw + victimw ) / scale ) + ( attackerw > 0 and self.spacing or 0 )
    self.__h = math.Round( math.max( h, inflictorh ) / scale )

    self.invalid_layout = false
    return true

end

function COMPONENT:SetPos( x, y )

    if self.x == x and self.y == y then return end

    self.x = x
    self.y = y
    self:InvalidateLayout()

    return true

end

function COMPONENT:SetSize( size )

    if self.size == size then return end

    self.size = size
    self:InvalidateLayout()

end

function COMPONENT:SetPadding( padding )

    if self.padding == padding then return end

    self.padding = padding
    self:InvalidateLayout()

end

function COMPONENT:SetSpacing( spacing )

    if self.spacing == spacing then return end

    self.spacing = spacing
    self:InvalidateLayout()

end

function COMPONENT:SetFont( font )

    if self.font == font then return end

    self.font = font
    self:InvalidateLayout()

end

function COMPONENT:SetAttackerColor( color )

    self.colorattacker = color

end

function COMPONENT:SetInflictorColor( color )

    self.colorinflictor = color

end

function COMPONENT:SetVictimColor( color )

    self.colorvictim = color

end

function COMPONENT:SetInflictorOnUppercase( upper )

    if self.inflictor_upper == upper then return end

    self.inflictor_upper = upper
    self:InvalidateLayout()

end

function COMPONENT:SetAttacker( attacker )

    if self.attacker == attacker then return end

    self.attacker = attacker
    self:InvalidateLayout()

    return true

end

function COMPONENT:SetInflictorName( inflictor_name )

    if self.inflictor_name == inflictor_name then return end

    self.inflictor_name = inflictor_name
    self:InvalidateLayout()

    return true

end

function COMPONENT:SetInflictorClass( inflictor_class )

    if self.inflictor_class == inflictor_class then return end

    self.inflictor_class = inflictor_class
    self:InvalidateLayout()

    return true

end

function COMPONENT:InvalidateInflictor()

    self:SetInflictorClass( "" )

end

function COMPONENT:SetVictim( victim )

    if self.victim == victim then return end

    self.victim = victim
    self:InvalidateLayout()
    
    return true

end

function COMPONENT:GetSize()

    return self.__w, self.__h

end

function COMPONENT:Paint( x, y )

    surface.SetFont( self.font )

    -- attacker
    surface.SetTextColor( self.colorattacker )
    surface.SetTextPos( x + self._attackerx, y + self._attackery )
    surface.DrawText( self._attacker )

    -- victim
    surface.SetTextColor( self.colorvictim )
    surface.SetTextPos( x + self._victimx, y + self._victimy )
    surface.DrawText( self._victim )

    -- inflictor
    if self._inflictoricon then

        surface.SetTexture( self._inflictor.texture )
        surface.SetDrawColor( self.colorinflictor )
        surface.DrawTexturedRectUV( x + self._inflictorx, y + self._inflictory, self._inflictorw, self._inflictorh, self._inflictor.u0 / self._inflictor.filew, self._inflictor.v0 / self._inflictor.fileh, ( self._inflictor.u0 + self._inflictor.u1 ) / self._inflictor.filew, ( self._inflictor.v0 + self._inflictor.v1 ) / self._inflictor.fileh )
    
    else

        surface.SetTextColor( self.colorinflictor )
        surface.SetTextPos( x + self._inflictorx, y + self._inflictory )
        surface.DrawText( self._inflictor )

    end

end

HOLOHUD2.component.Register( "DeathNotice", COMPONENT )