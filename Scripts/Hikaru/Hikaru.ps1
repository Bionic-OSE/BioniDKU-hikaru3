# Hikaru-chan 3.0 - (c) Bionic Butter

. $env:SYSTEMDRIVE\Bionic\Hikaru\Hikarestart.ps1
Start-Process "$env:SYSTEMDRIVE\Bionic\Hikaru\CADBeep.exe"
$sm = Check-SafeMode
switch ($sm) {
	$false {
		$ssv = (Get-ItemProperty -Path "HKCU:\Software\Hikaru-chan").StartupSoundVariant
		$abr = (Get-ItemProperty -Path "HKCU:\Software\Hikaru-chan").SystemABRState
		$sss = (Get-ItemProperty -Path "HKCU:\Software\Hikaru-chan").Unsealed

		if ($sss -ne 1) {
			Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search' -Name 'SearchBoxTaskbarMode' -Value 0 -Type DWord -Force
			Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name 'HideSCAMeetNow' -Value 1 -Type DWord -Force  -ErrorAction SilentlyContinue
			Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds' -Name 'IsFeedsAvailable' -Value 0 -Type DWord -Force  -ErrorAction SilentlyContinue
		}

		if ($abr -eq 1) {Start-Process "$env:SYSTEMDRIVE\Bionic\Hikaru\AddressBarRemover2.exe"}
		Restart-HikaruShell -NoStop -NoSpin -HKBoot

		taskkill /f /im FFPlay.exe
		Start-Sleep -Seconds 1
		Start-Process "$env:SYSTEMDRIVE\Bionic\Hikaru\HikaruQML.exe"
		Start-Process "$env:SYSTEMDRIVE\Bionic\Hikaru\FFPlay.exe" -WindowStyle Hidden -ArgumentList "-i $env:SYSTEMDRIVE\Bionic\Hikaru\StartupSound${ssv}.mp3 -nodisp -hide_banner -autoexit -loglevel quiet"
	}
	$true {
		taskkill /f /im FFPlay.exe
		Start-Process "$env:SYSTEMDRIVE\Bionic\Hikaru\HikaruSM.exe"
	}
}
