# BioniDKU OSXE System Colors Changer - Powered by SuwakoColors - (c) Bionic Butter

function Show-Branding {
	$prodname = (Get-ItemProperty -Path "HKCU:\Software\Hikaru-chan").ProductName
	$host.UI.RawUI.WindowTitle = "$prodname Quick Menu [Administrator]"
	Clear-Host
	Write-Host "$prodname Quick Menu" -ForegroundColor Black -BackgroundColor White
	Write-Host "System Colors changer module`r`n" -ForegroundColor White
}
function Set-SystemColor {
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

while ($true) {
	Show-Branding
	Write-Host "Input your desired color in R G and B, separated by spaces" -ForegroundColor White
	Write-Host "(Vaild values are integers from 0 to 255. Note that Windows will not accept all colors. Input 'b' to go back)"
	Write-Host "> " -n; $clri = Read-Host
	if ($clri -like "b") {exit}
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
