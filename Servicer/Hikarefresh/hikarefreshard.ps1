# Hikaru-chan hard files updater - (c) Bionic Butter

Param(
	[Parameter(Mandatory=$True,Position=0)]
	[int32]$rvm
	[Parameter(Mandatory=$True,Position=1)]
	[bool]$mvm
)

$host.UI.RawUI.WindowTitle = "BioniDKU OSXE System Updater | DO NOT CLOSE THIS WINDOW"
function Show-Branding {
	Clear-Host
	Write-Host "BioniDKU OSXE System Updater" -ForegroundColor Black -BackgroundColor White
	Write-Host "Menus layer updater`r`n"
}

Show-Branding
Write-Host "Updating hard (executables) layer" -ForegroundColor White; Write-Host " "

. $env:SYSTEMDRIVE\Bionic\Hikaru\Hikarestart.ps1
$tempuid = (New-GUID).GUID
New-Item -Path $env:TEMP -Name $tempuid -itemType Directory
Copy-Item -Path  $env:SYSTEMDRIVE\Bionic\Hikarefresh\* -Include 7z*.* -Destination $env:TEMP\$tempuid
Stop-Process -Name HikaruQML
if (Check-SafeMode) {Stop-Process "$env:SYSTEMDRIVE\Bionic\Hikaru\HikaruBuildMod.exe" -Force} else {Stop-ScheduledTask -TaskName 'BioniDKU Windows Build String Modifier'}
Start-Sleep -Seconds 3
Start-Process $env:TEMP\$tempuid\7za.exe -Wait -NoNewWindow -ArgumentList "x $env:SYSTEMDRIVE\Bionic\Executables.7z -pBioniDKU -o$env:SYSTEMDRIVE\Bionic -aoa"
Remove-Item -Path $env:TEMP\$tempuid -Recurse -Force

if ($rvm -ne 1) {
	& $env:SYSTEMDRIVE\Bionic\Hikarefresh\Hikarefreshvi.ps1 $mvm
	Restart-HikaruShell
}
Start-Process $env:SYSTEMDRIVE\Bionic\Hikaru\HikaruQML.exe
Write-Host " "; Write-Host "Update completed" -ForegroundColor Black -BackgroundColor White
Start-Sleep -Seconds 5
