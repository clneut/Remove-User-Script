
Remove all user profiles for window 11 with powershell (Interactive panel maintenance project)
 - Must be run as Administrator.
    - User must be logged off.
    - Deletes the profile via WMI/CIM so both files and registry
      profile entries are cleaned up.
    Run this in powershellscript: Set-ExecutionPolicy RemoteSigned -Scope Process -Force

