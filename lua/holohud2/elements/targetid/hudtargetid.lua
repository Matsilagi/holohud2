local FrameTime = FrameTime
local Lerp = Lerp
local StartAlphaMultiplier = HOLOHUD2.render.StartAlphaMultiplier
local EndAlphaMultiplier = HOLOHUD2.render.EndAlphaMultiplier

local TOP       = 1
local BOTTOM    = 2
local POS       = { "Top", "Bottom" }

local ANCHOR_NAME       = 1
local ANCHOR_HEALTHBAR  = 2
local ANCHORS           = { "Name", "Percentage bars" }

local COMPONENT = {
    invalid_layout          = false,
    x                       = 0,
    y                       = 0,
    name_align              = TEXT_ALIGN_CENTER,
    name_offset             = 0,
    name_on_background      = false,
    team_pos                = BOTTOM,
    team_margin             = 0,
    team_align              = TEXT_ALIGN_CENTER,
    team_offset             = 0,
    team_on_background      = true,
    progressbars_pos        = BOTTOM,
    progressbars_margin     = 0,
    progressbars_spacing    = 0,
    armorbar_visible        = true,
    healthbar_lerp          = true,
    armorbar_lerp           = true,
    numbers_anchor          = ANCHOR_NAME,
    numbers_pos             = BOTTOM,
    numbers_margin          = 0,
    numbers_align           = TEXT_ALIGN_CENTER,
    numbers_offset          = 0,
    numbers_spacing         = 0,
    healthnum_offset        = 0,
    healthicon_spacing      = 0,
    armornum_offset         = 0,
    armoricon_visible       = true,
    armoricon_spacing       = 0,
    healthnum_lerp          = false,
    armornum_lerp           = false,
    lerp_speed              = 12,
    name                    = "",
    team                    = "",
    health                  = 0,
    max_health              = 1,
    armor                   = 0,
    max_armor               = 1,
    _health                 = 0,
    _armor                  = 0,
    _lasthealthnumsize      = 0,
    _lastarmornumsize       = 0,
    __w                     = 0,
    __h                     = 0
}

function COMPONENT:Init()

    self.Blur = HOLOHUD2.component.Create( "Blur" )

    self.HealthColors = HOLOHUD2.component.Create( "ColorRanges" )
    self.HealthColors2 = HOLOHUD2.component.Create( "ColorRanges" )

    local healthcolor, healthcolor2 = self.HealthColors:GetColor(), self.HealthColors2:GetColor()

    self.ArmorColors = HOLOHUD2.component.Create( "ColorRanges" )
    self.ArmorColors2 = HOLOHUD2.component.Create( "ColorRanges" )

    local armorcolor, armorcolor2 = self.ArmorColors:GetColor(), self.ArmorColors2:GetColor()

    self.Name = HOLOHUD2.component.Create( "Text" )
    self.Team = HOLOHUD2.component.Create( "Text" )

    local healthbar = HOLOHUD2.component.Create( "LayeredBar" )
    healthbar:SetColor( healthcolor )
    healthbar:SetColor2( healthcolor2 )
    self.HealthBar = healthbar

    local armorbar = HOLOHUD2.component.Create( "LayeredBar" )
    armorbar:SetColor( armorcolor )
    armorbar:SetColor2( armorcolor2 )
    self.ArmorBar = armorbar

    local healthicon = HOLOHUD2.component.Create( "Icon" )
    healthicon:SetColor( healthcolor )
    self.HealthIcon = healthicon

    local healthnum = HOLOHUD2.component.Create( "Number" )
    healthnum:SetColor( healthcolor )
    healthnum:SetColor2( healthcolor2 )
    self.HealthNumber = healthnum

    local armoricon = HOLOHUD2.component.Create( "Icon" )
    armoricon:SetColor( armorcolor )
    self.ArmorIcon = armoricon

    local armornum = HOLOHUD2.component.Create( "Number" )
    armornum:SetColor( armorcolor )
    armornum:SetColor2( armorcolor2 )
    self.ArmorNumber = armornum

