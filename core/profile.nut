class Profile {
    keyframes = null; // Stores the keyframes for the camera movement within this profile
    cameraSpeed = 1; // Speed for camera movement
    lerpFunc = null;

    constructor(speed) {
        this.keyframes = List(); 
        this.cameraSpeed = speed;
    }

    function AddFrame(keyframe) null // Adds a new keyframe to the profile
    function GetFrame(idx) keyframe // Retrieves a keyframe by index
    function len() int // Returns the number of keyframes in the profile

    function RemoveFrame(idx) null // Removes a keyframe at a specified index
    function ClearFrames() null // Clears all keyframes from the profile

    function GetSpeed() float // Returns the current camera speed for this profile
}

// Implementation of 'addFrame' method to append a keyframe to the profile
function Profile::AddFrame(keyframe) {
    this.keyframes.append(keyframe)
}

// Implementation of 'getFrame' method to retrieve a keyframe by index
function Profile::GetFrame(idx) {
    return this.keyframes[idx]
}

// Implementation of 'len' method to return the number of keyframes
function Profile::len() {
    return this.keyframes.len()
}

// Implementation of 'removeFrame' method to remove a keyframe at a specified index
function Profile::RemoveFrame(idx) {
    this.keyframes.remove(idx)
} 

// Implementation of 'clearFrames' method to clear all keyframes from the profile
function Profile::ClearFrames() {
    this.keyframes.clear()
} 

// Implementation of 'getSpeed' method to return the camera speed of the profile
function Profile::GetSpeed() {
    return this.cameraSpeed
}