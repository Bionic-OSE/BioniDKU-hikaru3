# HikaruQML keep-alive agent

while ($true) {
	Wait-Process -Name "HikaruQML"
	Start-Sleep -Seconds 1
	$userd = Get-Process -Name "HikaruQMLu" -ErrorAction SilentlyContinue
	if ($userd -ne $null) {Start-ScheduledTask -TaskName 'BioniDKU Hot Keys Service'} else {Stop-Service -Name "HikaruQMLd"; exit}
}
