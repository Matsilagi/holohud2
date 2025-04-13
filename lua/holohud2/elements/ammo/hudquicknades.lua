local TEXTURE_QUICKNADE = surface.GetTextureID( "holohud2/quicknades/quicknade" )
local TEXTURE_FRAG      = surface.GetTextureID( "holohud2/quicknades/frag" )

local COMPONENT = {
    invalid_layout  = false,
    visible         = true,
    x               = 0,
    y               = 0,
    num_x           = 0,
    num_y           = 0,
    __w             = 0,
    __h             = 0
}

function COMPONENT:Init()

    self.Icon = HOLOHUD2.component.Create( "Icon" )
    self.Number = HOLOHUD2.component.Create( "Number" )

end

function COMPONENT:InvalidateLayout()

    self.invalid_layout = true

end

function COMPONENT:PerformLayout( force )

    if ( not self.visible or not self.invalid_layout ) and not force then return end

    self.Icon:PerformLayout( true )
    self.Number:PerformLayout( true )

    local h = math.max( self.Icon.__h, self.Number.__h )

    self.Icon:SetPos( self.x, self.y + h / 2 - self.Icon.__h / 2 )
    self.Number:SetPos( self.x + self.num_x + self.Icon.__w + 2, self.y + self.num_y + h / 2 - self.Number.__h / 2 )

    self.__w, self.__h = self.Icon.__w + self.Number.__w + 2, h
    self.invalid_layout = false

end

function COMPONENT:Think()

    self:PerformLayout()
    self.Icon:PerformLayout()
    self.Number:PerformLayout()

end

function COMPONENT:SetVisible( visible )

    self.visible = visible

end

function COMPONENT:SetPos( x, y )

    if self.x == x and self.y == y then return end

    self.x = x
    self.y = y

    self:InvalidateLayout()

end

function COMPONENT:SetNumberOffset( x, y )

    if self.num_x == x and self.num_y == y then return end

    self.num_x = x
    self.num_y = y

    self:InvalidateLayout()

end

function COMPONENT:SetAmount( amount )

    if self.Number.value == amount then return end

    self.Number:SetValue( amount )
    self:InvalidateLayout()

end

function COMPONENT:SetColor( color )

    self.Icon:SetColor( color )
    self.Number:SetColor( color )

end

function COMPONENT:SetColor2( color2 )

    self.Number:SetColor2( color2 )

end

function COMPONENT:PaintBackground( x, y )

    if not self.visible then return end

    self.Number:PaintBackground( x, y )

end

function COMPONENT:Paint( x, y )

    if not self.visible then return end

    self.Icon:Paint( x, y )
    self.Number:Paint( x, y )

end

function COMPONENT:ApplySettings( settings, fonts )

    self:SetVisible( settings.quicknades )
    self:SetNumberOffset( settings.quicknades_num_offset.x, settings.quicknades_num_offset.y )
    
    if settings.quicknades_separate then
        
        self:SetPos( settings.quicknades_separate_padding.x, settings.quicknades_separate_padding.y )

    else

        self:SetPos( settings.quicknades_pos.x, settings.quicknades_pos.y )

    end

    local icon = self.Icon
    icon:SetSize( settings.quicknades_icon_size )
    icon:SetTexture( settings.quicknades_icon_alt and TEXTURE_QUICKNADE or TEXTURE_FRAG, 64, 64, 0, 0, settings.quicknades_icon_alt and 64 or 56, 64 )

    local number = self.Number
    number:SetFont( fonts.quicknades_num_font )
    number:SetRenderMode( settings.quicknades_num_rendermode )
    number:SetBackground( settings.quicknades_num_background )
    number:SetAlign( settings.quicknades_num_align )
    number:SetDigits( settings.quicknades_num_digits )

    self:InvalidateLayout()

end

HOLOHUD2.component.Register( "HudQuickNades", COMPONENT )