end

function COMPONENT:InvalidateLayout()

    self.invalid_layout = true

end

function COMPONENT:PerformLayout( force )
    
    if not force and not self.invalid_layout then return end

    self.Name:SetText( self.name )
    self.Name:SetAlign( self.name_align )

    self.Team:SetText( self.team )
    self.Team:SetAlign( self.team_align )

    self.Name:PerformLayout( true )
    self.Team:PerformLayout( true )
    self.HealthBar:Think()
    self.ArmorBar:Think()
    self.HealthIcon:PerformLayout( true )
    self.HealthNumber:PerformLayout( true )
    self.ArmorIcon:PerformLayout( true )
    self.ArmorNumber:PerformLayout( true )

    -- calculate size first
    local w, h = 0, 0

    local nameh = 0

    if self.Name.visible then
        
        w, nameh = self.Name.__w, self.Name.__h

    end

    if self.Team.visible then

        if self.Name.visible then nameh = nameh + self.team_margin end

        w, nameh = math.max( w, self.Team.__w ), nameh + self.Team.__h

    end

    h = nameh

    local progressbarsh = 0
    local healthbarh, armorbarh = self.HealthBar.__h, self.ArmorBar.__h

    if self.HealthBar.visible then

        local dotline = self.HealthBar:GetDotLine()

        if dotline.visible and self.health > self.max_health then

            healthbarh = healthbarh + dotline.size + 2

        end

        progressbarsh = healthbarh
        w = math.max( w, self.HealthBar.__w )

    end

    if self.ArmorBar.visible then

        local dotline = self.ArmorBar:GetDotLine()

        if dotline.visible and self.armor > self.max_armor then

            armorbarh = armorbarh + dotline.size + 2

        end

        progressbarsh = progressbarsh + armorbarh
        w = math.max( w, self.ArmorBar.__w )

    end

    if ( self.Name or self.Team ) and ( self.HealthBar.visible or self.ArmorBar.visible ) then

        progressbarsh = progressbarsh + self.progressbars_margin

    end

    h = h + progressbarsh

    local numw, numh = 0, 0

    if self.HealthNumber.visible then

        if self.HealthIcon.visible then

            numw, numh = self.HealthIcon.__w + self.healthicon_spacing, self.HealthIcon.__h

        end
        
        numw, numh = numw + self.HealthNumber.__w, math.max( numh, self.HealthNumber.__h )
        
    end

    if self.ArmorNumber.visible then

        if self.HealthNumber.visible then numw = numw + self.numbers_spacing end
        
        if self.ArmorIcon.visible then

            numw, numh = numw + self.ArmorIcon.__w + self.armoricon_spacing, math.max( numh, self.ArmorIcon.__h )
            
        end

        numw, numh = numw + self.ArmorNumber.__w, math.max( numh, self.ArmorNumber.__h )

    end

    if ( self.Name.visible or self.Team.visible or self.HealthBar.visible or self.ArmorBar.visible ) and ( self.HealthNumber.visible or self.ArmorNumber.visible ) then

        h = h + self.numbers_margin

    end

    w, h = math.max( w, numw ), h + numh
    
    self.__w, self.__h = w, h

    -- position elements
    local name_y, team_y, progressbars_y, numbers_y = 0, 0, 0, 0

    if self.HealthBar.visible or self.ArmorBar.visible then

        if self.progressbars_pos == TOP then
            
            name_y = progressbarsh

        else

            progressbars_y = name_y + nameh + self.progressbars_margin

        end

    end

    if self.HealthNumber.visible or self.ArmorNumber.visible then

        local h = numh + self.numbers_margin

        if self.numbers_anchor == ANCHOR_NAME then
            
            if self.numbers_pos == TOP then

                numbers_y = name_y
                name_y = name_y + h

            else

                numbers_y = name_y + nameh + self.numbers_margin

            end

            if self.progressbars_pos == BOTTOM then

                progressbars_y = progressbars_y + h

            end

        else

            if self.numbers_pos == TOP then

                numbers_y = progressbars_y
                progressbars_y = progressbars_y + h

            else

                numbers_y = progressbars_y + progressbarsh + self.numbers_margin

            end

            if self.progressbars_pos == TOP then

                name_y = name_y + h

            end

        end

    end

    if self.Team.visible then

        if self.team_pos == TOP then

            name_y = name_y + self.Team.__h + self.team_margin

        else

            team_y = name_y + self.Name.__h + self.team_margin

        end

    end

    self.Name:SetPos( self.x + self.name_offset + ( self.name_align == TEXT_ALIGN_CENTER and ( w / 2 ) or ( self.name_align == TEXT_ALIGN_RIGHT and w ) or 0 ), self.y + name_y )
    self.Team:SetPos( self.x + self.team_offset + ( self.team_align == TEXT_ALIGN_CENTER and ( w / 2 ) or ( self.team_align == TEXT_ALIGN_RIGHT and w ) or 0 ), self.y + team_y )

    local dotline = self.HealthBar:GetDotLine()
    dotline:SetPos( dotline.x, self.y + progressbars_y )

    if dotline.visible and self.health > self.max_health then
        
        progressbars_y = progressbars_y + dotline.size + 2

    end

    self.HealthBar:SetPos( self.x + w / 2 - self.HealthBar.__w / 2, self.y + progressbars_y )
    dotline:SetPos( self.HealthBar.x, dotline.y )

    self.ArmorBar:SetPos( self.x + w / 2 - self.ArmorBar.__w / 2, self.y + progressbars_y + self.HealthBar.__h + 2 )
    self.ArmorBar:GetDotLine():SetPos( self.ArmorBar.x, self.ArmorBar.y + self.ArmorBar.__h + 2 )
    
    local x = self.numbers_align == TEXT_ALIGN_CENTER and ( w / 2 - numw / 2 ) or ( self.numbers_align == TEXT_ALIGN_RIGHT and ( w - numw ) or 0 )
    local y = numbers_y + numh / 2
    self.HealthIcon:SetPos( self.x + self.numbers_offset + x, self.y + y - self.HealthIcon.__h / 2 )
    self.HealthNumber:SetPos( self.HealthIcon.x + self.HealthIcon.__w + self.healthicon_spacing, self.y + y - self.HealthNumber.__h / 2 + self.healthnum_offset )
    self.ArmorIcon:SetPos( self.HealthNumber.x + self.HealthNumber.__w + self.numbers_spacing, self.y + y - self.ArmorIcon.__h / 2 )
    self.ArmorNumber:SetPos( self.ArmorIcon.x + self.ArmorIcon.__w + self.armoricon_spacing, self.y + y - self.ArmorNumber.__h / 2 + self.armornum_offset )

    self._lasthealthnumsize = self.HealthNumber.__w
    self._lastarmornumsize = self.ArmorNumber.__w

    self.invalid_layout = false

