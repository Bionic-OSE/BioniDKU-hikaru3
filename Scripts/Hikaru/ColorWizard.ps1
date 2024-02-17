# BioniDKU OSXE System Colors Changer - Powered by SuwakoColors - (c) Bionic Butter

function Show-Branding {
	$prodname = (Get-ItemProperty -Path "HKCU:\Software\Hikaru-chan").ProductName
	$host.UI.RawUI.WindowTitle = "$prodname Quick Menu [Administrator]"
	Clear-Host
	Write-Host "$prodname Quick Menu" -ForegroundColor Black -BackgroundColor White
	Write-Host "System Colors changer module" -ForegroundColor White -n; Write-Host " (Powered by SuwakoColors)`r`n"
}
Import-Module -DisableNameChecking $env:SYSTEMDRIVE\Bionic\Hikaru\ColorWizard.psm1

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
			} else {Set-SystemColor $red $gre $blu -Detailed}
		} catch {Write-Host "Please input valid integer numbers." -ForegroundColor Red; Start-Sleep -Seconds 2}
	}
}
