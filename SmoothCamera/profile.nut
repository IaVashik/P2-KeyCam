class camProfile {
    keyframes = arrayLib.new();
    cameraSpeed = 1;

    constructor(speed) {
        this.cameraSpeed = speed
    }

    function addFrame(keyframe) {}

    function removeFrame(idx) {}

    function clearKeyframes() {}

    // function changeKeyframe() {}
}

function profile::addKeyframe(keyframe) {
    this.keyframes.append(keyframe)
}

function profile::clearFrames() {
    keyframes.clear()
} 