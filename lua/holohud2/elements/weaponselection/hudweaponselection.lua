
local draw = draw
local surface = surface
local BlurRect = HOLOHUD2.render.BlurRect

local COMPONENT = {
    invalid_layout          = false,
    x                       = 0,
    y                       = 0,
    color                   = color_white,
    color2                  = color_white,
    color_out               = color_white,
    background              = true,
    background_color        = color_black,
    background_color_out    = color_black,
    smallbox_w              = 8,
    smallbox_h              = 8,
    smallbox_digit_font     = "default",
    smallbox_digit_x        = 2,
    smallbox_digit_y        = 1,
    smallbox_name_font      = "default",
    smallbox_name_x         = 1,
    smallbox_name_y         = 0,
    smallbox_name_align     = TEXT_ALIGN_LEFT,
    bigbox_w                = 64,
    bigbox_h                = 32,
    margin                  = 4,
    slot                    = 0,
    pos                     = 0,
    blur                    = true,
    weapons                 = { {}, {}, {}, {}, {}, {} },
    _weapons                = {},
    _find                   = {},
    _smallbox_digit_x       = 0,
    _smallbox_digit_y       = 0,
    _smallbox_name_x        = 0,
    _smallbox_name_y        = 0,
    __x                     = 0,
    __y                     = 0
}

local function sort( a, b )

    return a:GetSlotPos() < b:GetSlotPos()

end

function COMPONENT:InvalidateLayout()

    self.invalid_layout = true

end

function COMPONENT:PerformLayout( force )

    if not self.invalid_layout and not force then return end

    local scale = HOLOHUD2.scale.Get()

    self._smallbox_digit_x = self.smallbox_digit_x * scale
    self._smallbox_digit_y = self.smallbox_digit_y * scale
    self._smallbox_name_x = self.smallbox_name_x * scale
    self._smallbox_name_y = self.smallbox_name_y * scale

    local x = 0

    for i, slot in pairs( self.weapons ) do

        self._weapons[ i ] = {}

        local w = self.smallbox_w
        local y = 0
        
        if i == self.slot then

            w = self.bigbox_w

        end

        if #slot == 0 then

            self._weapons[ i ][ 1 ] = {
                x = ( self.x + x ) * scale,
                y = ( self.y + y ) * scale,
                w = w * scale,
                h = self.smallbox_h * scale
            }

        else

            for j, _ in pairs( slot ) do
                
                local selected = i == self.slot and j == self.pos
                local h = self.smallbox_h
    
                if selected then
    
                    h = self.bigbox_h
                    self.__x = self.x + x
                    self.__y = self.y + y
    
                end
    
                self._weapons[ i ][ j ] = {
                    x = ( self.x + x ) * scale,
                    y = ( self.y + y ) * scale,
                    w = w * scale,
                    h = h * scale
                }
    
                y = y + h + self.margin
    
            end

        end

        x = x + w + self.margin

    end

    self.invalid_layout = false

end

function COMPONENT:SetSlotPos( pos )

    self.pos = pos
    self:InvalidateLayout()

end

function COMPONENT:SetSlot( slot )

    self.slot = slot
    self:InvalidateLayout()

end

function COMPONENT:SetPos( x, y )

    if self.x == x and self.y == y then return end

    self.x = x
    self.y = y
    self:InvalidateLayout()

    return true

end

function COMPONENT:SetDrawBlur( blur )

    self.blur = blur

end

function COMPONENT:SetColor( color )

    self.color = color

end

function COMPONENT:SetColor2( color2 )

    self.color2 = color2

end

function COMPONENT:SetEmptyColor( color_out )

    self.color_out = color_out

end

function COMPONENT:SetDrawBackground( background )

    self.background = background

end

function COMPONENT:SetBackgroundColor( background_color )

    self.background_color = background_color

end

function COMPONENT:SetBackgroundEmptyColor( background_color_out )

    self.background_color_out = background_color_out

end

function COMPONENT:SetSmallBoxSize( w, h )

    if self.smallbox_w == w and self.smallbox_h == h then return end

    self.smallbox_w = w
    self.smallbox_h = h
    self:InvalidateLayout()

    return true

end

function COMPONENT:SetSlotHeaderFont( font )

    if self.smallbox_digit_font == font then return end

    self.smallbox_digit_font = font
    self:InvalidateLayout()

    return true

end

function COMPONENT:SetSlotHeaderPos( x, y )

    if self.smallbox_digit_x == x and self.smallbox_digit_y == y then return end

    self.smallbox_digit_x = x
    self.smallbox_digit_y = y
    self:InvalidateLayout()

    return true

end

function COMPONENT:SetWeaponNameFont( font )

    if self.smallbox_name_font == font then return end

    self.smallbox_name_font = font
    self:InvalidateLayout()

    return true

end

function COMPONENT:SetWeaponNamePos( x, y )

    if self.smallbox_name_x == x and self.smallbox_name_y == y then return end

    self.smallbox_name_x = x
    self.smallbox_name_y = y
    self:InvalidateLayout()

    return true

end

function COMPONENT:SetWeaponNameAlign( align )

    if self.smallbox_name_align == align then return end

    self.smallbox_name_align = align
    self:InvalidateLayout()

    return true

end

function COMPONENT:SetSelectionSize( w, h )

    if self.bigbox_w == w and self.bigbox_h == h then return end

    self.bigbox_w = w
    self.bigbox_h = h
    self:InvalidateLayout()

    return true

end

function COMPONENT:SetMargin( margin )

    if self.margin == margin then return end

    self.margin = margin
    self:InvalidateLayout()

    return true

end

