// 'camProfile' class represents a single camera movement profile
class camProfile {
    keyframes = null; // Stores the keyframes for the camera movement within this profile
    cameraSpeed = 1; // Speed for camera movement

    constructor(speed) {
        this.keyframes = arrayLib.new(); 
        this.cameraSpeed = speed;
    }

    function addFrame(keyframe) null // Adds a new keyframe to the profile
    function getFrame(idx) keyframe // Retrieves a keyframe by index
    function getFramesLen() int // Returns the number of keyframes in the profile

    function removeFrame(idx) null // Removes a keyframe at a specified index
    function clearFrames() null // Clears all keyframes from the profile

    function getSpeed() float // Returns the current camera speed for this profile

    function _get(idx) return this.keyframes[idx];

    function _nexti(previdx) {
        if(this.keyframes.len() == 0) return null
        if (previdx == null) return 0;
		return previdx < this.keyframes.len() - 1 ? previdx + 1 : null;
	}
}

// Implementation of 'addFrame' method to append a keyframe to the profile
function camProfile::addFrame(keyframe) {
    this.keyframes.append(keyframe)
}

// Implementation of 'getFrame' method to retrieve a keyframe by index
function camProfile::getFrame(idx) {
    return this.keyframes[idx]
}

// Implementation of 'getFramesLen' method to return the number of keyframes
function camProfile::getFramesLen() {
    return this.keyframes.len()
}

// Implementation of 'removeFrame' method to remove a keyframe at a specified index
function camProfile::removeFrame(idx) {
    this.keyframes.remove(idx)
} 

// Implementation of 'clearFrames' method to clear all keyframes from the profile
function camProfile::clearFrames() {
    this.keyframes.clear()
} 

// Implementation of 'getSpeed' method to return the camera speed of the profile
function camProfile::getSpeed() {
    return this.cameraSpeed
}