
HOLOHUD2.AddCSLuaFile( "weaponselection/hudweaponbucket.lua" )
HOLOHUD2.AddCSLuaFile( "weaponselection/hudweaponselection.lua" )

if SERVER then return end

local FrameTime = FrameTime
local CurTime = CurTime
local LocalPlayer = LocalPlayer
local StartAlphaMultiplier = HOLOHUD2.render.StartAlphaMultiplier
local EndAlphaMultiplier = HOLOHUD2.render.EndAlphaMultiplier
local GetMinimumGlow = HOLOHUD2.render.GetMinimumGlow

local hud_fastswitch = GetConVar( "hud_fastswitch" )

local WEAPON_PHYSGUN = "weapon_physgun"
local IN_INVNEXT, IN_INVPREV, IN_SLOT, IN_SELECT, IN_CANCEL = "invnext", "invprev", "slot", "+attack", "+attack2"
local FADEIN_TIME, FADEOUT_TIME, DELAY = .1, .4, 2

local animated = false
local volume
local move_sound, move_pitch
local select_sound, select_pitch
local cancel_sound, cancel_pitch
local open_sound, open_pitch

local ELEMENT = {
    name            = "#holohud2.weaponselection",
    helptext        = "#holohud2.weaponselection.helptext",
    on_overlay      = true,
    parameters      = {
        autohide                            = { name = "#holohud2.parameter.autohide", type = HOLOHUD2.PARAM_BOOL, value = true },

        pos                                 = { name = "#holohud2.parameter.pos", type = HOLOHUD2.PARAM_VECTOR, value = { x = 186, y = 72 } },
        background                          = { name = "#holohud2.parameter.background", type = HOLOHUD2.PARAM_BOOL, value = true },
        background_color                    = { name = "#holohud2.parameter.color", type = HOLOHUD2.PARAM_COLOR, value = Color( 0, 0, 0, 94 ) },
        background_color_empty              = { name = "#holohud2.weaponselection.empty_color", type = HOLOHUD2.PARAM_COLOR, value = Color( 140, 14, 14, 94 ) },
        animation                           = { name = "#holohud2.parameter.animation", type = HOLOHUD2.PARAM_OPTION, options = HOLOHUD2.PANELANIMATIONS, value = HOLOHUD2.PANELANIMATION_FLASH },
        
        color                               = { name = "#holohud2.parameter.color", type = HOLOHUD2.PARAM_COLOR, value = Color( 255, 255, 255 ) },
        slot_color                          = { name = "#holohud2.weaponselection.slot_color", type = HOLOHUD2.PARAM_COLOR, value = Color( 255, 255, 255, 64 ) },
        color_empty                         = { name = "#holohud2.weaponselection.empty_color", type = HOLOHUD2.PARAM_COLOR, value = Color( 224, 24, 24 ) },
        selection_ammo_color                = { name = "#holohud2.weaponselection.ammo_color", type = HOLOHUD2.PARAM_COLOR, value = Color( 180, 255, 60 ) },
        selection_ammo_color2               = { name = "#holohud2.parameter.background_color", type = HOLOHUD2.PARAM_COLOR, value = Color( 255, 255, 255, 12 ) },

        selection_size                      = { name = "#holohud2.parameter.size", type = HOLOHUD2.PARAM_VECTOR, value = { x = 144, y = 72 } },
        selection_animated                  = { name = "#holohud2.parameter.animated", type = HOLOHUD2.PARAM_BOOL, value = true },
        
        selection_name_pos                  = { name = "#holohud2.parameter.pos", type = HOLOHUD2.PARAM_VECTOR, value = { x = 4, y = 56 } },
        selection_name_font                 = { name = "#holohud2.parameter.font", type = HOLOHUD2.PARAM_FONT, value = { font = "Roboto Condensed Light", size = 14, weight = 0, italic = false } },
        selection_name_align                = { name = "#holohud2.parameter.align", type = HOLOHUD2.PARAM_TEXTALIGN, value = TEXT_ALIGN_LEFT },
        
        selection_icon_pos                  = { name = "#holohud2.parameter.pos", type = HOLOHUD2.PARAM_VECTOR, value = { x = 72, y = 36 } },
        selection_icon_size                 = { name = "#holohud2.parameter.size", type = HOLOHUD2.PARAM_NUMBER, value = 140, min = 0 },
        
        selection_ammo1_pos                 = { name = "#holohud2.weaponselection.ammo1_pos", type = HOLOHUD2.PARAM_VECTOR, value = { x = 106, y = 4 } },
        selection_ammo2_pos                 = { name = "#holohud2.weaponselection.ammo2_pos", type = HOLOHUD2.PARAM_VECTOR, value = { x = 68, y = 4 } },
        selection_ammo_size                 = { name = "#holohud2.parameter.size", type = HOLOHUD2.PARAM_VECTOR, value = { x = 34, y = 5 }, min_x = 1, min_y = 1 },
        selection_ammo_style                = { name = "#holohud2.parameter.style", type = HOLOHUD2.PARAM_OPTION, options = HOLOHUD2.PROGRESSBARSTYLES, value = HOLOHUD2.PROGRESSBAR_DOT_CONTINUOUS },
        selection_ammo_background           = { name = "#holohud2.parameter.background", type = HOLOHUD2.PARAM_BOOL, value = true },
        selection_ammo_growdirection        = { name = "#holohud2.parameter.grow_direction", type = HOLOHUD2.PARAM_GROWDIRECTION, value = HOLOHUD2.GROWDIRECTION_LEFT },
        selection_ammo_icon                 = { name = "#holohud2.component.icon", type = HOLOHUD2.PARAM_BOOL, value = true },
        selection_ammo_icon_offset          = { name = "#holohud2.parameter.offset", type = HOLOHUD2.PARAM_VECTOR, value = { x = 34, y = 8 } },
        selection_ammo_icon_size            = { name = "#holohud2.parameter.size", type = HOLOHUD2.PARAM_NUMBER, value = 4, min = 0 },
        selection_ammo_icon_align           = { name = "#holohud2.parameter.align", type = HOLOHUD2.PARAM_TEXTALIGN, value = TEXT_ALIGN_RIGHT },
        selection_ammo_icon_angle           = { name = "#holohud2.parameter.rotation", type = HOLOHUD2.PARAM_RANGE, min = 0, max = 360, value = 0 },
        selection_ammo_icon_on_background   = { name = "#holohud2.parameter.on_background", type = HOLOHUD2.PARAM_BOOL, value = true },

        selection_clip                      = { name = "#holohud2.weaponselection.clip", type = HOLOHUD2.PARAM_BOOL, value = false },
        selection_clip_pos                  = { name = "#holohud2.parameter.pos", type = HOLOHUD2.PARAM_VECTOR, value = { x = 140, y = 58 } },
        selection_clip_font                 = { name = "#holohud2.parameter.font", type = HOLOHUD2.PARAM_FONT, value = { font = "Roboto Light", size = 12, weight = 1000, italic = false } },
        selection_clip_align                = { name = "#holohud2.parameter.align", type = HOLOHUD2.PARAM_TEXTALIGN, value = TEXT_ALIGN_RIGHT },
        selection_clip_on_background        = { name = "#holohud2.parameter.on_background", type = HOLOHUD2.PARAM_BOOL, value = false },

        bucket_margin                       = { name = "#holohud2.parameter.margin", type = HOLOHUD2.PARAM_NUMBER, value = 4 },
        bucket_size                         = { name = "#holohud2.parameter.size", type = HOLOHUD2.PARAM_VECTOR, value = { x = 22, y = 22 } },
        
        slot_font                           = { name = "#holohud2.parameter.font", type = HOLOHUD2.PARAM_FONT, value = { font = "Roboto Condensed Light", size = 16, weight = 1000, italic = false } },
        slot_pos                            = { name = "#holohud2.parameter.pos", type = HOLOHUD2.PARAM_VECTOR, value = { x = 3, y = 1 } },
        
        name_font                           = { name = "#holohud2.parameter.font", type = HOLOHUD2.PARAM_FONT, value = { font = "Roboto Condensed Light", size = 14, weight = 0, italic = false } },
        name_pos                            = { name = "#holohud2.parameter.pos", type = HOLOHUD2.PARAM_VECTOR, value = { x = 72, y = 3 } },
        name_align                          = { name = "#holohud2.parameter.align", type = HOLOHUD2.PARAM_TEXTALIGN, value = TEXT_ALIGN_CENTER },

        sound_volume                        = { name = "#holohud2.parameter.sound_volume", type = HOLOHUD2.PARAM_RANGE, min = 0, max = 100, value = 50 },
        sound_move_path                     = { name = "#holohud2.weaponselection.sound_move", type = HOLOHUD2.PARAM_STRING, value = "buttons/button14.wav" },
        sound_move_pitch                    = { name = "#holohud2.parameter.sound_pitch", type = HOLOHUD2.PARAM_RANGE, min = 0, max = 255, value = 200 },
        sound_select_path                   = { name = "#holohud2.weaponselection.sound_select", type = HOLOHUD2.PARAM_STRING, value = "buttons/button17.wav" },
        sound_select_pitch                  = { name = "#holohud2.parameter.sound_pitch", type = HOLOHUD2.PARAM_RANGE, min = 0, max = 255, value = 200 },
        sound_cancel_path                   = { name = "#holohud2.weaponselection.sound_cancel", type = HOLOHUD2.PARAM_STRING, value = "buttons/button10.wav" }, 
        sound_cancel_pitch                  = { name = "#holohud2.parameter.sound_pitch", type = HOLOHUD2.PARAM_RANGE, min = 0, max = 255, value = 200 },
        sound_open_path                     = { name = "#holohud2.weaponselection.sound_open", type = HOLOHUD2.PARAM_STRING, value = "buttons/button3.wav" },
        sound_open_pitch                    = { name = "#holohud2.parameter.sound_pitch", type = HOLOHUD2.PARAM_RANGE, min = 0, max = 255, value = 50 }
    },

    menu = {
        { id = "autohide" },
        { id = "pos" },
        { id = "animation" },
        { id = "background", parameters = {
            { id = "background_color" },
            { id = "background_color_empty" }
        } },

        { category = "#holohud2.category.coloring", parameters = {
            { id = "color" },
            { id = "slot_color" },
            { id = "color_empty" },
            { id = "selection_ammo_color", parameters = {
                { id = "selection_ammo_color2" }
            } }
        } },

        { category = "#holohud2.weaponselection.category.slots", parameters = {
            { id = "bucket_margin" },
            { id = "bucket_size" },
            { name = "#holohud2.weaponselection.header", parameters = {
                { id = "slot_pos" },
                { id = "slot_font" }
            } },
            { name = "#holohud2.weaponselection.weapon_names", parameters = {
                { id = "name_pos" },
                { id = "name_font" },
                { id = "name_align" }
            } }
        } },

        { category = "#holohud2.weaponselection.category.selection", parameters = {
            { id = "selection_size" },
            { id = "selection_animated" },
            { name = "#holohud2.weaponselection.name", parameters = {
                { id = "selection_name_pos" },
                { id = "selection_name_font" },
                { id = "selection_name_align" }
            } },
            { id = "#holohud2.component.icon", parameters = {
                { id = "selection_icon_pos" },
                { id = "selection_icon_size" }
            } },
            { id = "#holohud2.weaponselection.ammo", parameters = {
                { id = "selection_ammo1_pos" },
                { id = "selection_ammo2_pos" },
                { name = "#holohud2.component.percentage_bar", parameters = {
                    { id = "selection_ammo_size" },
                    { id = "selection_ammo_style" },
                    { id = "selection_ammo_background" },
                    { id = "selection_ammo_growdirection" }
                } },
                { id = "selection_ammo_icon", parameters = {
                    { id = "selection_ammo_icon_offset" },
                    { id = "selection_ammo_icon_size" },
                    { id = "selection_ammo_icon_angle" },
                    { id = "selection_ammo_icon_align" },
                    { id = "selection_ammo_icon_on_background" }
                } }
            } },
            { id = "selection_clip", parameters = {
                { id = "selection_clip_pos" },
                { id = "selection_clip_font" },
                { id = "selection_clip_align" },
                { id = "selection_clip_on_background" }
            } }
        } },

        { category = "#holohud2.weaponselection.sounds", parameters = {
            { id = "sound_open_path", parameters = {
                { id = "sound_open_pitch" }
            } },
            { id = "sound_move_path", parameters = {
                { id = "sound_move_pitch" }
            } },
            { id = "sound_select_path", parameters = {
                { id = "sound_select_pitch" }
            } },
            { id = "sound_cancel_path", parameters = {
                { id = "sound_cancel_pitch" }
            } }
        } }
    },
    quickmenu = {
        { id = "pos" },

        { category = "#holohud2.category.coloring", parameters = {
            { id = "color" },
            { id = "slot_color" },
            { id = "color_empty", parameters = {
                { id = "background_color_empty", name = "#holohud2.parameter.background_color" }
            } },
            { id = "selection_ammo_color", parameters = {
                { id = "selection_ammo_color2" }
            } }
        } },

        { category = "#holohud2.weaponselection.category.slots", parameters = {
            { id = "bucket_size" },
            { name = "#holohud2.weaponselection.header", parameters = {
                { id = "slot_pos" },
                { id = "slot_font" }
            } },
            { name = "#holohud2.weaponselection.weapon_names", parameters = {
                { id = "name_pos" },
                { id = "name_font" }
            } }
        } },

        { category = "#holohud2.weaponselection.category.selection", parameters = {
            { id = "selection_size" },
            { id = "selection_animated" },
            { name = "#holohud2.weaponselection.name", parameters = {
                { id = "selection_name_pos" },
                { id = "selection_name_font" }
            } },
            { id = "#holohud2.component.icon", parameters = {
                { id = "selection_icon_pos" },
                { id = "selection_icon_size" }
            } },
            { id = "#holohud2.weaponselection.ammo", parameters = {
                { id = "selection_ammo1_pos" },
                { id = "selection_ammo2_pos" },
                { id = "selection_ammo_size", name = "Percentage bar size" },
                { id = "selection_ammo_icon", parameters = {
                    { id = "selection_ammo_icon_offset" },
                    { id = "selection_ammo_icon_size" }
                } }
            } },
            { id = "selection_clip", parameters = {
                { id = "selection_clip_pos" },
                { id = "selection_clip_font" }
            } }
        } }
    }
}

