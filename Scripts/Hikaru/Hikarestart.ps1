# BioniDKU Quick/Administrative Menu Explorer restarting functions loader

$shhk = "$env:SYSTEMDRIVE\Bionic\Hikaru\AdvancedRun.exe /run$env:SYSTEMDRIVE\Bionic\Hikaru\Hikaru.cfg"
$companion = (Get-ItemProperty -Path "HKCU:\Software\Hikaru-chan").Companion
if ($companion -like "Nilou" -or $companion -like "Erisa") {$attached = "SearchApp"} else {$attached = "SearchUI"}

function Start-ShellSpinner {
	Start-Process $env:SYSTEMDRIVE\Bionic\Hikaru\FFPlay.exe -WindowStyle Hidden -ArgumentList "-i $env:SYSTEMDRIVE\Bionic\Hikaru\ShellSpinner.mp4 -fs -alwaysontop -noborder -autoexit"
	Start-Sleep -Seconds 1
}

function Set-BootMessage {
	Set-ItemProperty "HKLM:\SYSTEM\Setup" -Name CmdLine -Value "cmd.exe /c $env:SYSTEMDRIVE\Bionic\Hikaru\Hikarepair.bat" -Type String -Force
	Set-ItemProperty "HKLM:\SYSTEM\Setup" -Name SystemSetupInProgress -Value 1 -Type DWord -Force
	Set-ItemProperty "HKLM:\SYSTEM\Setup" -Name SetupType -Value 2 -Type DWord -Force
}
function Clear-BootMessage {
	Set-ItemProperty "HKLM:\SYSTEM\Setup" -Name CmdLine -Value "" -Type String -Force
	Set-ItemProperty "HKLM:\SYSTEM\Setup" -Name SystemSetupInProgress -Value 0 -Type DWord -Force
	Set-ItemProperty "HKLM:\SYSTEM\Setup" -Name SetupType -Value 0 -Type DWord -Force
}
function Exit-HikaruShell {
	Start-Process $env:SYSTEMDRIVE\Bionic\Hikaru\ExitExplorer.exe -WindowStyle Hidden
	if ($companion -like "Collei") {
		taskkill /f /im SearchUI.exe
		Start-Sleep -Seconds 1
	} else {Wait-Process -Name $attached -ErrorAction SilentlyContinue}
}
function Restart-HikaruShell {
	param (
		[switch]$Force,
		[switch]$NoStop,
		[switch]$NoSpin
	)
	if (-not $NoSpin) {Start-ShellSpinner}
	Write-Host "Now restarting Explorer..." -ForegroundColor White
	Write-Host "DO NOT POWER OFF YOUR SYSTEM OR CLOSE THIS WINDOW UNTIL THE MAIN MENU APPEARS!" -ForegroundColor White
	if (-not $NoStop) {if ($Force) {taskkill /f /im explorer.exe} else {Exit-HikaruShell}}
	Set-BootMessage
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "Shell" -Value 'explorer.exe' -Type String -Force
	Start-Sleep -Seconds 2
	Start-Process $env:SYSTEMDRIVE\Windows\explorer.exe
	Start-Process $env:SYSTEMDRIVE\Bionic\Hikaru\SkipExplorer.exe
	Write-Host "If by any chance a new Explorer window is opened instead of the shell, press Ctrl+Q to retry starting it again." -ForegroundColor White
	while ($true) {
		$attaching = Get-Process -Name $attached -ErrorAction SilentlyContinue
		if ($attaching) {break}
	}
	Stop-Process -Name "SkipExplorer" -Force -ErrorAction SilentlyContinue
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "Shell" -Value $shhk -Type String -Force
	Clear-BootMessage
}
function Confirm-RestartShell {
	Show-Branding
	Write-Host "The Explorer shell on a BioniDKU enabled system works a bit differently, and thus restarting by normal means will `r`nresult in an Explorer window opening instead of the shell restarting. Use this option to restart the shell properly.`r`n"
	Write-Host " - To gracefully restart (only) the shell, hit 1 and Enter. This will not close your Explorer windows." -ForegroundColor White
	Write-Host " - To forcefully restart the shell (and Explorer as a whole), hit 9 and Enter.`r`n   This will close all Explorer windows and you may lose your desktop layout. Be careful when using this option." -ForegroundColor White
	Write-Host " - To go back to the main menu, hit anything else and Enter.`r`n" -ForegroundColor White
	Write-Host "Graceful shell restart is achieved using Winaero's `"ExitExplorer`" (how did I not know this before?)`r`n"
	Write-Host "> " -n; $back = Read-Host
	switch ($back) {
		{$_ -like "1"} {
			Show-Branding
			Restart-HikaruShell
		}
		{$_ -like "9"} {
			Show-Branding
			Restart-HikaruShell -Force
		}
	}
}
