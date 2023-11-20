class keyframe {
    origin = null;
    angle = null;
    forward = null;

    constructor(origin, angle, forward) {
        this.origin = origin;
        this.angle = angle;
        this.forward = forward;
    }

    function GetOrigin() {
        return this.origin
    }

    function GetAngles() {
        return this.angle
    }
    
    function GetForwardVector() {
        return this.forward
    }
}