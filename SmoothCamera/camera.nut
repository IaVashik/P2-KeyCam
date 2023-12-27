IncludeScript("P2-KeyCam/SmoothCamera/profile")
IncludeScript("P2-KeyCam/SmoothCamera/keyframes")

class keyCamera {
    profiles = arrayLib.new();
    cameraSpeed = 1;
    cameraEnt = null;
    currentProfile = null;
    currentProfileIdx = null;
    playAllProfile = false

    cameraHUD = null;
    gameui = null;

    constructor() {
        this.cameraEnt = entLib.CreateByClassname("point_viewcontrol", {targetname = "cameraEnt"})

        this.cameraHUD = screenText(0.01, 0.8, "")
        this.cameraHUD.enable()

        this.gameui = entLib.CreateByClassname("game_ui", {FieldOfView = -1, spawnflags = 128})
        frameChangerInit(gameui)
        
        this.createProfile()

        this.startDrawFrames()
    }

    function addKeyframe() {}
    function deleteKey(idx) {}
    function deleteLastKey() {}
    function clearKeyframes() {}

    function setSpeed(units) {}
    function setSpeedEx(units) {}
    function getSpeed() {}

    function playCurrentProfile() {}
    function playAllProfiles() {}
    function stopPlayback() {}

    function createProfile() {}
    function deleteProfile(idx) {}
    function clearProfiles() {}
    function switchProfile() {}

    function startDrawFrames() {}
    function endDrawFrames() {}

    // pseudo-private func
    function _startAnim() {}
    function _cameraRecursion(infoTable) {}
    function _DrawFrames() {}
}

IncludeScript("P2-KeyCam/HUD/screen_text")
IncludeScript("P2-KeyCam/HUD/screen_info")
IncludeScript("P2-KeyCam/HUD/viewport")

IncludeScript("P2-KeyCam/SmoothCamera/keyframes_editor")

/******************************************************************************
*                            TODO BLYAT
******************************************************************************/

function keyCamera::addKeyframe() {
    local origin = eyePointEntity.GetOrigin()
    local angle = eyePointEntity.GetAngles()
    local forward = eyePointEntity.GetForwardVector()
    local key = keyframe(origin, angle, forward)

    this.currentProfile.addFrame(key)
    this.updateHUD()
}

function keyCamera::deleteKey(idx) {
    this.currentProfile.removeFrame(idx)
    this.updateHUD()
}

function keyCamera::deleteLastKey() {
    this.currentProfile.keyframes.pop()
    this.updateHUD()
}

function keyCamera::clearKeyframes() {
    this.currentProfile.clearFrames()
    this.updateHUD()
}

/******************************************************************************
*                                   SETTERS
******************************************************************************/
function keyCamera::setSpeed(units) {
    this.cameraSpeed = units;
    this.currentProfile.cameraSpeed = units;
    this.updateHUD()
}

function keyCamera::setSpeedEx(units) {
    this.cameraSpeed = units;
    foreach(profile in profiles) {
        profile.cameraSpeed = units;
    }
    this.updateHUD()
}

function keyCamera::getSpeed() {
    return this.currentProfile.getSpeed()
}

/******************************************************************************
*                            TODO BLYAT
******************************************************************************/

function keyCamera::playCurrentProfile() {
    this.endDrawFrames()
    this.cameraHUD.disable()

    SendToConsole("KeyCam_HideHud")
    EntFireByHandle(this.cameraEnt, "Enable")
    this._startAnim()
}

function keyCamera::playAllProfiles() {
    this.playAllProfile = true
    this.currentProfileIdx = 0
    this.currentProfile = profiles[0]

    this.playCurrentProfile()
}

function keyCamera::stopPlayback() {
    this.startDrawFrames()
    this.cameraHUD.enable()

    this.playAllProfile = false
    SendToConsole("KeyCam_ShowHud")
    EntFireByHandle(this.cameraEnt, "Disable")
    if(eventIsValid("camera")) cancelScheduledEvent("camera")
}

/******************************************************************************
*                            TODO BLYAT
******************************************************************************/

function keyCamera::createProfile() {
    local newProfile = camProfile(this.cameraSpeed)
    this.currentProfile = newProfile;
    this.currentProfileIdx = profiles.len()

    profiles.append(newProfile);
    this.updateHUD()
}

function keyCamera::switchProfile() {
    local Currentindex = currentProfileIdx

    foreach(index, info in this.profiles){ //! BIG PROBLEM: NO _nexti
        if (index > Currentindex) {
            this.currentProfileIdx = index
            break
        }
    }
    if(currentProfileIdx == Currentindex) {
        currentProfileIdx = 0
    }

    this.currentProfile = profiles[currentProfileIdx]
    this.updateHUD()
}

function keyCamera::deleteProfile(idx) {
    this.profiles.remove(idx)
    this.updateHUD()
    this.switchProfile()
}

function keyCamera::clearProfiles() {
    this.profiles.clear()
    this.createProfile()
}


/******************************************************************************
*                            PSEUDO-PRIVATE FUNC
******************************************************************************/

function keyCamera::_startAnim() {
    if(currentProfile.getFramesLen() < 1)
        return this.stopPlayback()

    local start = currentProfile.getFrame(0)
    local end = currentProfile.getFrame(1)

    local infoTable = {
        startKey = 0,
        endKey = 1,
        totalStep = utils.getTotalStep(start, end, this.currentProfile.getSpeed()),
        currentStep = 0,
        shortestOrigin = utils.getShortestOrigin(start.origin, end.origin),
        shortestAngle = utils.getShortestAngle(start.angle, end.angle),
    }

    _cameraRecursion(infoTable)
}

function keyCamera::_cameraRecursion(infoTable) {
    local runAgain = function(infoTable) {
        local scope = this;
        CreateScheduleEvent("camera", function():(scope, infoTable) {scope._cameraRecursion(infoTable)}, FrameTime())
    }

    if(infoTable.currentStep == infoTable.totalStep) {
        if(infoTable.endKey == currentProfile.getFramesLen() - 1) {
            if(this.playAllProfile && currentProfileIdx < profiles.len() - 1) {
                this.switchProfile()
                return this._startAnim()
            }
            return this.stopPlayback()
        }

        local currentIdx = infoTable.startKey
        local start = this.currentProfile.getFrame(currentIdx + 1)
        local end = this.currentProfile.getFrame(currentIdx + 2)

        infoTable = {
            startKey = currentIdx + 1,
            endKey = currentIdx + 2,
            totalStep = utils.getTotalStep(start, end, this.currentProfile.getSpeed()),
            currentStep = 0,
            shortestOrigin = utils.getShortestOrigin(start.origin, end.origin),
            shortestAngle = utils.getShortestAngle(start.angle, end.angle),
        }

        return runAgain(infoTable)
    }

    local start = this.currentProfile.getFrame(infoTable.startKey)
    local end = this.currentProfile.getFrame(infoTable.endKey)

    local amount = infoTable.currentStep / infoTable.totalStep
    local newPosition = start.origin + infoTable.shortestOrigin * amount;
    local newAngle = start.angle + infoTable.shortestAngle * amount;

    this.cameraEnt.SetOrigin(newPosition)
    this.cameraEnt.SetAbsAngles(newAngle)

    infoTable["currentStep"] = infoTable["currentStep"] + 1
    return runAgain(infoTable)
}