viewerColors <- [
    Vector(210, 156, 156),
    Vector(198, 155, 186),
    Vector(186, 156, 209),
    Vector(165, 185, 210),
    Vector(159, 210, 197),
    Vector(181, 210, 171),
    Vector(203, 196, 156),
    Vector(208, 171, 156)
]

function keyCamera::startDrawFrames() {
    // fprint("len: {}", viewerColors.len())
    this._DrawFrames()   
}

function keyCamera::endDrawFrames() {
    cancelScheduledEvent("drawFrames")  
}

function keyCamera::_DrawFrames() {
    local scope = this
    CreateScheduleEvent("drawFrames", function():(scope) {scope._DrawFrames()}, 0.08)

    local frames = this.currentProfile.keyframes
    local frames_len = frames.len()
    local color = viewerColors[currentProfileIdx % viewerColors.len()] 

    foreach (idx, frame in frames) {
        local vector = frame.GetOrigin()
        local forward = vector + frame.GetForwardVector() * 15

        DebugDrawBox(vector, Vector(4,4,4), Vector(-4,-4,-4), 125, 125, 125, 100, 0.15)
        DebugDrawLine(vector, forward, 180, 230, 180, false, 0.15)
        
        if(idx != 0 && idx != frames_len) 
            DebugDrawLine(currentProfile.getFrame(idx - 1).GetOrigin(), vector, color.x, color.y, color.z, false, 0.15)
    }
}