---
--- Trouble in Terrorist Town
---

if SERVER then return end

if engine.ActiveGamemode() ~= "terrortown" then return end

local CurTime = CurTime
local LocalPlayer = LocalPlayer
local IsVisible = HOLOHUD2.IsVisible
local element_Get = HOLOHUD2.element.Get
local StartAlphaMultiplier = HOLOHUD2.render.StartAlphaMultiplier
local EndAlphaMultiplier = HOLOHUD2.render.EndAlphaMultiplier
local GetMinimumGlow = HOLOHUD2.render.GetMinimumGlow

local LAYER_FRAME       = HOLOHUD2.LAYER_FRAME
local LAYER_BACKGROUND  = HOLOHUD2.LAYER_BACKGROUND
local LAYER_SCANLINES   = HOLOHUD2.LAYER_SCANLINES

local element_health = HOLOHUD2.element.Get( "health" )
local element_ammo = HOLOHUD2.element.Get( "ammo" )
local element_timer = HOLOHUD2.element.Get( "timer" )
local element_role = HOLOHUD2.element.Get( "ttt_role" )

local ROLE_COLORS = {
    traitor     = Color( 200, 44, 44 ),
    detective   = Color( 44, 170, 200 ),
    innocent    = Color( 44, 200, 44 ),
    preparing   = Color( 200, 200, 200 )
}

local ROUNDSTATE_STR = {
    "round_wait",
    "round_prep",
    "round_active",
    "round_post"
}

---
--- Hide TTT HUD
---
hook.Add( "HUDShouldDraw", "holohud2_terrortown", function( name )
    
    if not IsVisible() then return end

    if ( element_health:IsVisible() or element_ammo:IsVisible() or element_timer:IsVisible() or element_role:IsVisible() ) and name == "TTTInfoPanel" then

        return false

    end

end)

