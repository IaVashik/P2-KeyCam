IncludeScript("P2-KeyCam//pcapture-lib.nut")
IncludeScript("P2-KeyCam/utils.nut")
IncludeScript("P2-KeyCam/SmoothCamera/camera.nut")
IncludeScript("P2-KeyCam/SmoothCamera/exporter.nut")
IncludeScript("P2-KeyCam/SmoothCamera/keyframes_editor") // Experimental feature

SendToConsole("sv_alternateticks 0")

keyCam <- keyCamera()


function export(name = "test") {
    keyCam.exportProfiles(name)
}

function import(name = "test") {
    keyCam.profiles.clear()
    SendToConsole("exec keycam_export_" + name + ".log")
}

function setSpeed(units) {
    keyCam.setSpeed(units)
}

function setSpeedEx(units) {
    keyCam.setSpeedEx(units)
}