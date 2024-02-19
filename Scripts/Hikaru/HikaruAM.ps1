# BioniDKU OSXE Administrative Menu - (c) Bionic Butter

. $env:SYSTEMDRIVE\Bionic\Hikaru\Hikarestart.ps1
$update = (Get-ItemProperty -Path "HKCU:\Software\Hikaru-chan").UpdateAvailable
$global:staticspinner = $false

Start-Process "$env:SYSTEMDRIVE\Bionic\Hikaru\FFPlay.exe" -WindowStyle Hidden -ArgumentList "-i $env:SYSTEMDRIVE\Bionic\Hikaru\HikaruAMBeep.mp3 -nodisp -hide_banner -autoexit -loglevel quiet"

function Show-Branding {
	$prodname = (Get-ItemProperty -Path "HKCU:\Software\Hikaru-chan").ProductName
	$host.UI.RawUI.WindowTitle = "$prodname Administrative Menu"
	Clear-Host
	Write-Host "$prodname Administrative Menu" -ForegroundColor Black -BackgroundColor Magenta
	Write-Host "IR: 24010.$hikarev, MSV: 22111.$hikaru - (c) Bionic Butter`r`n" -ForegroundColor White
}
function Show-Menu {
	Show-Branding
	if ($update -eq 1) {
		$updateopt = "9. View update`r`n "
		Write-Host 'An update is available, select option 9 for more information`r`nTo recheck for updates, type "9R" and press Enter' -ForegroundColor White
	} else {$updateopt = "9. Check for updates`r`n "}
	Write-Host "Becareful with what you are doing!`r`n" -ForegroundColor Magenta
	$lock, $lockclr = Get-SystemSwitches
	$abrs, $abrsclr = Touch-ABRState 0
	Write-Host " Shell tasks"
	Write-Host " 1. Restart Explorer shell" -ForegroundColor White
	switch ($true) {
		{Check-SafeMode} {Write-Host " 2. Shell restart animation is supressed in Safe Mode*`r`n" -ForegroundColor DarkGray}
		$staticspinner {Write-Host " 2. Shell restart animation is supressed, reopen AM to reenable*`r`n" -ForegroundColor DarkGray}
		default {Write-Host " 2. Supress shell restart animation*`r`n" -ForegroundColor White}
	}
	Write-Host " System tasks"
	Write-Host " 3. Toggle Lockdown (currently " -ForegroundColor White -n; Write-Host "$lock" -ForegroundColor $lockclr -n; Write-Host ")" -ForegroundColor White
	Write-Host " 4. Toggle Explorer Address bar (currently " -ForegroundColor White -n; Write-Host "$abrs" -ForegroundColor $abrsclr -n; Write-Host ")" -ForegroundColor White
	Write-Host " 5. Sign-in options" -ForegroundColor White
	Write-Host " 6. Open a Command Prompt window`r`n" -ForegroundColor White
	Write-Host " Others"
	Write-Host " ${updateopt}0. Close this menu`r`n" -ForegroundColor White
}
function Get-SystemSwitches {
	$nr = (Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer").DisallowRun
	$ncp = (Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer").NoControlPanel
	$ntcm = (Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer").NoTrayContextMenu
	if ($nr -eq 1 -and $ncp -eq 1 -and $ntcm -eq 1) {
		$nall = 'ENABLED'
		$nclr = 'Green'
	} elseif ($nr -eq 0 -and $ncp -eq 0 -and $ntcm -eq 0) {
		$nall = 'DISABLED'
		$nclr = 'Red'
	} else {
		$nall = 'UNKNOWN - select this to enable'
		$nclr = 'Yellow'
	}
	return $nall, $nclr
}
function Show-Magicauth { # Not the best security practice, but it's enough to protect the menu
	Show-Branding
	$lsei = Read-Host "Enter Administrative password" -MaskInput
	$lseh = (Get-ItemProperty -Path "HKCU:\Software\Hikaru-chan").ShellIL
	$lsec = ConvertTo-SecureString -String $lseh -Key (1..32)
	# From: https://stackoverflow.com/questions/38901752/verify-passwords-match-in-windows-powershell
	$lsep = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($lsec))
	return ($lsep -eq $lsei)
}
function Switch-ShellState($action) {
	gpupdate.exe
	reg import "$env:SYSTEMDRIVE\Bionic\Hikaru\ShellContext$action.reg"
	$actabr = (Get-ItemProperty -Path "HKCU:\Software\Hikaru-chan").SystemABRState 
	switch ($action) {
		1 {if ($actabr -eq 1) {Set-ABRValue 2 1}}
		2 {
			Remove-Item "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowRun" -Recurse -Force
			reg import "$env:SYSTEMDRIVE\Bionic\Hikaru\Hikarestrict.reg"
			if ($actabr -eq 2) {Set-ABRValue 1 1}
		}
	}
	Stop-Process -Name "ApplicationFrameHost" -Force -ErrorAction SilentlyContinue
	Restart-HikaruShell
}
function Switch-Lockdown {
	$lock, $lnul = Get-SystemSwitches
	if ($lock -eq 'ENABLED') {
		$lpwd = Show-Magicauth
		if (-not $lpwd) {return}
		
		Show-Branding
		Write-Host "This option will disable all application restrictions, unblock Settings, Control Panel, the taskbar context menu, `r`nand unhide the Windows version from Command Prompt. Use this option if you are the challenge host and want to do `r`nmaintenance on this system without having to go through Group Policy and disable the restrictions one by one."
		Write-Host "Disabling Lockdown means " -n; Write-Host "the RESPONSIBILTY of keeping the secrets will be YOURS " -ForegroundColor White -n; Write-Host "until you enable them again. If you `r`ncan securely proceed, hit 1 and Enter to disable, or hit anything and Enter to go back."
		Write-Host "The Explorer shell will be restarted to apply changes. Your files windows will not be closed.`r`n"
		Write-Host "> " -n; $back = Read-Host
		if ($back -ne 1) {return}

		Show-Branding
		Write-Host "Disabling Lockdown and applying changes..." -ForegroundColor White
		Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name DisallowRun -Value 0 -Type DWord -Force
		Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name NoControlPanel -Value 0 -Type DWord -Force
		Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name NoTrayContextMenu -Value 0 -Type DWord -Force
		Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Command Processor" -Name Autorun
		Set-ItemProperty -Path "HKCU:\Software\Hikaru-chan" -Name LockDisp -Value "Lockdown is DISABLED!" -Type String -Force
		Switch-ShellState 1
	} else {
		Show-Branding
		Write-Host "Reenable Lockdown? Hit 1 and Enter to enable, or hit anything and Enter to go back."
		Write-Host "The Explorer shell will be restarted to apply changes. Your files windows will not be closed.`r`n"
		Write-Host "> " -n; $back = Read-Host
		if ($back -ne 1) {return}
		
		Show-Branding
		Write-Host "Enabling Lockdown and applying changes..." -ForegroundColor White
		Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name DisallowRun -Value 1 -Type DWord -Force
		Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name NoControlPanel -Value 1 -Type DWord -Force
		Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name NoTrayContextMenu -Value 1 -Type DWord -Force
		Set-ItemProperty -Path "HKCU:\Software\Microsoft\Command Processor" -Name Autorun -Value "cls" -Type String
		Remove-ItemProperty -Path "HKCU:\Software\Hikaru-chan" -Name LockDisp
		Switch-ShellState 2
	}
}
function Set-ABRValue($value,$switchrunstate) {
	Set-ItemProperty "HKCU:\Software\Hikaru-chan" -Name SystemABRState -Value $value -Type DWord -Force
	if ($switchrunstate -eq 1) {
		switch ($value) {
			default {Stop-Process -Name "AddressBarRemover2" -Force -ErrorAction SilentlyContinue}
			1 {Start-Process "$env:SYSTEMDRIVE\Bionic\Hikaru\AddressBarRemover2.exe"}
		}
	}
}
function Touch-ABRState($action) {
	$abr = (Get-ItemProperty -Path "HKCU:\Software\Hikaru-chan").SystemABRState
	switch ($action) {
		0 {
			switch ($abr) {
				0 {$abst = 'SHOWN'; $aclr = 'Green'}
				default {$abst = 'HIDDEN'; $aclr = 'Red'}
			}
			return $abst, $aclr
		}
		1 {
			$lock, $lnul = Get-SystemSwitches
			switch ($abr) {
				0 {if ($lock -eq 'DISABLED') {Set-ABRValue 2} else {Set-ABRValue 1 1}}
				1 {Set-ABRValue 0 1}
				2 {Set-ABRValue 0}
			}
		}
	}
}
function Start-CommandPrompt {
	Show-Branding
	$lock, $lnul = Get-SystemSwitches
	$isuacon = (Get-ItemProperty 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System').EnableLUA
	Write-Host "Use this option to quickly reach the Command Prompt without having to search though Start folders."
	if ($lock -eq 'ENABLED') {
		$syscmd = "/commandline `"/k cls`""
	} else {
		Write-Host "The build number will be " -n; Write-Host "IMMEDIATELY SHOWN" -ForegroundColor Yellow -n; Write-Host " upon launching this program. It is then " -n; Write-Host "YOUR RESPONSIBILTY to keep `r`nthe secrets!" -ForegroundColor Yellow -n; Write-Host " If you can securely proceed:" -ForegroundColor White
		$syscmd = $null
	}
	if ($isuacon -eq 1) {
		Write-Host " - Hit 1 and Enter to open a normal Command Prompt." -ForegroundColor White
		Write-Host " - Hit 2 and Enter to open an elevated Command Prompt." -ForegroundColor White
	} else {
		Write-Host " - Hit 1 and Enter to open a normal Command Prompt." -ForegroundColor White
	}
	Write-Host " - Hit 3 and Enter to open Command Prompt as SYSTEM." -ForegroundColor White
	Write-Host " - Hit anything else and Enter to go back." -ForegroundColor White
	Write-Host ' '
	Write-Host "> " -n; $back = Read-Host
	switch ($back) {
		1 {Start-Process $env:SYSTEMDRIVE\Windows\System32\cmd.exe}
		2 {Start-Process $env:SYSTEMDRIVE\Bionic\Hikaru\AdvancedRun.exe -ArgumentList "/run /exefilename %SystemDrive%\Windows\System32\cmd.exe /runas 3"}
		3 {Start-Process $env:SYSTEMDRIVE\Bionic\Hikaru\AdvancedRun.exe -ArgumentList "/run /exefilename %SystemDrive%\Windows\System32\cmd.exe $syscmd /runas 4"}
		8 {Start-Process $env:SYSTEMDRIVE\Bionic\Hikaru\AdvancedRun.exe -ArgumentList "/run /exefilename %SystemDrive%\Windows\System32\cmd.exe $syscmd /runas 8"}
		default {return}
	}
}
function Show-StaticSpinnerInfo {
	Show-Branding
	Write-Host "This will temporarily simplify the shell restart animation for this Administrative Menu instance, which can be helpful `r`nif the full animation is slowing down your weak remote connection."
	Write-Host "This will not apply to other opening AM windows unless if you toggle this same option on each of them, and will have no effect on the Quick Menu (except in Safe Mode)."
	Write-Host "In Safe Mode, this option is always enabled for both menus.`r`n"
	Write-Host "Press Enter to go back." -ForegroundColor White; Read-Host
}

while ($true) {
	Show-Menu
	Write-Host "> " -n; $unem = Read-Host
	switch ($unem) {
		"0" {exit}
		"1" {Confirm-RestartShell}
		"2" {if (-not (Check-SafeMode)) {$global:staticspinner = $true}}
		"3" {Switch-Lockdown}
		"4" {Touch-ABRState 1}
		"5" {Show-Branding; Start-Process pwsh -Verb RunAs -Wait -ArgumentList "$env:SYSTEMDRIVE\Bionic\Kirisame\Magicpass\MagicpassConfig.ps1" -ErrorAction SilentlyContinue}
		"6" {Start-CommandPrompt}
		{$_ -eq '*'} {Show-StaticSpinnerInfo}
		{$_ -eq "Snull"} {Show-Branding; Start-Process pwsh -Verb RunAs -Wait -ArgumentList "$env:SYSTEMDRIVE\Bionic\Hikaru\StandbyWizard.ps1" -ErrorAction SilentlyContinue}
		"9" {
			if ($update -eq 1) {
				Start-Process $env:SYSTEMDRIVE\Bionic\Hikarefresh\Hikarefreshow.exe
				exit
			} else {
				Start-UpdateCheckerFM "AM"
			}
		}
		"9R" {
			Start-UpdateCheckerFM "AM"
		}
	}
}
