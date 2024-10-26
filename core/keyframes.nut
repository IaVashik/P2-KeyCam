class KeyFrame {
    origin = null; // Stores the position of the camera for this KeyFrame
    angles = null; // Stores the orientation of the camera for this KeyFrame
    forward = null; // Stores the forward direction of the camera for this KeyFrame
    timeCreated = 0;

    constructor(origin, angles, forward) {
        this.origin = origin;
        this.angles = angles;
        this.forward = forward;
        this.timeCreated = Time() // why not :0
    }

    function GetOrigin() Vector // Returns the position vector of the KeyFrame
    function GetAngles() Vector // Returns the orientation vector of the KeyFrame
    function GetForwardVector() Vector // Returns the forward direction vector of the KeyFrame

    function SetOrigin(vector) null // Sets the position vector of the KeyFrame
    function SetAngles(vector) null // Sets the orientation vector of the KeyFrame
    function SetForwardVector(vector) null // Sets the forward direction vector of the KeyFrame

    function _tostring() {
        return "KeyFrame: " + origin
    }
}

// Implementation of 'GetOrigin' method to return the position vector
function KeyFrame::GetOrigin() {
    return this.origin
}

// Implementation of 'GetAngles' method to return the orientation vector
function KeyFrame::GetAngles() {
    return this.angles
}

// Implementation of 'GetForwardVector' method to return the forward direction vector
function KeyFrame::GetForwardVector() {
    return this.forward
}

// Implementation of 'SetOrigin' method to set the position vector
function KeyFrame::SetOrigin(vector) {
    this.origin = vector
}

// Implementation of 'SetAngles' method to set the orientation vector
function KeyFrame::SetAngles(vector) {
    this.angles = vector
}

// Implementation of 'SetForwardVector' method to set the forward direction vector
function KeyFrame::SetForwardVector(vector) {
    this.forward = vector
}