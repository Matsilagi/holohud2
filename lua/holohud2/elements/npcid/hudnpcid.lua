local FrameTime = FrameTime
local Lerp = Lerp
local StartAlphaMultiplier = HOLOHUD2.render.StartAlphaMultiplier
local EndAlphaMultiplier = HOLOHUD2.render.EndAlphaMultiplier

local TOP       = 1
local BOTTOM    = 2
local POS       = { "Top", "Bottom" }

local ANCHOR_NAME       = 1
local ANCHOR_HEALTHBAR  = 2
local ANCHORS           = { "Name", "Health bar" }

local COMPONENT = {
    invalid_layout      = false,
    x                   = 0,
    y                   = 0,
    name_offset         = 0,
    name_align          = TEXT_ALIGN_CENTER,
    name_on_background  = false,
    healthbar_pos       = BOTTOM,
    healthbar_size      = { x = 32, y = 4 },
    healthbar_dynamic   = false,
    healthbar_margin    = 0,
    healthbar_lerp      = false,
    number_anchor       = ANCHOR_HEALTHBAR,
    number_offset       = 0,
    number_pos          = BOTTOM,
    number_align        = TEXT_ALIGN_CENTER,
    number_margin       = 0,
    number_spacing      = 0,
    number_lerp         = false,
    separator_offset    = 0,
    lerp_speed          = 12,
    name                = "",
    health              = 0,
    max_health          = 1,
    _health             = 0,
    _max_health         = 0,
    _lastnumsize        = 0,
    __w                 = 0,
    __h                 = 0
}

function COMPONENT:Init()

    self.Blur = HOLOHUD2.component.Create( "Blur" )
    self.Name = HOLOHUD2.component.Create( "Text" )
    self.HealthBar = HOLOHUD2.component.Create( "LayeredBar" )
    self.Number = HOLOHUD2.component.Create( "Number" )
    self.Number2 = HOLOHUD2.component.Create( "Number" )

    local separator = HOLOHUD2.component.Create( "Separator" )
    separator:SetDrawAsRectangle( true )
    self.Separator = separator

end

function COMPONENT:InvalidateLayout()

    self.invalid_layout = true

end

