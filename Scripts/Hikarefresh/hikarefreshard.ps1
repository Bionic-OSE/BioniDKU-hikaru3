# Hikaru-chan hard files updater - (c) Bionic Butter

$host.UI.RawUI.WindowTitle = "BioniDKU Quick Menu for OSTE Updater"
function Show-Branding {
	Clear-Host
	Write-Host "BioniDKU Quick Menu for OSTE Updater" -ForegroundColor Black -BackgroundColor White
	Write-Host ' '
}

Show-Branding
Write-Host "Finalizing update (Stage 2)" -ForegroundColor White; Write-Host " "

Stop-Process -Name HikaruQML
Start-Sleep -Seconds 3
Start-Process 7za -Wait -NoNewWindow -ArgumentList "x $env:SYSTEMDRIVE\Bionic\Hikare.7z -pBioniDKU -o$env:SYSTEMDRIVE\Bionic -aoa"
& $env:SYSTEMDRIVE\Bionic\Hikarefresh\Hikarefreshed.ps1
Set-ItemProperty -Path "HKCU:\Software\Hikaru-chan" -Name "UpdateAvailable" -Value 0 -Type DWord -Force
Start-Process $env:SYSTEMDRIVE\Bionic\Hikaru\HikaruQML.exe
Write-Host " "; Write-Host "Update completed" -ForegroundColor Black -BackgroundColor White
Start-Sleep -Seconds 5
