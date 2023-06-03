# BioniDKU OSTE update script - (c) Bionic Butter

Copy-Item "$env:SYSTEMDRIVE\Bionic\Hikaroste\DesktopInfo.ini" -Destination "$env:SYSTEMDRIVE\Program Files\DesktopInfo\DesktopInfo.ini" -Force
Start-Process $env:SYSTEMDRIVE\Bionic\Hikarefresh\wget.exe -Wait -NoNewWindow -ArgumentList "https://community.chocolatey.org/install.ps1" -WorkingDirectory "$env:SYSTEMDRIVE\Bionic\Hikaroste"
Start-Process powershell -Wait -WindowStyle Hidden -ArgumentList "$env:SYSTEMDRIVE\Bionic\Hikaroste\install.ps1"
Start-Process "$env:SYSTEMDRIVE\ProgramData\Chocolatey\choco.exe" -Wait -WindowStyle Hidden -ArgumentList "install EarTrumpet -y"
Start-Process "$env:SYSTEMDRIVE\ProgramData\Chocolatey\choco.exe" -Wait -WindowStyle Hidden -ArgumentList "install MSEdgeRedirect -y"
Start-Process $env:SYSTEMDRIVE\Bionic\Hikarefresh\wget.exe -Wait -NoNewWindow -ArgumentList "https://www.aloneguid.uk/projects/bt/bin/bt-3.0.0.msi" -WorkingDirectory "$env:SYSTEMDRIVE\Bionic\Hikaroste"
Start-Process $env:SYSTEMDRIVE\Bionic\Hikarefresh\wget.exe -Wait -NoNewWindow -ArgumentList "https://ninite.com/edge/ninite.exe" -WorkingDirectory "$env:SYSTEMDRIVE\Bionic\Hikaroste"
Start-Process msiexec -Wait -ArgumentList "/i $env:SYSTEMDRIVE\Bionic\Hikaroste\bt-3.0.0.msi /quiet /norestart"
Start-Process "$env:SYSTEMDRIVE\Bionic\Hikaroste\Ninite Edge Installer.exe" -Wait
