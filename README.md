<div align="center">
<img src="other\logo.png" alt="Logo"> <!-- width="660" height="350" -->

<h2 align="center">
    <i>Making cinematic flythroughs easy!</i>
</h2>
</div>

![version](https://img.shields.io/badge/P2--KeyCam-v1.0-informational)

P2-KeyCam is a cinematic camera control tool for Portal 2, designed for crafting seamless camera flythroughs ideal for YouTube videos, level showcases, or highlighting gameplay moments. 
With features like keyframe editing, profile management, real-time adjustments, and export/import capabilities, P2-KeyCam provides *unparalleled* control over your cinematic creations.

## Installation

To install P2-KeyCam:

1. Download or clone the repository
2. Copy the `P2-KeyCam` folder to `portal2/scripts/vscripts/`
3. Copy `KeyCam.cfg` to `portal2/cfg/`
4. Customize the key bindings in the config to suit your preferences.

Here's a quick reference table for the default key bindings:
| Command | Default Key | Description |
|-|-|-|  
| KeyCam_addKeyframe | mouse4 | Add keyframe at current camera position |
| KeyCam_deleteLastKey | mouse5 | Delete last added keyframe |
| KeyCam_clearFrames | 0 | Clear all keyframes in current profile |
| KeyCam_EditFrame | 8 | Edit details of selected keyframe |
| KeyCam_playCurrentProfile | 1 | Play back animation for current profile | 
| KeyCam_playAllProfiles | 9 | Chain playback all profiles sequentially |
| KeyCam_stopPlayback | 2 | Stop camera playback |
| KeyCam_createPreset | Q | Create new camera profile preset |
| KeyCam_switchProfile | 3 | Switch to different camera profile |
| KeyCam_clearProfiles | - | Delete all existing profiles |

5. Load any map and execute the command `exec keycam` in the console.
6. You're all set to capture cinematic footage!
> **Tip**
> For smoother animations, add `-tickrate 120` to your launch options. You may choose a higher value, but it's not recommended. Remember to remove this option when not using *P2-KeyCam* to avoid potential gameplay issues.


## Additional Features

- ### **Profiles** 
    - **Creation:** Create new camera movement presets with `KeyCam_createPreset`
    - **Switching:** Quickly switch between profiles using `KeyCam_switchProfile`
    - **Clearing:** Clear all existing profiles with `KeyCam_clearProfiles`
    - **Selective Deletion:** If you need to delete just one specific profile that's no longer needed or if you made a mistake, use the command `script keyCam.deleteProfile(profile_idx)` in the console, where profile_idx is the index number of the profile you want to delete.

- ### **Speed Customization** 
    - Adjust playback speed for the current profile using `script keyCam.setSpeed(units)`
    - Change playback speed globally across all profiles with `script keyCam.setSpeedEx(units)`
    - Speed is set in units per tick. Higher values give smoother but faster camera movement


- ### **Export and Import Functionality**
    - **Export:** Save all your carefully crafted profiles and settings using the export command `script export(name)`. You can optionally specify a name for the file, otherwise, "test" is used by default. This is particularly useful for backing up your work or sharing with others.
    - **Import:** If you need to move your camera profiles to another map or restore them after making changes, use `script import(name)` to bring them all back. Just make sure to use the same name you exported with to avoid any confusion. Remember that importing a profile with a name that already exists will overwrite the existing data, so use this feature with caution.

## Credit

P2-KeyCam was created by laVashik. When using P2-KeyCam in your videos or projects, please credit me in your description. This VScript depends on PCapture-Lib, which requires crediting the author (laVashik) if used in map for cutscenes.

Licensed under the BSD 3-Clause License - see the [LICENSE](LICENSE) file for details.