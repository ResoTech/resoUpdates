# Set execution policy to unrestricted
#Set-ExecutionPolicy -ExecutionPolicy Unrestricted

# Send message to user
$msgTitle = "Maintenance Notification"
$msgBody = "The computer will be restarted at 8 PM due to maintenance. Please save any open work and log off the computer before this time."

$msgCommand = "msg.exe * /time:300 $msgBody"

Invoke-Expression $msgCommand

# Define output file path
$OutputFile = "C:\resolveUpdates.txt"

# Install the PSWindowsUpdate module
Install-Module -Name PSWindowsUpdate -Force

# Check for updates
$Updates = Get-WUInstall

# Install updates
if ($Updates.Count -gt 0) {
    Write-Output "Installing updates..."
    $Result = Install-WindowsUpdate -AcceptAll -IgnoreReboot -ScheduleReboot $(Get-Date "20:00:00") | Out-String
    $Result | Out-File $OutputFile -Append
}
else {
    Write-Output "No updates available."
    # Schedule restart
    $Date = Get-Date -Hour 20 -Minute 0 -Second 0
    if ($Date -lt (Get-Date)) {
        $Date = $Date.AddDays(1)
    }
    $TimeSpan = $Date - (Get-Date)
    $Seconds = [int]$TimeSpan.TotalSeconds
    $Result = & shutdown.exe /r /t $Seconds /f /d p:4:1 /c "General Maintenance: Restarting device on $($Date.ToString('yyyy-MM-dd')) at 8:00 PM" | Out-String
    $Result | Out-File $OutputFile -Append
}

# Check for failed updates
$FailedUpdates = Get-WULastResults | Where-Object {$_.ResultCode -ne "0"}
if ($FailedUpdates) {
    Write-Output "The following updates failed to install:"
    $FailedUpdates | Format-Table -AutoSize | Out-File $OutputFile -Append | Out-Null
}
else {
    Write-Output "All updates installed successfully."
    # Remove the message about failed updates if there were none
    (Get-Content $OutputFile) | Where-Object {$_ -notlike "The following updates failed to install:*"} | Set-Content $OutputFile
}
