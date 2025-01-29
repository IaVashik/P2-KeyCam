function TryChangeFrame() {
    if(isPlaying) return

    local playerPos = playerEx.EyePosition()
    local playerForward = playerEx.EyeForwardVector()

    local mutableFrame = null
    foreach(frame in currentProfile.keyframes.iter()) {
        if(checkIfPlayerLooksAtPoint(playerPos, playerForward, frame.GetOrigin())) {
            mutableFrame = frame
            break;
        }
    }

    if(mutableFrame == null)
        return false

    if(GetPlayer().IsNoclipping())
        SendToConsole("noclip")

    EntFireByHandle(gameui, "Activate", "", 0.0, playerEx);
    EntFireByHandle(camera, "Enable")

    camera.SetOrigin(mutableFrame.GetOrigin())
    camera.SetAbsAngles(mutableFrame.GetAngles())
    toDown = false; inverted = false

    ScheduleEvent.AddInterval("FrameChanger", FrameEditor, FrameTime(), 0, [mutableFrame])
    ScheduleEvent.AddInterval("FrameChanger", playerEx.SetOrigin, 0.1, 0, [playerEx.GetOrigin()], playerEx)
}

function checkIfPlayerLooksAtPoint(playerPos, playerForward, targetPoint) {
    local directionToTarget = targetPoint - playerPos

    local playerForwardLength = playerForward.Length()
    local directionToTargetLength = directionToTarget.Length()  

    local dotProduct = playerForward.Dot(directionToTarget)

    local angle = acos(dotProduct / (playerForwardLength * directionToTargetLength))

    return angle < 0.26 // maxViewAngle, ~15 angles
}


modForAngles <- true 
// Indicates whether the current modification is for angles (true) or positions (false)
toRight <- false
toLeft <- false
toForward <- false
toBackward <- false
toDown <- false
inverted <- false

function FrameEditor(frame) {
    local position = frame.GetOrigin()
    local forward = frame.GetForwardVector()
    local up = Vector(0, 0, 0.5).Cross(forward)

    local posOffset = Vector()
    local anglesOffset = Vector()

    // Position Edit
    if(modForAngles == false) {
        if(toRight) posOffset -= up;
    
        if(toLeft) posOffset += up;

        if(toForward) posOffset += forward * 0.5;

        if(toBackward) posOffset -= forward * 0.5;

        if(toDown) posOffset -= Vector(0, 0, 0.5) * (inverted ? -1 : 1);
    } 
    // Angles Edit
    else if(modForAngles == true) {
        if(toRight) anglesOffset.y -= 0.2;

        if(toLeft) anglesOffset.y += 0.2;

        if(toForward) anglesOffset.x -= 0.2;

        if(toBackward) anglesOffset.x += 0.2;

        if(toDown) anglesOffset.z -= 0.2 * (inverted ? -1 : 1);
    }

    local newPos = position + posOffset
    local newAngles = frame.GetAngles() + anglesOffset
    
    camera.SetOrigin(newPos)
    camera.SetAbsAngles(newAngles)
    
    frame.SetOrigin(newPos)
    frame.SetAngles(newAngles)
    frame.SetForwardVector(camera.GetForwardVector())

    local info = "You are currently editing: " + (modForAngles ? "angle" : "position")
    info += "\nPosition: " + newPos
    info += "\nAngles: " + newAngles
    info += "\nPress \"Attack1\" for switch mode."
    info += "\nPress \"Attack2\" for exit.\n\n\n\n\n\n\n\n\n"

    UpdateHudInfo(info)
}


function stopChangeFrame() {
    EntFireByHandle(camera, "Disable")
    ScheduleEvent.TryCancel("FrameChanger")
    EntFireByHandle(gameui, "Deactivate", "", 0.0, playerEx);
    UpdateHudInfo()
}


function createGameUi() {
    local gameui = entLib.CreateByClassname("game_ui", {FieldOfView = -1, spawnflags = 128})
    beep <- HUD.ScreenText(Vector(0, RandomFloat(0.8, 0.95)), "·", 99999).SetColor("100 0 50")  // shhhh...˙

    gameui.AddOutput("PlayerOff", "worldspawn", "RunScriptCode", "stopChangeFrame()")
    gameui.AddOutput("PressedAttack2", "worldspawn", "RunScriptCode", "stopChangeFrame()")
    gameui.AddOutput("PressedAttack", "worldspawn", "RunScriptCode", "modForAngles = !modForAngles")

    gameui.AddOutput("PressedMoveLeft", "worldspawn", "RunScriptCode", "toLeft = true")
    gameui.AddOutput("UnPressedMoveLeft", "worldspawn", "RunScriptCode", "toLeft = false")
    
    gameui.AddOutput("PressedMoveRight", "worldspawn", "RunScriptCode", "toRight = true")
    gameui.AddOutput("UnPressedMoveRight", "worldspawn", "RunScriptCode", "toRight = false")

    gameui.AddOutput("PressedForward", "worldspawn", "RunScriptCode", "toForward = true")
    gameui.AddOutput("UnPressedForward", "worldspawn", "RunScriptCode", "toForward = false")

    gameui.AddOutput("PressedBack", "worldspawn", "RunScriptCode", "toBackward = true")
    gameui.AddOutput("UnPressedBack", "worldspawn", "RunScriptCode", "toBackward = false")

    local playerproxy = entLib.CreateByClassname("logic_playerproxy")
    playerproxy.AddOutput("OnDuck", "worldspawn", "RunScriptCode", "toDown = true")
    playerproxy.AddOutput("OnUnDuck", "worldspawn", "RunScriptCode", "toDown = false")

    playerproxy.AddOutput("OnJump", "worldspawn", "RunScriptCode", "inverted = !inverted")

    return gameui
}