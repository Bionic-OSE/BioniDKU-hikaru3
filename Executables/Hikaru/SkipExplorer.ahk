﻿#Requires AutoHotkey v2.0
#UseHook
#NoTrayIcon


^Q::
{
	Run "C:\Windows\explorer.exe"
}
^S::
{
	Run "powershell C:\Bionic\Hikaru\SkipUnstuck.ps1"
}
