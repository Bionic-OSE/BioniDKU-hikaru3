# BioniDKU OSXE User experience layer updater - (c) Bionic Butter

Param(
	[Parameter(Mandatory=$true,Position=0)]
	[bool]$mvm
)

function Show-WindowTitle {$host.UI.RawUI.WindowTitle = "BioniDKU OSXE System Updater | DO NOT CLOSE THIS WINDOW"}
function Show-Branding {
	Clear-Host
	Write-Host "BioniDKU OSXE System Updater" -ForegroundColor Black -BackgroundColor White
	Write-Host "User experience layer updater`r`n"
}
function Start-DownloadLoop($link,$file) {
	while ($true) {
		Start-BitsTransfer -DisplayName "Downloading $file" -Description " " -Source "${link}/${file}" -Destination "$env:SYSTEMDRIVE\Bionic\Hikarefresh\Delivery\Vendor\${file}" -RetryInterval 60 -RetryTimeout 70 -ErrorAction SilentlyContinue
		if (Test-Path -Path "$env:SYSTEMDRIVE\Bionic\Hikarefresh\Delivery\Vendor\${file}" -PathType Leaf) {break} else {
			Write-Host " "
			Write-Host -ForegroundColor White "Did the transfer fail?" -n; Write-Host " Retrying..."
			Start-Sleep -Seconds 1
		}
	}
}

Show-WindowTitle
Show-Branding
Write-Host "Updating user experience layer" -ForegroundColor White; Write-Host " "

Stop-Process -Name HikaruQML
Start-Sleep -Seconds 3
Remove-Item -Path $env:SYSTEMDRIVE\Bionic\Hikarefresh\Delivery\Vendor -Force -Recurse
Start-Process $env:SYSTEMDRIVE\Bionic\Hikarefresh\7za.exe -Wait -NoNewWindow -ArgumentList "x $env:SYSTEMDRIVE\Bionic\Hikarefresh\Delivery\Vendor.7z -pBioniDKU -o$env:SYSTEMDRIVE\Bionic\Hikarefresh\Delivery\Vendor -aoa"
& $env:SYSTEMDRIVE\Bionic\Hikarefresh\Delivery\Vendor\Imagervicing.ps1

. $env:SYSTEMDRIVE\Bionic\Hikarefresh\Versinfo.ps1
Set-ItemProperty -Path "HKCU:\Software\Hikaru-chan" -Name "Revision" -Value "24010.$revision" -Force
& $env:SYSTEMDRIVE\Bionic\Hikarefresh\Hikarefreshvi.ps1 $mvm
Start-Process $env:SYSTEMDRIVE\Bionic\Hikaru\AdvancedRun.exe -ArgumentList "/run /exefilename $env:SYSTEMDRIVE\Windows\System32\WindowsPowerShell\v1.0\powershell.exe /runas 9 /runasusername BioniDKU /commandline `". $env:SYSTEMDRIVE\Bionic\Hikaru\Hikarestart.ps1; Restart-HikaruShell`""
Start-Sleep -Seconds 2
Write-Host " "; Write-Host "Update completed!" -ForegroundColor Black -BackgroundColor White
Start-Sleep -Seconds 5