---
--- Composition
---
local hudweaponselection = HOLOHUD2.component.Create( "HudWeaponSelection" )
local hudweaponbucket = HOLOHUD2.component.Create( "HudWeaponBucket" )
local selectionpanel = HOLOHUD2.component.Create( "AnimatedPanel" )
selectionpanel:SetSmoothenTransforms( false )
selectionpanel:SetAnimationDirection( HOLOHUD2.GROWDIRECTION_DOWN )
selectionpanel.PaintOverFrame = function( _, x, y )

    hudweaponbucket:PaintFrame( x, y )

end
selectionpanel.PaintOverBackground = function( _, x, y )

    hudweaponbucket:PaintBackground( x, y )

end
selectionpanel.PaintOver = function( _, x, y )

    hudweaponbucket:Paint( x, y )

end

---
--- Startup
---
local valid_selection = false -- it's set here because we need to cancel the selection when starting up

local time = 0
local alpha = 0

local STARTUP_NONE      = -1
local STARTUP_QUEUED    = 0
local STARTUP_ACTIVATED = 1

local startup_phase = STARTUP_NONE
local startup_time = 0

function ELEMENT:QueueStartup()

    valid_selection = false
    alpha = 0
    hudweaponselection:SetSlot( 0 )
    hudweaponselection:SetSlotPos( 0 )
    startup_phase = STARTUP_QUEUED

