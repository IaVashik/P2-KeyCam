class screenText {
    CBaseEntity = null; // Stores `game_text` ent

    constructor(xPos, yPos, message, targetname = "") {
        this.CBaseEntity = entLib.CreateByClassname("game_text", {
            // Set initial properties for the text display entity
            channel = 2,
            color = "170 170 170",
            color2 = "0 0 0",
            effect = 0,
            fadein = 0,
            fadeout = 0,
            fxtime = 0,
            holdtime = 1000,
            x = xPos,
            y = yPos,
            spawnflags = 0,
            message = message,
            targetname = targetname
        })
    }

    function enable() null // Enables the text display
    function disable() null // Disables the text display
    function changeText(message) null // Changes the message of the text display

    function _tostring() {
        return this.CBaseEntity
    }
}

// Implementation of 'enable' to display the on-screen text
function screenText::enable() {
    EntFireByHandle(this.CBaseEntity, "Display")
}

// Implementation of 'disable' to hide the on-screen text
function screenText::disable() {
    EntFireByHandle(this.CBaseEntity, "Disable")
}

// Implementation of 'changeText' to change the message and re-enable the text display
function screenText::changeText(message) {
    this.CBaseEntity.SetKeyValue("message", message)
    this.enable()
}