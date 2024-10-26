function CreateAlias(key, action) {
    SendToConsole(format("alias \"%s\" \"%s\"", key, action))
    SendToConsole(format("setinfo %s \"\"", key))
    dev.info("The alias \"" + key + "\" was created")
}

::binds <- {}
function bind(key, action) {
    if(key == "") return
    SendToConsole(format("bind \"%s\" \"%s\"", key, action))
    binds[key] <- action
}

function _getBinds() {
    local message = ""
    foreach(bind, action in binds) 
        message += bind + " - " + action + "\n"
    
    return message
}


function Help() {
    local helpText = ""

    helpText += "\n\n----- P2-KeyCam Help -----\n\n"
    helpText += "P2-KeyCam is a Portal 2 modification that allows you to control the camera and record keyframes to create cinematic sequences and analyze gameplay.\n\n"

    helpText += "----- Available Functions -----\n\n"
    helpText += "Keyframe Management:\n"
    helpText += "  - AddFrame(): Adds a new keyframe at the player's current position.\n"
    helpText += "  - DeleteFrame(idx:int): Removes a keyframe by index.\n"
    helpText += "  - DeleteLastFrame(): Removes the last keyframe in the current profile.\n"
    helpText += "  - ClearFrames(): Clears all keyframes in the current profile.\n\n"

    helpText += "Profile Management:\n"
    helpText += "  - CreateProfile(): Creates a new camera profile and sets it as active.\n"
    helpText += "  - SwitchProfile(): Switches to the next profile in the list.\n"
    helpText += "  - DeleteProfile(idx:int): Deletes a specific profile by index.\n"
    helpText += "  - ClearProfiles(): Clears all profiles and creates a new default profile.\n\n"

    helpText += "Playback Control:\n"
    helpText += "  - PlayCurrentProfile(): Plays the current profile's keyframes in sequence.\n"
    helpText += "  - PlayAllProfiles(): Plays all profiles consecutively.\n"
    helpText += "  - StopPlayback(): Stops playback and restores HUD elements.\n\n"

    helpText += "Settings:\n"
    helpText += "  - SetSpeed(units:float): Sets the camera movement speed for the current profile.\n"
    helpText += "  - SetSpeedEx(units:float): Sets the camera movement speed for all profiles.\n"
    helpText += "  - GetSpeed(): Returns the current profile's speed.\n"
    helpText += "  - SetLerp(lerpFunc:function): Sets the interpolation function (lerp) for smooth transitions.\n"
    helpText += "  - GetLerp(): Returns the current interpolation method as a string.\n\n"

    helpText += "Export/Import:\n"
    helpText += "  - Export(name:string=\"test\"): Exports all profiles to a file named \"demo_export_<name>.log\".\n"
    helpText += "  - Import(name:string=\"test\"): Imports profiles from a file named \"demo_export_<name>.log\".\n"

    printl(helpText)
    helpText = ""

    helpText += "----- Keyframe Editor -----\n\n"
    helpText += "1. Select a Keyframe: Aim your crosshair at the keyframe you want to edit and press the bound key for \"KeyCam_EditFrame\".\n"
    helpText += "2. Navigation: Use WASD keys for forward/backward and left/right movement. Use the crouch key (Ctrl) for up/down movement. Spacebar inverts the up/down controls.\n"
    helpText += "3. Mode Switching: Press the primary fire key (Mouse1) to toggle between editing camera position and angles.\n"
    helpText += "4. Exit Editing: Press the secondary fire key (Mouse2) to exit the editor.\n\n"

    helpText += "----- How to Use Functions -----\n\n"
    helpText += "To use a function, type \"script <function_name>(<arguments>)\" in the console.\n"
    helpText += "For example, to add a new keyframe, type \"script AddFrame()\" in the console.\n\n"

    helpText += "----- User Binds -----\n\n"

    printl(helpText)
    printl(_getBinds())
}
