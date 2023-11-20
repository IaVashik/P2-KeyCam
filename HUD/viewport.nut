viewerColors <- [
    Vector(200, 100, 150), 
    Vector(188, 105, 155), 
    Vector(177, 111, 161), 
    Vector(166, 116, 166), 
    Vector(155, 122, 172), 
    Vector(144, 127, 177), 
    Vector(133, 133, 183), 
    Vector(122, 138, 188), 
    Vector(111, 144, 194), 
    Vector(100, 150, 200),
]

function keyCamera::startDrawFrames() {
    this._DrawFrames()   
}

function keyCamera::endDrawFrames() {
    cancelScheduledEvent("drawFrames")  
}


function keyCamera::_DrawFrames() {
    local scope = this
    CreateScheduleEvent("drawFrames", function(scope):(scope._DrawFrames()), 0.08)

    local frames = CurrentProfile.keyframes
    local frames_len = frames.len()
    local color = viewerColors[currentProfileIdx % 10] 

    foreach (idx, frame in frames) {
        local vector = frame.GetOrigin()

        DebugDrawBox(vector, Vector(4,4,4), Vector(-4,-4,-4), color.x - 30, color.y- 5, color.z - 8, 100, 0.1)
        
        if(idx != 0 && idx != frames_len) 
            DebugDrawLine(CurrentProfile.getFrame(idx - 1).GetOrigin(), vector, color.x, color.y, color.z, false, 0.1)
    }
}