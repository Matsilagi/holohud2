local FrameTime = FrameTime
local Lerp = Lerp
local StartAlphaMultiplier = HOLOHUD2.render.StartAlphaMultiplier
local EndAlphaMultiplier = HOLOHUD2.render.EndAlphaMultiplier
local GetMinimumGlow = HOLOHUD2.render.GetMinimumGlow

local TOP       = 1
local BOTTOM    = 2
local POS       = { "Top", "Bottom" }

local ANCHOR_NAME       = 1
local ANCHOR_DETAILS    = 2
local ANCHORS           = { "Name", "Details" }

local COMPONENT = {
    invalid_layout          = false,
    x                       = 0,
    y                       = 0,
    align                   = TEXT_ALIGN_CENTER,
    name_on_background      = false,
    details_pos             = BOTTOM,
    details_margin         = 0,
    details_on_background   = true,
    healthbar_anchor        = ANCHOR_DETAILS,
    healthbar_pos           = BOTTOM,
    healthbar_margin       = 0,
    healthbar_lerp          = true,
    lerp_speed              = 12,
    name                    = "",
    details                 = "",
    health                  = 0,
    _health                 = 0,
    __w                     = 0,
    __h                     = 0
}

function COMPONENT:Init()

    self.Name = HOLOHUD2.component.Create( "Text" )
    self.Details = HOLOHUD2.component.Create( "Text" )
    self.HealthBarBackground = HOLOHUD2.component.Create( "Bar" )
    self.HealthBar = HOLOHUD2.component.Create( "ProgressBar" )

end

function COMPONENT:InvalidateLayout()

    self.invalid_layout = true

end

function COMPONENT:PerformLayout( force )

    if not self.invalid_layout and not force then return end

    self.Name:SetText( self.name )
    self.Name:SetAlign( self.align )

    self.Details:SetText( self.details )
    self.Details:SetAlign( self.align )

    self.Name:PerformLayout( true )
    self.Details:PerformLayout( true )
    self.HealthBarBackground:PerformLayout( true )

    -- calculate size first
    local w, h = 0, 0

    if self.Name.visible then

        w, h = self.Name.__w, self.Name.__h

    end

    if self.Details.visible then

        if self.Name.visible then h = h + self.details_margin end

        w, h = math.max( w, self.Details.__w ), h + self.Details.__h

    end

    if self.HealthBar.visible then
        
        if self.Name.visible or self.Details.visible then h = h + self.healthbar_margin end

        w, h = math.max( w, self.HealthBarBackground.__w ), h + self.HealthBarBackground.__h

    end

    self.__w, self.__h = w, h

    -- position elements
    local name_y, details_y, healthbar_y = 0, 0, 0

    if self.Details.visible then

        if self.details_pos == TOP then
            
            name_y = self.Details.__h + self.details_margin

        else

            details_y = self.Name.__h + self.details_margin

        end

    end

    if self.HealthBar.visible then

        local h = self.HealthBarBackground.__h + self.healthbar_margin

        if self.healthbar_anchor == ANCHOR_NAME then

            if self.healthbar_pos == TOP then

                healthbar_y = name_y
                name_y = name_y + h
            
            else

                healthbar_y = name_y + self.Name.__h + self.healthbar_margin

            end

            if self.details_pos == BOTTOM then

                details_y = details_y + h

            end

        else
        
            if self.healthbar_pos == TOP then

                healthbar_y = details_y
                details_y = details_y + h

            else

                healthbar_y = details_y + self.Details.__h + self.healthbar_margin

            end

            if self.details_pos == TOP then

                name_y = name_y + h

            end

        end

    end

    local x = ( self.align == TEXT_ALIGN_CENTER and ( w / 2 ) or ( self.align == TEXT_ALIGN_RIGHT and w ) or 0 )

    self.Name:SetPos( self.x + x, self.y + name_y )
    self.Details:SetPos( self.x + x, self.y + details_y )
    self.HealthBarBackground:SetPos( self.x + x - ( self.align == TEXT_ALIGN_CENTER and ( self.HealthBarBackground.__w / 2 ) or ( self.align == TEXT_ALIGN_RIGHT and self.HealthBarBackground.__w ) or 0 ), self.y + healthbar_y )
    self.HealthBar:Copy( self.HealthBarBackground )

    self.invalid_layout = false

end

function COMPONENT:SetPos( x, y )

    if self.x == x and self.y == y then return end

    self.x = x
    self.y = y

    self:InvalidateLayout()

end

function COMPONENT:SetAlign( align )

    if self.align == align then return end

    self.align = align

    self:InvalidateLayout()

end

function COMPONENT:SetDrawNameOnBackground( on_background )

    if self.name_on_background == on_background then return end

    self.name_on_background = on_background

    self:InvalidateLayout()

end

function COMPONENT:SetDetailsPosition( pos )

    if self.details_pos == pos then return end

    self.details_pos = pos

    self:InvalidateLayout()

end