end

function COMPONENT:SetPos( x, y )

    if self.x == x and self.y == y then return end

    self.x = x
    self.y = y

    self:InvalidateLayout()

    return true

end

function COMPONENT:SetNameAlign( align )

    if self.name_align == align then return end

    self.name_align = align

    self:InvalidateLayout()

    return true

end

function COMPONENT:SetNameOffset( offset )

    if self.name_offset == offset then return end

    self.name_offset = offset

    self:InvalidateLayout()

    return true

end

function COMPONENT:SetDrawNameOnBackground( on_background )

    if self.name_on_background == on_background then return end

    self.name_on_background = on_background

    self:InvalidateLayout()

    return true

end

function COMPONENT:SetTeamPos( pos )

    if self.team_pos == pos then return end

    self.team_pos = pos

    self:InvalidateLayout()

    return true

end

function COMPONENT:SetTeamMargin( margin )

    if self.team_margin == margin then return end

    self.team_margin = margin

    self:InvalidateLayout()

    return true

end

function COMPONENT:SetTeamAlign( align )

    if self.team_align == align then return end

    self.team_align = align

    self:InvalidateLayout()

    return true

end

function COMPONENT:SetTeamOffset( offset )

    if self.team_offset == offset then return end

    self.team_offset = offset

    self:InvalidateLayout()

    return true

