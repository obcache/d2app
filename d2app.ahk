A_FileVersion := "1.5.1.2"
a_appName := "d2app"
if (fileExist("./d2app_currentBuild.dat"))
a_fileVersion := fileRead("./d2app_currentBuild.dat")
	
;@ahk2Exe-let fileVersion=%a_priorLine~U)^(.+"){1}(.+)".*$~$2% 
;@ahk2Exe-setName d2app
;@ahk2Exe-setVersion %a_fileVersion%
;@ahk2Exe-setFileVersion %a_fileVersion%

#requires autoHotkey v2.0+
#singleInstance
#warn All, Off

if !a_isAdmin {
    try
    {
        if a_isCompiled
            run '*runAs "' a_scriptFullPath '" /restart'
			else
            run '*runAs "' a_ahkPath '" /restart "' a_scriptFullPath '"'
    }
    exitApp()
}

a_cmdLine := DllCall("GetCommandLine", "str")
a_restarted := 
			(inStr(a_cmdLine,"/restart"))
				? true
				: false

persistent()
installMouseHook()
installKeybdHook()
keyHistory(10)
setWorkingDir(a_scriptDir)
	
installDir 		:= a_myDocuments "\d2app"
configFileName 	:= "d2app.ini"
themeFileName	:= "d2app.themes"

advProgress(progressAmount:=5,*) {
		ui.loadingProgress.value += progressAmount
}

preAutoExec(InstallDir,ConfigFileName)
cfg.file 		:= "./" ConfigFileName


d2ActivePanel := 1

; ui.AfkGui 		:= Gui()
dockApp 		:= Object()
workApp			:= Object()

cfg.ThemeFile	:= "./" ThemeFileName
ui.pinned 		:= 0
ui.hidden 		:= 0
ui.hwndAfkGui 	:= ""
ui.AfkHeight 	:= 170
ui.latestVersion := ""
ui.installedVersion := ""
ui.incursionDebug := false
loadScreen()

MonitorGet(MonitorGetprimary(),
	&primaryMonitorLeft,
	&primaryMonitorTop,
	&primaryMonitorRight,
	&primaryMonitorBottom)

MonitorGetWorkArea(MonitorGetprimary(),
	&primaryWorkAreaLeft,
	&primaryWorkAreaTop,
	&primaryWorkAreaRight,
	&primaryWorkAreaBottom)
advProgress(5)	
cfgLoad(&cfg, &ui)
advProgress(5)
initTrayMenu()

initGui(&cfg, &ui)
advProgress(5)

initConsole(&ui)
advProgress(5)


#include <class_sqliteDb>
advProgress(2)
#include <class_lv_colors>
advProgress(2)
#include <libGui>
advProgress(2)
#include <libWinMgr>
advProgress(2)
#include <libGlobal>
advProgress(2)
#include <libInstall>
advProgress(2)
#include <libGuiSetupTab>
advProgress(2)
#include <libGameAssists>
advProgress(2)
#include <libGameSettingsTab>
advProgress(2)
#include <libIncursionCheck>
advProgress(2)
#include <libHotkeys>
advProgress(2)
#include <libRoutines>
advProgress(2)
#include <libThemeEditor>
advProgress(2)
#include <libVaultCleaner>
advProgress(2)

OnExit(ExitFunc)

ui.gameTabs.choose(cfg.gameModuleList[cfg.activeGameTab])
tabsChanged()
advProgress(5)

try
	guiVis("all",false)

winSetRegion("33-0 w498 h214",ui.mainGui)
ui.mainGui.Show("x" cfg.guix " y" cfg.guiy " w567 h215 NoActivate")
ui.gameSettingsGui.show("x" cfg.guiX+34 " y" cfg.guiY+30 " w495 h182 noActivate")
ui.gameTabGui.show("w497 h32 noActivate x" cfg.guiX+34 " y" cfg.guiY+183)
advProgress(5)

if (cfg.startMinimizedEnabled)
	ui.mainGui.hide()

advProgress(5)
monitorResChanged()
ui.MainGuiTabs.Choose(cfg.mainTabList[cfg.activeMainTab])

advProgress(5)
fadeIn()
try {
	ui.notifyGui.hide()
	ui.notifyGui.destroy()
}

try {
	whr := ComObject("WinHttp.WinHttpRequest.5.1")
	whr.Open("GET", "http://sorryneedboost.com/cacheApp/recentIncursion.dat", true)
	whr.Send()
	whr.WaitForResponse()
	iniWrite(whr.ResponseText,cfg.file,"Game","LastIncursion")
}
	
autoUpdate()

if (cfg.AlwaysOnTopEnabled) {
	ui.MainGui.Opt("+AlwaysOnTop")
} else {
	ui.MainGui.Opt("-AlwaysOnTop")
	ui.AfkGui.Opt("-AlwaysOnTop")	
}
	
cfg.consoleVisible := !cfg.consoleVisible	
d2AutoGameConfigOverride()
ui.isActiveWindow:=""
;setTimer () => (ui.isActiveWindow:=(winActive("ahk_exe destiny2.exe")) ? (ui.isActiveWindow) ? 1 : (setCapsLockState(cfg.d2AlwaysRunEnabled),1) : (ui.isActiveWindow) ? (0,setCapsLockState(0)) : 0),500
loadScreen(0)
