class screenText {
    CBaseEntity = null; 

    constructor(xPos, yPos, message) {
        this.CBaseEntity = entLib.CreateByClassname("game_text", {
            channel = 2,
            color = "170 170 170",
            color2 = "0 0 0",
            effect = 0,
            fadein = 0,
            fadeout = 0,
            fxtime = 0,
            holdtime = 100,
            x = xPos,
            y = yPos,
            spawnflags = 0,
            message = message,
            targetname = "cucumber"
        })
    }

    function enable() {}

    function disable() {}

    function changeText(message) {}

}


function screenText::enable() {
    EntFireByHandle(this.CBaseEntity, "Display")
}

function screenText::disable() {
    EntFireByHandle(this.CBaseEntity, "Disable")
}

function screenText::changeText(message) {
    this.CBaseEntity.SetKeyValue("message", message)
    this.enable()
}