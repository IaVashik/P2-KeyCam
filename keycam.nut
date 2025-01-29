IncludeScript("P2-KeyCam/PCapture-Lib") // I LOVE U!

IncludeScript("P2-KeyCam/core/keyframes.nut")
IncludeScript("P2-KeyCam/core/profile.nut")
IncludeScript("P2-KeyCam/core/editor")
IncludeScript("P2-KeyCam/core/binds")

IncludeScript("P2-KeyCam/ui/viewer")
IncludeScript("P2-KeyCam/ui/screeninfo")


if("profiles" in getroottable()) {
    return dev.error("KeyCam is currently active and does'n require reinitialization!")
}

/******************************************************************************
*                                     INIT
******************************************************************************/

// Create a camera entity
camera <- entLib.CreateByClassname("point_viewcontrol", {targetname = "camera"})

// Create a game UI entity with specific properties
gameui <- createGameUi()

// Define global variables for managing profiles and settings
::profiles <- List()
::currentProfile <- null
::globalSpeed <- 1
::isPlaying <- false

// Initialize KeyCam and setup the main player view and HUD
function Init() {
    ::playerEx <- GetPlayerEx()
    CreateProfile() // Create an initial camera profile

    SendToConsole("sv_alternateticks 0")
    StartDrawFrames() // Begin the process to draw frames onto the HUD
    UpdateHudInfo()
}

ScheduleEvent.Add("global", Init, 0.2)

/******************************************************************************
*                            KEYFRAME MANAGEMENT
******************************************************************************/

// Add a new keyframe at the player's current position
function AddFrame() {
    if(isPlaying) return

    local origin = playerEx.EyePosition()
    local angles = playerEx.EyeAngles()
    local forward = playerEx.EyeForwardVector()
    local key = KeyFrame(origin, angles, forward)

    currentProfile.AddFrame(key)
    UpdateHudInfo()
}

// Remove a keyframe by index
function DeleteFrame(idx) {
    currentProfile.RemoveFrame(idx)
    UpdateHudInfo()
}

// Remove the last keyframe in the current profile
function DeleteLastFrame() {
    if(isPlaying) return
    currentProfile.keyframes.pop()
    UpdateHudInfo()
}

// Clear all keyframes in the current profile
function ClearFrames() {
    currentProfile.ClearFrames()
    UpdateHudInfo()
}

/******************************************************************************
*                                  SETTERS
******************************************************************************/

// Set the camera movement speed for the current profile
function SetSpeed(units) {
    if(isPlaying) return

    globalSpeed = units;
    currentProfile.cameraSpeed = units;
    UpdateHudInfo()
}

// Set camera speed for all profiles
function SetSpeedEx(units) {
    if(isPlaying) return

    globalSpeed = units;
    foreach(profile in profiles.iter())
        profile.cameraSpeed = units;
    
    UpdateHudInfo()
}

// Get the current profile's speed
function GetSpeed() {
    return currentProfile.getSpeed()
}

// Set the interpolation function (lerp) for smooth transitions
function SetLerp(lerpFunc) {
    if(isPlaying) return

    currentProfile.lerpFunc = lerpFunc
    UpdateHudInfo()
}

// Get the current interpolation method as a string
function GetLerp() {
    local lerpName = "linear"
    if(currentProfile.lerpFunc) {
        foreach(name, func in math.lerp) 
            if(func == currentProfile.lerpFunc) {
                lerpName = name
                break
            }
    }
    return lerpName
}

/******************************************************************************
*                              PLAYBACK CONTROL
******************************************************************************/

// Play the current profile's keyframes in sequence
function PlayCurrentProfile() {
    if(isPlaying) return
    _preparePlay()
    
    local animTime = _playProfile(currentProfile)
    ScheduleEvent.Add("cam", StopPlayback, animTime)
}

// Play the special profile's keyframes in sequence
function PlayProfile(idx) {
    if(isPlaying) return
    _preparePlay()
    
    local animTime = _playProfile(profiles[idx])
    ScheduleEvent.Add("cam", StopPlayback, animTime)
}

