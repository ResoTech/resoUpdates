# Set execution policy to unrestricted
Set-ExecutionPolicy -ExecutionPolicy Unrestricted

# Send message to user
$msgTitle = "Maintenance Notification"
$msgBody = "The computer will be restarted at 8 PM due to maintenance. Please save any open work and log off the computer before this time."

$msgCommand = "msg.exe * /time:300 $msgBody"

Invoke-Expression $msgCommand

# Define output file path
$OutputFile = "C:\resolveUpdates.txt"

# Install the PSWindowsUpdate module
Install-Module -Name PSWindowsUpdate -Force

# Import the module
Import-Module -Name PSWindowsUpdate

# Check for updates
$Updates = Get-WUInstall

# Install updates
if ($Updates) {
    Write-Output "Installing updates..."
    $Result = Install-WindowsUpdate -AcceptAll -IgnoreReboot -ScheduleReboot $(Get-Date "20:00:00") | Out-String
    $Result | Out-File $OutputFile -Append
}
else {
    Write-Output "No updates available."
}

# Check for failed updates
$FailedUpdates = Get-WULastResults | Where-Object {$_.ResultCode -ne "0"}
if ($FailedUpdates) {
    Write-Output "The following updates failed to install:"
    $FailedUpdates | Format-Table -AutoSize | Out-File $OutputFile -Append
}
else {
    Write-Output "All updates installed successfully."
}
