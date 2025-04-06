local BaseClass = HOLOHUD2.component.Get( "Icon" )

local FIREMODE_NONE     = 0
local FIREMODE_SAFE     = 1
local FIREMODE_SEMI     = 2
local FIREMODE_AUTO     = 3
local FIREMODE_3BURST   = 4
local FIREMODE_2BURST   = 5

local FIREMODES = {
    [ FIREMODE_SAFE ] = { surface.GetTextureID( "holohud2/firemode/safe" ), 64, 16 },
    [ FIREMODE_SEMI ] = { surface.GetTextureID( "holohud2/firemode/single" ), 64, 16 },
    [ FIREMODE_AUTO ] = { surface.GetTextureID( "holohud2/firemode/auto" ), 64, 16 },
    [ FIREMODE_3BURST ] = { surface.GetTextureID( "holohud2/firemode/burst3" ), 64, 16 },
    [ FIREMODE_2BURST ] = { surface.GetTextureID( "holohud2/firemode/burst2" ), 64, 16 }
}

local COMPONENT = {
    firemode    = FIREMODE_NONE,
    _invalid    = true
}

function COMPONENT:SetFireMode( firemode )

    if self.firemode == firemode then return end

    self.firemode = firemode

    if not firemode or not FIREMODES[ firemode ] then

        self._invalid = true
        return

    end

    self:SetTexture( FIREMODES[ firemode ] )
    self._invalid = false

end

function COMPONENT:Paint( x, y )

    if self._invalid then return end

    BaseClass.Paint( self, x, y )

end

function COMPONENT:ApplySettings( settings )

    self:SetVisible( settings.firemode )
    self:SetSize( settings.firemode_size )

    if settings.firemode_separate then

        self:SetPos( settings.firemode_separate_padding.x, settings.firemode_separate_padding.y )
        return

    end

    self:SetPos( settings.firemode_pos.x, settings.firemode_pos.y )

end

HOLOHUD2.component.Register( "HudFireMode", COMPONENT, "Icon" )

HOLOHUD2.FIREMODE_NONE      = FIREMODE_NONE
HOLOHUD2.FIREMODE_SAFE      = FIREMODE_SAFE
HOLOHUD2.FIREMODE_SEMI      = FIREMODE_SEMI
HOLOHUD2.FIREMODE_AUTO      = FIREMODE_AUTO
HOLOHUD2.FIREMODE_3BURST    = FIREMODE_3BURST
HOLOHUD2.FIREMODE_2BURST    = FIREMODE_2BURST