reg import $env:SYSTEMDRIVE\Bionic\Hikaru\ShellHikaru.reg
. $env:SYSTEMDRIVE\Bionic\Hikaru\Hikarestart.ps1
Clear-BootMessage
Start-Process wscript -ArgumentList "$env:SYSTEMDRIVE\Bionic\Hikaru\SkipUnstuck.vbs"
