local render = render
local surface = surface

local BaseClass = HOLOHUD2.component.Get( "Bar" )

local COMPONENT = {}

function COMPONENT:SetParent( parent )

    self.parent = parent

end

function COMPONENT:Paint( x, y )

    if not self.visible then return end

    local parent = self.parent

    surface.SetDrawColor( 255, 255, 255 )

    render.SetStencilWriteMask( 0xFF )
    render.SetStencilTestMask( 0xFF )
    render.SetStencilReferenceValue( 0 )
    render.SetStencilPassOperation( STENCIL_KEEP )
    render.SetStencilZFailOperation( STENCIL_KEEP )
    render.ClearStencil()

    render.SetStencilEnable( true )
    render.SetStencilReferenceValue( 1 )
    render.SetStencilCompareFunction( STENCIL_NEVER )
    render.SetStencilFailOperation( STENCIL_REPLACE )

    surface.DrawRect( x + self._x0, y + self._y0, self._x1 - self._x0, self._y1 - self._y0 )

    if self.parent then

        render.SetStencilCompareFunction( STENCIL_NEVER )
        render.SetStencilFailOperation( STENCIL_ZERO )

        surface.DrawRect( x + parent._x0, y + parent._y0, parent._x1 - parent._x0, parent._y1 - parent._y0 )

    end

    render.SetStencilCompareFunction( STENCIL_EQUAL )
    render.SetStencilFailOperation( STENCIL_KEEP )

    BaseClass.Paint( self, x, y )

    render.SetStencilEnable( false )

end

HOLOHUD2.component.Register( "DamageBar", COMPONENT, "ProgressBar" )