function keyCamera::exportProfiles(name = "test") {
    if(currentProfile.getFramesLen() == 0) {
        return printl("No data for export!")
    }

    SendToConsole(format("con_logfile cfg/demo_export_%s.log", name))

    SendToConsole("script printl(\"\\nscript keyCam.profiles.clear()\")")
    foreach(profile in this.profiles) {
        SendToConsole("script printl(\"script keyCam.createProfile()\")")
        SendToConsole("script printl(\"script keyCam.setSpeed("+ profile.getSpeed() + ")\")")
        foreach(frame in profile.keyframes) {
            local origin = _vecToStr(frame.GetOrigin())
            local angles = _vecToStr(frame.GetAngles())
            local forward = _vecToStr( frame.GetForwardVector())

            local command = "script keyCam.currentProfile.addFrame(keyframe(" + origin + ", " + angles + ", " + forward + "))"
            SendToConsole("script printl(\"" + command + "\")")
        }
    }

    SendToConsole("con_logfile off")
    SendToConsole("clear")
    SendToConsole("script printl(\"The data has been successfully exported!\")")
}

function _vecToStr(vec) {
    return format("Vector(%f, %f, %f)", vec.x, vec.y, vec.z)
}

function import(name = "test") {
    SendToConsole("exec demo_export_" + name + ".log")
    SendToConsole("clear")
    SendToConsole("script printl(\"The data has been successfully imported!\")")
}