function COMPONENT:PerformLayout( force )

    if not force and not self.invalid_layout then return end

    self.Name:SetText( self.name )
    self.Name:SetAlign( self.name_align )
    self.HealthBar:SetSize( self.healthbar_size.x * ( self.healthbar_dynamic and ( .3 + .7 * math.min( self.max_health / 100, 1 ) ) or 1 ), self.healthbar_size.y )
    
    self.Name:PerformLayout( true )
    self.HealthBar:PerformLayout( true )
    self.Number:PerformLayout( true )
    self.Separator:PerformLayout( true )
    self.Number2:PerformLayout( true )

    -- calculate size first
    local w, h = 0, 0

    if self.Name.visible then
        
        w, h = self.Name.__w, self.Name.__h

    end

    local healthbarh = self.HealthBar.__h

    if self.HealthBar.visible then

        local dotline = self.HealthBar:GetDotLine()

        if self.Name.visible then h = h + self.healthbar_margin end

        if dotline.visible and self.health > self._max_health then
            
            healthbarh = healthbarh + dotline.size + 2

        end

        w, h = math.max( w, self.HealthBar.__w ), h + healthbarh

    end

    local nums = self.Number.visible or self.Number2.visible
    local numw, numh = 0, 0

    if nums then

        if self.Name.visible or self.HealthBar.visible then h = h + self.number_margin end

        if self.Number.visible then
        
            numw, numh = self.Number.__w, self.Number.__h
        
        end

        if self.Number2.visible then
        
            if self.Number.visible and self.Separator.visible then
                
                numw = numw + self.Separator.__w + self.number_spacing * 2

            end

            numw, numh = numw + self.Number2.__w, math.max( numh, self.Number2.__h )
        
        end

        w, h = math.max( w, numw ), h + numh

    end
    
    self.__w, self.__h = w, h

    -- position elements
    local name_y, healthbar_y, number_y = 0, 0, 0

    if self.HealthBar.visible then

        if self.healthbar_pos == TOP then

            name_y = healthbarh + self.healthbar_margin

        else

            healthbar_y = self.Name.__h + self.healthbar_margin

        end

    end

    if nums then

        local h = numh + self.number_margin

        if self.number_anchor == ANCHOR_NAME then

            if self.number_pos == TOP then

                number_y = name_y
                name_y = name_y + h

            else

                number_y = name_y + self.Name.__h + self.number_margin

            end

            if self.healthbar_pos == BOTTOM then

                healthbar_y = healthbar_y + h

            end

        else

            if self.number_pos == TOP then
                
                number_y = healthbar_y
                healthbar_y = healthbar_y + h

            else

                number_y = healthbar_y + healthbarh + self.number_margin

            end

            if self.healthbar_pos == TOP then

                name_y = name_y + h

            end

        end

    end

    self.Name:SetPos( self.x + self.name_offset + ( self.name_align == TEXT_ALIGN_CENTER and ( w / 2 ) or ( self.name_align == TEXT_ALIGN_RIGHT and w ) or 0 ), self.y + name_y )
    self.HealthBar:SetPos( self.x + w / 2 - self.HealthBar.__w / 2, self.y + healthbar_y )
    self.HealthBar:GetDotLine():SetPos( self.HealthBar.x, self.HealthBar.y + self.HealthBar.__h + 2 )

    local x = self.number_align == TEXT_ALIGN_CENTER and ( w / 2 - numw / 2 ) or ( self.number_align == TEXT_ALIGN_RIGHT and ( w - numw ) or 0 )
    local y = number_y + numh / 2
    self.Number:SetPos( self.x + self.number_offset + x, self.y + y - self.Number.__h / 2 )
    self.Separator:SetPos( self.Number.x + self.Number.__w + self.number_spacing, self.y + y - self.Separator.__h / 2 + self.separator_offset )
    self.Number2:SetPos( self.Number.visible and ( self.Separator.x + self.Separator.__w + self.number_spacing ) or self.Number.x, self.y + y - self.Number2.__h / 2 )
    self._lastnumsize = self.Number.__w

    self.invalid_layout = false

end

function COMPONENT:SetPos( x, y )

    if self.x == x and self.y == y then return end

    self.x = x
    self.y = y

    self:InvalidateLayout()

    return true

end

function COMPONENT:SetNameOffset( offset )

    if self.name_offset == offset then return end

    self.name_offset = offset

    self:InvalidateLayout()

    return true

end

function COMPONENT:SetNameAlign( align )

    if self.name_align == align then return end

    self.name_align = align

    self:InvalidateLayout()

    return true

end

function COMPONENT:SetDrawNameOnBackground( on_background )

    if self.name_on_background == on_background then return end

    self.name_on_background = on_background

    self:InvalidateLayout()

    return true

end

function COMPONENT:SetHealthBarPosition( pos )

    if self.healthbar_pos == pos then return end

    self.healthbar_pos = pos

    self:InvalidateLayout()

    return true

end

function COMPONENT:SetHealthBarSize( w, h )

    if self.healthbar_size.x == w and self.healthbar_size.y == h then return end

    self.healthbar_size.x = w
    self.healthbar_size.y = h

    self:InvalidateLayout()

    return true

end

function COMPONENT:SetHealthBarColor( color )

    self.HealthBar:SetColor( color )

end

function COMPONENT:SetHealthBarDynamic( dynamic )

    if self.healthbar_dynamic == dynamic then return end

    self.healthbar_dynamic = dynamic
    self._max_health = self:CalculateMaxHealth()

    self:InvalidateLayout()

    return true

end

function COMPONENT:SetHealthBarMargin( margin )

    if self.healthbar_margin == margin then return end

    self.healthbar_margin = margin

    self:InvalidateLayout()

    return true

end

function COMPONENT:SetHealthBarLerp( lerp )

    if self.healthbar_lerp == lerp then return end

    if not lerp then self.HealthBar:SetValue( self.health / self._max_health ) end

    self.healthbar_lerp = lerp

    self:InvalidateLayout()

    return true

end

function COMPONENT:SetNumberAnchor( anchor )

    if self.number_anchor == anchor then return end

    self.number_anchor = anchor

    self:InvalidateLayout()

    return true

