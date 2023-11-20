class camProfile {
    keyframes = arrayLib.new();
    cameraSpeed = 1;

    constructor(speed) {
        this.cameraSpeed = speed
    }

    function len() {return keyframes.len()}

    function addFrame(keyframe) {}

    function getFrame(idx) {}

    function getFramesLen()

    function removeFrame(idx) {}

    function clearKeyframes() {}

    // function changeKeyframe() {}
}


function profile::addKeyframe(keyframe) {
    this.keyframes.append(keyframe)
}

function profile::getFrame(idx) {
    return this.keyframes[idx]
}

function profile::removeFrame(idx) {
    this.keyframes.remove(idx)
} 

function profile::clearFrames() {
    this.keyframes.clear()
} 

function profile::getFramesLen() {
    return this.keyframes.len()
}