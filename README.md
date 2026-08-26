
Remove all user profiles for window 11 with powershell (Interactive panel maintenance project)
 - Must be run as Administrator.
    - User must be logged off.
    - Deletes the profile via WMI/CIM so both files and registry
      profile entries are cleaned up.
    Run this in powershellscript before using the file: Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
    Copy the file path and add & before the file path : &"C:\Users\baominhchau.nguye\Downloads\Remove_UserProfile.ps1"