end

function COMPONENT:SetDrawTeamOnBackground( on_background )

    if self.team_on_background == on_background then return end

    self.team_on_background = on_background

    self:InvalidateLayout()

    return true

end

function COMPONENT:SetProgressBarsPos( pos )

    if self.progressbars_pos == pos then return end

    self.progressbars_pos = pos

    self:InvalidateLayout()

    return true

end

function COMPONENT:SetProgressBarsMargin( margin )

    if self.progressbars_margin == margin then return end

    self.progressbars_margin = margin

    self:InvalidateLayout()

    return true

end

function COMPONENT:SetProgressBarsSpacing( spacing )

    if self.progressbars_spacing == spacing then return end

    self.progressbars_spacing = spacing

    self:InvalidateLayout()

    return true

end

function COMPONENT:SetHealthBarLerp( lerp )

    if self.healthbar_lerp == lerp then return end

    if not lerp then self.HealthBar:SetValue( self.health / self.max_health ) end

    self.healthbar_lerp = lerp

    self:InvalidateLayout()

    return true

end

function COMPONENT:SetArmorBarLerp( lerp )

    if self.armorbar_lerp == lerp then return end

    if not lerp then self.ArmorBar:SetValue( self.armor / self.max_armor ) end

    self.armorbar_lerp = lerp

    self:InvalidateLayout()

    return true

end

function COMPONENT:SetNumbersAnchor( anchor )

    if self.numbers_anchor == anchor then return end

    self.numbers_anchor = anchor

    self:InvalidateLayout()

    return true

end

function COMPONENT:SetNumbersPos( pos )

    if self.numbers_pos == pos then return end

    self.numbers_pos = pos

    self:InvalidateLayout()

    return true

end

function COMPONENT:SetNumbersMargin( margin )

    if self.numbers_margin == margin then return end

    self.numbers_margin = margin

    self:InvalidateLayout()

    return true

end

function COMPONENT:SetNumbersAlign( align )

    if self.numbers_align == align then return end

    self.numbers_align = align

    self:InvalidateLayout()

    return true

end

function COMPONENT:SetNumbersOffset( offset )

    if self.numbers_offset == offset then return end

    self.numbers_offset = offset

    self:InvalidateLayout()

    return true

end

function COMPONENT:SetNumbersSpacing( spacing )

    if self.numbers_spacing == spacing then return end

    self.numbers_spacing = spacing

    self:InvalidateLayout()

    return true

end

function COMPONENT:SetHealthNumberOffset( offset )

    if self.healthnum_offset == offset then return end

    self.healthnum_offset = offset

    self:InvalidateLayout()

    return true

end

function COMPONENT:SetHealthIconSpacing( spacing )

    if self.healthicon_spacing == spacing then return end

    self.healthicon_spacing = spacing

    self:InvalidateLayout()

    return true

end

function COMPONENT:SetDrawArmorNumber( visible )

    if self.armornum_visible == visible then return end

    self.armornum_visible = visible

    self:InvalidateLayout()

    return true

end

function COMPONENT:SetArmorNumberOffset( offset )

    if self.armornum_offset == offset then return end

    self.armornum_offset = offset

    self:InvalidateLayout()

    return true

end

function COMPONENT:SetDrawArmorBar( visible )

    if self.armorbar_visible == visible then return end

    self.armorbar_visible = visible

    self:InvalidateLayout()

    return true

