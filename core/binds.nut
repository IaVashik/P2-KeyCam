macros.CreateCommand(   "KeyCam_AddKeyframe",        "script AddFrame()")
macros.CreateCommand(   "KeyCam_DeleteLastKey",      "script DeleteLastFrame()")
macros.CreateCommand(   "KeyCam_ClearFrames",        "script ClearFrames()")

macros.CreateCommand(   "KeyCam_PlayCurrentProfile", "script PlayCurrentProfile()")
macros.CreateCommand(   "KeyCam_PlayAllProfiles",    "script PlayAllProfiles()")
macros.CreateCommand(   "KeyCam_StopPlayback",       "script StopPlayback()")

macros.CreateCommand(   "KeyCam_CreatePreset",       "script CreateProfile()")
macros.CreateCommand(   "KeyCam_SwitchProfile",      "script SwitchProfile()")
macros.CreateCommand(   "KeyCam_ClearProfiles",      "script ClearProfiles()")

macros.CreateCommand(   "KeyCam_EditFrame",          "script TryChangeFrame()")

macros.CreateCommand(   "KeyCam_HideHud",            "crosshair 0; net_graph 0; developer 0; r_drawviewmodel 0")
macros.CreateCommand(   "KeyCam_ShowHud",            "crosshair 1; net_graph 1; developer 1; r_drawviewmodel 1")
macros.CreateCommand(   "help_KeyCam",               "script Help()")
macros.CreateCommand(   "KeyCam_Meow",               "echo Meow, meow ^-^")


::binds <- []
function bind(key, action) {
    if(key == "") return
    SendToConsole(format("bind \"%s\" \"%s\"", key, action))
    binds.append([key, action]) 
}

function _getBinds() {
    local message = ""
    foreach(kv in binds) 
        message += kv[0] + " - " + kv[1].slice(7) + "\n"
    
    return message
}


function Help() {
    local helpText = ""

    printl("\n\n----- P2-KeyCam Help -----\n")
    printl("P2-KeyCam is a Portal 2 modification that allows you to control the camera and record keyframes to create cinematic sequences and analyze gameplay.\n")

    printl("----- Available Functions -----\n")
    printl("Keyframe Management:")
    printl("  - AddFrame(): Adds a new keyframe at the player's current position.")
    printl("  - DeleteFrame(idx:int): Removes a keyframe by index.")
    printl("  - DeleteLastFrame(): Removes the last keyframe in the current profile.")
    printl("  - ClearFrames(): Clears all keyframes in the current profile.\n")

    printl("Profile Management:")
    printl("  - CreateProfile(): Creates a new camera profile and sets it as active.")
    printl("  - SwitchProfile(): Switches to the next profile in the list.")
    printl("  - DeleteProfile(idx:int): Deletes a specific profile by index.")
    printl("  - ClearProfiles(): Clears all profiles and creates a new default profile.\n")

    printl("Playback Control:")
    printl("  - PlayCurrentProfile(): Plays the current profile's keyframes in sequence.")
    printl("  - PlayAllProfiles(): Plays all profiles consecutively.")
    printl("  - StopPlayback(): Stops playback and restores HUD elements.\n")

    printl("Settings:")
    printl("  - SetSpeed(units:float): Sets the camera movement speed for the current profile.")
    printl("  - SetSpeedEx(units:float): Sets the camera movement speed for all profiles.")
    printl("  - GetSpeed(): Returns the current profile's speed.")
    printl("  - SetLerp(lerpFunc:function): Sets the interpolation function (lerp) for smooth transitions.")
    printl("  - GetLerp(): Returns the current interpolation method as a string.\n")

    printl("Export/Import:")
    printl("  - Export(name:string=\"test\"): Exports all profiles to a file named \"demo_export_<name>.log\".")
    printl("  - Import(name:string=\"test\"): Imports profiles from a file named \"demo_export_<name>.log\".")

    printl("----- Keyframe Editor -----\n")
    printl("1. Select a Keyframe: Aim your crosshair at the keyframe you want to edit and press the bound key for \"KeyCam_EditFrame\".")
    printl("2. Navigation: Use WASD keys for forward/backward and left/right movement. Use the crouch key (Ctrl) for up/down movement. Spacebar inverts the up/down controls.")
    printl("3. Mode Switching: Press the primary fire key (Mouse1) to toggle between editing camera position and angles.")
    printl("4. Exit Editing: Press the secondary fire key (Mouse2) to exit the editor.\n")

    printl("----- How to Use Functions -----\n")
    printl("To use a function, type \"script <function_name>(<arguments>)\" in the console.")
    printl("For example, to add a new keyframe, type \"script AddFrame()\" in the console.\n")

    printl("----- User Binds -----\n")

    printl(_getBinds())
}
