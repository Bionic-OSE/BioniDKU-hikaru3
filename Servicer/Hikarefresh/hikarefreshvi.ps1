# Hikaru-chan version info updater - (c) Bionic Butter

Param(
	[Parameter(Mandatory=$True,Position=1)]
	[bool]$mvv
)

& $env:SYSTEMDRIVE\Bionic\Hikarefresh\Hikarefreshed.ps1
. $env:SYSTEMDRIVE\Bionic\Hikarefresh\Versinfo.ps1
Set-ItemProperty -Path "HKCU:\Software\Hikaru-chan" -Name "Version" -Value "22111.$version" -Force
if (-not $mvv) {
	Set-ItemProperty -Path "HKCU:\Software\Hikaru-chan" -Name "UpdateAvailable" -Value 0 -Type DWord -Force
	Remove-Item -Path "$env:SYSTEMDRIVE\Bionic\Hikarefresh\VersinFOLD.ps1" -Force
	Rename-Item -Path "$env:SYSTEMDRIVE\Bionic\Hikarefresh\Versinfo.ps1" -NewName VersinFOLD.ps1
}
if ($mvv) {
	Stop-Process -Name "Magicdrum" -Force
}
