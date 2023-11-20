function export(name = "test") {
    result <- "importKeyPoints(["
    foreach(arr in presedList.arr) {
        result += "\n\t["
        foreach(elements in arr) {
            result += "\n\t\t{"
            foreach(keyname, keyinfo in elements) {
                result += keyname + " = " + format("Vector(%f, %f, %f)", keyinfo.x, keyinfo.y, keyinfo.z) + ", "
            }
            result = result.slice(0, -2) + "}"
        }
        result += "\n], "
    }
    result += "\n])"
    
    SendToConsole(format("con_logfile scripts/vscripts/demo_export_%s.log", name))
    SendToConsole("script printl(result)")
    SendToConsole("con_logfile off")
    // SendToConsole("clear; echo Done! :>")
}