utils <- {
    getShortestOrigin = function(startOrigin, endOrigin) {
        return Vector(endOrigin.x - startOrigin.x, 
                    endOrigin.y - startOrigin.y,
                    endOrigin.z - startOrigin.z)
    },

    getShortestAngle = function(startAngles, endAngles) {
        local shortest_angle_x = ((((endAngles.x - startAngles.x) % 360) + 540) % 360) - 180;
        local shortest_angle_y = ((((endAngles.y - startAngles.y) % 360) + 540) % 360) - 180;
        local shortest_angle_z = ((((endAngles.z - startAngles.z) % 360) + 540) % 360) - 180;
        return Vector(shortest_angle_x, shortest_angle_y, shortest_angle_z)
    },

    getTotalStep = function(start, end, cameraSpeed) {
        local distance = end.origin - start.origin
        local totalStep = abs(distance.Length() / cameraSpeed)
        return totalStep.tofloat()
    },

    createAlias = function(key, action) {
        SendToConsole(format("alias \"%s\" \"%s\"", key, action))
        SendToConsole(format("setinfo %s \"\"", key))
        dev.log("The alias \"" + key + "\" was created")
    },

    vecToStr = function(vec) {
        return format("Vector(%f, %f, %f)", vec.x, vec.y, vec.z)
    }
}