;MaintainBuild.ahk
#SingleInstance
#Requires AutoHotKey v2.0+
#Warn All, Off

; if (InStr(A_LineFile,A_ScriptFullPath)){
	; Run(A_ScriptDir "/../d2app.ahk")
	; ExitAppE
	; Return
; }

MainScriptFile := "E:\Documents\Resources\AutoHotKey\__d2app\d2app.ahk"
Loop Read MainScriptFile, MainScriptFile "-tmp"
{
	CurrLine := A_LoopReadLine
   If (A_Index == 1)
	{ 
		OldBuildNumber := FileRead("E:\Documents\Resources\AutoHotKey\__d2app\d2app_currentBuild.dat")
		BuildNumber := OldBuildNumber + 1
		FileDelete("E:\Documents\Resources\AutoHotKey\__d2app\d2app_currentBuild.dat")
		FileAppend(BuildNumber,"E:\Documents\Resources\AutoHotKey\__d2app\d2app_currentBuild.dat")
		A_BuildVersion := SubStr(BuildNumber,1,1) "." SubStr(BuildNumber,2,1) "." SubStr(BuildNumber,3,1) "." SubStr(BuildNumber,4,1)
		CurrLine := 'A_FileVersion := "' A_BuildVersion '"' 
	}
   FileAppend(CurrLine "`n")
}
msgBox(MainScriptFile "`n" OldBuildNumber)
FileMove(MainScriptFile,"E:\documents\resources\autoHotKey\__d2app\backups\d2app-" OldBuildNumber ".ahk")
FileMove(MainScriptFile "-tmp",MainScriptFile,1)
RunWait('"c:\Program Files\AutoHotkey\Compiler\Ahk2Exe.exe" /in "E:\Documents\Resources\AutoHotKey\__d2app\d2app.ahk" /out "E:\Documents\Resources\AutoHotKey\__d2app\Bin\d2app_' BuildNumber '.exe"')
;FileCreateShortcut("E:\Documents\Resources\AutoHotKey\__d2app\Bin\d2app_" BuildNumber ".exe","e:\desktop\d2app.lnk")
if (FileExist(A_Desktop "/d2app.lnk"))
	FileDelete(A_Desktop "\d2app.lnk")
FileCreateShortcut("E:\Documents\Resources\AutoHotKey\__d2app\Bin\d2app_" BuildNumber ".exe", A_Desktop "\d2app.lnk",,,"d2app-Latest Build",,"i")
if (FileExist("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\_d2app.lnk"))
	FileDelete("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\_d2app.lnk")
FileCreateShortcut("E:\Documents\Resources\AutoHotKey\__d2app\Bin\d2app_" BuildNumber ".exe", "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\_d2app.lnk",,,"d2app-Latest Build",,"i")