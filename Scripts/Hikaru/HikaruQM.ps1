# HikaruQM for BioniDKU OSTE - (c) Bionic Butter

$host.UI.RawUI.WindowTitle = "BioniDKU Quick Menu for OSTE"
$update = (Get-ItemProperty -Path "HKCU:\Software\Hikaru-chan").UpdateAvailable
. $env:SYSTEMDRIVE\Bionic\Hikaru\Hikarestart.ps1

Start-Process "$env:SYSTEMDRIVE\Bionic\Hikaru\FFPlay.exe" -WindowStyle Hidden -ArgumentList "-i $env:SYSTEMDRIVE\Bionic\Hikaru\HikaruQMBeepOSTE.mp3 -nodisp -hide_banner -autoexit -loglevel quiet"

function Show-Branding {
	Clear-Host
	Write-Host "BioniDKU Quick Menu - OSTE edition" -ForegroundColor Black -BackgroundColor White
	Write-Host ' '
}
function Show-Menu {
	Show-Branding
	if ($update -eq 1) {
		Write-Host "9. An update is available, select this option for more information" -ForegroundColor White
		Write-Host " "
	}
	Write-Host "What do you want to do?" -ForegroundColor White
	Write-Host "1. Restart Explorer shell" -ForegroundColor White
	Write-Host "2. Change system colors" -ForegroundColor White
	Write-Host "0. Close this menu" -ForegroundColor White
	Write-Host ' '
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
	Write-Host "These color values will set on your Active title bar color and Highlight color:" -ForegroundColor Cyan
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
	Write-Host "These color values will set on your Inactive title bar color:" -ForegroundColor Cyan
	Write-Host "60% Desaturated RGB Dec color: $redd, $gred, $blud, 255"
	Write-Host "60% Desaturated RGB Hex color: $cldx"
	Write-Host "60% Desaturated BGR Hex color: $dlcx"
	
	Write-Host " "
	Write-Host "Apply the abovementioned colors to the system? (Yes/No): " -ForegroundColor White -n; $bruh = Read-Host
	if ($bruh -like "yes") {
		Set-ItemProperty -Path "HKCU:\Control Panel\Colors" -Name HotTrackingColor -Value "$red $gre $blu" -Type String -Force
		Set-ItemProperty -Path "HKCU:\Control Panel\Colors" -Name Hilight -Value "$red $gre $blu" -Type String -Force
		Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\DWM" -Name AccentColorInactive -Value "0x$dlcx" -Type DWord -Force
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\DefaultColors\Standard" -Name HotTrackingColor -Value "0x$rlc0" -Type DWord -Force
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\DefaultColors\Standard" -Name Hilight -Value "0x$rlc0" -Type DWord -Force
		Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Accent" -Name AccentColorMenu -Value "0x$rlcx" -Type DWord -Force
		Write-Host "SUCCESS" -ForegroundColor Green
		Write-Host "For the highlight color change to take effect, either lock your PC or do Ctrl+Alt+Delete, and come back in." -ForegroundColor Yellow
		Start-Sleep -Seconds 5
	} else {}
}
function Input-SystemColor {
	# SuwakoColors - (c) Bionic Butter
	while ($true) {
		Show-Branding
		Write-Host "Input your desired color in R G and B, separated by spaces" -ForegroundColor White
		Write-Host "(If you input nothing, the input will be inteperted as 0 0 0. Input 'b' to go back)"
		Write-Host "> " -n; $clri = Read-Host
		if ($clri -like "b") {break}
		$redi,$grei,$blui = $clri.Split(" ")
		try {
			$red = [int32]$redi
			$gre = [int32]$grei
			$blu = [int32]$blui
			if ($red -gt 255 -or $gre -gt 255 -or $blu -gt 255 -or $red -lt 0 -or $gre -lt 0 -or $blu -lt 0 -or $red -like '' -or $gre -like '' -or $blu -like '' -or $red -like ' ' -or $gre -like ' ' -or $blu -like ' ' -or $red -eq $null -or $gre -eq $null -or $blu -eq $null) {
				Write-Host "One or more value either exceeds 255, falls below 0, or equals null. Try again" -ForegroundColor Red; Start-Sleep -Seconds 5
			} else {Set-SystemColor}
		} catch {Write-Host "Please input valid integer numbers." -ForegroundColor Red; Start-Sleep -Seconds 5}
	}
}

while ($true) {
	Show-Menu
	Write-Host "Your selection: " -n; $unem = Read-Host
	switch ($unem) {
		{$unem -like "0"} {exit}
		{$unem -like "1"} {Confirm-RestartShell}
		{$unem -like "2"} {Input-SystemColor}
		{$unem -like "9"} {
			if ($update -eq 1) {
				Start-Process $env:SYSTEMDRIVE\Bionic\Hikarefresh\Hikarefreshow.exe
				exit
			}
		}
	}
}
