<# Chau Nguyen
.SYNOPSIS
    Delete a local user profile in Windows 11.

.DESCRIPTION
    - Must be run as Administrator.
    - User must be logged off.
    - Deletes the profile via WMI/CIM so both files and registry
      profile entries are cleaned up.
    Run this in powershellscript: Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
    Copy the file path and add & before the file path : &"C:\Users\baominhchau.nguye\Downloads\Remove_UserProfile.ps1"
#>

# Run this script in an elevated PowerShell session (Run as Administrator)

# Profiles to keep (folder names under C:\Users)
$ExcludedProfiles = @(
    'bl setup',
    'maintenance',
    'bl user'
)

# Optional: also keep some standard/system profiles
$ExcludedProfiles += @(
    'Administrator',
    'Default',
    'Default User',
    'Public',
    'All Users'
)

Write-Host "Excluded profiles:" ($ExcludedProfiles -join ', ')

# Get all user profiles via CIM
$profiles = Get-CimInstance -Class Win32_UserProfile

foreach ($profile in $profiles) {
    # Skip special/system profiles and profiles without a local path
    if ($profile.Special -eq $true -or [string]::IsNullOrWhiteSpace($profile.LocalPath)) {
        continue
    }

    # Extract folder name from LocalPath (e.g. C:\Users\username -> username)
    $folderName = Split-Path $profile.LocalPath -Leaf

    # Skip if this profile folder is in the exclusion list
    if ($ExcludedProfiles -contains $folderName) {
        Write-Host "Skipping profile:" $profile.LocalPath
        continue
    }

    # Safety: skip if profile is currently in use (loaded)
    if ($profile.Loaded -eq $true) {
        Write-Host "Profile in use, skipping:" $profile.LocalPath
        continue
    }

    # At this point, we will delete the profile
    Write-Host "Deleting profile:" $profile.LocalPath

    # Remove profile (uncomment Remove-CimInstance when ready)
    # Remove-CimInstance -InputObject $profile
}

Write-Host "Done. Review output above."