// Play all profiles consecutively
function PlayAllProfiles() {
    if(isPlaying) return
    _preparePlay()
    
    local delay = 0
    foreach(idx, profile in profiles.iter()) {
        delay = _playProfile(profile, delay)
    }

    ScheduleEvent.Add("cam", StopPlayback, delay)
}

// Stop playback and restore HUD elements
function StopPlayback() {
    StartDrawFrames()
    ScreenInfo.Enable()
    isPlaying = false

    SendToConsole("KeyCam_ShowHud")
    EntFireByHandle(camera, "Disable")
    ScheduleEvent.TryCancel("cam")
}

function _preparePlay() {
    EndDrawFrames()
    ScreenInfo.Disable()
    beep.Enable()
    isPlaying = true

    SendToConsole("KeyCam_HideHud")
    EntFireByHandle(camera, "Enable")
}

function _playProfile(profile, globalDelay = 0) {
    local len = profile.len() - 1

    for(local idx = 0; idx < len; idx++) {
        local k1 = profile.GetFrame(idx)
        local k2 = profile.GetFrame(idx + 1)
        local settings = {globalDelay = globalDelay, eventName = "cam", lerp = profile.lerpFunc}

        local animTime = animate.RT.PositionTransitionBySpeed(camera, k1.GetOrigin(), k2.GetOrigin(), profile.cameraSpeed, settings)
        animate.RT.AnglesTransitionByTime(camera, k1.GetAngles(), k2.GetAngles(), animTime, settings)
        globalDelay += animTime
    }

    return globalDelay
}

/******************************************************************************
*                              PROFILES CONTROL
******************************************************************************/

// Create a new camera profile and set it as active
function CreateProfile() {
    if(isPlaying) return

    local newProfile = Profile(globalSpeed)
    currentProfile = newProfile;
    profiles.append(newProfile);
    UpdateHudInfo()
}

// Switch to the next profile in the list
function SwitchProfile() {
    if(isPlaying) return

    local idx = profiles.search(currentProfile)
    if(idx >= profiles.len() - 1)
        idx = -1
    currentProfile = profiles[++idx]
    UpdateHudInfo()
}

// Delete a specific profile by index
function DeleteProfile(idx) {
    if(profiles[idx - 1] == currentProfile) 
        SwitchProfile()
    profiles.remove(idx - 1)
    UpdateHudInfo()
}

// Clear all profiles and create a new default profile
function ClearProfiles() {
    if(isPlaying) return

    profiles.clear()
    CreateProfile()
}


/******************************************************************************
*                               EXPORT/IMPORT
******************************************************************************/

// Export all profiles to a file
function Export(name = "test") {
    // Check if there is no data to export
    if(profiles.len() == 1 && currentProfile.len() == 0) 
        return printl("No data for export!")
    
    local file = File("demo_export_" + name)
    file.writeRawData(macros.format("// Export from {} (time: {})", GetMapName(), Time()))
    file.writeRawData("script profiles.clear()")

    foreach(idx, profile in profiles.iter()) {
        file.writeRawData("\\n// Profile " + idx)
        file.writeRawData("script CreateProfile()")
        file.writeRawData(macros.format("script SetSpeed({})", profile.GetSpeed()))
        
        local lerp = GetLerp()
        if(lerp != "linear")
            file.writeRawData(macros.format("script SetLerp(math.lerp.{})", lerp))
        
        foreach(frame in profile.keyframes.iter()) {
            local origin =  "Vector(" + macros.VecToStr(frame.GetOrigin(), ", ")        + ")"
            local angles =  "Vector(" + macros.VecToStr(frame.GetAngles(), ", ")        + ")"
            local forward = "Vector(" + macros.VecToStr(frame.GetForwardVector(), ", ") + ")"

            file.writeRawData(macros.format(
                "script currentProfile.AddFrame( KeyFrame({}, {}, {}) )", 
                origin, angles, forward
            ))
        }
    }

    file.writeRawData("\\n\\n")
    SendToConsole("clear")
    SendToConsole("script printl(\"The data has been successfully exported!\")")
}

// Import profiles from a file
function Import(name = "test") {
    SendToConsole("exec demo_export_" + name + ".log")
    SendToConsole("clear")
    SendToConsole("script printl(\"The data has been successfully imported!\")")
}