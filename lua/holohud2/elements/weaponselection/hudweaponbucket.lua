
local CurTime = CurTime
local FrameTime = FrameTime

local COMPONENT = {
    ammo1                   = 0,
    ammo2                   = 0,
    animated                = false,
    warmup                  = 0,
    show_max_clip           = true,
    clip                    = 0,
    max_clip                = 0,
    _nextchar               = 0,
    background              = true,
    ammoicon_on_background  = true,
    clip_on_background      = false
}

local WARMUP_TIME, ANIMATION_SPEED = .17, 64

function COMPONENT:Init()

    self.Header = HOLOHUD2.component.Create( "Text" )
    self.Icon = HOLOHUD2.component.Create( "WeaponSelectionIcon" )
    self.Name = HOLOHUD2.component.Create( "Text" )
    self.Ammo1Background = HOLOHUD2.component.Create( "Bar" )
    self.Ammo1 = HOLOHUD2.component.Create( "ProgressBar" )
    self.Ammo1Icon = HOLOHUD2.component.Create( "AmmoIcon" )
    self.Ammo2Background = HOLOHUD2.component.Create( "Bar" )
    self.Ammo2 = HOLOHUD2.component.Create( "ProgressBar" )
    self.Ammo2Icon = HOLOHUD2.component.Create( "AmmoIcon" )
    self.Clip = HOLOHUD2.component.Create( "Text" )

end

function COMPONENT:InvalidateLayout()

    self.Header:InvalidateLayout()
    self.Icon:InvalidateLayout()
    self.Name:InvalidateLayout()
    self.Ammo1Background:InvalidateLayout()
    self.Ammo1:InvalidateLayout()
    self.Ammo1Icon:InvalidateLayout()
    self.Ammo2Background:InvalidateLayout()
    self.Ammo2:InvalidateLayout()
    self.Ammo2Icon:InvalidateLayout()
    self.Clip:InvalidateLayout()

end

function COMPONENT:PaintFrame( x, y )

    self.Icon:PaintFrame( x, y )

end

function COMPONENT:Think()

    local curtime = CurTime()

    self.Header:PerformLayout()
    self.Icon:PerformLayout()
    self.Name:PerformLayout()
    self.Ammo1Background:PerformLayout()
    self.Ammo1:Think()
    self.Ammo1Icon:PerformLayout()
    self.Ammo2Background:PerformLayout()
    self.Ammo2:Think()
    self.Ammo2Icon:PerformLayout()
    self.Clip:PerformLayout()

    if not self.animated then return end
    if self.warmup > curtime then return end

    local frametime = FrameTime()
    local length = utf8.len( self.Name.text )

    if self.Name.charsvisible < length and self._nextchar < curtime then

        self.Name:SetCharsVisible( self.Name.charsvisible + 1 )
        self._nextchar = curtime + 1 / ANIMATION_SPEED

    end

    self.Ammo1:SetValue( math.min( self.Ammo1.value + frametime * ANIMATION_SPEED * .1, self.ammo1 ) )
    self.Ammo2:SetValue( math.min( self.Ammo2.value + frametime * ANIMATION_SPEED * .1, self.ammo2 ) )

end

function COMPONENT:SetAnimated( animated )

    self.animated = animated
    self.warmup = CurTime() + WARMUP_TIME

    if animated then

        self.Name:SetCharsVisible( 0 )
        self.Ammo1:SetValue( 0 )
        self.Ammo2:SetValue( 0 )

    else

        self.Name:SetCharsVisible( -1 )
        self.Ammo1:SetValue( self.ammo1 )
        self.Ammo2:SetValue( self.ammo2 )

    end

end

function COMPONENT:SetWeapon( weapon )

    self.Icon:SetWeapon( weapon )

    if not IsValid( weapon ) then return end

    self:SetName( weapon.GetPrintName and weapon:GetPrintName() or weapon.PrintName or weapon:GetClass() )

end

function COMPONENT:SetClass( class )

    self.Icon:SetClass( class )

end

function COMPONENT:SetHeader( slot )

    self.Header:SetText( slot )

end

function COMPONENT:SetDrawHeader( visible )

    self.Header:SetVisible( visible )

end

function COMPONENT:SetName( name )

    self.Name:SetText( name )

end

function COMPONENT:SetAmmo1Type( ammotype )

    self.Ammo1Icon:SetAmmoType( ammotype )

end

function COMPONENT:SetDrawMaxClip( show_max_clip )

    if self.show_max_clip == show_max_clip then return end

    self.show_max_clip = show_max_clip

    if self.clip == -1 then return end

    if show_max_clip then

        self.Clip:SetText( self.clip .. "/" .. self.max_clip )

    else

        self.Clip:SetText( self.clip )
    
    end

end

function COMPONENT:SetClip( clip, max_clip )

    if clip == self.clip and max_clip == self.max_clip then return end

    self.clip = clip
    self.max_clip = max_clip

    if clip == -1 then

        self.Clip:SetText( "" )
        return

    end

    if self.show_max_clip then
    
        self.Clip:SetText( clip .. "/" .. max_clip )

    else

        self.Clip:SetText( clip )
    
    end

end

function COMPONENT:SetAmmo1( ammo )

    if self.ammo1 == ammo then return end

    self.ammo1 = ammo
    self.Ammo1Background:SetVisible( self.background and ammo ~= -1 )
    self.Ammo1Icon:SetVisible( ammo ~= -1 )

    if self.animated then return end

    self.Ammo1:SetValue( ammo )

