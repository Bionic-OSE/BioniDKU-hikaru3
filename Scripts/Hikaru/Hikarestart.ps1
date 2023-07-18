# BioniDKU Quick/Administrative Menu Explorer restarting functions loader

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
function Restart-HikaruShell {
	param ([switch]$Force)
	Start-Process $env:SYSTEMDRIVE\Bionic\Hikaru\FFPlay.exe -WindowStyle Hidden -ArgumentList "-i $env:SYSTEMDRIVE\Bionic\Hikaru\ShellSpinner.mp4 -fs -alwaysontop -noborder -autoexit"
	Start-Sleep -Seconds 2
	Write-Host "Now restarting Explorer..." -ForegroundColor White -n; Write-Host " DO NOT POWER OFF YOUR SYSTEM UNTIL THE MAIN MENU APPEARS!" -ForegroundColor White
	$shhk = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon").Shell
	if ($Force) {taskkill /f /im explorer.exe} else {Start-Process $env:SYSTEMDRIVE\Bionic\Hikaru\ExitExplorer.exe -Wait -NoNewWindow}
	Set-BootMessage $ittt $imsg
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "Shell" -Value 'explorer.exe' -Type String
	Start-Process $env:SYSTEMDRIVE\Windows\explorer.exe
	Start-Sleep -Seconds 3
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "Shell" -Value $shhk -Type String
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
