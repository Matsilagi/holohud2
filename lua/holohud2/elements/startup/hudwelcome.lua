local CurTime = CurTime

local StartAlphaMultiplier = HOLOHUD2.render.StartAlphaMultiplier
local EndAlphaMultiplier = HOLOHUD2.render.EndAlphaMultiplier
local GetMinimumGlow = HOLOHUD2.render.GetMinimumGlow

local COMPONENT = {}

function COMPONENT:Init()

    self.Title = HOLOHUD2.component.Create( "Text" )
    self.Version = HOLOHUD2.component.Create( "Text" )

    local separator = HOLOHUD2.component.Create( "Separator" )
    separator:SetDrawAsRectangle( true )
    self.Separator = separator

    local messagebox = HOLOHUD2.component.Create( "MessageLog" )
    messagebox:SetLetterRate( .028 )
    self.MessageBox = messagebox

end

function COMPONENT:InvalidateLayout()

    self.Title:InvalidateLayout()
    self.Version:InvalidateLayout()
    self.Separator:InvalidateLayout()
    self.MessageBox:InvalidateLayout()

end

function COMPONENT:AddMessage( text )

    return self.MessageBox:AddMessage( text )

end

function COMPONENT:AddSpacer()

    self.MessageBox:AddMessage( "", color_black, color_black, "" )

end

function COMPONENT:AddDeferredMessage( loading, success, time )

    local message, duration = self.MessageBox:AddMessage( loading )
    message.deferred = true
    message.success = success

    if time then

        message.time = CurTime() + time

    end

    return message, duration

end

function COMPONENT:Clear()

    self.MessageBox:Purge()

end


local SPINNER = { "/", "-", "\\", "|" }

local cur = 1 -- current spinner frame
local next = 0

function COMPONENT:Think()

    local curtime = CurTime()

    -- run spinner animation
    if next < curtime then

        cur = cur + 1

        if cur > #SPINNER then

            cur = 1

        end

        next = curtime + .1

    end

    self.Title:PerformLayout()
    self.Version:PerformLayout()
    self.Separator:PerformLayout()
    self.MessageBox:Think()

    -- check for loading animations
    for i=1, #self.MessageBox.messages do

        local message = self.MessageBox.messages[ i ]

        if not message.deferred then continue end

        message.bullet = SPINNER[ cur ]

        if not message.time then continue end

        if message.time < curtime then

            self.MessageBox:SetMessage( i, message.success, nil, nil, ">" )
            message.deferred = false

        end

    end

end

function COMPONENT:Paint( x, y )

    self.Title:Paint( x, y )
    self.Version:Paint( x, y )
    self.Separator:Paint( x, y )
    self.MessageBox:Paint( x, y )

end

function COMPONENT:PaintScanlines( x, y )

    StartAlphaMultiplier( GetMinimumGlow() )
    self:Paint( x, y )
    EndAlphaMultiplier()

end

function COMPONENT:ApplySettings( settings, fonts )

    self.Title:SetVisible( settings.title )
    self.Title:SetPos( settings.title_pos.x, settings.title_pos.y )
    self.Title:SetFont( fonts.title_font )
    self.Title:SetColor( settings.tint )

    if utf8.len( settings.title_override ) == 0 then

        self.Title:SetText( HOLOHUD2.CodeName )

    else

        self.Title:SetText( settings.title_override )

    end

    self.Version:SetVisible( settings.version )
    self.Version:SetPos( settings.version_pos.x, settings.version_pos.y )
    self.Version:SetFont( fonts.version_font )
    self.Version:SetColor( settings.tint )

    if utf8.len( settings.version_override ) == 0 then

        self.Version:SetText( string.format( "V %s.%s" , HOLOHUD2.Version, os.date( "%y%m%d", HOLOHUD2.Date ) ) )

    else

        self.Version:SetText( settings.version_override )

    end

    self.Separator:SetVisible( settings.separator )
    self.Separator:SetPos( settings.separator_pos.x, settings.separator_pos.y )
    self.Separator:SetSize( settings.separator_size.x, settings.separator_size.y )
    self.Separator:SetColor( settings.tint )

    self.MessageBox:SetPos( settings.messages_pos.x, settings.messages_pos.y )
    self.MessageBox:SetSize( settings.messages_size.x, settings.messages_size.y )
    self.MessageBox:SetFont( fonts.messages_font )
    self.MessageBox:SetColor( settings.messages_color )
    self.MessageBox:SetSpacing( settings.messages_spacing )
    self.MessageBox:SetMargin( settings.messages_margin )
    self.MessageBox:SetColor2( settings.tint )
    
    self:InvalidateLayout()

end

HOLOHUD2.component.Register( "HudWelcome", COMPONENT )