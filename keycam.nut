IncludeScript("pcapture/pcapture-lib/pcapture-lib.nut")
IncludeScript("P2-KeyCam/utils.nut")
IncludeScript("P2-KeyCam/SmoothCamera/camera.nut")

IncludeScript("P2-KeyCam/io/exporter.nut")
// IncludeScript("P2-KeyCam/io/importer.nut")

SendToConsole("sv_alternateticks 0")

keyCam <- keyCamera()


function export(name = "test") {
    keyCam.exportProfiles(name)
}

function import(name = "test") {
    SendToConsole("exec demo_export_" + name + ".log")
    SendToConsole("clear")
    SendToConsole("script printl(\"The data has been successfully imported!\")")
}