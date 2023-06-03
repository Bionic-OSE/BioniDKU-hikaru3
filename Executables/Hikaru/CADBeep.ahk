#Requires AutoHotkey v2.0
#UseHook
#NoTrayIcon

^!Del::
{

	Run "C:\Bionic\Hikaru\FFPlay.exe -i C:\Bionic\Hikaru\CADBeep.wav -nodisp -hide_banner -autoexit -loglevel quiet" , , "Hide"

}