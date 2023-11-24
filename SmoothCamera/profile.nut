class camProfile {
    keyframes = null;
    cameraSpeed = 1;

    constructor(speed) {
        this.keyframes = arrayLib.new();
        this.cameraSpeed = speed;
    }

    function addFrame(keyframe) {}

    function getFrame(idx) {}

    function getFramesLen()

    function removeFrame(idx) {}

    function clearFrames() {}

    function getSpeed() {}

    // function changeKeyframe() {}
}


function camProfile::addFrame(keyframe) {
    this.keyframes.append(keyframe)
}

function camProfile::getFrame(idx) {
    return this.keyframes[idx]
}

function camProfile::removeFrame(idx) {
    this.keyframes.remove(idx)
} 

function camProfile::clearFrames() {
    this.keyframes.clear()
} 

function camProfile::getFramesLen() {
    return this.keyframes.len()
}

function camProfile::getSpeed() {
    return this.cameraSpeed
}