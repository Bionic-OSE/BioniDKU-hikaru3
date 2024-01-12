# BioniDKU OSTE updater - (c) Bionic Butter

$host.UI.RawUI.WindowTitle = "BioniDKU OSXE System Updater | DO NOT CLOSE THIS WINDOW"
function Show-Branding {
	Clear-Host
	Write-Host "BioniDKU OSXE System Updater" -ForegroundColor Black -BackgroundColor White
	Write-Host "User experience layer updater`r`n"
}

Show-Branding
Write-Host "Updating user experience layer" -ForegroundColor White; Write-Host " "

Stop-Process -Name HikaruQML
Start-Sleep -Seconds 3
Remove-Item -Path $env:SYSTEMDRIVE\Bionic\Hikaroste -Force -Recurse
Start-Process 7za -Wait -NoNewWindow -ArgumentList "x $env:SYSTEMDRIVE\Bionic\Hikarefresh\Delivery\Vendor.7z -pBioniDKU -o$env:SYSTEMDRIVE\Bionic\Hikarefresh\Delivery\Vendor -aoa"
& $env:SYSTEMDRIVE\Bionic\Hikarefresh\Delivery\Vendor\Imagervicing.ps1
. $env:SYSTEMDRIVE\Bionic\Hikarefresh\Versinfo.ps1
Set-ItemProperty -Path "HKCU:\Software\Hikaru-chan" -Name "Revision" -Value "24010.$version" -Force
Write-Host " "; Write-Host "Update completed!" -ForegroundColor Black -BackgroundColor White
Start-Sleep -Seconds 5
