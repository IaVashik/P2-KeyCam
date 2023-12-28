IncludeScript("P2-KeyCam/SmoothCamera/profile")
IncludeScript("P2-KeyCam/SmoothCamera/keyframes")

// Define the 'keyCamera' class which handles the cinematic camera system
class keyCamera {
    profiles = arrayLib.new(); // Array to store camera profiles
    cameraSpeed = 1; // Default camera speed
    cameraEnt = null; // The entity representing the camera
    currentProfile = null; // The currently active camera profile
    currentProfileIdx = null; // Index of the current profile

    playAllProfile = false // Flag to control whether all profiles should be played sequentially

    cameraHUD = null; // The camera's HUD (game_text) element
    gameui = null; // Entity representing the game's user interface

    // Constructor for the 'keyCamera' class
    constructor() {
        // Create a camera entity
        this.cameraEnt = entLib.CreateByClassname("point_viewcontrol", {targetname = "cameraEnt"})

        // Initialize the camera HUD with position and text
        this.cameraHUD = screenText(0.01, 0.8, "")
        this.cameraHUD.enable() // Enable the HUD for display

        // Create a game UI entity with specific properties
        this.gameui = entLib.CreateByClassname("game_ui", {FieldOfView = -1, spawnflags = 128})
        frameChangerInit(gameui) // Initialize frame changer
        
        this.createProfile() // Create an initial camera profile

        this.startDrawFrames() // Begin the process to draw frames onto the HUD
    }

    // Keyframe management methods
    function addKeyframe() null // Adds a new keyframe to the current profile
    function deleteKey(idx) null // Deletes a keyframe at the specified index
    function deleteLastKey() null // Deletes the last keyframe from the current profile
    function clearKeyframes() null // Clears all keyframes from the current profile
    function tryChangeFrame() bool // Activate the editor of the keyframe you are looking at

    // Camera speed management methods
    function setSpeed(units) null // Sets the speed of the camera movement
    function setSpeedEx(units) null // Sets the speed of the camera movement for ALL profiles
    function getSpeed() float // Returns the current speed of the camera

    // Playback control methods
    function playCurrentProfile() null // Plays current profile
    function playAllProfiles() null // Plays all profiles sequentially
    function stopPlayback() null // Stops the playback of keyframes

    // Profile management methods
    function createProfile() null // Creates a new camera movement profile
    function deleteProfile(idx) null // Deletes the profile at the specified index
    function clearProfiles() null // Clears all camera movement profiles
    function switchProfile() null // Switches to a next camera movement profile
    function exportProfiles(name) null // Saves all profiles to a file, you can import them using the command `script import(name)`

    // Frame drawing methods
    function startDrawFrames() null // Initiates the drawing of frames onto the HUD
    function endDrawFrames() null // Ends the drawing of frames onto the HUD

    // Internal methods (not part of the public API and are meant for internal logic)
    function _updateHUD() null // Update the information on the screen
    function _startAnim() null // Begins the camera animation process
    function _cameraRecursion(infoTable) null // Handles the recursive logic for camera movement
    function _DrawFrames() null // Internal method for drawing frames
}

IncludeScript("P2-KeyCam/HUD/screen_text")
IncludeScript("P2-KeyCam/HUD/screen_info")
IncludeScript("P2-KeyCam/HUD/viewport")

/******************************************************************************
*                            KEYFRAME MANAGEMENT
******************************************************************************/

function keyCamera::addKeyframe() {
    local origin = eyePointEntity.GetOrigin()
    local angle = eyePointEntity.GetAngles()
    local forward = eyePointEntity.GetForwardVector()
    local key = keyframe(origin, angle, forward)

    this.currentProfile.addFrame(key)
    this._updateHUD()
}

function keyCamera::deleteKey(idx) {
    this.currentProfile.removeFrame(idx)
    this._updateHUD()
}

function keyCamera::deleteLastKey() {
    this.currentProfile.keyframes.pop()
    this._updateHUD()
}

function keyCamera::clearKeyframes() {
    this.currentProfile.clearFrames()
    this._updateHUD()
}

/******************************************************************************
*                                   SETTERS
******************************************************************************/

function keyCamera::setSpeed(units) {
    this.cameraSpeed = units;
    this.currentProfile.cameraSpeed = units;
    this._updateHUD()
}

function keyCamera::setSpeedEx(units) {
    this.cameraSpeed = units;
    foreach(profile in profiles) {
        profile.cameraSpeed = units;
    }
    this._updateHUD()
}

function keyCamera::getSpeed() {
    return this.currentProfile.getSpeed()
}

/******************************************************************************
*                               PLAYBACK CONTROL
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

    EntFireByHandle(this.gameui, "Deactivate", "", 0.0, GetPlayer())
}

/******************************************************************************
*                                PROFILES CONTROL
******************************************************************************/

function keyCamera::createProfile() {
    local newProfile = camProfile(this.cameraSpeed)
    this.currentProfile = newProfile;
    this.currentProfileIdx = profiles.len()

    profiles.append(newProfile);
    this._updateHUD()
}

function keyCamera::switchProfile() {
    local Currentindex = currentProfileIdx

    foreach(index, info in this.profiles){
        if (index > Currentindex) {
            this.currentProfileIdx = index
            break
        }
    }
    if(currentProfileIdx == Currentindex) {
        currentProfileIdx = 0
    }

    this.currentProfile = profiles[currentProfileIdx]
    this._updateHUD()
}

function keyCamera::deleteProfile(idx) {
    this.profiles.remove(idx - 1)
    this._updateHUD()
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