end

function COMPONENT:SetArmorIconSpacing( spacing )

    if self.armoricon_spacing == spacing then return end

    self.armoricon_spacing = spacing

    self:InvalidateLayout()

    return true

end

function COMPONENT:SetHealthNumberLerp( lerp )

    if self.healthnum_lerp == lerp then return end

    if not lerp then self.HealthNumber:SetValue( self.health ) end

    self.healthnum_lerp = lerp

    self:InvalidateLayout()

    return true

end

function COMPONENT:SetArmorNumberLerp( lerp )

    if self.armornum_lerp == lerp then return end

    if not lerp then self.ArmorNumber:SetValue( self.armor ) end

    self.armornum_lerp = lerp

    self:InvalidateLayout()

    return true

end

function COMPONENT:SetName( name )

    if self.name == name then return end

    self.name = name

    self:InvalidateLayout()

    return true

end

function COMPONENT:SetTeam( team )

    if self.team == team then return end

    self.team = team

    self:InvalidateLayout()

    return true

end

function COMPONENT:SetHealth( health )

    if self.health == health then return end

    if ( health > self.max_health ) ~= ( self.health > self.max_health ) then

        self:InvalidateLayout()

    end

    self.HealthColors:SetValue( health )
    self.HealthColors2:SetValue( health )

    if not self.healthnum_lerp then self.HealthNumber:SetValue( health ) end
    if not self.healthbar_lerp then self.HealthBar:SetValue( health / self.max_health ) end

    self.health = health

    return true

end

function COMPONENT:SetMaxHealth( max_health )

    if self.max_health == max_health then return end

    if ( self.health > self.max_health ) ~= ( self.health > max_health ) then

        self:InvalidateLayout()

    end

    self.HealthColors:SetMaxValue( max_health )
    self.HealthColors2:SetMaxValue( max_health )

    if not self.healthbar_lerp then self.HealthBar:SetValue( self.health / max_health ) end

    self.max_health = max_health

    return true

end

function COMPONENT:SetArmor( armor )

    if self.armor == armor then return end

    if ( self.armor > 0 ) ~= ( armor > 0 ) then
        
        self.ArmorNumber:SetVisible( self.armornum_visible and armor > 0 )
        self.ArmorIcon:SetVisible( self.armornum_visible and armor > 0 )
        self.ArmorBar:SetVisible( self.armorbar_visible and armor > 0 )

        self:InvalidateLayout()

    end

    if ( armor > self.max_armor ) ~= ( self.armor > self.max_armor ) then

        self:InvalidateLayout()

    end

    self.ArmorColors:SetValue( armor )
    self.ArmorColors2:SetValue( armor )

    if not self.armornum_lerp then self.ArmorNumber:SetValue( armor ) end
    if not self.armorbar_lerp then self.ArmorBar:SetValue( armor / self.max_armor ) end

    self.armor = armor

    return true

end

function COMPONENT:SetMaxArmor( max_armor )

    if self.max_armor == max_armor then return end

    self.ArmorColors:SetMaxValue( max_armor )
    self.ArmorColors2:SetMaxValue( max_armor )

    if not self.armorbar_lerp then self.ArmorBar:SetValue( self.armor / max_armor ) end

    self.max_armor = max_armor

    return true

end

function COMPONENT:GetSize()

    return self.__w, self.__h

end

