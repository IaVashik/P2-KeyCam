<div align="center">
<img src="https://i.ibb.co/xXBbCJj/KeyCam2.png" alt="Logo"> <!-- width="660" height="350" -->

<h2 align="center">
    <i>Making cinematic flythroughs easy!</i>
</h2>
</div>

![version](https://img.shields.io/badge/P2--KeyCam-v2.0-informational)

P2-KeyCam is a cinematic camera control tool for Portal 2, designed for crafting seamless camera flythroughs ideal for YouTube videos, level showcases, or highlighting gameplay moments. 
With features like keyframe editing, profile management, real-time adjustments, and export/import capabilities, P2-KeyCam provides *unparalleled* control over your cinematic creations.

## Installation

To install P2-KeyCam:

1. Download or clone the repository.
2. Copy the `P2-KeyCam` folder to `portal2/scripts/vscripts/`.
3. Copy `KeyCam.cfg` to `portal2/cfg/`.
4. Customize the key bindings in the config to suit your preferences.

### Running P2-KeyCam

Load any map and execute the command `exec KeyCam` in the console. You’re all set to capture cinematic footage!

> **Tip**  
> For smoother animations, add `-tickrate 124` to your launch options. If you don't set this, alternate ticks will be disabled as a compensation, which may lead to camera instability. Higher values can improve animation smoothness, but may affect gameplay.  
> **FPS Calculation**: FPS of animations is calculated as `tickrate / 2`.

### Key Bindings

Here’s a quick reference table for the default key bindings:

| Command                     | Default Key | Description                                            |
|-----------------------------|-------------|--------------------------------------------------------|
| KeyCam_AddKeyframe          | mouse4      | Add keyframe at current camera position                |
| KeyCam_DeleteLastKey        | mouse5      | Delete last added keyframe                             |
| KeyCam_ClearFrames          | 0           | Clear all keyframes in current profile                 |
| KeyCam_EditFrame            | 8           | Edit details of selected keyframe                      |
| KeyCam_PlayCurrentProfile    | 1           | Play back animation for current profile                |
| KeyCam_PlayAllProfiles      | 9           | Chain playback all profiles sequentially                |
| KeyCam_StopPlayback         | 2           | Stop camera playback                                   |
| KeyCam_CreatePreset         | Q           | Create new camera profile preset                       |
| KeyCam_SwitchProfile        | 3           | Switch to different camera profile                     |
| KeyCam_ClearProfiles        | -           | Delete all existing profiles                           |
| KeyCam_HideHud             | N/A         | Hide HUD elements (crosshair, net_graph, etc.)        |
| KeyCam_ShowHud             | N/A         | Show HUD elements                                      |
| help_KeyCam                | N/A         | Display help information                               |

### Additional Features

P2-KeyCam offers a variety of console commands for advanced control and customization:

- **Keyframe Management:**
    - `script DeleteFrame(idx)`: Remove a specific keyframe by its index.

- **Profile Management:**
    - `script DeleteProfile(idx)`: Delete a specific profile by its index.

- **Playback Control:**
    - `script PlayProfile(idx)`: Play a specific profile by its index (useful for cutscenes).
    - `script StopPlayback()`: Stop camera playback and restore HUD elements.

- **Camera Settings:**
    - `script SetSpeed(units)`: Set the camera movement speed for the current profile (units per tick).
    - `script SetSpeedEx(units)`: Set the camera movement speed for all profiles (units per tick).
    - `script SetLerp(lerpFunc)`: Set the interpolation function for smoother camera transitions (e.g., `script SetLerp(math.lerp.easeInOutQuad)`).
    - `script GetSpeed()`: Get the current profile's camera speed.
    - `script GetLerp()`: Get the current interpolation method as a string.

- **Export/Import:**
    - `script Export("test")`: Export all profiles and settings to a file named `demo_export_<name>.log`.
    - `script Import("test")`: Import profiles and settings from a file named `demo_export_<name>.log`.

- **Debugging:**
    - `EnableBindHelper <0/1>` (in `KeyCam.cfg`): Enable/disable on-screen debugging information.

### Using Keyframe Editor

The Keyframe Editor allows you to modify camera keyframes in real-time. Here's how to use it:

1. Call the `TryChangeFrame()` function to activate the editor.
2. The editor will check if the player is looking at a keyframe. If so, it will allow you to edit its position and angles.
3. Use the following controls to modify the keyframe:
   - **Move Left/Right**: Adjusts the keyframe position or angle.
   - **Move Forward/Backward**: Moves the keyframe in the specified direction.
   - **Duck**: Toggles the downward adjustment for the keyframe position.
   - **Jump**: Inverts the downward adjustment.

4. To exit the editor, press the "Attack2"/"Use" button.

The editor updates the camera's position and angles based on your adjustments, allowing for precise control over cutscenes.

**Note**: The spacebar is used to invert the `toDown` movement.

### Using P2-KeyCam for Cutscenes

P2-KeyCam can also be utilized in your maps for cutscenes. Here’s a quick guide:

1. **Setup:** Load your map, launch KeyCam, set keyframes, create profiles, and configure everything as needed.
2. **Export:** Export your setup using the `script Export("mycutscene")` command, replacing "mycutscene" with your desired filename.
3. **Integration:** In your map's vscript, include the following code:

```squirrel
::NoHud <- true // Disables HUD elements during the cutscene
IncludeScript("p2-keycam/keycam")
Import("mycutscene")

function MyFunc() {
    PlayProfile(1) // Play the first profile (adjust index as needed) 
                   // IMPORTANT: Do not play animations immediately after including the script.
                   // Allow at least 0.3 seconds for the Import to complete.
}
```

Now you can play animations using any of the track functions: `PlayCurrentProfile`, `PlayProfile`, or `PlayAllProfiles`.

## Credit

P2-KeyCam was created by laVashik. Credit is *required* when using P2-KeyCam in your videos or projects. I respect content creators, and I appreciate you respecting my work as well. This VScript depends on PCapture-Lib, which also requires crediting the author (laVashik) if used in maps for cutscenes.

Licensed under the BSD 3-Clause License - see the [LICENSE](LICENSE) file for details.