end

function COMPONENT:SetAmmo2Type( ammotype )

    self.Ammo2Icon:SetAmmoType( ammotype )

end

function COMPONENT:SetAmmo2( ammo )

    if self.ammo2 == ammo then return end

    self.ammo2 = ammo
    self.Ammo2Background:SetVisible( self.background and ammo ~= -1 )
    self.Ammo2Icon:SetVisible( ammo ~= -1 )

    if self.animated then return end

    self.Ammo2:SetValue( ammo )

end

function COMPONENT:SetColor( color )

    self.Icon:SetColor( color )
    self.Name:SetColor( color )

    if self.clip_on_background then return end

    self.Clip:SetColor( color )

end

function COMPONENT:PaintBackground( x, y )

    self.Header:Paint( x, y )
    self.Ammo1Background:Paint( x, y )
    self.Ammo2Background:Paint( x, y )

    if self.clip_on_background then self.Clip:Paint( x, y ) end
    if not self.ammoicon_on_background then return end

    self.Ammo1Icon:Paint( x, y )
    self.Ammo2Icon:Paint( x, y )

end

function COMPONENT:Paint( x, y )

    self.Icon:Paint( x, y )
    self.Name:Paint( x, y )
    self.Ammo1:Paint( x, y )
    self.Ammo2:Paint( x, y )

    if not self.clip_on_background then self.Clip:Paint( x, y ) end

    if self.ammoicon_on_background then return end

    self.Ammo1Icon:Paint( x, y )
    self.Ammo2Icon:Paint( x, y )

end

function COMPONENT:ApplySettings( settings, fonts )

    self.Header:SetFont( fonts.slot_font )
    self.Header:SetColor( settings.slot_color )
    self.Header:SetPos( settings.slot_pos.x, settings.slot_pos.y )

    self.Name:SetPos( settings.selection_name_pos.x, settings.selection_name_pos.y )
    self.Name:SetFont( fonts.selection_name_font )
    self.Name:SetAlign( settings.selection_name_align )
    
    self.Icon:SetPos( settings.selection_icon_pos.x, settings.selection_icon_pos.y )
    self.Icon:SetSize( settings.selection_icon_size )
    
    self.Ammo1Background:SetSize( settings.selection_ammo_size.x, settings.selection_ammo_size.y )
    self.Ammo1Background:SetStyle( settings.selection_ammo_style )
    self.Ammo1Background:SetPos( settings.selection_ammo1_pos.x, settings.selection_ammo1_pos.y )
    self.Ammo1Background:SetColor( settings.selection_ammo_color2 )
    
    self.Ammo1:Copy( self.Ammo1Background )
    self.Ammo1:SetColor( settings.selection_ammo_color )
    self.Ammo1:SetGrowDirection( settings.selection_ammo_growdirection )
    
    self.Ammo2Background:Copy( self.Ammo1Background )
    self.Ammo2Background:SetPos( settings.selection_ammo2_pos.x, settings.selection_ammo2_pos.y )
    self.Ammo2Background:SetColor( settings.selection_ammo_color2 )
    
    self.Ammo2:Copy( self.Ammo2Background )
    self.Ammo2:SetColor( settings.selection_ammo_color )
    self.Ammo2:SetGrowDirection( settings.selection_ammo_growdirection )

    self.background = settings.selection_ammo_background
    self.Ammo1Background:SetVisible( self.background and self.Ammo1.value ~= -1 )
    self.Ammo2Background:SetVisible( self.background and self.Ammo2.value ~= -1 )

    self.Ammo1Icon:SetPos( self.Ammo1.x + settings.selection_ammo_icon_offset.x, self.Ammo1.y + settings.selection_ammo_icon_offset.y )
    self.Ammo1Icon:SetSize( settings.selection_ammo_icon_size )
    self.Ammo1Icon:SetAngle( settings.selection_ammo_icon_angle )
    self.Ammo1Icon:SetAlign( settings.selection_ammo_icon_align )
    self.Ammo1Icon:SetColor( settings.selection_ammo_icon_on_background and settings.selection_ammo_color2 or settings.selection_ammo_color )

    self.Ammo2Icon:SetPos( self.Ammo2.x + settings.selection_ammo_icon_offset.x, self.Ammo2.y + settings.selection_ammo_icon_offset.y )
    self.Ammo2Icon:SetSize( settings.selection_ammo_icon_size )
    self.Ammo2Icon:SetAngle( settings.selection_ammo_icon_angle )
    self.Ammo2Icon:SetAlign( settings.selection_ammo_icon_align )
    self.Ammo2Icon:SetColor( settings.selection_ammo_icon_on_background and settings.selection_ammo_color2 or settings.selection_ammo_color )

    self.Clip:SetVisible( settings.selection_clip )
    self.Clip:SetPos( settings.selection_clip_pos.x, settings.selection_clip_pos.y )
    self.Clip:SetFont( fonts.selection_clip_font )
    self.Clip:SetAlign( settings.selection_clip_align )

    if settings.selection_clip_on_background then self.Clip:SetColor( settings.selection_ammo_color2 ) end

    self.ammoicon_on_background = settings.selection_ammo_icon_on_background
    self.clip_on_background = settings.selection_clip_on_background

end

HOLOHUD2.component.Register( "HudWeaponBucket", COMPONENT )