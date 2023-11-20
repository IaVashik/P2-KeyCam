class keyCamera {
    profiles = arrayLib.new();
    cameraSpeed = 1;
    cameraEnt = null;
    currentProfile = null;
    currentProfileIdx = null;

    constructor() {
        this.cameraEnt = entLib.CreateByClassname("point_viewcontrol")
        this.createProfile()
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
}

// TODO TEXT

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

// TODO TEXT

function keyCamera::playCurrentProfile() {
    
}

function keyCamera::playAllProfiles() {

}

function keyCamera::stopPlayback() {

}

// TODO TEXT

function keyCamera::createProfile() {
    local newProfile = camProfile(this.cameraSpeed)
    profiles.append(newProfile)
    this.switchProfile()
}

function keyCamera::switchProfile() {
    // local Currentindex = CurrentProfile

    // foreach(index, info in presedList.arr){ //! BIG PROBLEM: NO _nexti
    //     if (index > Currentindex) {
    //         CurrentProfile = index
    //         break
    //     }
    // }
    // if(CurrentProfile == Currentindex) {
    //     CurrentProfile = 0
    // }
    // pseudoHud.SetKeyValue("message", "Selected Profile: " + (CurrentProfile + 1))
    // keypoints = presedList[CurrentProfile]
}