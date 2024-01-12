# BioniDKU OSTE updater - (c) Bionic Butter

$host.UI.RawUI.WindowTitle = "BioniDKU OSXE System Updater | DO NOT CLOSE THIS WINDOW"
function Show-Branding {
	Clear-Host
	Write-Host "BioniDKU OSXE System Updater" -ForegroundColor Black -BackgroundColor White
	Write-Host "User experience layer updater`r`n"
}

Show-Branding
Write-Host "Updating your image (Stage 3)" -ForegroundColor White; Write-Host " "

Stop-Process -Name HikaruQML
Start-Sleep -Seconds 3
Remove-Item -Path $env:SYSTEMDRIVE\Bionic\Hikaroste -Force -Recurse
Start-Process 7za -Wait -NoNewWindow -ArgumentList "x $env:SYSTEMDRIVE\Bionic\Hikarefresh\Delivery\Vendor.7z -pBioniDKU -o$env:SYSTEMDRIVE\Bionic -aoa"
& $env:SYSTEMDRIVE\Bionic\Hikarefresh\Delivery\Vendor\Imagervicing.ps1
Write-Host " "; Write-Host "Update completed!" -ForegroundColor Black -BackgroundColor White
Start-Sleep -Seconds 5
