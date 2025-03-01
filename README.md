# Wallpaper and Lock Screen Changer Script Documentation 🌟
## Overview

This script automates changing your desktop wallpaper and lock screen background on a Windows machine. It fetches a random or themed wallpaper from Unsplash using its API, downloads it, and applies it using Python 🐍 and PowerShell ⚡. Perfect for keeping your Windows setup fresh!
Prerequisites 📋

Before starting, ensure you have:

    Python installed (3.x recommended).
        Install the requests library:
        bash

    pip install requests

* PowerShell with administrative privileges.
* An Unsplash API access key (details below).
PowerShell execution policy set to allow scripts:

    Run in PowerShell as Administrator:
    powershell

        Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
        Type Y and press Enter to confirm.

## Files 📂

The repository includes:

    fetch_wallpaper.py: Fetches and downloads the wallpaper.
    set_wallpaper_lockscreen.ps1: Sets the wallpaper and lock screen.
    run_wallpaper_script.bat: Triggers the PowerShell script.

## Registry Entries 🔧

The script modifies these registry values:
Lock Screen Background

    Path: HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP
        LockScreenImagePath: File path to the lock screen image.
        LockScreenImageStatus: 1 (enabled).
        LockScreenImageUrl: URL or path (optional).

Desktop Wallpaper

    Path: HKEY_CURRENT_USER\Control Panel\Desktop
        WallPaper: File path to the wallpaper.
        TileWallpaper: 0 (no tiling).

Additional Desktop Settings

    Path: HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP
        DesktopImagePath: File path to the wallpaper.
        DesktopImageStatus: 1 (enabled).
        DesktopImageUrl: URL or path (optional).

Note: Some values may require manual adjustment if permissions or paths differ.

## Getting an Unsplash API Key 🔑

To use Unsplash, you need an API key:

    Sign Up:
        Visit Unsplash.com and create an account.
    Create an App:
        Go to Unsplash Developers.
        Click "Your Apps" > "New Application".
        Name it (e.g., "Wallpaper Changer") and submit.
    Get Your Key:
        Copy the Access Key (e.g., 12345abcde...).
        Add it to fetch_wallpaper.py:
        python

        access_key = "YOUR_ACCESS_KEY_HERE"
    Rate Limits:
        Free tier: 50 requests/hour—sufficient for personal use.

## Usage 🚀

Here’s how to run it:

    Configure:
        Edit fetch_wallpaper.py and insert your API key.
    Execute:
        Double-click:
        bash

        run_wallpaper_script.bat
        Run as Administrator if needed (right-click > "Run as Administrator").
    Enjoy:
        Your desktop and lock screen update with a new image! 🎉

## Scheduling the Script ⏰

Schedule it with Windows Task Scheduler:

    Open Task Scheduler:
        Win + S > "Task Scheduler".
    Create Task:
        Click "Create Task".
    General Tab:
        Name: "Wallpaper Changer".
        Check "Run with highest privileges".
    Triggers Tab:
        "New" > "On a schedule".
        Set frequency/time (e.g., Daily, 8:00 AM).
    Actions Tab:
        "New" > "Start a program".
        Program: Full path to the batch file:
        plaintext

        C:\Scripts\run_wallpaper_script.bat
    Save:
        Click OK and test by running the task manually.

Your wallpaper will now change on schedule! ⏳
## Customizing Wallpaper Themes 🎨

Tweak these variables in fetch_wallpaper.py:
Search Query

    Variable: search_query
    Default: 'monochrome'.
    Purpose: Define a theme or leave empty for random.
    Example:
    python

    search_query = 'nature'  # Fetches nature-themed wallpapers

Collection ID

    Variable: collection_id
    Default: '' (no specific collection).
    Purpose: Pull from a curated Unsplash collection (find IDs in collection URLs, e.g., 1065976).
    Example:
    python

collection_id = '1065976'  # Nature collection
How to Edit:

    Open fetch_wallpaper.py in a text editor.
    Update the values:
    python

        search_query = 'space'
        collection_id = '1234567'
        Save and run the script.

## Troubleshooting 🛠️

    Registry Permissions:
        "Access Denied"? Run as Administrator.
    PowerShell Policy:
        Blocked? Re-run:
        powershell

    Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned

API Errors:

    Verify your API key and rate limits.

Debug:

    Run manually in PowerShell:
    powershell

        .\set_wallpaper_lockscreen.ps1

## Future Enhancements 🌈

    Add multi-monitor support.
    Modify wallpaper fit style via registry.
    Use local images instead of Unsplash.

## Notes 📝

    Ensure script paths in run_wallpaper_script.bat are correct.
    Keep your Unsplash API key secure.

### Enjoy your dynamic wallpapers! ⭐ Star this repo if you find it useful! 😊
