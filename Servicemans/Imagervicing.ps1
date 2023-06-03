# BioniDKU OSTE update script - (c) Bionic Butter

Copy-Item "$env:SYSTEMDRIVE\Bionic\Hikaroste\DesktopInfo.ini" -Destination "$env:SYSTEMDRIVE\Program Files\DesktopInfo\DesktopInfo.ini" -Force
Start-Process $env:SYSTEMDRIVE\Bionic\Hikarefresh\wget.exe -Wait -NoNewWindow -ArgumentList "https://community.chocolatey.org/install.ps1 --no-check-certificate" -WorkingDirectory "$env:SYSTEMDRIVE\Bionic\Hikaroste"
# -WindowStyle Hidden is left out in these 3 lines below for debugging purposes, since this update is performed before the image is even announced. But do remember to include it with next updates if you were to use choco, since it spit out colors.
Start-Process powershell -Wait -ArgumentList "$env:SYSTEMDRIVE\Bionic\Hikaroste\install.ps1" # -WindowStyle Hidden
Start-Process "$env:SYSTEMDRIVE\ProgramData\Chocolatey\choco.exe" -Wait -ArgumentList "install EarTrumpet -y" # -WindowStyle Hidden
Start-Process "$env:SYSTEMDRIVE\ProgramData\Chocolatey\choco.exe" -Wait -ArgumentList "install MSEdgeRedirect -y" # -WindowStyle Hidden
Start-Process $env:SYSTEMDRIVE\Bionic\Hikarefresh\wget.exe -Wait -NoNewWindow -ArgumentList "https://www.aloneguid.uk/projects/bt/bin/bt-3.0.0.msi" -WorkingDirectory "$env:SYSTEMDRIVE\Bionic\Hikaroste"
Start-Process $env:SYSTEMDRIVE\Bionic\Hikarefresh\wget.exe -Wait -NoNewWindow -ArgumentList "https://ninite.com/edge/ninite.exe" -WorkingDirectory "$env:SYSTEMDRIVE\Bionic\Hikaroste"
Start-Process msiexec -Wait -ArgumentList "/i $env:SYSTEMDRIVE\Bionic\Hikaroste\bt-3.0.0.msi /quiet /norestart"
Start-Process "$env:SYSTEMDRIVE\Bionic\Hikaroste\ninite.exe"
