# BioniDKU OSXE Modern Standby Configurator - (c) Bionic Butter

function Show-Branding {
	$prodname = (Get-ItemProperty -Path "HKCU:\Software\Hikaru-chan").ProductName
	$host.UI.RawUI.WindowTitle = "$prodname Administrative Menu [Administrator]"
	Clear-Host
	Write-Host "$prodname Administrative Menu" -ForegroundColor Black -BackgroundColor Magenta
	Write-Host "Modern Standby configuration module`r`n" -ForegroundColor White
}

$global:battery = (Get-CimInstance -ClassName Win32_Battery)
if (-not (Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Power\PowerSettings\f15576e8-98b7-4186-b944-eafa664402d9")) {
	Show-Branding
	Write-Host "You are about to activate the experimental Modern Standby control panel". -ForegroundColor Yellow
	Write-Host "This feature, while included in this update, has not yet been announced to everyone."
	Write-Host "If you found this entrace, it is very likely that I told you about it."
	Write-Host "For now, please activate ONLY when I told you to do so!`r`n" -ForegroundColor White
	
	Write-Host 'To active this hidden menu, type "activate". Type anything else to go back.'
	Write-Host "> " -n; $activ = Read-Host
	
	if ($activ -like "activate") {
		Start-Process reg.exe -Wait -NoNewWindow -ArgumentList "add HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Power\PowerSettings\f15576e8-98b7-4186-b944-eafa664402d9 /v ACSettingIndex /t REG_DWORD /d 1 /f"
		if ($null -ne $battery) {Start-Process reg.exe -Wait -NoNewWindow -ArgumentList "add 	HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Power\PowerSettings\f15576e8-98b7-4186-b944-eafa664402d9 /v DCSettingIndex /t REG_DWORD /d 0 /f"}
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

$state0k = "HKLM:\SYSTEM\CurrentControlSet\Control\Power"
$state0kc = "HKLM:\SOFTWARE\Policies\Microsoft\Power\PowerSettings\f15576e8-98b7-4186-b944-eafa664402d9"

function Show-StandbyMenu {
	Show-Branding
	$state0st = (Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power").PlatformAoAcOverride
	Write-Host "Select an action:`r`n" -ForegroundColor White
	Write-Host " 1. Toggle Modern Standby (S0) (currently " -ForegroundColor White -n; Show-Disenabled $state0k "PlatformAoAcOverride"; Write-Host ")"
	if ($state0st -eq 1) {
		Write-Host " 2. Keep Wi-Fi enabled while in S0, plugged in (currently " -ForegroundColor White -n; Show-Disenabled $state0kc "ACSettingIndex"; Write-Host ")"
		if ($null -ne $battery) {Write-Host " 3. Keep Wi-Fi enabled while in S0, on battery (currently " -ForegroundColor White -n; Show-Disenabled $state0kc "DCSettingIndex"; Write-Host ")`r`n"}
	}
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
		0 {exit}
	}

}