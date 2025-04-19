local StartAlphaMultiplier = HOLOHUD2.render.StartAlphaMultiplier
local EndAlphaMultiplier = HOLOHUD2.render.EndAlphaMultiplier

local COMPONENT = {
    invalid_layout          = false,
    size                    = 0,
    inverted                = false,
    x                       = 0,
    y                       = 0,
    spacing                 = 0,
    pile_min                = 4,
    pile_x                  = 0,
    pile_y                  = 0,
    pile_spacing            = 0,
    pile_oddoffset          = 0,
    pile_max                = 9,
    pile_num                = true,
    color                   = color_white,
    fade_time               = 1,
    fade_offset             = 0,
    fade_color              = color_white,
    highlight_time          = 1,
    highlight_offset        = 0,
    highlight_color         = color_white,
    outlined                = false,
    healthbar               = true,
    healthbar_background    = true,
    healthbar_x             = 0,
    healthbar_y             = 0,
    healthbar_w             = 0,
    healthbar_h             = 0,
    healthbar_style         = HOLOHUD2.PROGRESSBAR_SIMPLE,
    healthbar_growdirection = HOLOHUD2.GROWDIRECTION_UP,
    health_color            = { colors = { [ 0 ] = color_white }, fraction = false, gradual = false },
    health_color2           = { colors = { [ 0 ] = color_white }, fraction = false, gradual = false },
    text_on_background      = false
}

function COMPONENT:Init()
    
    self.members = {} -- avoid reference sharing

    self.Blur = HOLOHUD2.component.Create( "Blur" )

    local plus = HOLOHUD2.component.Create( "Text" )
    plus:SetText( "+" )
    self.Plus = plus

    self.Count = HOLOHUD2.component.Create( "Number" )
    self.Text = HOLOHUD2.component.Create( "Text" )

end

function COMPONENT:InvalidateLayout()

    self.invalid_layout = true

end

