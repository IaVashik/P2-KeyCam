IncludeScript("P2-KeyCam/SmoothCamera/profile")
IncludeScript("P2-KeyCam/SmoothCamera/keyframes")

class keyCamera {
    profiles = arrayLib.new();
    cameraSpeed = 1;
    cameraEnt = null;
    currentProfile = null;
    currentProfileIdx = null;
    playAllProfile = false

    _screenText = null;

    constructor() {
        this.cameraEnt = entLib.CreateByClassname("point_viewcontrol")
        this._screenText = screenText(0.01, 0.95, "Selected Profile: 1")
        this.createProfile()

        this._screenText.enable()
        this.startDrawFrames()
    }

    function addKeyframe() {}
    function deleteKey(idx) {}
    function deleteLastKey() {}
    function clearKeyframes() {}

    function playCurrentProfile() {}
    function playAllProfiles() {}
    function stopPlayback() {}

    function createProfile() {}
    function switchProfile() {}

    function startDrawFrames() {}
    function endDrawFrames() {}

    // pseudo-private func
    function _startAnim() {}
    function _cameraRecursion(infoTable) {}
    function _DrawFrames() {}
}

IncludeScript("P2-KeyCam/HUD/screen_text")
IncludeScript("P2-KeyCam/HUD/viewport")

/******************************************************************************
*                            TODO BLYAT
******************************************************************************/

function keyCamera::addKeyframe() {
    local origin = eyePointEntity.GetOrigin()
    local angle = eyePointEntity.GetAngles()
    local forward = eyePointEntity.GetForwardVector()
    local key = keyframe(origin, angle, forward)

    this.currentProfile.addFrame(key)
}

function keyCamera::deleteKey(idx) {
    this.currentProfile.deleteFrame(idx)
}

function keyCamera::deleteLastKey() {
    this.currentProfile.deleteFrame(currentProfileIdx)
}

function keyCamera::clearKeyframes() {
    this.currentProfile.clearFrames()
}

/******************************************************************************
*                            TODO BLYAT
******************************************************************************/

function keyCamera::playCurrentProfile() {
    this.endDrawFrames()
    this._screenText.disable()

    SendToConsole("DEMO_HideHud")
    EntFireByHandle(this.cameraEnt, "Enable")
    this._startAnim()
}

function keyCamera::playAllProfiles() {
    playAllProfile = true
    this.playCurrentProfile()
}

function keyCamera::stopPlayback() {
    this.startDrawFrames()
    this._screenText.enable()

    playAllProfile = false
    SendToConsole("DEMO_ShowHud")
    EntFireByHandle(this.cameraEnt, "Disable")
    if(eventIsValid("camera")) cancelScheduledEvent("camera")
}

/******************************************************************************
*                            TODO BLYAT
******************************************************************************/

function keyCamera::createProfile() {
    local newProfile = camProfile(this.cameraSpeed)
    currentProfile = newProfile;
    profiles.append(newProfile)
    this.switchProfile()
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
    this._screenText.changeText("Selected Profile: " + (currentProfileIdx + 1))
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
            if(this.playAllProfile && currentProfileIdx < currentProfile.len() - 1) {
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