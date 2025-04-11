local surface = surface
local scale_Get = HOLOHUD2.scale.Get

local COMPONENT = {
    gunlicense_invalidlayout    = false,
    has_gunlicense              = false,
    gunlicense                  = true,
    gunlicense_x                = 0,
    gunlicense_y                = 0,
    gunlicense_size             = 32,
    gunlicense_alpha            = 255,
    _gunlicense_x               = 0,
    _gunlicense_y               = 0,
    _gunlicense_size            = 32
}

local RESOURCE_GUNLICENSE = Material( "icon16/page.png" )

function COMPONENT:Init()

    self.Job = HOLOHUD2.component.Create( "Text" )
    self.Currency = HOLOHUD2.component.Create( "Text" )
    self.Salary = HOLOHUD2.component.Create( "Number" )

end

function COMPONENT:InvalidateLayout()

    self.Job:InvalidateLayout()
    self.Currency:InvalidateLayout()
    self.Salary:InvalidateLayout()
    self.gunlicense_invalidlayout = true

end

function COMPONENT:SetJob( job )

    self.Job:SetText( job )

end

function COMPONENT:SetSalary( salary )

    self.Salary:SetValue( salary )

end

function COMPONENT:SetGunLicense( gunlicense )

    self.has_gunlicense = gunlicense

end

function COMPONENT:Think()

    self.Job:PerformLayout()
    self.Currency:PerformLayout()
    self.Salary:PerformLayout()

    if not self.gunlicense_invalidlayout then return end

    local scale = scale_Get()
    self._gunlicense_x = math.Round( self.gunlicense_x * scale )
    self._gunlicense_y = math.Round( self.gunlicense_y * scale )
    self._gunlicense_size = math.Round( self.gunlicense_size * scale )

end

function COMPONENT:PaintBackground( x, y )

    self.Salary:PaintBackground( x, y )

    if not self.gunlicense or not self.has_gunlicense then return end
    
    surface.SetMaterial( RESOURCE_GUNLICENSE )
    surface.SetDrawColor( 255, 255, 255, self.gunlicense_alpha )
    surface.DrawTexturedRect( x + self._gunlicense_x, y + self._gunlicense_y, self._gunlicense_size, self._gunlicense_size )

end

function COMPONENT:Paint( x, y )

    self.Job:Paint( x, y )
    self.Currency:Paint( x, y )
    self.Salary:Paint( x, y )

end

function COMPONENT:ApplySettings( settings, fonts )

    local job = self.Job
    job:SetVisible( settings.job )
    job:SetPos( settings.job_pos.x, settings.job_pos.y )
    job:SetColor( settings.job_color )
    job:SetFont( fonts.job_font )
    job:SetAlign( settings.job_align )

    local currency = self.Currency
    currency:SetVisible( settings.currency and settings.number )
    currency:SetPos( settings.currency_pos.x, settings.currency_pos.y )
    currency:SetFont( fonts.currency_font )
    currency:SetColor( settings.salary_color )
    currency:SetText( settings.currency_text )

    local number = self.Salary
    number:SetVisible( settings.number )
    number:SetPos( settings.number_pos.x, settings.number_pos.y )
    number:SetFont( fonts.number_font )
    number:SetColor( settings.salary_color )
    number:SetColor2( settings.salary_color2 )
    number:SetRenderMode( settings.number_rendermode )
    number:SetBackground( settings.number_background )
    number:SetAlign( settings.number_align )
    number:SetDigits( settings.number_digits )

    self.gunlicense = settings.gunlicense
    self.gunlicense_x = settings.gunlicense_pos.x
    self.gunlicense_y = settings.gunlicense_pos.y
    self.gunlicense_size = settings.gunlicense_size
    self.gunlicense_alpha = settings.gunlicense_alpha
    self.gunlicense_invalidlayout = true

end

HOLOHUD2.component.Register( "DarkRP_HudJob", COMPONENT )