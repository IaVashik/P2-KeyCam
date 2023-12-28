// Function to export camera profiles to a file with an optional name parameter
function keyCamera::exportProfiles(name = "test") {
    // Check if there is no data to export
    if(profiles.len() == 1 && currentProfile.getFramesLen() == 0) {
        return printl("No data for export!") // Print an error message if there's nothing to export
    }

    // Begin logging to a file with the specified name
    SendToConsole(format("con_logfile cfg/keycam_export_%s.log", name))

    // Write commands to clear existing profiles in the log file
    SendToConsole("script printl(\"\\nscript keyCam.profiles.clear()\")")
    // Loop through each profile and write commands to create profiles and set speed
    foreach(profile in this.profiles) {
        SendToConsole("script printl(\"script keyCam.createProfile()\")")
        SendToConsole("script printl(\"script keyCam.setSpeed("+ profile.getSpeed() + ")\")")
        // Loop through each frame in the profile and write commands to add keyframes
        foreach(frame in profile.keyframes) {
            local origin = utils.vecToStr(frame.GetOrigin())
            local angles = utils.vecToStr(frame.GetAngles())
            local forward = utils.vecToStr(frame.GetForwardVector())

            // Format the command to add a frame and write it to the log file
            local command = "script keyCam.currentProfile.addFrame(keyframe(" + origin + ", " + angles + ", " + forward + "))"
            SendToConsole("script printl(\"" + command + "\")")
        }
    }

    // End logging and notify the user of successful export
    SendToConsole("con_logfile off")
    SendToConsole("clear")
    SendToConsole("script printl(\"The data has been successfully exported!\")")
}

