viewerColors <- [
    Vector(240, 128, 128),  // светло-красный
    Vector(123, 104, 238),  // средне-фиолетовый
    Vector(255, 165, 30),    // оранжевый
    Vector(135, 206, 235),  // светло-голубой
    Vector(60, 179, 113),   // средне-зеленый
    Vector(255, 228, 181),  // светло-бежевый (персиковый)
    Vector(218, 165, 32),   // золотой
    Vector(238, 130, 238)   // светло-розовый (фиолетовый)
]

function StartDrawFrames() {
    if("NoHud" in getroottable() && NoHud) return
    ScheduleEvent.AddInterval("drawFrames", _drawFrames, 0.08)
}

function EndDrawFrames() {
    ScheduleEvent.TryCancel("drawFrames")
}

function _drawFrames() {
    local frames = currentProfile.keyframes
    local frames_len = frames.len()
    local profileIdx = profiles.search(currentProfile)
    local color = viewerColors[profileIdx % viewerColors.len()] 

    foreach(idx, frame in frames.iter()) {
        local vector = frame.GetOrigin()
        local forward = vector + frame.GetForwardVector() * 30

        DebugDrawBox(vector, Vector(4,4,4), Vector(-4,-4,-4), color.x - 30, color.y - 30, color.z - 30, 100, 0.1)
        DebugDrawLine(vector, forward, 180, 230, 180, false, 0.1)
        
        if(idx != 0 && idx != frames_len) 
            DebugDrawLine(currentProfile.GetFrame(idx - 1).GetOrigin(), vector, color.x, color.y, color.z, true, 0.1)
    }
}