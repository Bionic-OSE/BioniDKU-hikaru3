# BioniDKU OSXE Modern Standby Configurator - (c) Bionic Butter

$global:battery = (Get-CimInstance -ClassName Win32_Battery)
if (-not (Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Power\PowerSettings\f15576e8-98b7-4186-b944-eafa664402d9")) {
	Show-Branding
	Write-Host "You are about to activate the experimental Modern Standby control panel". -ForegroundColor Yellow
	Write-Host "This module, when activated, will take control from Windows over the Modern Standby (S0) settings on your image,"
	Write-Host "allowing you to disable it and/or adjust a few of its settings. And there's good reason why it's hidden from the menu."
	Write-Host "Activating this module on hardware that does NOT NATIVELY support the opposite power modes will cause power havocs to"
	Write-Host "your system. On newer S0 capable systems, deactivating it can cause Unconscious S3 (never waking up) or no sleep at all."
	Write-Host "On the good old standard S3-only system, activating it will cause Fake S0 where sleep will act simply like a display off"
	Write-Host "button, and can POTENTIALLY screw up S3 even after you undid the switch."
	Write-Host "Ideally, you should never activate this module on non-S0 systems. If your system is S0 capable, please check to make sure"
	Write-Host "that it supports other power modes. POWERCFG and the internet is your friend.`r`n"

	
	Write-Host 'To active this hidden menu, type "activate". Type anything else to go back.' -ForegroundColor White
	Write-Host "> " -n; $activ = Read-Host
	
	if ($activ -like "activate") {
		Start-Process reg.exe -Wait -NoNewWindow -ArgumentList "add HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Power\PowerSettings\f15576e8-98b7-4186-b944-eafa664402d9 /v ACSettingIndex /t REG_DWORD /d 0 /f"
		if ($null -ne $battery) {Start-Process reg.exe -Wait -NoNewWindow -ArgumentList "add HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Power\PowerSettings\f15576e8-98b7-4186-b944-eafa664402d9 /v DCSettingIndex /t REG_DWORD /d 0 /f"}
		Start-Process reg.exe -Wait -NoNewWindow -ArgumentList "add HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Power /v PlatformAoAcOverride /t REG_DWORD /d 1 /f"
	} else {exit}
}
function Show-Disenabled($regkey,$regvalue) {
	$regreturns = (Get-ItemProperty -Path $regkey).$regvalue
	if ($regreturns -eq 1) {
		Write-Host -ForegroundColor Green "ENABLED" -n
	} else {
		Write-Host -ForegroundColor Red "DISABLED" -n
	}
}
function Select-Disenabled($regkey,$regvalue) {
	$regreturns = (Get-ItemProperty -Path "$regkey").$regvalue
	if ($regreturns -eq 1) {
		Set-ItemProperty -Path "$regkey" -Name $regvalue -Value 0 -Type DWord -Force
	} else {
		Set-ItemProperty -Path "$regkey" -Name $regvalue -Value 1 -Type DWord -Force
	}
}
function Disable-StandbyMenu {
	Show-Branding
	Write-Host "Deactivating this module will return the power mode control back to Windows. However there is no guarantee that"
	Write-Host "this will certainly fix any of the issues you encountered it was activated and/or while the power settings was being"
	Write-Host "altered by this module. Again, I warned you before you activated this."
	Write-Host "`r`nAre sure you want to deactivate this module?" -ForegroundColor Yellow -n; Write-Host " (Yes): " -n; $state0da = Read-Host
	
	if ($state0da -like "yes") {
		Start-Process reg.exe -Wait -NoNewWindow -ArgumentList "delete HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Power\PowerSettings\f15576e8-98b7-4186-b944-eafa664402d9 /f"
		Start-Process reg.exe -Wait -NoNewWindow -ArgumentList "delete HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Power /v PlatformAoAcOverride /f"
		
		Write-Host "`r`nTo apply changes, you will need to restart your device. Do it now?" -ForegroundColor Cyan -n; Write-Host " (Yes): " -n; $state0rm = Read-Host
		if ($state0rm -notlike "yes") {exit}

		. $env:SYSTEMDRIVE\Bionic\Hikaru\Hikarestart.ps1
		Start-ShellSpinner; shutdown -r -t 5 -c " "; Start-Sleep -Seconds 30; exit
	} else {return}
}

$state0k = "HKLM:\SYSTEM\CurrentControlSet\Control\Power"
$state0kc = "HKLM:\SOFTWARE\Policies\Microsoft\Power\PowerSettings\f15576e8-98b7-4186-b944-eafa664402d9"

function Show-StandbyMenu {
	Show-Branding
	$state0st = (Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power").PlatformAoAcOverride
	Write-Host "Control the Modern Standy feature on your device (EXPERIMENTAL)`r`n"  -ForegroundColor White
	Write-Host " Main actions:"
	Write-Host " 1. Toggle Modern Standby (S0) (currently " -ForegroundColor White -n; Show-Disenabled $state0k "PlatformAoAcOverride"; Write-Host ")"
	if ($state0st -eq 1) {
		Write-Host " 2. Keep Wi-Fi enabled while in S0, plugged in (currently " -ForegroundColor White -n; Show-Disenabled $state0kc "ACSettingIndex"; Write-Host ")"
		if ($null -ne $battery) {Write-Host " 3. Keep Wi-Fi enabled while in S0, on battery (currently " -ForegroundColor White -n; Show-Disenabled $state0kc "DCSettingIndex"; Write-Host ")`r`n"}
	}
	Write-Host " Module actions:"
	Write-Host " 4. Deactivate this module" -ForegroundColor White
	Write-Host " 0. Return to main menu`r`n" -ForegroundColor White
}
function Select-StandState {
	Write-Host "`r`nAre sure you want to switch the Modern Standby state?" -ForegroundColor Yellow -n; Write-Host " (Yes): " -n; $state0fm = Read-Host
	if ($state0fm -notlike "yes") {return}
	
	Select-Disenabled $state0k "PlatformAoAcOverride"

	Write-Host "`r`nTo apply changes, you will need to restart your device. Do it now?" -ForegroundColor Cyan -n; Write-Host " (Yes): " -n; $state0rm = Read-Host
	if ($state0rm -notlike "yes") {return}

	. $env:SYSTEMDRIVE\Bionic\Hikaru\Hikarestart.ps1
	Start-ShellSpinner; shutdown -r -t 5 -c " "; Start-Sleep -Seconds 30
}

while ($true) {
	Show-StandbyMenu
	Write-Host "> " -n; $action = Read-Host
	
	switch ($action) {
		1 {Select-StandState}
		2 {Select-Disenabled $state0kc "ACSettingIndex"}
		{$_ -eq 3 -and $null -ne $battery} {Select-Disenabled $state0kc "DCSettingIndex"}
		4 {Disable-StandbyMenu}
		0 {exit}
	}

}
