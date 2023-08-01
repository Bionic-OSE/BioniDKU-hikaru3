# HikaruQM for BioniDKU OSTE - (c) Bionic Butter

$update = (Get-ItemProperty -Path "HKCU:\Software\Hikaru-chan").UpdateAvailable
. $env:SYSTEMDRIVE\Bionic\Hikaru\Hikarestart.ps1

Start-Process "$env:SYSTEMDRIVE\Bionic\Hikaru\FFPlay.exe" -WindowStyle Hidden -ArgumentList "-i $env:SYSTEMDRIVE\Bionic\Hikaru\HikaruQMBeepOSTE.mp3 -nodisp -hide_banner -autoexit -loglevel quiet"

function Show-Branding {
	$host.UI.RawUI.WindowTitle = "BioniDKU OSTE Quick Menu"
	Clear-Host
	Write-Host "BioniDKU OSTE Quick Menu" -ForegroundColor Black -BackgroundColor White
	Write-Host ' '
}
function Show-Menu {
	Show-Branding
	$nekoboxinstalled = Test-Path -Path "$env:SYSTEMDRIVE\Bionic\Nekobox\Kernel\Nekoprompt.exe"
	if ($nekoboxinstalled) {$nekoboxopt = "8. Check for Nekobox updates"} else {$nekoboxopt = "8. Install Nekobox"}
	if ($update -eq 1) {
		$updateopt = "9. View update`r`n"
		Write-Host "An update is available, select option 9 for more information`r`n" -ForegroundColor White
	} else {$updateopt = "9. Check for OSTE updates`r`n"}
	Write-Host "What do you want to do?`r`n" -ForegroundColor White
	Write-Host " Shell tasks"
	Write-Host " 1. Restart Explorer shell`r`n" -ForegroundColor White
	Write-Host " Personalize"
	Write-Host " 2. Change system colors" -ForegroundColor White
	Write-Host " 3. Change taskbar location" -ForegroundColor White
	Write-Host " 4. Open BioniDKU OS Wallpapers collection" -ForegroundColor White
	Write-Host " 5. Change system sounds`r`n" -ForegroundColor White
	Write-Host " Configure your device"
	Write-Host " 6. Adjust time settings" -ForegroundColor White
	Write-Host " 7. Adjust power settings`r`n" -ForegroundColor White
	Write-Host " Others"
	Write-Host " ${nekoboxopt}" -ForegroundColor White
	Write-Host " ${updateopt} 0. Close this menu`r`n" -ForegroundColor White
}

