function keyCamera::_updateHUD() {
    local info = "     KeyCam Info:"
    info += "\nAvailable profiles: " + this.profiles.len()
    info += "\nSelected Profile: " + (this.currentProfileIdx + 1)
    info += "\nNumber of keyframes: " + this.currentProfile.getFramesLen()
    info += "\nCamera Speed: " + this.currentProfile.getSpeed()

    local needTime = 0
    if(this.currentProfile.getFramesLen() > 1) {
        for(local i = 1; i < this.currentProfile.getFramesLen(); i++){
            local length = (currentProfile.getFrame(i).GetOrigin() - currentProfile.getFrame(i - 1).GetOrigin()).Length()
            needTime += (length * FrameTime()) / this.currentProfile.getSpeed()
        }
    }
    info += "\nAnim Time: " + needTime

    this.cameraHUD.changeText(info)
}
