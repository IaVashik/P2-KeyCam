IncludeScript("pcapture/pcapture-lib/pcapture-lib")

cam <- entLib.CreateByClassname("point_viewcontrol", {targetname = "camera"})
keypoints <- [] // список ключевых точек для камеры
isRecording <- false // true - включить запись / false - выключить

cameraSpeed <- 0.4

function AddKeyPoint()
{
    local origin = GetPlayer().EyePosition()
    local angle = ::eyePointEntity.GetAngles()
    keypoints.append( {
        origin = origin,
        angle = angle
    } ) 
    dev.log("Create new key: origin- " + origin + ", angles- " + angle)
}


function DeleteLastPoint() {
    keypoints.pop()
}

function DeleteAllPoint() {
    keypoints.clear()
}

function StopPlaying() {
    cancelScheduledEvent("camera")
    EndPlaying()
}

function StartPlaying() {
    SendToConsole("DEMO_HideHud")
    EntFire("camera", "Enable")
    isRecording = true

    SetCameraPosition() 
}

function EndPlaying() {
    SendToConsole("DEMO_ShowHud")
    EntFire("camera", "Disable")
    isRecording = false
    DrawKey()
}

function SetCameraPosition() {
    if(keypoints.len() < 1) 
        return EndPlaying()

    local requiredTime = 0
    for(local i = 1; i < keypoints.len(); i++) {
        local start = keypoints[i - 1]
        local end = keypoints[i]
        printl((end.origin - start.origin ).Length())
        te <- start.origin

        local neededTime = animate.PositionTransitionBySpeed(cam, start.origin, end.origin, cameraSpeed, {eventName = "camera", globalDelay = requiredTime})
        animate.AnglesTransitionByTime(cam, start.angle, end.angle, neededTime, {eventName = "camera", globalDelay = requiredTime})
        
        requiredTime += neededTime
    }
    CreateScheduleEvent("camera", "EndPlaying()", requiredTime)
}


function DrawKey()
{
    RunScriptCode.delay("DrawKey()", 0.05)
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