function COMPONENT:SetDetailsMargin( margin )

    if self.details_margin == margin then return end

    self.details_margin = margin

    self:InvalidateLayout()

end

function COMPONENT:SetDrawDetailsOnBackground( on_background )

    if self.details_on_background == on_background then return end

    self.details_on_background = on_background

    self:InvalidateLayout()

end

function COMPONENT:SetHealthBarAnchor( anchor )

    if self.healthbar_anchor == anchor then return end

    self.healthbar_anchor = anchor

    self:InvalidateLayout()

end

function COMPONENT:SetHealthBarPos( pos )

    if self.healthbar_pos == pos then return end

    self.healthbar_pos = pos

    self:InvalidateLayout()

end

function COMPONENT:SetHealthBarMargin( margin )

    if self.healthbar_margin == margin then return end

    self.healthbar_margin = margin

    self:InvalidateLayout()

end

function COMPONENT:SetHealthBarLerp( lerp )

    if self.healthbar_lerp == lerp then return end

    if not lerp then
        
        self.HealthBar:SetValue( self.health )

    end

    self.healthbar_lerp = lerp

end

function COMPONENT:SetName( name )

    if self.name == name then return end

    self.name = name

    self:InvalidateLayout()

end

function COMPONENT:SetDetails( details )

    if self.details == details then return end

    self.details = details

    self:InvalidateLayout()

end

function COMPONENT:SetHealth( health )
    
    if self.health == health then return end

    if not self.healthbar_lerp then self.HealthBar:SetValue( self.health ) end

    self.health = health

end

function COMPONENT:GetSize()

    return self.__w, self.__h

end

function COMPONENT:Think()

    self._health = Lerp( FrameTime() * self.lerp_speed, self._health, self.health )

    if self.healthbar_lerp then self.HealthBar:SetValue( self._health ) end
    
    self.Name:PerformLayout()
    self.Details:PerformLayout()
    self.HealthBarBackground:PerformLayout()
    self.HealthBar:Think()
    self:PerformLayout()

end

function COMPONENT:PaintBackground( x, y )

    if self.name_on_background then
        
        self.Name:Paint( x, y )

    end

    if self.details_on_background then

        self.Details:Paint( x, y )

    end

    self.HealthBarBackground:Paint( x, y )

end

function COMPONENT:Paint( x, y )

    if not self.name_on_background then
        
        self.Name:Paint( x, y )

    end

    if not self.details_on_background then

        self.Details:Paint( x, y )

    end

    self.HealthBar:Paint( x, y )

end

function COMPONENT:PaintScanlines( x, y )
   
    StartAlphaMultiplier( GetMinimumGlow() )
    self:Paint( x, y )
    EndAlphaMultiplier()

end

function COMPONENT:ApplySettings( settings, fonts )
    
    self:SetPos( settings.padding, settings.padding )
    self:SetAlign( settings.align )

    self.Name:SetVisible( settings.name )
    self.Name:SetFont( fonts.name_font )
    self.Name:SetColor( settings.name_color )
    self:SetDrawNameOnBackground( settings.name_on_background )

    self:SetDetailsPosition( settings.details_pos )
    self:SetDetailsMargin( settings.details_margin )
    self.Details:SetFont( fonts.details_font )
    self.Details:SetColor( settings.details_color )
    self:SetDrawDetailsOnBackground( settings.details_on_background )

    self:SetHealthBarAnchor( settings.healthbar_anchor )
    self:SetHealthBarPos( settings.healthbar_pos )
    self:SetHealthBarMargin( settings.healthbar_margin )

    local healthbarbackground = self.HealthBarBackground
    healthbarbackground:SetSize( settings.healthbar_size.x, settings.healthbar_size.y )
    healthbarbackground:SetStyle( settings.healthbar_style )
    healthbarbackground:SetColor( settings.healthbar_color2 )

    local healthbar = self.HealthBar
    healthbar:Copy( healthbarbackground )
    healthbar:SetGrowDirection( settings.healthbar_growdirection == TEXT_ALIGN_CENTER and HOLOHUD2.GROWDIRECTION_CENTER_HORIZONTAL or ( settings.healthbar_growdirection == TEXT_ALIGN_LEFT and HOLOHUD2.GROWDIRECTION_LEFT ) or HOLOHUD2.GROWDIRECTION_RIGHT )
    healthbar:SetColor( settings.healthbar_color )

    self:SetHealthBarLerp( settings.healthbar_lerp )
    
    self:InvalidateLayout()

end

HOLOHUD2.component.Register( "HudEntityID", COMPONENT )

HOLOHUD2.ENTID_TOP      = TOP
HOLOHUD2.ENTID_BOTTOM   = BOTTOM
HOLOHUD2.ENTID_POS      = POS

HOLOHUD2.ENTID_ANCHOR_NAME      = ANCHOR_NAME
HOLOHUD2.ENTID_ANCHOR_DETAILS   = ANCHOR_DETAILS
HOLOHUD2.ENTID_ANCHORS          = ANCHORS