function COMPONENT:Think()

    local frametime = FrameTime()

    self._health = Lerp( frametime * self.lerp_speed, self._health, self.health )
    self._armor = Lerp( frametime * self.lerp_speed, self._armor, self.armor )

    if self.healthbar_lerp then self.HealthBar:SetValue( self._health / self.max_health ) end
    if self.armorbar_lerp then self.ArmorBar:SetValue( self._armor / self.max_armor ) end
    if self.healthnum_lerp then self.HealthNumber:SetValue( math.max( math.Round( self._health ), 0 ) ) end
    if self.armornum_lerp then self.ArmorNumber:SetValue( math.max( math.Round( self._armor ), 0 ) ) end

    self.Blur:Think()
    self.HealthColors:Think()
    self.HealthColors2:Think()
    self.ArmorColors:Think()
    self.ArmorColors2:Think()
    self.Name:PerformLayout()
    self.Team:PerformLayout()
    self.HealthBar:Think()
    self.ArmorBar:Think()
    self.HealthIcon:PerformLayout()
    self.HealthNumber:PerformLayout()
    self.ArmorIcon:PerformLayout()
    self.ArmorNumber:PerformLayout()

    if self.HealthNumber.__w ~= self._lasthealthnumsize then

        self:InvalidateLayout()

    end

    if self.ArmorNumber.__w ~= self._lastarmornumsize then

        self:InvalidateLayout()

    end

    self:PerformLayout()

end

function COMPONENT:PaintBackground( x, y )

    if self.name_on_background then self.Name:Paint( x, y ) end
    if self.team_on_background then self.Team:Paint( x, y ) end

    self.HealthBar:PaintBackground( x, y )
    self.ArmorBar:PaintBackground( x, y )
    self.HealthNumber:PaintBackground( x, y )
    self.ArmorNumber:PaintBackground( x, y )

end

function COMPONENT:Paint( x, y )

    if not self.name_on_background then self.Name:Paint( x, y ) end
    if not self.team_on_background then self.Team:Paint( x, y ) end

    self.HealthBar:Paint( x, y )
    self.ArmorBar:Paint( x, y )
    self.HealthIcon:Paint( x, y )
    self.HealthNumber:Paint( x, y )
    self.ArmorIcon:Paint( x, y )
    self.ArmorNumber:Paint( x, y )

end

function COMPONENT:PaintScanlines( x, y )

    StartAlphaMultiplier( self.Blur:GetAmount() )
    self:Paint( x, y )
    EndAlphaMultiplier()

end

