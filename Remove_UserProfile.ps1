<# Chau Nguyen
.SYNOPSIS
    Delete a local user profile in Windows 11.

.DESCRIPTION
    - Must be run as Administrator.
    - User must be logged off.
    - Deletes the profile via WMI/CIM so both files and registry
      profile entries are cleaned up.
    Run this in powershellscript: Set-ExecutionPolicy RemoteSigned -Scope Process -Force

#>

Write-Host "=== Delete Windows User Profile ===" -ForegroundColor Cyan
Write-Host "Run this as Administrator and make sure the user is logged off." -ForegroundColor Yellow

# Ask user for the profile folder name (e.g. the folder under C:\Users)
$UserName = Read-Host -Prompt "Enter the profile folder name (as shown under C:\Users)"

if ([string]::IsNullOrWhiteSpace($UserName)) {
    Write-Host "No profile name entered. Exiting." -ForegroundColor Red
    exit 1
}

Write-Host "Deleting profile for '$UserName'..." -ForegroundColor Yellow

# Find the profile whose local path ends with the specified folder name
$profile = Get-CimInstance -ClassName Win32_UserProfile |
    Where-Object { $_.LocalPath -and ($_.LocalPath.Split('\')[-1] -ieq $UserName) }

if (-not $profile) {
    Write-Host "No profile found for '$UserName'. Check C:\Users for the exact folder name." -ForegroundColor Red
    exit 1
}

if ($profile.Loaded) {
    Write-Host "Profile is currently loaded (user likely logged on). Log off that user and try again." -ForegroundColor Red
    exit 1
}

try {
    Remove-CimInstance -InputObject $profile -ErrorAction Stop
    Write-Host "Profile for '$UserName' deleted successfully." -ForegroundColor Green
}
catch {
    Write-Host "Failed to delete profile: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}