---
--- Hide our HUD when spectating (I didn't feel like replacing the whole HUD, sorry)
---
HOLOHUD2.hook.Add( "ShouldDrawHUD", "terrortown", function()

    local localplayer = LocalPlayer()
    local team_Get = localplayer.Team

    if not team_Get or team_Get( localplayer ) == TEAM_SPEC then return false end

end)

---
--- Extend settings
---
local haste_color = color_white

local ELEMENT_TIMER = element_Get( "timer" )
ELEMENT_TIMER:DefineParameter( "ttt_overtime_font", { name = "Haste overtime font", type = HOLOHUD2.PARAM_FONT, value = { font = "Roboto Condensed Light", size = 16, weight = 1000, italic = false } } )
ELEMENT_TIMER:DefineParameter( "ttt_haste_color", { name = "Haste timer colour", type = HOLOHUD2.PARAM_COLOR, value = Color( 255, 48, 32 ) } )

HOLOHUD2.hook.Add( "OnSettingsChanged", "terrortown", function( settings )

    haste_color = settings.timer.ttt_haste_color

end)

---
--- Timer
---
local round_time = 0
local haste_time = 0
local is_haste = false
local is_traitor = false
local traitor_showhaste = false
local last_showhaste = false

HOLOHUD2.hook.Add( "ShouldDrawTimer", "terrortown", function() return true end )
HOLOHUD2.hook.Add( "GetTime", "terrortown", function()

    local curtime = CurTime()
    is_haste = HasteMode() and GAMEMODE.round_state == ROUND_ACTIVE
    is_traitor = LocalPlayer():IsActiveTraitor()
    traitor_showhaste = curtime % 7 <= 2
    local showhaste = is_haste and is_traitor and traitor_showhaste

    haste_time = GetGlobalFloat( "ttt_haste_end", 0 ) - curtime
    round_time = math.max( GetGlobalFloat( "ttt_round_end", 0 ) - curtime, 0 )

    if last_showhaste ~= showhaste then
    
        if showhaste then

            HOLOHUD2.gamemode.SetParameterOverride( "timer", "color", haste_color )

        else

            HOLOHUD2.gamemode.SetParameterOverride( "timer", "color", nil )

        end

        last_showhaste = showhaste
    
    end

    if is_haste and not showhaste then

        return haste_time

    end

    return round_time

end)
HOLOHUD2.hook.Add( "DrawTimer", "terrortown", function( x, y, w, h, layer )

    if not LANG then return end
    if layer == LAYER_FRAME then return end
    if not is_haste or haste_time >= 0 or ( is_traitor and traitor_showhaste ) then return end

    if layer == LAYER_BACKGROUND then return true end

    if layer == LAYER_SCANLINES then

        StartAlphaMultiplier( GetMinimumGlow() )

    end

    draw.SimpleText( LANG.GetUnsafeLanguageTable().overtime, "holohud2_timer_ttt_overtime_font", x + w / 2, y + h / 2, haste_color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

    if layer == LAYER_SCANLINES then
        
        EndAlphaMultiplier()

    end

    return true

end)


---
--- Radar
---
HOLOHUD2.hook.Add( "VisibleOnRadar", "terrortown", function( ent )

    if not ent:IsPlayer() then return end

    local localplayer = LocalPlayer()

    -- spectators see everything
    if localplayer:Team() == TEAM_SPEC then return true end
    
    -- teammates see each other
    if ( localplayer:GetTraitor() and ent:GetTraitor() ) or ( localplayer:GetDetective() and ent:GetDetective() ) then

        return true

    end

end)
HOLOHUD2.hook.Add( "GetRadarBlipColor", "terrortown", function( ent )

    if not ent:IsPlayer() then return end

    local localplayer = LocalPlayer()

    -- traitors recognise each other
    if ent:GetTraitor() and ( localplayer:GetTraitor() or localplayer:Team() == TEAM_SPEC ) then
        
        return ROLE_COLORS.traitor

    end

    if ent:GetDetective() then

        return ROLE_COLORS.detective
        
    end

    return ROLE_COLORS.innocent

end)

---
--- Default layout
---
HOLOHUD2.gamemode.SubmitDefaults( {
    health      = {
        autohide_threshold  = 90,
        size                = { x = 89, y = 43 },
        health_color        = { colors = { [20] = Color( 255, 64, 48 ), [45] = Color( 255, 96, 48 ), [70] = Color( 255, 186, 72 ), [90] = Color( 162, 255, 72 ), [100] = Color( 72, 255, 72 ) }, fraction = false, gradual = false },
        healthnum_pos       = { x = 31, y = -1 },
        healthbar_size      = { x = 84, y = 6 },
        healthicon          = true,
        healthicon_pos      = { x = 9, y = 9 },
        suitnum             = false,
        suiticon            = false
    },
    clock       = {
        _visible            = false
    },
    targetid    = {
        health_color        = { colors = { [20] = Color( 255, 64, 48 ), [45] = Color( 255, 96, 48 ), [70] = Color( 255, 186, 72 ), [90] = Color( 162, 255, 72 ), [100] = Color( 72, 255, 72 ) }, fraction = false, gradual = false }
    },
    timer       = {
        size                = { x = 89, y = 24 },
        dock                = HOLOHUD2.DOCK.BOTTOM_LEFT,
        direction           = HOLOHUD2.DIRECTION_UP,
        order               = 3,
        origin              = { x = 45, y = 3 }
    }
} )
HOLOHUD2.gamemode.SetParameterOverride( "radar", "insight", true )
HOLOHUD2.gamemode.SetParameterOverride( "radar", "insight_fov", 60 )
HOLOHUD2.gamemode.SetParameterOverride( "suitpower", "_visible", false )
HOLOHUD2.gamemode.SetParameterOverride( "deathnotice", "_visible", false )
HOLOHUD2.gamemode.SetParameterOverride( "startup", "_visible", false )

---
--- Role indicator element
---
local ELEMENT = {
    name        = "Role",
    helptext    = "Shows your role in the current round.",
    parameters  = {
        pos                 = { name = "#holohud2.parameter.pos", type = HOLOHUD2.PARAM_VECTOR, value = { x = 12, y = 12 } },
        dock                = { name = "#holohud2.parameter.dock", type = HOLOHUD2.PARAM_DOCK, value = HOLOHUD2.DOCK.BOTTOM_LEFT },
        direction           = { name = "#holohud2.parameter.direction", type = HOLOHUD2.PARAM_DIRECTION, value = HOLOHUD2.DIRECTION_UP },
        margin              = { name = "#holohud2.parameter.margin", type = HOLOHUD2.PARAM_NUMBER, value = 4, min = 0 },
        order               = { name = "#holohud2.parameter.order", type = HOLOHUD2.PARAM_ORDER, value = 4 },

        size                = { name = "#holohud2.parameter.size", type = HOLOHUD2.PARAM_VECTOR, value = { x = 89, y = 24 } },
        background          = { name = "#holohud2.parameter.background", type = HOLOHUD2.PARAM_BOOL, value = true },
        background_color    = { name = "#holohud2.parameter.color", type = HOLOHUD2.PARAM_COLOR, value = Color( 0, 0, 0, 94 ) },
        animation           = { name = "#holohud2.parameter.animation", type = HOLOHUD2.PARAM_OPTION, options = HOLOHUD2.PANELANIMATIONS, value = HOLOHUD2.PANELANIMATION_FLASH },
        animation_direction = { name = "#holohud2.parameter.direction", type = HOLOHUD2.PARAM_DIRECTION, value = HOLOHUD2.DIRECTION_UP },

        role_pos            = { name = "#holohud2.parameter.pos", type = HOLOHUD2.PARAM_VECTOR, value = { x = 45, y = 4 } },
        role_font           = { name = "#holohud2.parameter.font", type = HOLOHUD2.PARAM_FONT, value = { font = "Roboto Condensed Light", size = 16, weight = 500 } },
        role_align          = { name = "#holohud2.parameter.align", type = HOLOHUD2.PARAM_TEXTALIGN, value = TEXT_ALIGN_CENTER }
    },
    menu = {
        { category = "#holohud2.category.panel", parameters = {
            { id = "pos", parameters = {
                { id = "dock" },
                { id = "direction" },
                { id = "margin" },
                { id = "order" }
            } },
            { id = "size" },
            { id = "background", parameters = {
                { id = "background_color" }
            } },
            { id = "animation", parameter = {
                { id = "animation_direction" }
            } }
        } },

        { category = "Role", parameters = {
            { id = "role_pos" },
            { id = "role_font" },
            { id = "role_align" }
        } }
    },
    quickmenu = {
        { category = "#holohud2.category.panel", parameters = {
            { id = "pos" },
            { id = "size" }
        } },
        { category = "Role", parameters = {
            { id = "role_pos" },
            { id = "role_font" },
            { id = "role_align" }
        } }
    }
}

local layout = HOLOHUD2.layout.Register( "ttt_role" )
local component = HOLOHUD2.component.Create( "Text" )
local panel = HOLOHUD2.component.Create( "AnimatedPanel" )
panel:SetLayout( layout )

panel.PaintOver = function( _, x, y )

    component:Paint( x, y )

end

function ELEMENT:PreDraw( settings )

    if not LANG then return end

    local localplayer = LocalPlayer()
    local L = LANG.GetUnsafeLanguageTable()

    if GAMEMODE.round_state == ROUND_ACTIVE then
    
        local color = ROLE_COLORS.innocent

        if localplayer:GetTraitor() then

            color = ROLE_COLORS.traitor

        elseif localplayer:GetDetective() then

            color = ROLE_COLORS.detective

        end

        component:SetColor( color )
        component:SetText( string.upper( L[ localplayer:GetRoleStringRaw() ] ) )

    else

        component:SetColor( ROLE_COLORS.preparing )
        component:SetText( string.upper( L[ ROUNDSTATE_STR[ GAMEMODE.round_state ] ] ) )
    
    end

    panel:Think()
    panel:SetDeployed( true )

    layout:SetVisible( panel:IsVisible() )

    if not panel:IsVisible() then return end

    component:PerformLayout()

end

function ELEMENT:PaintFrame( settings, x, y )

    panel:PaintFrame( x, y )

end

function ELEMENT:Paint( settings, x, y )

    panel:Paint( x, y )

end

function ELEMENT:PaintScanlines( settings, x, y )

    StartAlphaMultiplier( GetMinimumGlow() )
    panel:Paint( x, y )
    EndAlphaMultiplier()

end

function ELEMENT:OnSettingsChanged( settings )

    if not settings._visible then

        layout:SetVisible( false )
        return

    end

    layout:SetPos( settings.pos.x, settings.pos.y )
    layout:SetDock( settings.dock )
    layout:SetSize( settings.size.x, settings.size.y )
    layout:SetDirection( settings.direction )
    layout:SetMargin( settings.margin )
    layout:SetOrder( settings.order )

    panel:SetDrawBackground( settings.background )
    panel:SetColor( settings.background_color )
    panel:SetAnimation( settings.animation )
    panel:SetAnimationDirection( settings.animation_direction )

    component:SetPos( settings.role_pos.x, settings.role_pos.y )
    component:SetFont( self.fonts.role_font )
    component:SetAlign( settings.role_align )

end

HOLOHUD2.element.Register( "ttt_role", ELEMENT )

HOLOHUD2.modifier.Add( "text_font", "ttt_role", "role_font" )
HOLOHUD2.modifier.Add( "text_offset", "ttt_role", "role_pos" )