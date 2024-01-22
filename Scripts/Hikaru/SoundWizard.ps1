# BioniDKU OSXE Sound changer script

function Show-StateColor($type,$variant) {
	$varireg = (Get-ItemProperty -Path "HKCU:\Software\Hikaru-chan")."${type}SoundVariant"
	if ($variant -eq $varireg) {$varicfg = "Black"; $varicbg = "White"} else {$varicfg = "White"; $varicbg = "Black"}
	return $varicfg, $varicbg
}
function Start-PlaySound($type,$variant) {
	if ($type -like "Charging") {$typefile = "wma"} else {$typefile = "mp3"}
	Start-Process "$env:SYSTEMDRIVE\Bionic\Hikaru\FFPlay.exe" -WindowStyle Hidden -ArgumentList "-i $env:SYSTEMDRIVE\Bionic\Hikaru\${type}Sound${variant}.${typefile} -nodisp -hide_banner -autoexit -loglevel quiet"
}
function Set-SystemSound($typeno,$variantno) {
	switch ($typeno) {
		2 {
			Write-Host "Changing sounds..." -ForegroundColor White
			reg import "$env:SYSTEMDRIVE\Bionic\Hikaru\SystemSound${variantno}.reg"
			Start-Sleep -Seconds 1
		}
		3 {
			Copy-Item "$env:SYSTEMDRIVE\Bionic\Hikaru\ChargingSound${variantno}.wma" -Destination "$env:SYSTEMDRIVE\Windows\Media\Alert_charging.wma" -Force
		}
	}
}
function Show-IPrompt($typeno,$maxvars,$typedisp) {
	switch ($typeno) {
		1 {$type = "Startup"}
		2 {$type = "System"}
		3 {$type = "Charging"}
	}
	while ($true) {
		Show-Branding
		if ($typeno -eq 3) {$typemsg = "Type a number higher than $maxvars to disable the charging sound. "} else {$typemsg = $null}
		Write-Host "Choose your desired ${typedisp}:" -ForegroundColor White
		Write-Host "Select a variant by typing its number, and preview that variant by typing the letter next to that number."
		Write-Host "${typemsg}Type '0' to go back.`r`n"
		for ($v = 1; $v -le $maxvars; $v++) {
			$l = $az[$v-1]; $vfg, $vbg = Show-StateColor $type $v
			Write-Host "    " -n; Write-Host "$v.$l"  -ForegroundColor $vfg -BackgroundColor $vbg -n
		}
		Write-Host "`r`n"
		Write-Host "> " -n; $inp = Read-Host
		if (-not [string]::IsNullOrWhiteSpace($inp)) {
			if ($inp -like "0") {break}

			$inpvld = (1..$maxvars); $inpint = -1
			$inpcnv = [System.Int32]::TryParse($inp,[ref]$inpint)
			switch ($true) {
				{$inpint.GetType().Name -like "Int32" -and $inpvld.Contains($inpint)} {
					if ($typeno -eq 2 -or $typeno -eq 3) {Set-SystemSound $typeno $inpint}
					Set-ItemProperty -Path "HKCU:\Software\Hikaru-chan" -Name "${type}SoundVariant" -Value $inpint -Type DWord -Force
				}
				{$inpint.GetType().Name -like "Int32" -and $inpint -gt $maxvars -and $typeno -eq 3} {
					Set-SystemSound 3 0
					Set-ItemProperty -Path "HKCU:\Software\Hikaru-chan" -Name "ChargingSoundVariant" -Value 0 -Type DWord -Force
				}
				{$az.Contains([char]$inp)} {
					$inpidx = $az.IndexOf([char]$inp)+1
					Start-PlaySound $type $inpidx
				}
			}
		}
	}
}
function Show-SoundMenu {
	Show-Branding
	Write-Host "Choose a sound type you want to change:`r`n" -ForegroundColor White
	Write-Host " 1. Sign-in sound" -ForegroundColor White
	Write-Host " 2. System sound pack" -ForegroundColor White
	Write-Host " 3. Charging sound`r`n" -ForegroundColor White
	Write-Host " 0. Return to main menu`r`n" -ForegroundColor White
}

$az = [char[]]('a'[0]..'z'[0])

while ($true) {
	Show-SoundMenu
	Write-Host "> " -n; $action = Read-Host
	
	switch ($action) {
		1 {$actioname = "sign-in sound"; $actionmax = 3}
		2 {$actioname = "system sounds pack"; $actionmax = 3}
		3 {$actioname = "charging sound"; $actionmax = 6}
		0 {exit}
	}
	
	Show-IPrompt $action $actionmax $actioname
}
