// Initialize the camera HUD with position and text
ScreenInfo <- HUD.ScreenText(Vector(0.01, 0.8, 0), "", 1000).SetChannel(2)
ScreenInfo.Enable()

function UpdateHudInfo(additionalText = null) {
    if("NoHud" in getroottable() && NoHud) return
    
    local info = "     KeyCam Info:"
    info += "\nAvailable profiles: " + profiles.len()
    info += "\nSelected Profile: " + (profiles.search(currentProfile) + 1)
    info += "\nNumber of keyframes: " + currentProfile.len()
    info += "\nCamera Speed: " + currentProfile.GetSpeed()
    
    info += "\nLerp function: " + GetLerp()

    local needTime = 0
    if(currentProfile.len() > 1) {
        local iter = currentProfile.keyframes.iter()
        local prevFrame = resume iter
        foreach(keyframe in iter) {
            local length = macros.GetDist(prevFrame.GetOrigin(), keyframe.GetOrigin())
            needTime += length * FrameTime() / currentProfile.GetSpeed()
            prevFrame = keyframe
        }
    }
    info += "\nAnim Time: " + needTime

    if(!additionalText && "EnableBindHelper" in getroottable() && EnableBindHelper)
        additionalText = _getBinds() + "For more information, use help_KeyCam." + "\n\n\n\n\n\n\n\n\n"
    
    if(additionalText) {
        info = additionalText + info
    }

    ScreenInfo.SetText(info)
    ScreenInfo.Update()
}