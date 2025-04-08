local CurTime = CurTime

local AMMOPICKUPMODE_NAMEFALLBACK   = 1
local AMMOPICKUPMODE_NAMEALWAYS     = 2
local AMMOPICKUPMODE_FULL           = 3
local AMMOPICKUPMODES               = { "Name as fallback", "Name always", "Icon and name" }

local AMMOPICKUPNAMEPOS_ABOVE       = 1
local AMMOPICKUPNAMEPOS_UNDER       = 2
local AMMOPICKUPNAMEPOS             = { "Above", "Under" }

local FORMAT_AMMONAME   = "%s_ammo"

local COMPONENT = {
    invalid_layout  = false,
    x               = 0,
    y               = 0,
    spacing         = 0,
    mode            = AMMOPICKUPMODE_NAMEFALLBACK,
    name_pos        = AMMOPICKUPNAMEPOS_UNDER,
    name_spacing    = 0,
    name_align      = TEXT_ALIGN_RIGHT,
    name_animated   = false,
    name_animspeed  = 1,
    name_animdelay  = 1,
    amount_x        = 0,
    amount_y        = 0,
    lerp            = true,
    ammotype        = 0,
    amount          = 0,
    _amount         = 0,
    _nextnamechar   = 0,
    __w             = 0,
    __h             = 0
}

function COMPONENT:Init()

    self.Icon = HOLOHUD2.component.Create( "AmmoIcon" )
    self.Name = HOLOHUD2.component.Create( "Text" )
    self.Amount = HOLOHUD2.component.Create( "Number" )

end

function COMPONENT:InvalidateLayout()

    self.invalid_layout = true

end

function COMPONENT:PerformLayout()

    if not self.invalid_layout then return end

    self.Name:PerformLayout( true )
    self.Amount:PerformLayout( true )
    self.Icon:PerformLayout( true )

    local x, y = self.x, self.y -- offset
    local w, h = 0, 0 -- bounding box of all elements

    local name_w, name_h = self.Name:GetSize()
    local amount_w, amount_h = self.Amount:GetSize()

    if self.mode == AMMOPICKUPMODE_NAMEALWAYS or
       ( self.mode == AMMOPICKUPMODE_NAMEFALLBACK and not HOLOHUD2.ammo.Has( self.ammotype ) ) then

        self.Icon:SetVisible( false )

        w, h = name_w + self.spacing + amount_w, math.max( name_h, amount_h )

        self.Name:SetPos( x, y + h / 2 - name_h / 2 )
        self.Amount:SetPos( x + name_w + self.spacing + self.amount_x, y + h / 2 - amount_h / 2 + self.amount_y )

    else

        local icon_w, icon_h = self.Icon:GetSize()
        local line_h = math.max( icon_h, amount_h ) -- icon and amount line height

        w, h = icon_w + self.spacing + amount_w, line_h

        -- if the name is always drawn, we need to reposition everything
        if self.mode == AMMOPICKUPMODE_FULL then
            
            self.Name:SetVisible( true )

            -- calculate horizontal position of the name
            local name_x = self.name_align == TEXT_ALIGN_RIGHT and ( math.max( w, name_w ) - name_w ) or ( self.name_align == TEXT_ALIGN_CENTER and w / 2 ) or 0

            -- if name is above, move everything down
            if self.name_pos == AMMOPICKUPNAMEPOS_ABOVE then
                
                self.Name:SetPos( x + name_x, y )
                y = y + name_h + self.name_spacing

            else

                self.Name:SetPos( x + name_x, y + h + self.name_spacing )

            end

            -- if the name is bigger than everything else, we need to move it according to alignment
            if name_w > w then
                
                if self.name_align == TEXT_ALIGN_RIGHT then
                    
                    x = x + name_w - w

                elseif self.name_align == TEXT_ALIGN_CENTER then

                    x = x + ( name_w - w ) / 2

                end

                w = name_w

            end

            h = h + name_h + self.name_spacing

        else

            self.Name:SetVisible( false )

        end

        self.Icon:SetVisible( true )
        self.Icon:SetPos( x, y + line_h / 2 )
        self.Amount:SetPos( x + icon_w + self.spacing + self.amount_x, y + line_h / 2 - amount_h / 2 + self.amount_y )

    end

    self.__w, self.__h = w, h

    self.invalid_layout = false
    return true

end

function COMPONENT:SetNameAnimated( animated )

    if self.name_animated == animated then return end

    if animated then

        self.Name:SetCharsVisible( 0 )
        self._nextnamechar = CurTime() + self.name_animdelay

    else

        self.Name:SetCharsVisible( -1 )

    end

    self.name_animated = animated

    return true