function COMPONENT:SetBucket( slot, pos, has_ammo, name, class )

    if not self.weapons[ slot ] then self.weapons[ slot ] = {} end

    local bucket = self.weapons[ slot ][ pos ]

    if bucket then

        if name then bucket.name = name end
        if class then bucket.class = class end
        bucket.has_ammo = has_ammo
        return

    end

    self.weapons[ slot ][ pos ] = {
        name = name,
        has_ammo = has_ammo,
        class = class
    }

end

function COMPONENT:RemoveBucket( slot, pos )

    if not self.weapons[ slot ] then return end

    self.weapons[ slot ][ pos ] = nil

    if table.Count( self.weapons[ slot ] ) > 0 then return end

    self.weapons[ slot ] = nil

end

function COMPONENT:GetBucket( slot, pos )

    if not self.weapons[ slot ] then return end

    return self.weapons[ slot ][ pos ]

end

function COMPONENT:SetWeapons( weapons )

    local cache = {}
    self._find = {}

    for i=1, HOLOHUD2.WeaponSelectionSlots do

        self.weapons[ i ] = {}
        cache[ i ] = {}

    end

    for _, weapon in ipairs( weapons ) do

        if not IsValid( weapon ) then continue end

        local slot = weapon:GetSlot() + 1

        if slot < 1 or slot > HOLOHUD2.WeaponSelectionSlots then continue end

        table.insert( cache[ slot ], weapon )

    end

    for i=1, HOLOHUD2.WeaponSelectionSlots do

        table.sort( cache[ i ], sort )

        for j, weapon in ipairs( cache[ i ] ) do

            self:SetBucket( i, j, weapon:HasAmmo(), weapon.GetPrintName and weapon:GetPrintName() or weapon.PrintName or weapon:GetClass(), weapon:GetClass() )
            self._find[ weapon:GetClass() ] = { slot = i, pos = j }

        end

    end

    self:InvalidateLayout()

end

function COMPONENT:Find( class )

    return self._find[ class ]

end

function COMPONENT:PaintFrame( x, y )

    if not self.background then return end

    local weapons = self.weapons
    local background_color, background_color_out = self.background_color, self.background_color_out

    for i, slot in ipairs( self._weapons ) do

        for j, pos in ipairs( slot ) do

            if self.slot == i and self.pos == j then continue end

            local x, y = x + pos.x, y + pos.y
            local weapon = weapons[ i ][ j ]

            if self.blur then

                BlurRect( x, y, pos.w, pos.h )

            end

            surface.SetDrawColor( ( not weapon or weapon.has_ammo ) and background_color or background_color_out )
            surface.DrawRect( x, y, pos.w, pos.h )

        end

    end

end

function COMPONENT:PaintBackground( x, y )

    local weapons = self.weapons
    local name_font = self.smallbox_name_font
    local name_x, name_y, name_align = self._smallbox_name_x, self._smallbox_name_y, self.smallbox_name_align
    local digit_font = self.smallbox_digit_font
    local digit_x, digit_y = self._smallbox_digit_x, self._smallbox_digit_y
    local color2, color_out = self.color2, self.color_out

    for i, slot in ipairs( self._weapons ) do

        if #weapons[ i ] == 0 then continue end

        for j, pos in ipairs( slot ) do

            if self.slot == i and self.pos == j then continue end

            local weapon = weapons[ i ][ j ]
            local x, y = x + pos.x, y + pos.y
            local color = weapon.has_ammo and color2 or color_out

            -- header
            if j == 1 then

                surface.SetFont( digit_font )
                surface.SetTextColor( color2.r, color2.g, color2.b, color2.a )
                surface.SetTextPos( x + digit_x, y + digit_y )
                surface.DrawText( i )

            end

            -- draw out of ammo bucket
            if self.slot ~= i or weapon.has_ammo then continue end
            
            draw.DrawText( weapon.name, name_font, x + name_x, y + name_y, color, name_align )

        end

    end

end

function COMPONENT:Paint( x, y )

    local slot = self._weapons[ self.slot ]

    if not slot or #slot == 0 then return end
    
    local weapons = self.weapons
    local name_font = self.smallbox_name_font
    local name_x, name_y, name_align = self._smallbox_name_x, self._smallbox_name_y, self.smallbox_name_align
    local color = self.color

    for i, pos in ipairs( slot ) do

        if self.pos == i then continue end

        local weapon = weapons[ self.slot ][ i ]

        if not weapon.has_ammo then continue end

        local x, y = x + pos.x, y + pos.y
        
        draw.DrawText( weapon.name, name_font, x + name_x, y + name_y, color, name_align )

    end

end

function COMPONENT:ApplySettings( settings, fonts )

    self:SetPos( settings.pos.x, settings.pos.y )
    self:SetDrawBackground( settings.background )
    self:SetBackgroundColor( settings.background_color )
    self:SetBackgroundEmptyColor( settings.background_color_empty )
    self:SetColor( settings.color )
    self:SetColor2( settings.slot_color )
    self:SetEmptyColor( settings.color_empty )
    self:SetSelectionSize( settings.selection_size.x, settings.selection_size.y )
    self:SetSmallBoxSize( settings.bucket_size.x, settings.bucket_size.y )
    self:SetSlotHeaderPos( settings.slot_pos.x, settings.slot_pos.y )
    self:SetSlotHeaderFont( fonts.slot_font )
    self:SetWeaponNamePos( settings.name_pos.x, settings.name_pos.y )
    self:SetWeaponNameFont( fonts.name_font )
    self:SetWeaponNameAlign( settings.name_align )
    self:SetMargin( settings.bucket_margin )

end

HOLOHUD2.component.Register( "HudWeaponSelection", COMPONENT )