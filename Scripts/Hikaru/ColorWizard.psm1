# SuwakoColors functions module for BioniDKU OS - (c) Bionic Butter

function Convert-SystemColor {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$True,Position=0)]
		[int32]$red,
		[Parameter(Mandatory=$True,Position=1)]
		[int32]$gre,
		[Parameter(Mandatory=$True,Position=2)]
		[int32]$blu,
		[switch]$Detailed
	)
	
	$redx = ([System.Convert]::ToString($red,16)).PadLeft(2,'0')
	$grex = ([System.Convert]::ToString($gre,16)).PadLeft(2,'0')
	$blux = ([System.Convert]::ToString($blu,16)).PadLeft(2,'0')
	$clrx = "${redx}${grex}${blux}ff"
	$rlcx = "ff${blux}${grex}${redx}"
	$rlc0 = "00${blux}${grex}${redx}"
	
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
	
	if ($Detailed) {return $dlcx, $rlcx, $rlc0, $clrx, $redd, $gred, $blud, $cldx} else {return $dlcx, $rlcx, $rlc0}
}
function Set-SystemColor {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$True,Position=0)]
		[int32]$red,
		[Parameter(Mandatory=$True,Position=1)]
		[int32]$gre,
		[Parameter(Mandatory=$True,Position=2)]
		[int32]$blu,
		[switch]$NoHilight,
		[switch]$Detailed,
		[switch]$Force
	)
	
	if ($Detailed) {
		$dlcx, $rlcx, $rlc0, $clrx, $redd, $gred, $blud, $cldx = Convert-SystemColor $red $gre $blu -Detailed
	} else {
		$dlcx, $rlcx, $rlc0 = Convert-SystemColor $red $gre $blu
	}
	
	if (-not $Force) {
		if ($Detailed) {
			if (-not $NoHilight) {$verbh = " and Highlight color"} else {$verbh = $null}
			Write-Host "`r`nThese color values will set on your Active title bar color${verbh}:" -ForegroundColor White
			Write-Host "RGB Dec color: $red, $gre, $blu, 255"
			Write-Host "RGB Hex color: $clrx"
			Write-Host "BGR Hex color: $rlcx`r`n"
			Write-Host "These color values will set on your Inactive title bar color:" -ForegroundColor White
			Write-Host "60% Desaturated RGB Dec color: $redd, $gred, $blud, 255"
			Write-Host "60% Desaturated RGB Hex color: $cldx"
			Write-Host "60% Desaturated BGR Hex color: $dlcx `r`n"
			
			$verbc = "colors"
		} else {$verbc = "color"}
		
		Write-Host "Apply the specified $verbc to the system? (Yes): " -ForegroundColor White -n; $bruh = Read-Host
		if ($bruh -notlike "yes") {return}
	}
	
	Set-ItemProperty -Path "HKCU:\Software\Hikaru-chan" -Name ShellIC -Value "$red $gre $blu" -Type String -Force
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\DWM" -Name AccentColorInactive -Value "0x$dlcx" -Type DWord -Force
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Accent" -Name AccentColorMenu -Value "0x$rlcx" -Type DWord -Force
	
	if (-not $NoHilight) {
		Set-ItemProperty -Path "HKCU:\Control Panel\Colors" -Name HotTrackingColor -Value "$red $gre $blu" -Type String -Force
		Set-ItemProperty -Path "HKCU:\Control Panel\Colors" -Name Hilight -Value "$red $gre $blu" -Type String -Force
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\DefaultColors\Standard" -Name HotTrackingColor -Value "0x$rlc0" -Type DWord -Force
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\DefaultColors\Standard" -Name Hilight -Value "0x$rlc0" -Type DWord -Force
	}
	
	if (-not $Force) {
		Write-Host "`r`nColors changed." -ForegroundColor White
		if (-not $NoHilight) {Write-Host "For the highlight color change to take effect, either lock or do Ctrl+Alt+Delete, and come back in."} 
		Start-Sleep -Seconds 5
	}
	return
}