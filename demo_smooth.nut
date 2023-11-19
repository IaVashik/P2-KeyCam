IncludeScript("pcapture/pcapture-lib/pcapture-lib")

cam <- entLib.CreateByClassname("point_viewcontrol", {targetname = "camera"})
pseudoHud <- entLib.CreateByClassname("game_text", {
    channel = 2,
    color = "170 170 170",
    color2 = "240 110 0",
    effect = 0,
    fadein = 0,
    fadeout = 0,
    fxtime = 0,
    holdtime = 100,
    x = 0.01,
    y = 0.95,
    spawnflags = 0,
    message = "Selected preset: 1"
})

keypoints <- [] // список ключевых точек для камеры
presedList <- arrayLib.new()
CurrentPreset <- 0
isRecording <- false // true - включить запись / false - выключить
playAllPreset <- false

cameraSpeed <- 0.4

function AddKeyPoint()
{
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

function export(name = "test") {
    result <- "importKeyPoints(["
    foreach(arr in presedList.arr) {
        result += "\n\t["
        foreach(elements in arr) {
            result += "\n\t\t{"
            foreach(keyname, keyinfo in elements) {
                result += keyname + " = " + format("Vector(%f, %f, %f)", keyinfo.x, keyinfo.y, keyinfo.z) + ", "
            }
            result = result.slice(0, -2) + "}"
        }
        result += "\n], "
    }
    result += "\n])"
    
    SendToConsole(format("con_logfile scripts/vscripts/demo_export_%s.log", name))
    SendToConsole("script printl(result)")
    SendToConsole("con_logfile off")
    // SendToConsole("clear; echo Done! :>")
}

function importKeyPoints(keyPoints) {
    print(keyPoints.len())
    presedList = arrayLib(keyPoints)
    keypoints = presedList[0]
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

function StartPlayingAllPresets() {
    if(presedList.len() > 0) {
        CurrentPreset = 0
        keypoints = presedList[CurrentPreset]
        playAllPreset = true
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

function createPreset() {
    if(presedList.search(keypoints) == null)
        presedList.append(keypoints)
    CurrentPreset = presedList.len() -1
    keypoints <- []
    presedList.append(keypoints)
    // CurrentPreset = CurrentPreset + 1
    changePreset()
}

function changePreset() {
    local Currentindex = CurrentPreset

    foreach(index, info in presedList.arr){ // TODO BIG PROBLEM: NO _nexti
        if (index > Currentindex) {
            CurrentPreset = index
            break
        }
    }
    if(CurrentPreset == Currentindex) {
        CurrentPreset = 0
    }
    pseudoHud.SetKeyValue("message", "Selected preset: " + (CurrentPreset + 1))
    keypoints = presedList[CurrentPreset]
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


function DrawKey()
{
    RunScriptCode.delay("DrawKey()", 0.05)
    EntFireByHandle(pseudoHud, "Display")
    if(isRecording || keypoints.len() == 0) 
        return

    foreach (k,vector in keypoints) {
        vector = vector.origin
        DebugDrawBox(vector, Vector(4,4,4), Vector(-4,-4,-4), 171, 214, 213, 100, 0.1)
        if(k != 0 && k != keypoints.len()) 
            DebugDrawLine(keypoints[k-1].origin, vector, 224, 216, 232, false, 0.1)
    }
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
            if(playAllPreset && CurrentPreset < presedList.len() - 1) {
                changePreset()
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


function getShortestOrigin(startOrigin, endOrigin) {
    return Vector(endOrigin.x - startOrigin.x, 
                  endOrigin.y - startOrigin.y,
                  endOrigin.z - startOrigin.z)
}

function getShortestAngle(startAngles, endAngles) {
    local shortest_angle_x = ((((endAngles.x - startAngles.x) % 360) + 540) % 360) - 180;
    local shortest_angle_y = ((((endAngles.y - startAngles.y) % 360) + 540) % 360) - 180;
    local shortest_angle_z = ((((endAngles.z - startAngles.z) % 360) + 540) % 360) - 180;
    return Vector(shortest_angle_x, shortest_angle_y, shortest_angle_z)
}

function getTotalStep(start, end) {
    local distance = end.origin - start.origin
    local totalStep = abs(distance.Length() / cameraSpeed)
    return totalStep.tofloat()
}