end

function COMPONENT:SetNumberOffset( offset )

    if self.number_offset == offset then return end

    self.number_offset = offset

    self:InvalidateLayout()

    return true

end

function COMPONENT:SetNumberPos( pos )

    if self.number_pos == pos then return end

    self.number_pos = pos

    self:InvalidateLayout()

    return true

end

function COMPONENT:SetNumberAlign( align )

    if self.number_align == align then return end

    self.number_align = align

    self:InvalidateLayout()

    return true

end

function COMPONENT:SetNumberMargin( margin )

    if self.number_margin == margin then return end

    self.number_margin = margin

    self:InvalidateLayout()

    return true

end

function COMPONENT:SetNumberSpacing( spacing )

    if self.number_spacing == spacing then return end

    self.number_spacing = spacing

    self:InvalidateLayout()

    return true

end

function COMPONENT:SetNumberLerp( lerp )

    if self.number_lerp == lerp then return end

    if not lerp then self.Number:SetValue( self.health ) end

    self.number_lerp = lerp

    self:InvalidateLayout()

    return true

end

function COMPONENT:SetSeparatorOffset( offset )

    if self.separator_offset == offset then return end

    self.separator_offset = offset

    self:InvalidateLayout()

    return true

end

function COMPONENT:SetLerpSpeed( lerp_speed )

    self.lerp_speed = lerp_speed

end

function COMPONENT:SetName( name )

    if self.name == name then return end

    self.name = name

    self:InvalidateLayout()

    return true

end

function COMPONENT:SetHealth( health )

    if self.health == health then return end

    self.Blur:Activate()
    self.Number:SetValue( health )

    if not self.healthbar_lerp then
        
        self.HealthBar:SetValue( health / self._max_health )

        if ( self.health > self._max_health ) ~= ( health > self._max_health ) then
            
            self:InvalidateLayout()

        end

    end

    self.health = health

end

function COMPONENT:SetMaxHealth( max_health )

    if self.max_health == max_health then return end

    self.Number2:SetValue( max_health )

    self.max_health = max_health
    self._max_health = self:CalculateMaxHealth()

    if not self.healthbar_lerp then
        
        self.HealthBar:SetValue( self.health / self._max_health )

    end

end

function COMPONENT:CalculateMaxHealth()

    if self.max_health == 0 then return 1 end
    if not self.healthbar_dynamic then return self.max_health end

    local bars = self.max_health / 100
    
    return math.min( self.max_health, math.max( bars / math.floor( bars ), 1 ) * 100 )

end

function COMPONENT:GetSize()
    
    return self.__w, self.__h

end

function COMPONENT:Think()

    local prev = self._health

    self._health = Lerp( FrameTime() * self.lerp_speed, self._health, self.health )

    if self.number_lerp then self.Number:SetValue( math.Round( self._health ) ) end
    
    if self.healthbar_lerp then
        
        self.HealthBar:SetValue( self._health / self._max_health )

        if ( self._health > self._max_health ) ~= ( prev > self._max_health ) then
            
            self:InvalidateLayout()

        end

    end

    self.Blur:Think()
    self.Name:PerformLayout()
    self.HealthBar:Think()
    self.Number:PerformLayout()
    self.Separator:PerformLayout()
    self.Number2:PerformLayout()

    if self._lastnumsize ~= self.Number.__w then self:InvalidateLayout() end

    self:PerformLayout()

end

function COMPONENT:PaintBackground( x, y )

    if self.name_on_background then
        
        self.Name:Paint( x, y )

    end

    self.HealthBar:PaintBackground( x, y )
    self.Number:PaintBackground( x, y )
    self.Number2:PaintBackground( x, y )

end

function COMPONENT:Paint( x, y )

    if not self.name_on_background then
        
        self.Name:Paint( x, y )

    end

    self.HealthBar:Paint( x, y )
    self.Number:Paint( x, y )
    self.Separator:Paint( x, y )
    self.Number2:Paint( x, y )

end

function COMPONENT:PaintScanlines( x, y )
   
    StartAlphaMultiplier( self.Blur:GetAmount() )
    self:Paint( x, y )
    EndAlphaMultiplier()