function COMPONENT:PerformLayout()

    if not self.invalid_layout then return end

    local x = 0
    local piled = #self.members > self.pile_min
    local spacing = piled and self.pile_spacing or self.spacing

    for i=1, math.min( #self.members, self.pile_max ) do

        local member = self.members[ i ]

        -- member:SetOutlined( self.outlined )
        member:SetSize( self.size )
        member:SetColor( self.color )
        member:SetFadeTime( self.fade_time )
        member:SetFadeOffset( self.fade_offset )
        member:SetFadeColor( self.fade_color )
        member:SetHighlightTime( self.highlight_time )
        member:SetHighlightOffset( self.highlight_offset )
        member:SetHighlightColor( self.highlight_color )
        member:SetDrawBackground( self.healthbar_background )
        member.Colors:SetColors( self.health_color )
        member.Colors2:SetColors( self.health_color2 )
        member.HealthBarBackground:SetPos( self.healthbar_x, self.healthbar_y )
        member.HealthBarBackground:SetSize( self.healthbar_w, self.healthbar_h )
        member.HealthBarBackground:SetStyle( self.healthbar_style )
        member.HealthBar:Copy( member.HealthBarBackground )
        member.HealthBar:SetGrowDirection( self.healthbar_growdirection )
        member:SetDrawHealth( self.healthbar and not piled )

        member:PerformLayout( true )

        local size = member:GetSize()

        if self.inverted then
           
            size = - size - spacing

            if i == 1 then x = x + size end

        else

            size = size + spacing
            
        end

        if piled then

            member:SetPos( self.pile_x + x, self.pile_y + ( ( i % 2 ~= 0 ) and self.pile_spacing or 0 ) )

        else

            member:SetPos( self.x + x, self.y )

        end

        x = x + size

    end

    local overflow = #self.members > self.pile_max

    self.Plus:SetVisible( self.pile_num and overflow )
    self.Count:SetVisible( self.pile_num and overflow )
    self.Count:SetValue( #self.members - self.pile_max )

    self.invalid_layout = false

end

function COMPONENT:SetSize( size )

    if self.size == size then return end

    self.size = size
    
    self:InvalidateLayout()

end

function COMPONENT:SetInverted( inverted )

    if self.inverted == inverted then return end

    self.inverted = inverted

    self:InvalidateLayout()

end

function COMPONENT:SetPos( x, y )

    if self.x == x and self.y == y then return end

    self.x = x
    self.y = y

    self:InvalidateLayout()

end

function COMPONENT:SetSpacing( spacing )

    if self.spacing == spacing then return end

    self.spacing = spacing

    self:InvalidateLayout()

end

function COMPONENT:SetPileMinimum( pile_min )

    if self.pile_min == pile_min then return end

    self.pile_min = pile_min

    self:InvalidateLayout()

end

function COMPONENT:SetPilePos( x, y )

    if self.pile_x == x and self.pile_y == y then return end

    self.pile_x = x
    self.pile_y = y

    self:InvalidateLayout()

end

function COMPONENT:SetPileSpacing( spacing )

    if self.pile_spacing == spacing then return end

    self.pile_spacing = spacing

    self:InvalidateLayout()

end

function COMPONENT:SetPileOddOffset( offset )

    if self.pile_oddoffset == offset then return end

    self.pile_oddoffset = offset

    self:InvalidateLayout()

end

function COMPONENT:SetPileMaximum( pile_max )

    if self.pile_max == pile_max then return end

    self.pile_max = pile_max

    self:InvalidateLayout()

end

function COMPONENT:SetDrawPileNumber( pile_num )

    if self.pile_num == pile_num then return end

    self.pile_num = pile_num

    self:InvalidateLayout()

end

function COMPONENT:SetColor( color )

    if self.color == color then return end

    self.color = color

    self:InvalidateLayout()

end

function COMPONENT:SetFadeTime( time )

    if self.fade_time == time then return end

    self.fade_time = time

    self:InvalidateLayout()

end

function COMPONENT:SetFadeOffset( offset )

    if self.fade_offset == offset then return end

    self.fade_offset = offset

    self:InvalidateLayout()

end

function COMPONENT:SetFadeColor( color )

    if self.fade_color == color then return end

    self.fade_color = color
    
    self:InvalidateLayout()

end

function COMPONENT:SetHighlightTime( time )

    if self.highlight_time == time then return end

    self.highlight_time = time

    self:InvalidateLayout()

end

function COMPONENT:SetHighlightOffset( offset )

    if self.highlight_offset == offset then return end

    self.highlight_offset = offset

    self:InvalidateLayout()

end


function COMPONENT:SetHighlightColor( color )

    if self.highlight_color == color then return end

    self.highlight_color = color

    self:InvalidateLayout()

end

function COMPONENT:SetOutlined( outlined )

    if self.outlined == outlined then return end

    self.outlined = outlined

    self:InvalidateLayout()

end

function COMPONENT:SetDrawHealthBar( healthbar )

    if self.healthbar == healthbar then return end

    self.healthbar = healthbar

    self:InvalidateLayout()

end

function COMPONENT:SetDrawHealthBarBackground( background )

    if self.healthbar_background == background then return end

    self.healthbar_background = background

    self:InvalidateLayout()

end

function COMPONENT:SetHealthBarPos( x, y )

    if self.healthbar_x == x and self.healthbar_y == y then return end

    self.healthbar_x = x
    self.healthbar_y = y

    self:InvalidateLayout()

end

function COMPONENT:SetHealthBarSize( w, h )

    if self.healthbar_w == w and self.healthbar_h == h then return end

    self.healthbar_w = w
    self.healthbar_h = h

    self:InvalidateLayout()

end

function COMPONENT:SetHealthBarStyle( style )

    if self.healthbar_style == style then return end

    self.healthbar_style = style

    self:InvalidateLayout()

end

function COMPONENT:SetHealthColor( color )

    if self.health_color == color then return end

    self.health_color = color

    self:InvalidateLayout()

end

function COMPONENT:SetHealthBarGrowDirection( growdirection )

    if self.healthbar_growdirection == growdirection then return end

    self.healthbar_growdirection = growdirection

    self:InvalidateLayout()

end

function COMPONENT:SetHealthColor2( color2 )

    if self.health_color2 == color2 then return end

    self.health_color2 = color2

    self:InvalidateLayout()

end

function COMPONENT:SetDrawTextOnBackground( on_background )

    self.text_on_background = on_background

end

function COMPONENT:AddMember( is_medic )

    self.Blur:Activate()

    local member = HOLOHUD2.component.Create( "HudSquadMember" )
    member:SetIsMedic( is_medic )

    table.insert( self.members, member )
    self:InvalidateLayout()

    return member

end

function COMPONENT:RemoveMember( i, died )

    if not isnumber( i ) then
        
        i = table.KeyFromValue( self.members, i )

    end

    local member = self.members[ i ]

    if not member then return end

    self.Blur:Activate()
    member:SetFading( false, died )

end

function COMPONENT:Clear()

    self.members = {}
    self:InvalidateLayout()

end

function COMPONENT:Think()

    self.Blur:Think()
    self.Plus:PerformLayout()
    self.Count:PerformLayout()
    self.Text:PerformLayout()
    self:PerformLayout()

    for i=1, #self.members do

        local member = self.members[ i ]

        if not member then continue end

        member:Think()

        if member.fade then continue end
        if member._fanim > 0 then continue end

        table.remove( self.members, i )
        self:InvalidateLayout()

    end

end

function COMPONENT:PaintBackground( x, y )

    for i=1, #self.members do

        self.members[ i ]:PaintBackground( x, y )

    end

    self.Count:PaintBackground( x, y )

    if not self.text_on_background then return end

    self.Text:Paint( x, y )

end

function COMPONENT:Paint( x, y )

    for i=1, #self.members do

        self.members[ i ]:Paint( x, y )

    end

    self.Plus:Paint( x, y )
    self.Count:Paint( x, y )

    if self.text_on_background then return end

    self.Text:Paint( x, y )

end

function COMPONENT:PaintScanlines( x, y )

    StartAlphaMultiplier( self.Blur:GetAmount() )
    self:Paint( x, y )
    EndAlphaMultiplier()

end

function COMPONENT:ApplySettings( settings, fonts )

    self:SetOutlined( settings.outlined )
    self:SetSize( settings.icon_size )
    self:SetInverted( settings.inverted )
    self:SetPos( settings.icon_pos.x, settings.icon_pos.y )
    self:SetSpacing( settings.spacing )
    self:SetPileMinimum( settings.pile_min )
    self:SetPilePos( settings.pile_pos.x, settings.pile_pos.y )
    self:SetPileSpacing( settings.pile_spacing )
    self:SetPileOddOffset( settings.pile_oddoffset )
    self:SetPileMaximum( settings.pile_max )
    self:SetColor( settings.color )
    self:SetFadeTime( .4 )
    self:SetFadeOffset( settings.fade_offset )
    self:SetFadeColor( settings.died_color )
    self:SetHighlightTime( .2 )
    self:SetHighlightOffset( settings.highlight_offset )
    self:SetHighlightColor( settings.highlight_color )
    self:SetDrawHealthBar( settings.healthbar )
    self:SetDrawHealthBarBackground( settings.healthbar_background )
    self:SetHealthBarPos( settings.healthbar_pos.x, settings.healthbar_pos.y )
    self:SetHealthBarSize( settings.healthbar_size.x, settings.healthbar_size.y )
    self:SetHealthBarStyle( settings.healthbar_style )
    self:SetHealthBarGrowDirection( settings.healthbar_growdirection )
    self:SetHealthColor( settings.healthbar_color )
    self:SetHealthColor2( settings.healthbar_color2 )
    self:SetDrawTextOnBackground( settings.text_on_background )

    local x, y = settings.pile_num_pos.x, settings.pile_num_pos.y

    local plus = self.Plus
    plus:SetFont( fonts.pile_num_font )
    plus:SetColor( settings.color )
    plus:PerformLayout( true )
    self:SetDrawPileNumber( settings.pile_num )

    local count = self.Count
    count:SetColor( settings.color )
    count:SetColor2( settings.color2 )
    count:SetFont( fonts.pile_num_font )
    count:SetRenderMode( settings.pile_num_rendermode )
    count:SetBackground( settings.pile_num_background )
    count:SetDigits( settings.pile_num_digits )
    count:SetAlign( settings.pile_num_align )
    count:PerformLayout( true )

    count:SetPos( x + plus.__w + 2, y )
    plus:SetPos( x, y + plus.__h / 2 - count.__h / 2 )

    local text = self.Text
    text:SetVisible( settings.text )
    text:SetPos( settings.text_pos.x, settings.text_pos.y )
    text:SetFont( fonts.text_font )
    text:SetText( settings.text_text )
    text:SetColor( settings.text_on_background and settings.color2 or settings.color )
    text:SetAlign( settings.text_align )
    self:SetDrawTextOnBackground( settings.text_on_background )
    
    self:InvalidateLayout()

end

HOLOHUD2.component.Register( "HudSquadStatus", COMPONENT )