function COMPONENT:ApplySettings( settings, fonts )

    self.HealthColors:SetColors( settings.health_color )
    self.HealthColors2:SetColors( settings.health_color2 )
    self.ArmorColors:SetColors( settings.suit_color )
    self.ArmorColors2:SetColors( settings.suit_color2 )

    self:SetPos( settings.padding + 2, settings.padding )

    local name = self.Name
    name:SetVisible( settings.name )
    name:SetFont( fonts.name_font )
    name:SetColor( settings.name_color )
    self:SetNameAlign( settings.name_align )
    self:SetNameOffset( settings.name_offset )
    self:SetDrawNameOnBackground( settings.name_on_background )

    local team = self.Team
    team:SetVisible( settings.team )
    team:SetFont( fonts.team_font )
    team:SetColor( settings.team_color )
    self:SetTeamPos( settings.team_pos )
    self:SetTeamMargin( settings.team_margin ) 
    self:SetTeamAlign( settings.team_align )
    self:SetTeamOffset( settings.team_offset )
    self:SetDrawTeamOnBackground( settings.team_on_background )

    local healthbar = self.HealthBar
    healthbar:SetVisible( settings.progressbars and settings.healthbar )
    healthbar:SetSize( settings.healthbar_size.x, settings.healthbar_size.y )
    healthbar:SetStyle( settings.healthbar_style )
    healthbar:SetDrawBackground( settings.healthbar_background )
    healthbar:SetLayered( settings.healthbar_layered )
    self:SetHealthBarLerp( settings.healthbar_lerp )

    local dotline = healthbar:GetDotLine()
    dotline:SetVisible( settings.healthbar_dotline )
    dotline:SetSize( settings.healthbar_dotline_size )
    dotline:SetGrowDirection( HOLOHUD2.GROWDIRECTION_RIGHT )

    local armorbar = self.ArmorBar
    armorbar:SetVisible( settings.progressbars and settings.suitbar and self.armor > 0 )
    armorbar:SetSize( settings.suitbar_size.x, settings.suitbar_size.y )
    armorbar:SetStyle( settings.suitbar_style )
    armorbar:SetDrawBackground( settings.suitbar_background )
    armorbar:SetLayered( settings.suitbar_layered )
    self:SetArmorBarLerp( settings.suitbar_lerp )
    self:SetDrawArmorBar( settings.progressbars and settings.suitbar )

    local dotline = armorbar:GetDotLine()
    dotline:SetVisible( settings.suitbar_dotline )
    dotline:SetSize( settings.suitbar_dotline_size )
    dotline:SetGrowDirection( HOLOHUD2.GROWDIRECTION_RIGHT )

    self:SetProgressBarsPos( settings.progressbars_pos )
    self:SetProgressBarsMargin( settings.progressbars_margin )
    self:SetProgressBarsSpacing( settings.progressbars_spacing )

    local healthicon = self.HealthIcon
    healthicon:SetVisible( settings.numbers and settings.healthnum and settings.healthicon )
    healthicon:SetSize( settings.healthicon_size )
    healthicon:SetTexture( HOLOHUD2.RESOURCE_HEALTH[ settings.healthicon_style ] )
    self:SetHealthIconSpacing( settings.healthicon_spacing )

    local healthnum = self.HealthNumber
    healthnum:SetVisible( settings.numbers and settings.healthnum )
    healthnum:SetFont( fonts.healthnum_font )
    healthnum:SetRenderMode( settings.healthnum_rendermode )
    healthnum:SetBackground( settings.healthnum_background )
    healthnum:SetAlign( settings.healthnum_align )
    healthnum:SetDigits( settings.healthnum_digits )
    self:SetHealthNumberLerp( settings.healthnum_lerp )
    self:SetHealthNumberOffset( settings.healthnum_offset )

    local armoricon = self.ArmorIcon
    armoricon:SetVisible( settings.numbers and settings.suitnum and settings.suiticon and self.armor > 0 )
    armoricon:SetSize( settings.suiticon_size )
    armoricon:SetTexture( HOLOHUD2.RESOURCE_SUITBATTERY[ settings.suiticon_style ] )
    self:SetArmorIconSpacing( settings.suiticon_spacing )

    local armornum = self.ArmorNumber
    armornum:SetVisible( settings.numbers and settings.suitnum and self.armor > 0 )
    armornum:SetFont( fonts.suitnum_font )
    armornum:SetRenderMode( settings.suitnum_rendermode )
    armornum:SetBackground( settings.suitnum_background )
    armornum:SetAlign( settings.suitnum_align )
    armornum:SetDigits( settings.suitnum_digits )
    self:SetArmorNumberLerp( settings.suitnum_lerp )
    self:SetArmorNumberOffset( settings.suitnum_offset )
    self:SetDrawArmorNumber( settings.numbers and settings.suitnum )

    self:SetNumbersAlign( settings.numbers_align )
    self:SetNumbersAnchor( settings.numbers_anchor )
    self:SetNumbersMargin( settings.numbers_margin )
    self:SetNumbersOffset( settings.numbers_offset )
    self:SetNumbersPos( settings.numbers_pos )
    self:SetNumbersSpacing( settings.numbers_spacing )
    
    self:InvalidateLayout()

end

HOLOHUD2.component.Register( "HudTargetID", COMPONENT )

HOLOHUD2.TARGETID_TOP               = TOP
HOLOHUD2.TARGETID_BOTTOM            = BOTTOM
HOLOHUD2.TARGETID_POS               = POS

HOLOHUD2.TARGETID_ANCHOR_NAME       = ANCHOR_NAME
HOLOHUD2.TARGETID_ANCHOR_HEALTHBAR  = ANCHOR_HEALTHBAR
HOLOHUD2.TARGETID_ANCHORS           = ANCHORS