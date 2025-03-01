Wallpaper and Lock Screen Changer Script Documentation
#Overview

This script automates the process of changing the desktop wallpaper and lock screen background on a Windows machine. It uses a combination of Python and PowerShell to fetch a random wallpaper from Unsplash, download it, and set it as the desktop wallpaper and lock screen background.

#Prerequisites

    - Python installed on your machine. Libraries used: requests
    - PowerShell with administrative privileges.
    - Unsplash API access key.
    - Ensure that the PowerShell execution policy allows scripts to run.
	- Command to run in PowerShell window: Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned

#Files

    - fetch_wallpaper.py: Python script to fetch and download the wallpaper.
    - set_wallpaper_lockscreen.ps1: PowerShell script to set the wallpaper and lock screen background.
    - run_wallpaper_script.bat: Batch file to run the PowerShell script.

#Registry Entries

The script modifies the following registry values to set the lock screen and desktop wallpaper backgrounds:
Some of the registry values might needs to be changed manually.

	* Lock Screen Background
    	- Registry Path: HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP
        - LockScreenImagePath: Path to the lock screen image.
        - LockScreenImageStatus: Status of the lock screen image (1 for enabled).
        - LockScreenImageUrl: URL or path to the lock screen image.

	* Desktop Wallpaper
    	- Registry Path: HKEY_CURRENT_USER\Control Panel\Desktop
        - WallPaper: Path to the desktop wallpaper image.
        - TileWallpaper: Status of the wallpaper tiling (0 for not tiled).

	* Additional Desktop Wallpaper Settings
    	* Registry Path: HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP
        - DesktopImagePath: Path to the desktop wallpaper image.
        - DesktopImageStatus: Status of the desktop wallpaper image (1 for enabled).
        - DesktopImageUrl: URL or path to the desktop wallpaper image.

#Usage

    - Run the Batch File: Double-click the run_wallpaper_script.bat file to execute the PowerShell script.
    - Administrative Privileges: Ensure that the batch file is run with administrative privileges if required.

#Troubleshooting

    - Registry Permissions: Ensure that you have the necessary permissions to modify the registry.
    - PowerShell Execution Policy: Ensure that the PowerShell execution policy allows the script to run. You can set the execution policy to Bypass using the batch file.
    - Error Logging: Check the PowerShell script output for any error messages.

#Future Reference

    - Changing Registry Values: If you need to change other registry values or locations, update the PowerShell script accordingly.
    - Script Locations: Ensure that the paths to the Python and PowerShell scripts are correct.
    - Unsplash API: Ensure that your Unsplash API access key is valid and has the necessary permissions.