function Set-SystemColor {
	# SuwakoColors - (c) Bionic Butter
	$redx = ([System.Convert]::ToString($red,16)).PadLeft(2,'0')
	$grex = ([System.Convert]::ToString($gre,16)).PadLeft(2,'0')
	$blux = ([System.Convert]::ToString($blu,16)).PadLeft(2,'0')
	$clrx = "${redx}${grex}${blux}ff"
	$rlcx = "ff${blux}${grex}${redx}"
	$rlc0 = "00${blux}${grex}${redx}"
	
	Write-Host " "
	Write-Host "These color values will set on your Active title bar color and Highlight color:" -ForegroundColor White
	Write-Host "RGB Dec color: $red, $gre, $blu, 255"
	Write-Host "RGB Hex color: $clrx"
	Write-Host "BGR Hex color: $rlcx"
	Write-Host "RGB Hex array: $bite"
	
	$dsat = 0.6
	$lumi = $red*0.3 + $gre*0.6 + $blu*0.1
	$redd = [Math]::Round($red + $dsat*($lumi-$red))
	$gred = [Math]::Round($gre + $dsat*($lumi-$gre))
	$blud = [Math]::Round($blu + $dsat*($lumi-$blu))
	
	$rddx = ([System.Convert]::ToString($redd,16)).PadLeft(2,'0')
	$grdx = ([System.Convert]::ToString($gred,16)).PadLeft(2,'0')
	$bldx = ([System.Convert]::ToString($blud,16)).PadLeft(2,'0')
	$cldx = "${rddx}${grdx}${bldx}ff"
	$dlcx = "ff${bldx}${grdx}${rddx}"
	
	Write-Host " "
	Write-Host "These color values will set on your Inactive title bar color:" -ForegroundColor White
	Write-Host "60% Desaturated RGB Dec color: $redd, $gred, $blud, 255"
	Write-Host "60% Desaturated RGB Hex color: $cldx"
	Write-Host "60% Desaturated BGR Hex color: $dlcx"
	
	Write-Host " "
	Write-Host "Apply the abovementioned colors to the system? (Yes): " -ForegroundColor White -n; $bruh = Read-Host
	if ($bruh -like "yes") {
		Set-ItemProperty -Path "HKCU:\Control Panel\Colors" -Name HotTrackingColor -Value "$red $gre $blu" -Type String -Force
		Set-ItemProperty -Path "HKCU:\Control Panel\Colors" -Name Hilight -Value "$red $gre $blu" -Type String -Force
		Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\DWM" -Name AccentColorInactive -Value "0x$dlcx" -Type DWord -Force
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\DefaultColors\Standard" -Name HotTrackingColor -Value "0x$rlc0" -Type DWord -Force
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\DefaultColors\Standard" -Name Hilight -Value "0x$rlc0" -Type DWord -Force
		Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Accent" -Name AccentColorMenu -Value "0x$rlcx" -Type DWord -Force
		Write-Host "Colors changed. For the highlight color change to take effect, either lock your device or do Ctrl+Alt+Delete, and come back in." -ForegroundColor White
		Start-Sleep -Seconds 5
	}
}
function Input-SystemColor {
	# SuwakoColors - (c) Bionic Butter
	while ($true) {
		Show-Branding
		Write-Host "Input your desired color in R G and B, separated by spaces" -ForegroundColor White
		Write-Host "(Vaild values are integers from 0 to 255. Note that Windows will not accept all colors. Input 'b' to go back)"
		Write-Host "> " -n; $clri = Read-Host
		if ($clri -like "b") {break}
		if (-not [string]::IsNullOrWhiteSpace($clri)) {
			$redi,$grei,$blui = $clri.Split(" ")
			try {
				$red = [int32]$redi
				$gre = [int32]$grei
				$blu = [int32]$blui
				if ($red -gt 255 -or $gre -gt 255 -or $blu -gt 255 -or $red -lt 0 -or $gre -lt 0 -or $blu -lt 0) {
					Write-Host "One or more value either exceed(s) 255 or fall(s) below 0. Try again" -ForegroundColor Red; Start-Sleep -Seconds 2
				} else {Set-SystemColor}
			} catch {Write-Host "Please input valid integer numbers." -ForegroundColor Red; Start-Sleep -Seconds 2}
		}
	}
}
function Set-TaskbarLocation {
	# Sourced from https://blog.ironmansoftware.com/daily-powershell/windows-11-taskbar-location/
	param(
		[Parameter(Mandatory)]
		[ValidateSet("3", "4", "1", "2")] # Left, Right, Top, Bottom
		$Location
	)
	
	Write-Host "Changing taskbar location" -ForegroundColor White
	
	Start-ShellSpinner
	Exit-HikaruShell
	if ($companion -like "Nilou" -or $companion -like "Erisa") {$tskbt = "Legacy"} else {$tskbt = "3"}
	$bit = 0;
	switch ($Location) {
		"3" { $bit = 0x00 }
		"4" { $bit = 0x02 }
		"1" { $bit = 0x01 }
		"2" { $bit = 0x03 }
	}
	$Settings = (Get-ItemProperty HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\StuckRects${tskbt} -Name Settings).Settings
	$Settings[12] = $bit
	Set-ItemProperty HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\StuckRects${tskbt} -Name Settings -Value $Settings
	
	Restart-HikaruShell -NoStop -NoSpin
}
function Input-TaskbarLocation {
	while ($true) {
		Show-Branding
		Write-Host "Move your taskbar without disabling lockdown using this option. The Explorer shell will be (gracefully) restarted for `r`nchanges to take effect.`r`n" -ForegroundColor White
		Write-Host " Select a taskbar location"
		Write-Host " 1. Top" -ForegroundColor White -n; Write-Host " (OSTE default)"
		Write-Host " 2. Bottom" -ForegroundColor White
		Write-Host " 3. Left" -ForegroundColor White
		Write-Host " 4. Right`r`n" -ForegroundColor White
		Write-Host " 0. Cancel`r`n" -ForegroundColor White
		Write-Host "> " -n; $tskbl = Read-Host
		$tskbv = "1","2","3","4"
		if ($tskbl -like "0") {break}
		if (-not [string]::IsNullOrWhiteSpace($tskbl) -and $tskbv.Contains($tskbl)) {
			Write-Host "Are sure you want to do this? (1): " -ForegroundColor White -n; $bruu = Read-Host
			if ($bruu -like "1") {Set-TaskbarLocation -Location $tskbl}
		}
	}
}
function Open-OSMEBackdrops {
	Start-Process $env:SYSTEMDRIVE\Windows\explorer.exe -ArgumentList "$env:SYSTEMDRIVE\Bionic\Wallpapers"
}
function Start-RunDllCpl($param) {
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name NoControlPanel -Value 0 -Type DWord
	Start-Process rundll32.exe -ArgumentList "$param"
	Start-Sleep -Seconds 1
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name NoControlPanel -Value 1 -Type DWord
}

while ($true) {
	Show-Menu
	Write-Host "> " -n; $unem = Read-Host
	switch ($unem) {
		{$_ -like "0"} {exit}
		{$_ -like "1"} {Confirm-RestartShell}
		{$_ -like "2"} {Input-SystemColor}
		{$_ -like "3"} {Input-TaskbarLocation}
		{$_ -like "4"} {Open-OSMEBackdrops}
		{$_ -like "5"} {& $env:SYSTEMDRIVE\Bionic\Hikaru\SoundWizard.ps1}
		{$_ -like "6"} {Start-RunDllCpl "shell32.dll,Control_RunDLL TimeDate.cpl,,0"}
		{$_ -like "7"} {Start-RunDllCpl "shell32.dll,Control_RunDLL PowerCfg.cpl @0,/editplan:381b4222-f694-41f0-9685-ff5bb260df2e"}
		{$_ -like "8"} {
			Start-Process powershell -Wait -WindowStyle Hidden -ArgumentList "& $env:SYSTEMDRIVE\Bionic\Nekobox\Updater\Nekodatenn.ps1"
			& $env:SYSTEMDRIVE\Bionic\Nekobox\Updater\Nekodatedl.ps1
		}
		{$_ -like "9"} {
			if ($update -eq 1) {
				Start-Process $env:SYSTEMDRIVE\Bionic\Hikarefresh\Hikarefreshow.exe
				exit
			} else {
				Set-ItemProperty -Path "HKCU:\Software\Hikaru-chan" -Name "UpdateCheckerLaunchedFrom" -Value "QM" -Type String -Force
				Start-Process $env:SYSTEMDRIVE\Bionic\Hikarefresh\Hikarefresh.exe
				exit
			}
		}
	}
}
