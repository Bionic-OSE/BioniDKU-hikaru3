# Hikaru-chan on-demand updater - (c) Bionic Butter

function Show-WindowTitle($nc) {
	if ($nc -eq 1) {$noclose = " | DO NOT CLOSE THIS WINDOW OR DISCONNECT INTERNET"} else {$noclose = $null}
	$host.UI.RawUI.WindowTitle = "BioniDKU OSXE System Updater$noclose"
}
function Show-Branding {
	. $env:SYSTEMDRIVE\Bionic\Hikarefresh\ServicinFOLD.ps1
	Clear-Host
	Write-Host "BioniDKU OSXE System Updater" -ForegroundColor Black -BackgroundColor White
	Write-Host "Version $servicer - (c) Bionic Butter`r`n" -ForegroundColor White
}
function Start-DownloadLoop($file) {
	while ($true) {
		Start-Process $env:SYSTEMDRIVE\Bionic\Hikarefresh\wget.exe -Wait -NoNewWindow -ArgumentList "https://github.com/Bionic-OSE/BioniDKU-hikaru3/releases/latest/download/${file}" -WorkingDirectory "$PSScriptRoot\Delivery"
		Show-WindowTitle 1
		if (Test-Path -Path "$PSScriptRoot\Delivery\${file}" -PathType Leaf) {break} else {
			Write-Host " "
			Write-Host -ForegroundColor White "Did the transfer fail?" -n; Write-Host " Retrying..."
			Start-Sleep -Seconds 1
		}
	}
}
function Start-Hikarefreshing($hv,$rv,$mv) {
	if ($mv) {
		$mvt = '$true'
		try {
			Start-Process powershell -Verb RunAs -ArgumentList "& $env:SYSTEMDRIVE\Bionic\Kirisame\Magicroll\MagicrollLauncher.ps1"
		} catch {return}
		Start-Process $env:SYSTEMDRIVE\Bionic\Kirisame\Magicroll\Magicdrum.exe
	} else {$mvt = '$false'}
	Show-WindowTitle 1
	Show-Branding
	Write-Host "Got it, proceeding to update" -ForegroundColor White; Write-Host " "
	Start-Sleep -Seconds 3
	Write-Host "Updating soft (scripts) layer" -ForegroundColor White
	if (Test-Path -Path "$PSScriptRoot\Delivery\Scripts.7z.old") {Remove-Item -Path "$PSScriptRoot\Delivery\Scripts.7z.old" -Force}
	if (Test-Path -Path "$PSScriptRoot\Delivery\Executables.7z.old") {Remove-Item -Path "$PSScriptRoot\Delivery\Executables.7z.old" -Force}
	if (Test-Path -Path "$PSScriptRoot\Delivery\Vendor.7z.old") {Remove-Item -Path "$PSScriptRoot\Delivery\Vendor.7z.old" -Force}
	if (Test-Path -Path "$PSScriptRoot\Delivery\Scripts.7z") {Rename-Item -Path "$PSScriptRoot\Delivery\Scripts.7z" -NewName Scripts.7z.old}
	if (Test-Path -Path "$PSScriptRoot\Delivery\Executables.7z") {Rename-Item -Path "$PSScriptRoot\Delivery\Executables.7z" -NewName Executables.7z.old}
	if (Test-Path -Path "$PSScriptRoot\Delivery\Vendor.7z") {Rename-Item -Path "$PSScriptRoot\Delivery\Vendor.7z" -NewName Vendor.7z.old}
	Start-DownloadLoop "Scripts.7z"
	Start-Process $env:SYSTEMDRIVE\Bionic\Hikarefresh\7za.exe -Wait -NoNewWindow -ArgumentList "x $PSScriptRoot\Delivery\Scripts.7z -pBioniDKU -o$env:SYSTEMDRIVE\Bionic -aoa"
	if ($rv -eq 1) {
		Start-DownloadLoop "Vendor.7z"
		while ($true) {
			try {
				Write-Host "Please accept the UAC prompt to continue. (If you click No it will ask again, so Yes please)." -ForegroundColor White
				Start-Process powershell -Verb RunAs -ArgumentList "-Command $env:SYSTEMDRIVE\Bionic\Hikarefresh\Hikarefreshosxe.ps1 $mvt"
				break
			} catch {continue}
		}
	} if ($hv -eq 1) {
		Start-DownloadLoop "Executables.7z"
		Start-Process powershell -ArgumentList "-Command $env:SYSTEMDRIVE\Bionic\Hikarefresh\Hikarefreshard.ps1 $rv $mvt"
	} elseif ($hv -ne 1) {& $env:SYSTEMDRIVE\Bionic\Hikarefresh\Hikarefreshvi.ps1 $mvt}
	exit
}

$update = (Get-ItemProperty -Path "HKCU:\Software\Hikaru-chan").UpdateAvailable
if ($update -ne 1) {exit}

while ($true) {
	Show-WindowTitle 0
	Show-Branding
	Write-Host "An update is available:`r`n" -ForegroundColor White
	
	. $env:SYSTEMDRIVE\Bionic\Hikarefresh\Versinfo.ps1
	$versionremote = $version
	$minbaseremote = $minbase
	$revisionremote = $revision
	$magicremote = $magicroll
	$magicrobremote = $magicrobr # This will be used to compare against the system UBR, not the previous file's
	Write-Host "Menu System Version: " -ForegroundColor White -n; Write-Host "$versionremote - " -n; Write-Host "Image Revision: " -ForegroundColor White -n; Write-Host "$revisionremote"
	Write-Host "Update size: " -ForegroundColor White -n; Write-Host "$size"
	Write-Host "Update information: " -ForegroundColor White -n; Write-Host "$descr"
	. $env:SYSTEMDRIVE\Bionic\Hikarefresh\VersinFOLD.ps1
	
	Write-Host "`r`n Select an action"
	Write-Host " 1. Accept update" -ForegroundColor White
	Write-Host " 0. Cancel and close this window`r`n" -ForegroundColor White
	Write-Host "> " -n; $act = Read-Host
	switch ($act) {
		0 {exit}
		1 {
			if ($minbaseremote -notlike $minbase) {$hard = 1} else {$hard = 0}
			if ($revisionremote -notlike $revision) {$rev = 1} else {$rev = 0}
			if ($magicremote) {
				$magicubr = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion').UBR
				if ($magicubr -lt $magicrobremote) {$mag = $true} else {$mag = $false}
			} else {$mag = $false}
			Start-Hikarefreshing $hard $rev $mag
		}
	}
}
