IncludeScript("pcapture/pcapture-lib/pcapture-lib.nut")
IncludeScript("P2-KeyCam/utils.nut")
IncludeScript("P2-KeyCam/SmoothCamera/camera.nut")
IncludeScript("P2-KeyCam/SmoothCamera/exporter.nut")

SendToConsole("sv_alternateticks 0")

keyCam <- keyCamera()


function export(name = "test") {
    keyCam.exportProfiles(name)
}


function setSpeed(units) {
    keyCam.setSpeed(units)
}

function setSpeedEx(units) {
    keyCam.setSpeedEx(units)
}