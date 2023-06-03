::[Bat To Exe Converter]
::
::YAwzoRdxOk+EWAjk
::fBw5plQjdCaDJH6N4H4SIRRaRSCpCSayD74d+v3Hx+OMo18UV+0xRKfS0bWcKeMc5AvtdplN
::YAwzuBVtJxjWCl3EqQJgSA==
::ZR4luwNxJguZRRnk
::Yhs/ulQjdF+5
::cxAkpRVqdFKZSTk=
::cBs/ulQjdF+5
::ZR41oxFsdFKZSDk=
::eBoioBt6dFKZSDk=
::cRo6pxp7LAbNWATEpCI=
::egkzugNsPRvcWATEpCI=
::dAsiuh18IRvcCxnZtBJQ
::cRYluBh/LU+EWAnk
::YxY4rhs+aU+IeA==
::cxY6rQJ7JhzQF1fEqQJieEsaHkrScjva
::ZQ05rAF9IBncCkqN+0xwdVsGHFTMbiXqSOV8
::ZQ05rAF9IAHYFVzEqQJQ
::eg0/rx1wNQPfEVWB+kM9LVsJDGQ=
::fBEirQZwNQPfEVWB+kM9LVsJDGQ=
::cRolqwZ3JBvQF1fEqQIYIRBVXhHPP2O7CPUP4O3346qUtkwPQPcvOIzU1KCcL+xT61X0eZ8u125Tl8Vs
::dhA7uBVwLU+EWHuN+0w5K1t2WRCWOXna
::YQ03rBFzNR3SWATElA==
::dhAmsQZ3MwfNWATElA==
::ZQ0/vhVqMQ3MEVWAtB9wSA==
::Zg8zqx1/OA3MEVWAtB9wSA==
::dhA7pRFwIByZRRnk
::Zh4grVQjdCuDJHuR4FY1OidzRRCOPWmGJLwT5uHfxN/KrkIeVe4DXIrNyaSPI+Ve4kzvdIQ4hUZymdkIMDNRdRO5ezMcoGVDpHHLMt+Z0w==
::YB416Ek+ZW8=
::
::
::978f952a14a936cc963da21a135fa983
@echo off
rem ####### Hikaru-chan by Bionic Butter #######

start %systemdrive%\Bionic\Hikaru\StartupSpinner.exe
timeout /t 2 /nobreak

rem Pre-Explorer command section
rem --------------------------------------------
call %systemdrive%\Bionic\Hikaru\Hikarun.bat
rem --------------------------------------------

rem Hikaru section
:StartupBegin
reg import %systemdrive%\Bionic\Hikaru\ShellDefault.reg
reg add HKLM\System\Setup /v CmdLine /t REG_SZ /d "%systemdrive%\Bionic\Hikaru\Hikarepair.exe" /f
reg add HKLM\System\Setup /v SystemSetupInProgress /t REG_DWORD /d 1 /f
reg add HKLM\System\Setup /v SetupType /t REG_DWORD /d 2 /f
start %windir%\Explorer.exe
timeout /t 4 /nobreak
goto StartupDone

:StartupDone
reg import %systemdrive%\Bionic\Hikaru\ShellHikaru.reg
reg add HKLM\System\Setup /v CmdLine /t REG_SZ /d "" /f
reg add HKLM\System\Setup /v SystemSetupInProgress /t REG_DWORD /d 0 /f
reg add HKLM\System\Setup /v SetupType /t REG_DWORD /d 0 /f
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v legalnoticecaption /f
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v legalnoticetext /f
for /f "tokens=3" %%a in ('reg query "HKCU\Software\Hikaru-chan" /v StartupSoundVariant  ^|findstr /ri "REG_DWORD"') do set "ssv=%%a"
taskkill /f /im FFPlay.exe
timeout /t 1 /nobreak
if %ssv%==0x1 goto StartupSoundDefault
if %ssv%==0x2 goto StartupSoundOSSE
if %ssv%==0x3 goto StartupSoundOSTE
goto StartupSoundNone

:StartupSoundDefault
%systemdrive%\Bionic\Hikaru\FFPlay.exe -i %systemdrive%\Bionic\Hikaru\StartupSound1.mp3 -nodisp -hide_banner -autoexit 
exit

:StartupSoundOSSE
%systemdrive%\Bionic\Hikaru\FFPlay.exe -i %systemdrive%\Bionic\Hikaru\StartupSound2.mp3 -nodisp -hide_banner -autoexit 
exit

:StartupSoundOSTE
%systemdrive%\Bionic\Hikaru\FFPlay.exe -i %systemdrive%\Bionic\Hikaru\StartupSound3.mp3 -nodisp -hide_banner -autoexit 
exit

:StartupSoundNone
exit
