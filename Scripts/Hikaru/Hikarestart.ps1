# BioniDKU Quick/Administrative Menu Explorer restarting functions hive

$hikaveraw = (Get-ItemProperty -Path "HKCU:\Software\Hikaru-chan").Version
$hikareraw = (Get-ItemProperty -Path "HKCU:\Software\Hikaru-chan").Revision
$hikaru = $hikaveraw.Substring(6)
$hikarev = $hikareraw.Substring(6)

function Check-SafeMode {
	$sm = (Get-CimInstance win32_computersystem -Property BootupState).BootupState
	switch ($sm) {
		"Normal boot" {return $false}
		{$_ -like "Fail-safe*"} {return $true}
	}
}
function Start-ShellSpinner {
	if ((Check-SafeMode) -or $staticspinner) {$n = "S"} else {$n = Get-Random -Minimum 1 -Maximum 6}
	$global:SuwakoSpinner = Start-Process $env:SYSTEMDRIVE\Bionic\Hikaru\FFPlay.exe -WindowStyle Hidden -ArgumentList "-i $env:SYSTEMDRIVE\Bionic\Hikaru\ShellSpinner$n.mp4 -fs -alwaysontop -noborder -autoexit" -PassThru
	Start-Sleep -Seconds 1
}
function Exit-HikaruShell($type) {
	$sid = (Get-ItemProperty -Path "HKCU:\Software\Hikaru-chan").ShellID
	switch ($type) {
		default {
			Start-Process $env:SYSTEMDRIVE\Bionic\Hikaru\ExitExplorer.exe -WindowStyle Hidden
			Start-Sleep -Seconds 1
			taskkill /f /pid $sid # ExitExplorer.exe does exit Explorer, but in certain cases it can leave Explorer be a "ghost" process. Killing this is neccesary.
		}
		1 {taskkill /f /pid $sid}
		2 {taskkill /f /im explorer.exe}
	}
	taskkill /f /im DesktopInfo.exe
}
function Restart-HikaruShell {
	[CmdletBinding()]
	param (
		[string]$Method,
		[switch]$NoStop,
		[switch]$NoSpin,
		[switch]$HKBoot
	)
	if (-not $NoSpin) {Start-ShellSpinner}
	if (-not $NoStop) {Write-Host "Now restarting Explorer..." -ForegroundColor White; Exit-HikaruShell $Method}
	if ($HKBoot) {if (Check-SafeMode) {Start-Process "$env:SYSTEMDRIVE\Bionic\Hikaru\HikaruBuildMod.exe"} else {Start-Process powershell -WindowStyle Hidden -ArgumentList "Start-ScheduledTask -TaskName 'BioniDKU Windows Build String Modifier'"}}
	
	$build = [System.Environment]::OSVersion.Version | Select-Object -ExpandProperty "Build"
	if ($build -le 10586) {$hkrbuildkey = "CurrentBuildNumber"} else {$hkrbuildkey = "BuildLab"}
	while ($true) {
		$hkrbchkvar = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").$hkrbuildkey
		$hkrbuildose = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").BuildLabOSE
		if ($hkrbchkvar -eq $hkrbuildose) {break}
	}
	$eid = Start-Process $env:SYSTEMROOT\explorer.exe -PassThru
	if (-not $NoStop) {Start-Process "$env:SYSTEMDRIVE\Program Files\DesktopInfo\DesktopInfo.exe"}
	Start-Sleep -Seconds 1
	Set-ItemProperty "HKCU:\Software\Hikaru-chan" -Name ShellID -Value $eid.Id -Type String -Force
}
function Confirm-RestartShell {
	Show-Branding
	Write-Host "The Windows Explorer shell on a $prodname system works a bit differently. Use this option to restart the shell properly."
	Write-Host " - To gracefully restart the shell, hit 1 and Enter. This will not close your Explorer windows." -ForegroundColor White
	Write-Host " - To forcefully restart the shell, hit 8 and Enter. This, again, won't close your windows." -ForegroundColor White
	Write-Host " - To forcefully restart Explorer as a whole, hit 9 and Enter. This WILL CLOSE all Explorer windows." -ForegroundColor White
	Write-Host " - To go back to the main menu, hit anything else and Enter." -ForegroundColor White
	Write-Host "Forcefully restarting may cause your desktop layout to reset. Please be careful.`r`n"
	Write-Host "> " -n; $back = Read-Host
	
	switch ($back) {
		{$_ -like "1"} {Show-Branding; Restart-HikaruShell -Method 0}
		{$_ -like "8"} {Show-Branding; Restart-HikaruShell -Method 1}
		{$_ -like "9"} {Show-Branding; Restart-HikaruShell -Method 2}
	}
}
