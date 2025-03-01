# Get the directory of the current script
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# Parameters for source and destination for the Image file
$ImageDestinationFolder = Join-Path $scriptDir "downloads"  # Folder for the wallpaper image
$WallpaperDestinationFile = Join-Path $ImageDestinationFolder "wallpaper.jpg"  # Wallpaper image
$LockScreenDestinationFile = Join-Path $ImageDestinationFolder "LockScreen.jpg"  # Lockscreen image

# Creates the destination folder on the target computer
Write-Output "Creating destination folder: $ImageDestinationFolder"
mkdir $ImageDestinationFolder -ErrorAction SilentlyContinue

# Run the Python script to fetch and download the wallpaper
$pythonScript = Join-Path $scriptDir "fetch_wallpaper.py"  # Path to your Python script
Write-Output "Running Python script to fetch wallpaper..."
python $pythonScript

# Check if the Python script executed successfully and the wallpaper was downloaded
if (Test-Path $WallpaperDestinationFile) {
    Write-Output "Wallpaper downloaded successfully: $WallpaperDestinationFile"
    
    # Copy the wallpaper to the lock screen destination
    Copy-Item -Path $WallpaperDestinationFile -Destination $LockScreenDestinationFile -Force
    Write-Output "Copied wallpaper to lock screen destination: $LockScreenDestinationFile"

    # Check if the Wallpaper class is already defined
    if (-not ([System.Management.Automation.PSTypeName]'Wallpaper').Type) {
        Add-Type @"
        using System;
        using System.Runtime.InteropServices;
        public class Wallpaper {
            [DllImport("user32.dll", CharSet=CharSet.Auto)]
            private static extern int SystemParametersInfo (int uAction, int uParam, string lpvParam, int fuWinIni);
            public static void SetWallpaper(string path) {
                SystemParametersInfo(20, 0, path, 3);
            }
        }
"@
    }

    Write-Output "Setting wallpaper using SystemParametersInfo"
    [Wallpaper]::SetWallpaper($WallpaperDestinationFile)

    # Verify if the wallpaper was set correctly
    $currentWallpaper = Get-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name WallPaper
    if ($currentWallpaper.WallPaper -eq $WallpaperDestinationFile) {
        Write-Output "Wallpaper set successfully: $WallpaperDestinationFile"
    } else {
        Write-Output "Failed to set wallpaper: $WallpaperDestinationFile"
    }

    # Refresh the desktop to apply the new wallpaper
    Write-Output "Refreshing the desktop to apply the new wallpaper"
    Start-Process "RUNDLL32.EXE" "user32.dll,UpdatePerUserSystemParameters"

    # Assign the lock screen background using registry
    $RegKeyPath = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP'
    $LockScreenPath = "LockScreenImagePath"
    $LockScreenStatus = "LockScreenImageStatus"
    $LockScreenUrl = "LockScreenImageUrl"
    $DesktopImagePath = "DesktopImagePath"
    $DesktopImageStatus = "DesktopImageStatus"
    $DesktopImageUrl = "DesktopImageUrl"
    $StatusValue = "1"
    $ImageValue = "$LockScreenDestinationFile"

    Write-Output "Checking if registry key exists: $RegKeyPath"
    if (!(Test-Path $RegKeyPath)) {
        Write-Output "Creating registry key: $RegKeyPath"
        New-Item -Path $RegKeyPath -Force | Out-Null
    }

    Write-Output "Setting registry values for lock screen and desktop"
    New-ItemProperty -Path $RegKeyPath -Name $LockScreenStatus -Value $StatusValue -PropertyType DWORD -Force | Out-Null
    New-ItemProperty -Path $RegKeyPath -Name $LockScreenPath -Value $ImageValue -PropertyType STRING -Force | Out-Null
    New-ItemProperty -Path $RegKeyPath -Name $LockScreenUrl -Value $ImageValue -PropertyType STRING -Force | Out-Null
    New-ItemProperty -Path $RegKeyPath -Name $DesktopImageStatus -Value $StatusValue -PropertyType DWORD -Force | Out-Null
    New-ItemProperty -Path $RegKeyPath -Name $DesktopImagePath -Value $ImageValue -PropertyType STRING -Force | Out-Null
    New-ItemProperty -Path $RegKeyPath -Name $DesktopImageUrl -Value $ImageValue -PropertyType STRING -Force | Out-Null

    # Verify the registry settings
    Write-Output "Verifying registry settings"
    $LockScreenStatusValue = Get-ItemProperty -Path $RegKeyPath -Name $LockScreenStatus
    $LockScreenPathValue = Get-ItemProperty -Path $RegKeyPath -Name $LockScreenPath
    $LockScreenUrlValue = Get-ItemProperty -Path $RegKeyPath -Name $LockScreenUrl
    $DesktopImageStatusValue = Get-ItemProperty -Path $RegKeyPath -Name $DesktopImageStatus
    $DesktopImagePathValue = Get-ItemProperty -Path $RegKeyPath -Name $DesktopImagePath
    $DesktopImageUrlValue = Get-ItemProperty -Path $RegKeyPath -Name $DesktopImageUrl

    Write-Output "LockScreenImageStatus: $($LockScreenStatusValue.$LockScreenStatus)"
    Write-Output "LockScreenImagePath: $($LockScreenPathValue.$LockScreenPath)"
    Write-Output "LockScreenImageUrl: $($LockScreenUrlValue.$LockScreenUrl)"
    Write-Output "DesktopImageStatus: $($DesktopImageStatusValue.$DesktopImageStatus)"
    Write-Output "DesktopImagePath: $($DesktopImagePathValue.$DesktopImagePath)"
    Write-Output "DesktopImageUrl: $($DesktopImageUrlValue.$DesktopImageUrl)"

    # Clears the error log from PowerShell before exiting
    $error.clear()
    Write-Output "Script execution completed"
} else {
    Write-Output "Error: Wallpaper file not found at $WallpaperDestinationFile."
}