end

function COMPONENT:ApplySettings( settings, fonts )

    self:SetPos( settings.padding, settings.padding )
    
    local name = self.Name
    name:SetVisible( settings.name )
    name:SetFont( fonts.name_font )
    name:SetColor( settings.name_color )
    self:SetNameAlign( settings.name_align )
    self:SetNameOffset( settings.name_offset )
    self:SetDrawNameOnBackground( settings.name_on_background )

    local healthbar = self.HealthBar
    healthbar:SetVisible( settings.healthbar )
    healthbar:SetLayered( settings.healthbar_layered )
    healthbar:SetGrowDirection( settings.healthbar_growdirection == TEXT_ALIGN_CENTER and HOLOHUD2.GROWDIRECTION_CENTER_HORIZONTAL or ( settings.healthbar_growdirection == TEXT_ALIGN_LEFT and HOLOHUD2.GROWDIRECTION_LEFT ) or HOLOHUD2.GROWDIRECTION_RIGHT )
    healthbar:SetStyle( settings.healthbar_style )
    healthbar:SetDrawBackground( settings.healthbar_background )
    healthbar:SetColor2( settings.healthbar_color2 )
    self:SetHealthBarPosition( settings.healthbar_pos )
    self:SetHealthBarSize( settings.healthbar_size.x, settings.healthbar_size.y )
    self:SetHealthBarDynamic( settings.healthbar_dynamic )
    self:SetHealthBarLerp( settings.healthbar_lerp )
    self:SetHealthBarMargin( settings.healthbar_margin )

    local dotline = healthbar:GetDotLine()
    dotline:SetSize( 4 )
    dotline:SetGrowDirection( HOLOHUD2.GROWDIRECTION_RIGHT )

    local num = self.Number
    num:SetVisible( settings.healthnums and settings.healthnum )
    num:SetColor( settings.healthnum_color )
    num:SetColor2( settings.healthnum_color2 )
    num:SetFont( fonts.healthnum_font )
    num:SetRenderMode( settings.healthnum_rendermode )
    num:SetBackground( settings.healthnum_background )
    num:SetAlign( settings.healthnum_align )
    num:SetDigits( settings.healthnum_digits )
    self:SetNumberAnchor( settings.healthnums_anchor )
    self:SetNumberPos( settings.healthnums_y )
    self:SetNumberAlign( settings.healthnums_x )
    self:SetNumberLerp( settings.healthnum_lerp )
    self:SetNumberMargin( settings.healthnums_margin )
    self:SetNumberSpacing( settings.healthnums_spacing )
    self:SetNumberOffset( settings.healthnums_offset )

    local separator = self.Separator
    separator:SetVisible( settings.healthnums and settings.healthnum and settings.healthnum2 and settings.healthnum_separator )
    separator:SetSize( settings.healthnum_separator_size.x, settings.healthnum_separator_size.y )
    separator:SetColor( settings.healthnum_color )
    self:SetSeparatorOffset( settings.healthnum_separator_offset )

    local num2 = self.Number2
    num2:SetVisible( settings.healthnums and settings.healthnum2 )
    num2:SetColor( settings.healthnum2_color )
    num2:SetColor2( settings.healthnum2_color2 )
    num2:SetFont( fonts.healthnum2_font )
    num2:SetRenderMode( settings.healthnum2_rendermode )
    num2:SetBackground( settings.healthnum2_background )
    num2:SetAlign( settings.healthnum2_align )
    num2:SetDigits( settings.healthnum2_digits )
    
    self:InvalidateLayout()

end

HOLOHUD2.component.Register( "HudNPCID", COMPONENT )

HOLOHUD2.NPCID_TOP                  = TOP
HOLOHUD2.NPCID_BOTTOM               = BOTTOM
HOLOHUD2.NPCID_POS                  = POS

HOLOHUD2.NPCID_ANCHOR_NAME          = ANCHOR_NAME
HOLOHUD2.NPCID_ANCHOR_HEALTHBAR     = ANCHOR_HEALTHBAR
HOLOHUD2.NPCID_ANCHORS              = ANCHORS