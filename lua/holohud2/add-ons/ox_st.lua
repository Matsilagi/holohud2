---
--- Oxygen and Stamina System (And Flashlight Battery).
--- https://steamcommunity.com/sharedfiles/filedetails/?id=2358652168%22
---

if SERVER then return end

if not _G.OXST then return end

local IsEnabled = HOLOHUD2.IsEnabled
local element_stamina = HOLOHUD2.element.Get( "stamina" )
local element_oxygen = HOLOHUD2.element.Get( "oxygen" )
local element_flashlight = HOLOHUD2.element.Get( "flashlight" )

local cvar_flashlight = GetConVar( "sv_flashlight_enablebattery" )
local cvar_maxflashlight = GetConVar( "sv_flashlight_maxbattery" )
local cvar_hideflashlight = GetConVar( "cl_flashlight_hudhide" )

local cvar_oxygen = GetConVar( "sv_oxygen_enable" )
local cvar_maxoxygen = GetConVar( "sv_oxygen_maxoxygen" )
local cvar_hideoxygen = GetConVar( "cl_oxygen_hudhide" )

local cvar_stamina = GetConVar( "sv_stamina_enable" )
local cvar_maxstamina = GetConVar( "sv_stamina_maxstamina" )
local cvar_hidestamina = GetConVar( "cl_stamina_hudhide" )

hook.Add( "FlashlightHUDPaint", "holohud2", function( x, y, w, h, timesincenotfull )

    if not IsEnabled() or not element_flashlight:IsVisible() then return end
    
    return true
      
end )

HOLOHUD2.hook.Add( "ShouldDrawFlashlight", "ox_st", function()

	if not cvar_flashlight:GetBool() or (cvar_hideflashlight:GetBool() and GetLocalFlashlightBattery() >= cvar_maxflashlight:GetInt()) then return end
	
	return true

end )

HOLOHUD2.hook.Add( "GetFlashlight", "ox_st", function()

	if not cvar_flashlight:GetBool() then return end

    return GetLocalFlashlightBattery() / cvar_maxflashlight:GetInt() * 100
  
end )

hook.Add( "OxygenHUDPaint", "holohud2", function( x, y, w, h, timesincenotfull )

    if not IsEnabled() or not element_oxygen:IsVisible() then return end
    
    return true
    
end )

HOLOHUD2.hook.Add( "ShouldDrawOxygen", "ox_st", function()

	if not cvar_oxygen:GetBool() or (cvar_hideoxygen:GetBool() and GetLocalOxygen() >= cvar_maxoxygen:GetInt()) then return end
	
	return true

end )

HOLOHUD2.hook.Add( "GetOxygen", "ox_st", function()

	if not cvar_oxygen:GetBool() then return end

    return GetLocalOxygen() / cvar_maxoxygen:GetInt() * 100
  
end )

hook.Add( "StaminaHUDPaint", "holohud2", function( x, y, w, h, timesincenotfull )

    if not IsEnabled() or not element_stamina:IsVisible() then return end
    
    return true
    
end )

HOLOHUD2.hook.Add( "ShouldDrawStamina", "ox_st", function()

	if not cvar_stamina:GetBool() or (cvar_hidestamina:GetBool() and GetLocalStamina() >= cvar_maxstamina:GetInt()) then return end
	
	return true

end )

HOLOHUD2.hook.Add( "GetStamina", "ox_st", function()

	if not cvar_stamina:GetBool() then return end

    return GetLocalStamina() / cvar_maxstamina:GetInt() * 100
  
end )