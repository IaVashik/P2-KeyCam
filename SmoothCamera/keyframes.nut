// 'keyframe' class represents a single camera keyframe with position, orientation, and direction
class keyframe {
    origin = null; // Stores the position (vector) of the camera for this keyframe
    angle = null; // Stores the orientation (vector) of the camera for this keyframe
    forward = null; // Stores the forward direction (vector) of the camera for this keyframe

    constructor(origin, angle, forward) {
        this.origin = origin;
        this.angle = angle;
        this.forward = forward;
    }

    function GetOrigin() Vector // Returns the position vector of the keyframe
    function GetAngles() Vector // Returns the orientation vector of the keyframe
    function GetForwardVector() Vector // Returns the forward direction vector of the keyframe

    function SetOrigin(vector) null // Sets the position vector of the keyframe
    function SetAngles(vector) null // Sets the orientation vector of the keyframe
    function SetForwardVector(vector) null // Sets the forward direction vector of the keyframe

    function _tostring() {
        return "keyframe: " + origin
    }
}

// Implementation of 'GetOrigin' method to return the position vector
function keyframe::GetOrigin() {
    return this.origin
}

// Implementation of 'GetAngles' method to return the orientation vector
function keyframe::GetAngles() {
    return this.angle
}

// Implementation of 'GetForwardVector' method to return the forward direction vector
function keyframe::GetForwardVector() {
    return this.forward
}

// Implementation of 'SetOrigin' method to set the position vector
function keyframe::SetOrigin(vector) {
    this.origin = vector
}

// Implementation of 'SetAngles' method to set the orientation vector
function keyframe::SetAngles(vector) {
    this.angle = vector
}

// Implementation of 'SetForwardVector' method to set the forward direction vector
function keyframe::SetForwardVector(vector) {
    this.forward = vector
}