end

function ELEMENT:Startup()

    startup_phase = STARTUP_ACTIVATED
    startup_time = CurTime() + 3
    time = startup_time

end

function ELEMENT:CancelStartup()

    startup_phase = STARTUP_NONE

end

function ELEMENT:GetStartupMessage()

    return "#holohud2.weaponselection.startup"

end

function ELEMENT:IsStartupOver()

    if startup_phase == STARTUP_ACTIVATED and startup_time < CurTime() then

        startup_phase = STARTUP_NONE

    end

    return startup_phase == STARTUP_NONE

end

---
--- Logic
---
local localplayer
local cache, invalid_cache = {}, false
local has_ammo = false
local has_selected = true
function ELEMENT:PreDraw( settings )

    if startup_phase == STARTUP_QUEUED then return end

    localplayer = localplayer or LocalPlayer()

    -- invalidate cache
    local weapons = localplayer:GetWeapons()

    if #weapons ~= table.Count( cache ) then

        invalid_cache = true

    else

        for _, weapon in ipairs( weapons ) do

            if not IsValid( weapon ) then

                invalid_cache = true
                break

            end

            local class = weapon:GetClass()

            if cache[ class ] then

                local pos = hudweaponselection:Find( class )
                if not pos then continue end

                hudweaponselection:SetBucket( pos.slot, pos.pos, weapon:HasAmmo() )
                continue

            end

            invalid_cache = true
            break

        end

    end

    -- refresh cache
    if invalid_cache then
    
        cache = {}

        for _, weapon in ipairs( weapons ) do

            cache[ weapon:GetClass() ] = true

        end

        local weapon = hudweaponselection.weapons[ hudweaponselection.slot ] and hudweaponselection.weapons[ hudweaponselection.slot ][ hudweaponselection.pos ] and hudweaponselection.weapons[ hudweaponselection.slot ][ hudweaponselection.pos ].class

        hudweaponselection:SetWeapons( weapons )

        -- update selection position
        if weapon then
            
            local pos = hudweaponselection:Find( weapon )
            
            if pos then

                hudweaponselection:SetSlot( pos.slot )
                hudweaponselection:SetSlotPos( pos.pos )

            else

                hudweaponselection:SetSlot( 0 )
                hudweaponselection:SetSlotPos( 0 )
                valid_selection = false

            end

        else

            hudweaponselection:SetSlot( 0 )
            hudweaponselection:SetSlotPos( 0 )
            valid_selection = false

        end
        
        invalid_cache = false
    
    end

    -- update selection colouring
    if valid_selection then

        local weapon = localplayer:GetWeapon( hudweaponselection.weapons[ hudweaponselection.slot ][ hudweaponselection.pos ].class )
        local primary, secondary = weapon:GetPrimaryAmmoType(), weapon:GetSecondaryAmmoType()
        has_ammo = weapon:HasAmmo()
        hudweaponbucket:SetAmmo1Type( primary )
        hudweaponbucket:SetAmmo1( primary > 0 and ( localplayer:GetAmmoCount( primary ) / game.GetAmmoMax( primary ) ) or -1 )
        hudweaponbucket:SetAmmo2Type( secondary )
        hudweaponbucket:SetAmmo2( secondary > 0 and ( localplayer:GetAmmoCount( secondary ) / game.GetAmmoMax( secondary ) ) or -1 )
        hudweaponbucket:SetClip( primary > 0 and weapon:Clip1() or -1, weapon:GetMaxClip1() )
        hudweaponbucket:SetColor( has_ammo and settings.color or settings.color_empty )
        selectionpanel:SetColor( has_ammo and settings.background_color or settings.background_color_empty )

    end

    -- if automatic hiding is disabled, make the time never run out
    if not settings.autohide and not has_selected then
        
        time = CurTime()

    end

    -- run animations
    if time < CurTime() then

        alpha = math.max( alpha - FrameTime() / ( has_selected and FADEIN_TIME or FADEOUT_TIME ), 0 )

    else

        alpha = math.min( alpha + FrameTime() / FADEIN_TIME, 1 )

    end

    -- tick components
    hudweaponselection:PerformLayout()
    hudweaponbucket:Think()

    selectionpanel:SetPos( hudweaponselection.__x, hudweaponselection.__y )
    selectionpanel:Think()

