//******************************************************************************
//*                          EXPERIMENTAL FEATURE
//******************************************************************************


function keyCamera::tryChangeFrame() {
    local playerPos = eyePointEntity.GetOrigin()
    local playerForward = eyePointEntity.GetForwardVector()

    local mutableFrame = null
    foreach(frame in currentProfile) {
        if(checkIfPlayerLooksAtPoint(playerPos, playerForward, frame.GetOrigin())) {
            mutableFrame = frame
            break;
        }
    }

    if(mutableFrame == null)
        return false

    EntFireByHandle(this.gameui, "Activate", "", 0.0, GetPlayer());
    EntFireByHandle(this.cameraEnt, "Enable")

    this.cameraEnt.SetOrigin(mutableFrame.GetOrigin())
    this.cameraEnt.SetAbsAngles(mutableFrame.GetAngles())
    this.cameraEnt.SetUserData("mutableFrame", mutableFrame)

    toDown = false
    toUp = false

    changeFrameRecurse(mutableFrame, GetPlayer().GetOrigin())

    return true
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
toRight <- false
toLeft <- false
toForward <- false
toBackward <- false
toUp <- false
toDown <- false

function changeFrameRecurse(frame, playerPos) {
    CreateScheduleEvent("frameChanger", function() : (frame, playerPos) {changeFrameRecurse(frame, playerPos)}, FrameTime())
    GetPlayer().SetOrigin(playerPos)

    if(!toRight && !toLeft && !toForward && !toBackward && !toUp && !toDown) 
        return 

    local position = frame.GetOrigin()
    local forward = frame.GetForwardVector()
    local up = Vector(0, 0, 0.5).Cross(forward)

    local newPos = position
    local newAngles = frame.GetAngles()

    if(modForAngles == false) {
        if(toRight) {
            newPos -= up 
        }
    
        if(toLeft) {
            newPos += up
        }

        if(toForward) {
            newPos += forward * 0.5
        }

        if(toBackward) {
            newPos -= forward * 0.5
        }

        if(toUp) {
            newPos += Vector(0, 0, 0.5)
        }

        if(toDown) {
            newPos -= Vector(0, 0, 0.5)
        }
        
    } else if(modForAngles == true) {
        if(toRight) {
            newAngles.y -= 0.2;
        }

        if(toLeft) {
            newAngles.y += 0.2;
        }

        if(toForward) {
            newAngles.x -= 0.2;
        }

        if(toBackward) {
            newAngles.x += 0.2;
        }

        if(toUp) {
            newAngles.z += 0.2;
        }

        if(toDown) {
            newAngles.z -= 0.2;
        }
    }

    keyCam.cameraEnt.SetOrigin(newPos)  // bruh
    keyCam.cameraEnt.SetAngles(newAngles.x, newAngles.y, newAngles.z)
    
    frame.SetOrigin(newPos)
    frame.SetAngles(newAngles)
    frame.SetForwardVector(keyCam.cameraEnt.GetForwardVector())

    if(modForAngles == false)
        keyCam._updateHUD()
}


function stopChangeFrame() {
    EntFireByHandle(keyCam.cameraEnt, "Disable")
    cancelScheduledEvent("frameChanger")
}


function frameChangerInit(gameui) {
    gameui.addOutput("PlayerOff", "worldspawn", "RunScriptCode", "stopChangeFrame()")
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

    playerproxy.addOutput("OnJump", "worldspawn", "RunScriptCode", "toUp = !toUp")
}