function DrawKey()
{
    RunScriptCode.delay("DrawKey()", 0.05)
    EntFireByHandle(pseudoHud, "Display")
    if(isRecording || keypoints.len() == 0) 
        return

    foreach (k,vector in keypoints) {
        vector = vector.origin
        DebugDrawBox(vector, Vector(4,4,4), Vector(-4,-4,-4), 171, 214, 213, 100, 0.1)
        if(k != 0 && k != keypoints.len()) 
            DebugDrawLine(keypoints[k-1].origin, vector, 224, 216, 232, false, 0.1)
    }
}