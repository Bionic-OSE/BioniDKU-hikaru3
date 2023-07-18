# HikaruQM's System Sounds Wizard panel - (c) Bionic Butter

$az = [char[]]('a'[0]..'z'[0])
function Set-HikaruDValue($type,$value) {
	switch ($type) {
		{$_ -like "S"} {$typename = "StartupSoundVariant"}
		{$_ -like "C"} {$typename = "ChargingSoundVariant"}
		{$_ -like "L"} {$typename = "LowBattSoundVariant"}
	}
	Set-ItemProperty -Path "HKCU:\Software\Hikaru-chan" -Name $typename -Value $value -Type DWord -Force
}
function Show-StateColor($type,$variant) {
	switch ($type) {
		{$_ -like "S"} {$typename = "StartupSoundVariant"}
		{$_ -like "C"} {$typename = "ChargingSoundVariant"}
		{$_ -like "L"} {$typename = "LowBattSoundVariant"}
	}
	$varireg = (Get-ItemProperty -Path "HKCU:\Software\Hikaru-chan").$typename
	if ($variant -eq $varireg) {$varicfg = "Black"; $varicbg = "White"} else {$varicfg = "White"; $varicbg = "Black"}
	return $varicfg, $varicbg
}
function Start-PlayOrSetSound($type,$action,$variant) {
	switch ($type) {
		{$_ -like "S"} {$typename = "StartupSound"; $typefile = "mp3"; $copy = $false}
		{$_ -like "C"} {$typename = "Alert_charging_"; $typefile = "wma"; $copy = $true}
		{$_ -like "L"} {$typename = "Alert_low_battery_"; $typefile = "wav"; $copy = $true}
	}
	switch ($action) {
		0 {
			Start-Process "$env:SYSTEMDRIVE\Bionic\Hikaru\FFPlay.exe" -WindowStyle Hidden -ArgumentList "-i $env:SYSTEMDRIVE\Bionic\Hikaru\${typename}${variant}.${typefile} -nodisp -hide_banner -autoexit -loglevel quiet"
		}
		{$_ -eq 1 -and $copy} {
			$typenmds = $typename.Substring(0, $typename.Length-1)
			Copy-Item "$env:SYSTEMDRIVE\Bionic\Hikaru\${typename}${variant}.${typefile}" -Destination "$env:SYSTEMDRIVE\Windows\Media\${typenmds}.${typefile}" -Force
		}
	}
}

function Show-IPrompt($type,$descr,$maxvars) {
	while ($true) {
		Show-Branding
		Write-Host "Choose your desired ${descr}:" -ForegroundColor White
		Write-Host "Select a sound by typing its number, and play that sound by typing the letter next to that number."
		Write-Host "Type '0' to go back.`r`n"
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
					Set-HikaruDValue $type $inpint
					Start-PlayOrSetSound $type 1 $inpint
				}
				{$az.Contains([char]$inp)} {
					$inpidx = $az.IndexOf([char]$inp)+1
					Start-PlayOrSetSound $type 0 $inpidx
				}
			}
		}
	}
}
function Show-SoundMenu {
	Show-Branding
	Write-Host "Choose a sound type you want to change:`r`n" -ForegroundColor White
	Write-Host " 1. Sign-in sound" -ForegroundColor White
	Write-Host " 2. Charging sound" -ForegroundColor White
	Write-Host " 3. Low battery sound`r`n" -ForegroundColor White
	Write-Host " 0. Return to main menu`r`n" -ForegroundColor White
}

while ($true) {
	Show-SoundMenu
	Write-Host "> " -n; $snem = Read-Host
	switch ($snem) {
		{$_ -like "0"} {exit}
		{$_ -like "1"} {Show-IPrompt S "sign-in sound" 3}
		{$_ -like "2"} {Show-IPrompt C "charging sound" 5}
        {$_ -like "3"} {Show-IPrompt L "low battery sound" 3}
	}
}
