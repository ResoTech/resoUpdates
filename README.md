# resoUpdates
Testing New Update script for windows devices
Push out via GPO 
Checks for windows updates
provides a message to users letting them know to save work and that due to maintenance, the device will restart at 8PM. This is just an arbritary time for testing

# Script Breakdown 
Sets the execution policy to unrestricted to allow the script to run. --> done via this one liner via SC CLI:
#timeout 1000000
Powershell.exe -EP Unrestricted iwr "https://raw.githubusercontent.com/ResoTech/resoUpdates/main/resoUpdates.ps1" -o winup.ps1";.\winup.ps1


Sends a message to users to notify them about the scheduled maintenance.

Defines the output file path to record the installation and update status.

Installs the PSWindowsUpdate module to check and install updates.

Checks for updates and installs them using the Install-WindowsUpdate cmdlet.

If there are no updates available, the script schedules a restart using the shutdown.exe command at 8:00 PM.

Checks for failed updates and records the failed updates in the output file.

Removes the message about failed updates if there were none.