end

function COMPONENT:SetNameAnimationSpeed( speed )

    self.name_animspeed = speed

end

function COMPONENT:SetNameAnimationDelay( delay )

    self.name_animdelay = delay

end

function COMPONENT:SetAmountOffset( x, y )

    if self.amount_x == x and self.amount_y == y then return end

    self.amount_x = x
    self.amount_y = y
    self:InvalidateLayout()

    return true

end

function COMPONENT:SetAmmoType( ammotype )

    if self.ammotype == ammotype then return end

    self.Icon:SetAmmoType( ammotype )
    self.Name:SetText( language.GetPhrase( string.format( FORMAT_AMMONAME, game.GetAmmoName( ammotype ) or "NULL" ) ) )

    self.ammotype = ammotype
    self:InvalidateLayout()

    return true

end

function COMPONENT:SetAmount( amount )

    if self.amount == amount then return end

    self.Amount:SetValue(amount)
    self.amount = amount

    return true

end

function COMPONENT:SetPos( x, y )

    if self.x == x and self.y == y then return end

    self.x = x
    self.y = y
    self:InvalidateLayout()

    return true

end

function COMPONENT:SetSpacing( spacing )

    if self.spacing == spacing then return end

    self.spacing = spacing
    self:InvalidateLayout()

    return true

end

function COMPONENT:SetMode( mode )

    if self.mode == mode then return end

    self.mode = mode
    self:InvalidateLayout()

    return true

end

function COMPONENT:SetNamePos( pos )

    if self.name_pos == pos then return end

    self.name_pos = pos
    self:InvalidateLayout()

    return true

end

function COMPONENT:SetNameSpacing( spacing )

    if self.name_spacing == spacing then return end

    self.name_spacing = spacing
    self:InvalidateLayout()

    return true

end

function COMPONENT:SetNameAlign( align )

    if self.name_align == align then return end

    self.Name:SetAlign(align)
    self.name_align = align
    self:InvalidateLayout()

    return true

end

function COMPONENT:SetLerp( lerp )

    if self.lerp == lerp then return end

    self.Amount:SetValue(lerp and self._amount or self.amount)
    self.lerp = lerp

    return true

end

function COMPONENT:SetColor( color )

    self.Amount:SetColor( color )
    self.Icon:SetColor( color )
    self.Name:SetColor( color )

end

function COMPONENT:SetColor2( color2 )

    self.Amount:SetColor2( color2 )

end

function COMPONENT:GetSize()

    return self.__w, self.__h

end

local LERP_SPEED = 12
function COMPONENT:Think()

    self._amount = Lerp( FrameTime() * LERP_SPEED, self._amount, self.amount )

    if self.lerp then self.Amount:SetValue( math.Round( self._amount ) ) end

    self.Amount:PerformLayout()
    self.Icon:PerformLayout()
    self.Name:PerformLayout()
    self:PerformLayout()

    if not self.name_animated or self.Name.charsvisible >= utf8.len( self.Name.text ) then return end

    local curtime = CurTime()

    if self._nextnamechar > curtime then return end

    self.Name:SetCharsVisible( self.Name.charsvisible + 1 )
    self._nextnamechar = curtime + 1 / self.name_animspeed

end

function COMPONENT:PaintBackground( x, y )

    self.Amount:PaintBackground( x, y )

end

function COMPONENT:Paint( x, y )

    self.Amount:Paint( x, y )
    self.Name:Paint( x, y )
    self.Icon:Paint( x, y )

end

HOLOHUD2.AMMOPICKUPMODE_NAMEFALLBACK    = AMMOPICKUPMODE_NAMEFALLBACK
HOLOHUD2.AMMOPICKUPMODE_NAMEALWAYS      = AMMOPICKUPMODE_NAMEALWAYS
HOLOHUD2.AMMOPICKUPMODE_FULL            = AMMOPICKUPMODE_FULL
HOLOHUD2.AMMOPICKUPMODES                = AMMOPICKUPMODES

HOLOHUD2.AMMOPICKUPNAMEPOS_ABOVE        = AMMOPICKUPNAMEPOS_ABOVE
HOLOHUD2.AMMOPICKUPNAMEPOS_UNDER        = AMMOPICKUPNAMEPOS_UNDER
HOLOHUD2.AMMOPICKUPNAMEPOS              = AMMOPICKUPNAMEPOS

HOLOHUD2.component.Register( "AmmoPickup", COMPONENT )