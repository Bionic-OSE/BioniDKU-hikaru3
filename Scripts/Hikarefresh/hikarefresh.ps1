# Hikaru-chan background update checker - (c) Bionic Butter

function Show-NotifyBalloon {
	[system.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms') | Out-Null
	$Global:Balloon = New-Object System.Windows.Forms.NotifyIcon
	$Balloon.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon("$env:SYSTEMDRIVE\Bionic\Hikarefresh\Hikarefresh.exe")
	$Balloon.BalloonTipIcon = 'Info'
	$Balloon.BalloonTipText = 'For more information, please open Quick Menu/Administrative Menu and select 9'
	$Balloon.BalloonTipTitle = 'BioniDKU Quick Menu Update available'
	$Balloon.Visible = $true
	$Balloon.ShowBalloonTip(7000)
}

Remove-Item -Path $env:SYSTEMDRIVE\Bionic\Hikarefresh\Hikarinfo.ps1 -Force
Start-Process $env:SYSTEMDRIVE\Bionic\Hikarefresh\wget.exe -Wait -NoNewWindow -ArgumentList "https://github.com/Bionic-OSE/BioniDKU-hikaru3/releases/latest/download/Hikarinfo.ps1" -WorkingDirectory "$env:SYSTEMDRIVE\Bionic\Hikarefresh"

. $env:SYSTEMDRIVE\Bionic\Hikarefresh\Hikarinfo.ps1
$versionremote = $version
. $env:SYSTEMDRIVE\Bionic\Hikarefresh\HikarinFOLD.ps1

if ($versionremote -eq $null) {
	Set-ItemProperty -Path "HKCU:\Software\Hikaru-chan" -Name "UpdateAvailable" -Value 0 -Type DWord -Force
}
elseif ($versionremote -ne $version) {
	Set-ItemProperty -Path "HKCU:\Software\Hikaru-chan" -Name "UpdateAvailable" -Value 1 -Type DWord -Force
	Show-NotifyBalloon
} else {
	Set-ItemProperty -Path "HKCU:\Software\Hikaru-chan" -Name "UpdateAvailable" -Value 0 -Type DWord -Force
}
