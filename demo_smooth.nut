IncludeScript("pcapture/pcapture-lib/pcapture-lib")





function AddKeyPoint() {
    local origin = GetPlayer().EyePosition()
    local angle = ::eyePointEntity.GetAngles()
    local forward = ::eyePointEntity.GetForwardVector()
    keypoints.append( {
        origin = origin,
        angle = angle,
        forward = forward,
    } ) 
    dev.log("Create new key: origin- " + origin + ", angles- " + angle)
}





function DeleteLastPoint() {
    keypoints.pop()
}

function DeleteAllPoint() {
    keypoints.clear()
}

function StartPlaying() {
    SendToConsole("DEMO_HideHud")
    EntFire("camera", "Enable")
    isRecording = true
    SetCameraPosition() 
}

function StartPlayingAllProfiles() {
    if(presedList.len() > 0) {
        CurrentProfile = 0
        keypoints = presedList[CurrentProfile]
        playAllProfile = true
    }

    StartPlaying() 
}

function EndPlaying() {
    printl(("DISABLE"))
    SendToConsole("DEMO_ShowHud")
    EntFire("camera", "Disable")
    isRecording = false
    if(eventIsValid("camera")) cancelScheduledEvent("camera")
}

function StopPlaying() {
    EndPlaying()
}

function createProfile() {
    if(presedList.search(keypoints) == null)
        presedList.append(keypoints)
    CurrentProfile = presedList.len() -1
    keypoints <- []
    presedList.append(keypoints)
    // CurrentProfile = CurrentProfile + 1
    changeProfile()
}

function changeProfile() {
    
}

function SetCameraPosition() {
    if(keypoints.len() < 1) 
        return EndPlaying()

    local start = keypoints[0]
    local end = keypoints[1]

    local infoTable = {
        startKey = 0,
        endKey = 1,
        totalStep = getTotalStep(start, end),
        currentStep = 0,
        shortestOrigin = getShortestOrigin(start.origin, end.origin),
        shortestAngle = getShortestAngle(start.angle, end.angle),
    }

    fuckingRecursive(infoTable)
}




DrawKey()

SendToConsole("sv_alternateticks 0")


function fuckingRecursive(infoTable) {
    local runAgain = function(infoTable) {
        CreateScheduleEvent("camera", function():(infoTable) {fuckingRecursive(infoTable)}, FrameTime())
    }

    // foreach(k, i in infoTable) print(k +" = " + i +", ")
    // printl("")
    if(infoTable.currentStep == infoTable.totalStep) {
        if(infoTable.endKey == keypoints.len() - 1) {
            if(playAllProfile && CurrentProfile < presedList.len() - 1) {
                changeProfile()
                return SetCameraPosition()
            }
            return EndPlaying()
        }

        local start = keypoints[infoTable.startKey + 1]
        local end = keypoints[infoTable.endKey + 1]
        infoTable = {
            startKey = infoTable.startKey + 1,
            endKey = infoTable.endKey + 1,
            totalStep = getTotalStep(start, end),
            currentStep = 0,
            shortestOrigin = getShortestOrigin(start.origin, end.origin),
            shortestAngle = getShortestAngle(start.angle, end.angle),
        }
        return runAgain(infoTable)
    }

    local start = keypoints[infoTable.startKey]
    local end = keypoints[infoTable.endKey]

    local amount = infoTable.currentStep / infoTable.totalStep
    local newPosition = start.origin + infoTable.shortestOrigin * amount;
    local newAngle = start.angle + infoTable.shortestAngle * amount;    
    
    cam.SetOrigin(newPosition)
    cam.SetAbsAngles(newAngle)

    infoTable["currentStep"] = infoTable["currentStep"] + 1 
    return runAgain(infoTable)
}


