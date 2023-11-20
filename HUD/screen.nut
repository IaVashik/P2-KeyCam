class screenText {
    CBaseEntity = null; 

    constructor(xPos, yPos, message) {
        this.CBaseEntity = entLib.CreateByClassname("game_text", {
            channel = 2,
            color = "170 170 170",
            color2 = "240 110 0",
            effect = 0,
            fadein = 0,
            fadeout = 0,
            fxtime = 0,
            holdtime = 100,
            x = 0.01,
            y = 0.95,
            spawnflags = 0,
            message = "Selected Profile: 1"
        })
    }

    function enable() {}

    function disable() {}

    function changeText(message) {}

}


function screenText::enable() {
    EntFireByHandle(this.CBaseEntity, "Enable")
}

function screenText::disable() {
    EntFireByHandle(this.CBaseEntity, "Disable")
}

function screenText::changeText(message) {
    this.CBaseEntity.SetKeyValue("message", message)
}