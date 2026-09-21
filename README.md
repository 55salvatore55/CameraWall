# CameraWall

CameraWall is an AutoHotkey v2 application designed to automatically
open, arrange and refresh multiple Windows Explorer windows used for
CCTV image monitoring.

It was developed for a surveillance system where cameras continuously
upload JPG images to folders through FTP.

CameraWall automatically:

- Opens the configured camera folders.
- Finds the most recent JPG image.
- Arranges Explorer windows according to a saved layout.
- Uses Extra Large Icons for camera folders.
- Detects missing camera folders.
- Opens folders automatically when they become available.
- Detects the change to a new day.
- Reloads the camera folders after midnight.
- Restores the saved window layout.
- Supports local and network paths.

---

## Features

### Automatic camera folders

Each camera can be configured independently in `Config.ini`.

CameraWall builds the path for the current date automatically.

Example:

    C:\CameraData\CAMERA_1\2026-08-10\01\pic

The date folder is generated automatically using the current date.

### Extra Large Icons

CameraWall explicitly sets Windows Explorer to Extra Large Icons.

This prevents Explorer's saved folder-view preferences from changing
the camera display unexpectedly.

### Automatic refresh

CameraWall periodically checks the camera folders.

If a camera folder becomes available after the program has started,
CameraWall automatically opens it.

This is useful when a camera or FTP service becomes available later.

### Daily folder change

At the beginning of a new day, CameraWall detects the date change,
closes the previous Explorer windows and opens the folders belonging
to the new date.

The saved layout is then restored.

### Saved layout

Window positions and sizes can be saved with:

    F9

The layout is stored in `Layout.ini`.

The layout is specific to the computer and monitor configuration.

If `Layout.ini` does not exist, CameraWall starts without a saved
layout. The user can arrange the windows and press F9 to create one.

### Network paths

Camera folders do not have to be located on the same computer.

Windows network paths are supported, for example:

    \\SERVER\CameraData\CAMERA_1

The only requirement is that Windows Explorer can access the configured
path.

---

## Requirements

- Windows
- AutoHotkey v2
- Windows Explorer
- Access to the configured camera folders

CameraWall has been tested on:

- Windows 10
- Windows 7

The application was also tested on different computers and screen
resolutions.

---

## Installation

1. Install AutoHotkey v2.
2. Copy the CameraWall folder to a suitable location.
3. Copy `Config.ini.example` to `Config.ini`.
4. Edit `Config.ini` according to your camera folders.
5. Run `CameraWall.ahk`.

The first time CameraWall is started, no `Layout.ini` is required.

Arrange the Explorer windows as desired and press F9 to save the layout.

---

## Configuration

Camera configuration is stored in `Config.ini`.

A configuration example is provided as:

    Config.ini.example

Example:

    [GENERAL]
    CameraCount=8

    [CAMERA1]
    Enabled=1
    Name=Camera 1
    BasePath=C:\CameraData\CAMERA_1
    SubFolder=01\pic

Each camera section contains:

- `Enabled` — enables or disables the camera.
- `Name` — display name used in the log.
- `BasePath` — base folder containing the date folders.
- `SubFolder` — folder below the date folder containing the JPG images.

---

## Project Structure

    CameraWall/
    │
    ├── CameraWall.ahk
    ├── Config.ini.example
    ├── README.md
    ├── CHANGELOG.md
    ├── .gitignore
    │
    └── Source/
        ├── Camera.ahk
        ├── Config.ahk
        ├── Explorer.ahk
        ├── Layout.ahk
        ├── Refresh.ahk
        └── Utils.ahk

`Config.ini` and `Layout.ini` are user-specific files and are not
included in the public repository.

---

## Logging

CameraWall writes operational information to:

    CameraWall.log

The log can be useful for troubleshooting camera availability,
Explorer windows and refresh operations.

---

## Troubleshooting

If a camera folder is not available when CameraWall starts, the camera
is skipped.

CameraWall periodically checks for missing folders and opens them
automatically when they become available.

If troubleshooting is required, additional diagnostic logging can be
temporarily enabled in `Refresh.ahk`.

---

## Version

Current release:

**CameraWall 1.0.2**

This is the first stable release.

---

## License

See the `LICENSE` file included with the project.