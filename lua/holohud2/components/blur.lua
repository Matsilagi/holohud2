local FrameTime = FrameTime

local SCANLINES_NONE = HOLOHUD2.SCANLINES_NONE

local minglow       = CreateClientConVar( "holohud2_draw_minglow", .2, true, false, "Minimum amount of idle glow.", 0, 1 )
local scanlines     = GetConVar( "holohud2_r_scanlines" )

local COMPONENT = {
    enabled     = true,
    bright_time = .1,
    dim_time    = 2,
    active      = false,
    amount      = 0
}

function COMPONENT:SetEnabled( enabled )

    self.enabled = enabled

end

function COMPONENT:SetBrightTime( time )

    self.bright_time = time

end

function COMPONENT:SetDimTime( time )

    self.dim_time = time

end

function COMPONENT:Activate()

    if not self.enabled then return end

    self.active = true

end

function COMPONENT:GetAmount()

    if not scanlines:GetBool() then return self.amount end

    local glow = minglow:GetFloat()
    return glow + self.amount * ( 1 - glow )

end

function COMPONENT:Think()

    if not self.enabled then return end

    local delta = FrameTime()

    if self.active then

        self.amount = math.min(self.amount + delta / self.bright_time, 1)

        if self.amount >= 1 then self.active = false end

    else

        self.amount = math.max(self.amount - delta / self.dim_time, 0)

    end

end

function HOLOHUD2.render.GetMinimumGlow()

    if not scanlines:GetBool() then return 0 end

    return minglow:GetFloat()

end

HOLOHUD2.component.Register( "Blur", COMPONENT )