end

---
--- Input
---
function ELEMENT:PlayAnimation()

    hudweaponbucket:SetAnimated( animated )
    selectionpanel:Close()
    selectionpanel:SetDeployed( true )
    selectionpanel.progress = hudweaponselection.smallbox_h / hudweaponselection.bigbox_h

end

function ELEMENT:FindActiveWeapon()

    local weapon = localplayer:GetActiveWeapon()

    if not IsValid( weapon ) then

        hudweaponselection:SetSlot( 0 )
        hudweaponselection:SetSlotPos( 0 )
        return
        
    end

    local pos = hudweaponselection:Find( weapon:GetClass() )
    if not pos then return end

    hudweaponselection:SetSlot( pos.slot )
    hudweaponselection:SetSlotPos( pos.pos )

    return true

end

function ELEMENT:MoveCursor( forward )

    valid_selection = false
    local last_class = hudweaponselection.weapons[ hudweaponselection.slot ] and hudweaponselection.weapons[ hudweaponselection.slot ][ hudweaponselection.pos ] and hudweaponselection.weapons[ hudweaponselection.slot ][ hudweaponselection.pos ].class
    
    if time < CurTime() then

        -- we don't have a valid starting position -- skip
        if not self:FindActiveWeapon() then return end

    end

    if not hudweaponselection.weapons[ hudweaponselection.slot ] then return end

    local selection

    repeat

        if forward then

            hudweaponselection:SetSlotPos( hudweaponselection.pos + 1 )

            if hudweaponselection.pos > #hudweaponselection.weapons[ hudweaponselection.slot ] then

                hudweaponselection:SetSlot( hudweaponselection.slot + 1 )
    
                if hudweaponselection.slot > 6 then
    
                    hudweaponselection:SetSlot( 1 )
    
                end
    
                hudweaponselection:SetSlotPos( 1 )
    
            end

        else

            hudweaponselection:SetSlotPos( hudweaponselection.pos - 1 )

            if hudweaponselection.pos < 1 then

                hudweaponselection:SetSlot( hudweaponselection.slot - 1 )
    
                if hudweaponselection.slot < 1 then
    
                    hudweaponselection:SetSlot( 6 )
    
                end
    
                hudweaponselection:SetSlotPos( #hudweaponselection.weapons[ hudweaponselection.slot ] )
    
            end

        end

        selection = hudweaponselection.weapons[ hudweaponselection.slot ][ hudweaponselection.pos ]

    until selection

    if last_class ~= selection.class then

        localplayer:EmitSound( move_sound, nil, move_pitch, volume, CHAN_WEAPON )
        self:PlayAnimation()

    end

    local weapon = localplayer:GetWeapon( selection.class )
    hudweaponbucket:SetWeapon( weapon )
    hudweaponbucket:SetHeader( hudweaponselection.slot )
    hudweaponbucket:SetDrawHeader( hudweaponselection.pos == 1 )
    valid_selection = true

    time = CurTime() + DELAY

end

function ELEMENT:CycleSlot( slot )

    valid_selection = false
    local last_class = hudweaponselection.weapons[ hudweaponselection.slot ] and hudweaponselection.weapons[ hudweaponselection.slot ][ hudweaponselection.pos ] and hudweaponselection.weapons[ hudweaponselection.slot ][ hudweaponselection.pos ].class
    local weapons = #hudweaponselection.weapons[ slot ]

    if weapons <= 0 then

        if time < CurTime() then

            localplayer:EmitSound( open_sound, nil, open_pitch, volume, CHAN_WEAPON )

        end
        
        hudweaponselection:SetSlot( 0 )
        valid_selection = false

        time = CurTime() + DELAY
        return

    end

    if time < CurTime() or hudweaponselection.slot ~= slot then

        localplayer:EmitSound( open_sound, nil, open_pitch, volume, CHAN_WEAPON )
        hudweaponselection:SetSlotPos( 0 )

    end

    hudweaponselection:SetSlot( slot )
    hudweaponselection:SetSlotPos( hudweaponselection.pos + 1 )

    if hudweaponselection.pos > weapons then

        hudweaponselection:SetSlotPos( 1 )

    end

    local class = hudweaponselection.weapons[ hudweaponselection.slot ][ hudweaponselection.pos ].class

    if last_class ~= class or time < CurTime() then
        
        if time >= CurTime() then

            localplayer:EmitSound( move_sound, nil, move_pitch, volume, CHAN_WEAPON )

        end

        self:PlayAnimation()

    end

    hudweaponbucket:SetWeapon( localplayer:GetWeapon( class ) )
    hudweaponbucket:SetHeader( hudweaponselection.slot )
    hudweaponbucket:SetDrawHeader( hudweaponselection.pos == 1 )
    valid_selection = true
    
    time = CurTime() + DELAY

end

UnintrusiveBindPress.add( "holohud2", function( ply, bind, pressed, code )

    if not HOLOHUD2.IsEnabled() or not HOLOHUD2.IsVisible() or not ELEMENT:IsVisible() then return end
    if hud_fastswitch:GetBool() then return end
    if startup_phase ~= STARTUP_NONE and ( bind == IN_INVNEXT or bind == IN_INVPREV ) then return true end
    if table.IsEmpty( cache ) or not ply:Alive() or ( ply:InVehicle() and not ply:GetAllowWeaponsInVehicle() ) then return end
    if not pressed then return end

    -- check whether the physics gun is in use
    local weapon = ply:GetActiveWeapon()
    if IsValid( weapon ) and weapon:GetClass() == WEAPON_PHYSGUN and ply:KeyDown( IN_ATTACK ) and ( bind == IN_INVPREV or bind == IN_INVNEXT ) then return true end

    -- move forward
    if bind == IN_INVNEXT then
        
        ELEMENT:MoveCursor( true )
        has_selected = false

        return true

    end

    -- move backwards
    if bind == IN_INVPREV then

        ELEMENT:MoveCursor( false )
        has_selected = false

        return true

    end

    -- cycle slot
    if string.sub( bind, 1, 4 ) == IN_SLOT then
        
        local slot = tonumber( string.sub( bind, 5, 6 ) )

        if slot < 1 or slot > 6 then return end

        ELEMENT:CycleSlot( slot )
        has_selected = false

        return true

    end

    if time < CurTime() then return end

    -- select
    if bind == IN_SELECT then

        local class = hudweaponselection.weapons[ hudweaponselection.slot ] and hudweaponselection.weapons[ hudweaponselection.slot ][ hudweaponselection.pos ] and hudweaponselection.weapons[ hudweaponselection.slot ][ hudweaponselection.pos ].class
        
        if class then
            
            input.SelectWeapon( localplayer:GetWeapon( class ) )

        end

        localplayer:EmitSound( select_sound, nil, select_pitch, volume, CHAN_WEAPON )
        time = 0
        has_selected = true

        return true

    end

    -- cancel
    if bind == IN_CANCEL then

        localplayer:EmitSound( cancel_sound, nil, cancel_pitch, volume, CHAN_WEAPON )
        time = 0
        has_selected = true

        return true

    end

end)

---
--- Paint
---
function ELEMENT:PaintFrame( settings, x, y )

    if alpha <= 0 then return end

    StartAlphaMultiplier( alpha )
    hudweaponselection:PaintFrame( x, y )
    
    if valid_selection then

        selectionpanel:PaintFrame( x, y )

    end

    EndAlphaMultiplier()

end

function ELEMENT:PaintBackground( settings, x, y )

    if alpha <= 0 then return end

    StartAlphaMultiplier( alpha )
    hudweaponselection:PaintBackground( x, y )

    if valid_selection then
        
        selectionpanel:PaintBackground( x, y )

    end

    EndAlphaMultiplier()

end

function ELEMENT:Paint( settings, x, y )

    if alpha <= 0 then return end

    StartAlphaMultiplier( alpha )
    hudweaponselection:Paint( x, y )

    if valid_selection then
        
        selectionpanel:Paint( x, y )

    end

    EndAlphaMultiplier()

end

function ELEMENT:PaintScanlines( settings, x, y )

    if alpha <= 0 then return end
    
    StartAlphaMultiplier( GetMinimumGlow() * alpha )

    if valid_selection and has_ammo then
        
        selectionpanel:Paint( x, y )

    end

    hudweaponselection:Paint( x, y )

    EndAlphaMultiplier()

end

---
--- Preview
---
local PREVIEW_FONTS = { "slot_font", "name_font", "selection_name_font" }
local preview_hudweaponselection = HOLOHUD2.component.Create( "HudWeaponSelection" )
local preview_hudweaponbucket = HOLOHUD2.component.Create( "HudWeaponBucket" )

preview_hudweaponselection:SetDrawBlur( false )
preview_hudweaponselection:SetBucket( 1, 1, true )
preview_hudweaponselection:SetBucket( 1, 2, true )
preview_hudweaponselection:SetBucket( 2, 1, true )
preview_hudweaponselection:SetBucket( 3, 1, true )
preview_hudweaponselection:SetBucket( 3, 2, false, language.GetPhrase( "#HL2_Pulse_Rifle" ) )
preview_hudweaponselection:SetBucket( 4, 1, false )
preview_hudweaponselection:SetBucket( 6, 1, true )
preview_hudweaponselection:SetBucket( 6, 2, true )

preview_hudweaponselection:SetSlot( 3 )
preview_hudweaponselection:SetSlotPos( 1 )

preview_hudweaponbucket:SetClass( "weapon_smg1" )
preview_hudweaponbucket:SetName( language.GetPhrase( "#HL2_SMG1" ) )
preview_hudweaponbucket:SetAmmo1( .7 )
preview_hudweaponbucket:SetAmmo1Type( 4 )
preview_hudweaponbucket:SetAmmo2( .3 )
preview_hudweaponbucket:SetAmmo2Type( 9 )
preview_hudweaponbucket:SetClip( 30, 45 )

function ELEMENT:PreviewInit( panel )

    local controls = vgui.Create( "Panel", panel )
    controls:SetSize( 96, 94 )
    controls:SetPos( 4, panel:GetTall() - controls:GetTall() - 4 )

    local open = vgui.Create( "DButton", controls )
    open:Dock( TOP )
    open:DockMargin( 0, 0, 0, 2 )
    open:SetText( "#holohud2.weaponselection.preview.open" )
    open:SetImage( "icon16/sound.png" )
    open.DoClick = function()

        LocalPlayer():EmitSound( open_sound, nil, open_pitch, volume )

    end

    local move = vgui.Create( "DButton", controls )
    move:Dock( TOP )
    move:DockMargin( 0, 0, 0, 2 )
    move:SetText( "#holohud2.weaponselection.preview.move" )
    move:SetImage( "icon16/sound.png" )
    move.DoClick = function()

        LocalPlayer():EmitSound( move_sound, nil, move_pitch, volume )

    end

    local select = vgui.Create( "DButton", controls )
    select:Dock( TOP )
    select:DockMargin( 0, 0, 0, 2 )
    select:SetText( "#holohud2.weaponselection.preview.select" )
    select:SetImage( "icon16/sound.png" )
    select.DoClick = function()

        LocalPlayer():EmitSound( select_sound, nil, select_pitch, volume )

    end

    local cancel = vgui.Create( "DButton", controls )
    cancel:Dock( TOP )
    cancel:SetText( "#holohud2.weaponselection.preview.cancel" )
    cancel:SetImage( "icon16/sound.png" )
    cancel.DoClick = function()

        LocalPlayer():EmitSound( cancel_sound, nil, cancel_pitch, volume )

    end

end

function ELEMENT:PreviewPaint( x, y, w, h, settings )

    local scale = HOLOHUD2.scale.Get()

    x = x + w / 2 - ( settings.bucket_size.x * 5 + settings.selection_size.x + settings.bucket_margin * 6 ) * scale / 2
    y = y + h / 2 - ( settings.bucket_size.y + settings.selection_size.y + settings.bucket_margin ) * scale / 2

    preview_hudweaponselection:PerformLayout()
    preview_hudweaponselection:PaintFrame( x, y )
    preview_hudweaponselection:PaintBackground( x, y )
    preview_hudweaponselection:Paint( x, y )

    local x, y = x + preview_hudweaponselection.__x * scale, y + preview_hudweaponselection.__y * scale
    local w, h = settings.selection_size.x * scale, settings.selection_size.y * scale

    draw.RoundedBox( 0, x, y, w, h, settings.background_color )

    preview_hudweaponbucket:Think()
    preview_hudweaponbucket:PaintBackground( x, y )
    preview_hudweaponbucket:Paint( x, y )

end

function ELEMENT:OnPreviewChanged( settings )

    for _, font in ipairs( PREVIEW_FONTS ) do

        HOLOHUD2.font.Register( self.preview_fonts[ font ], settings[ font ] )
        HOLOHUD2.font.Create( self.preview_fonts[ font ] )

    end

    preview_hudweaponselection:ApplySettings( settings, self.preview_fonts )
    preview_hudweaponbucket:ApplySettings( settings, self.preview_fonts )
    preview_hudweaponselection:SetPos( 0, 0 )
    preview_hudweaponbucket:SetColor( settings.color )

end

---
--- Apply changes
---
function ELEMENT:OnSettingsChanged( settings )

    selectionpanel:SetSize( settings.selection_size.x, settings.selection_size.y )
    selectionpanel:SetDrawBackground( settings.background )
    selectionpanel:SetColor( settings.background_color )
    selectionpanel:SetAnimation( settings.animation )
    selectionpanel:SetDeployed( true )

    hudweaponselection:ApplySettings( settings, self.fonts )
    hudweaponbucket:ApplySettings( settings, self.fonts )

    animated = settings.selection_animated
    volume = settings.sound_volume / 100
    move_sound, move_pitch = settings.sound_move_path, settings.sound_move_pitch
    select_sound, select_pitch = settings.sound_select_path, settings.sound_select_pitch
    cancel_sound, cancel_pitch = settings.sound_cancel_path, settings.sound_cancel_pitch
    open_sound, open_pitch = settings.sound_open_path, settings.sound_open_pitch

end

---
--- Screen size changed
---
function ELEMENT:OnScreenSizeChanged()

    hudweaponselection:InvalidateLayout()
    hudweaponbucket:InvalidateLayout()

end

HOLOHUD2.element.Register( "weaponselection", ELEMENT )

---
--- Export components
---
ELEMENT.components = {
    hudweaponselection  = hudweaponselection,
    hudweaponbucket     = hudweaponbucket
}

---
--- Add common parameters to modifiers
---
HOLOHUD2.modifier.Add( "panel_animation", "weaponselection", "animation" )
HOLOHUD2.modifier.Add( "background_color", "weaponselection", "background_color" )
HOLOHUD2.modifier.Add( "color", "weaponselection", "color" )
HOLOHUD2.modifier.Add( "color2", "weaponselection", { "slot_color", "selection_ammo_color2" } )
HOLOHUD2.modifier.Add( "number3_font", "weaponselection", { "slot_font", "selection_clip_font" } )
HOLOHUD2.modifier.Add( "number3_offset", "weaponselection", "slot_pos" )
HOLOHUD2.modifier.Add( "text_font", "weaponselection", { "selection_name_font", "name_font" } )
HOLOHUD2.modifier.Add( "text_pos", "weaponselection", { "selection_name_pos", "name_pos" } )
HOLOHUD2.modifier.Add( "text_pos", "weaponselection", { "selection_name_pos", "name_pos" } )

---
--- Presets
---
HOLOHUD2.presets.Register( "weaponselection", "element/weaponselection" )
HOLOHUD2.presets.Add( "weaponselection", "Alternate - Default Sounds", {
    sound_move_path     = "common/wpn_moveselect.wav",
    sound_move_pitch    = 100,
    sound_select_path   = "common/wpn_select.wav",
    sound_select_pitch  = 100,
    sound_cancel_path   = "common/wpn_hudoff.wav",
    sound_cancel_pitch  = 100,
    sound_open_path     = "common/wpn_moveselect.wav",
    sound_open_pitch    = 100
} )