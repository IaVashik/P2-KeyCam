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
    ScheduleEvent.AddInterval("FrameChanger", playerEx.SetOrigin, 0.1, 0, [playerPos], playerEx)
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

    local info = "You are currently editing: camera " + (modForAngles ? "angle" : "position")
    info += "\nPoint Position: " + newPos
    info += "\nPoint Angles: " + newAngles
    info += "\nPosition Offset: " + posOffset
    info += "\nAngles Offset: " + anglesOffset
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

    gameui.addOutput("PlayerOff", "worldspawn", "RunScriptCode", "stopChangeFrame()")
    gameui.addOutput("PressedAttack2", "worldspawn", "RunScriptCode", "stopChangeFrame()")
    gameui.addOutput("PressedAttack", "worldspawn", "RunScriptCode", "modForAngles = !modForAngles")

    gameui.addOutput("PressedMoveLeft", "worldspawn", "RunScriptCode", "toLeft = true")
    gameui.addOutput("UnPressedMoveLeft", "worldspawn", "RunScriptCode", "toLeft = false")
    
    gameui.addOutput("PressedMoveRight", "worldspawn", "RunScriptCode", "toRight = true")
    gameui.addOutput("UnPressedMoveRight", "worldspawn", "RunScriptCode", "toRight = false")

    gameui.addOutput("PressedForward", "worldspawn", "RunScriptCode", "toForward = true")
    gameui.addOutput("UnPressedForward", "worldspawn", "RunScriptCode", "toForward = false")

    gameui.addOutput("PressedBack", "worldspawn", "RunScriptCode", "toBackward = true")
    gameui.addOutput("UnPressedBack", "worldspawn", "RunScriptCode", "toBackward = false")

    local playerproxy = entLib.CreateByClassname("logic_playerproxy")
    playerproxy.addOutput("OnDuck", "worldspawn", "RunScriptCode", "toDown = true")
    playerproxy.addOutput("OnUnDuck", "worldspawn", "RunScriptCode", "toDown = false")

    playerproxy.addOutput("OnJump", "worldspawn", "RunScriptCode", "inverted = !inverted")

    return gameui
}