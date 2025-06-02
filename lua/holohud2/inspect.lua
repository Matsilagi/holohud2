local gui = gui
local vgui = vgui
local input = input
local IsValid = IsValid
local LocalPlayer = LocalPlayer
local CurTime = CurTime
local hook_Call = HOLOHUD2.hook.Call

local inspect_key = CreateClientConVar( "holohud2_inspect_key", KEY_C, true, false, "What key is used to show all the HUD panels." )
local hideonweaponinspect = CreateClientConVar( "holohud2_hideonweaponinspect", 1, true, false, "Hides the HUD when inspecting a weapon.", 0, 1 )

local inspect_time = 0

---
--- Inspect HUD when pressing a key.
---
HOLOHUD2.hook.Add( "IsInspectingHUD", "inspect", function()
    
    if inspect_time > CurTime() then return true end

    if gui.IsGameUIVisible() or vgui.GetKeyboardFocus() then return end

    local key = inspect_key:GetInt()

    if key == KEY_NONE or not input.IsKeyDown( key ) then return end

    inspect_time = CurTime() + 4

    return true

end)

---
--- Inspect HUD with a console command.
---
concommand.Add( "holohud2_inspect", function()
    
    inspect_time = CurTime() + 4
    
end)

---
--- Inspecting a weapon makes the HUD minimize.
---
local localplayer
HOLOHUD2.hook.Add( "IsMinimized", "inspect", function()

    if not hideonweaponinspect:GetBool() then return end

    localplayer = localplayer or LocalPlayer()
    local weapon = localplayer:GetActiveWeapon()

    if not IsValid( weapon ) or not hook_Call( "IsInspectingWeapon", weapon ) then return end

    return true

end)
