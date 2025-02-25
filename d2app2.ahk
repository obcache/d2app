A_FileVersion := "1.4.1.9"
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
	
installDir 			:= a_myDocuments "\d2app"
configFileName 		:= "d2app.ini"
themeFileName		:= "d2app.themes"

preAutoExec(InstallDir,ConfigFileName)
loadScreen()

cfg.ThemeFile		:= "./" ThemeFileName
cfg.file 			:= "./" ConfigFileName
ui.latestVersion 	:= ""
ui.installedVersion := ""

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
	
initProgress(5)	
cfgLoad(&cfg, &ui)
initProgress(10)
initTrayMenu()

initGui(&cfg, &ui)
initProgress(10)

initConsole(&ui)
ui.loadingProgress.value += 10


#include <class_sqliteDb>
#include <class_lv_colors>
#include <libGui>
#include <libWinMgr>
#include <libGlobal>
#include <libInstall>
;#include <libAfkFunctions>
#include <libGuiSetupTab>
#include <libGuiAppDockTab>
#include <libGameAssists>
#include <libGameSettingsTab>
#include <libIncursionCheck>
ui.loadingProgress.value += 15
#include <libGuiSystemTab>
#include <libHotkeys>
#include <libRoutines>
#include <libThemeEditor>
#include <libVaultCleaner>
ui.loadingProgress.value += 10

debugLog("Interface Initialized")
OnExit(ExitFunc)
debugLog("Console Initialized")

ui.gameTabs.choose(cfg.gameModuleList[cfg.activeGameTab])
ui.loadingProgress.value += 5
tabsChanged()
;createDockBar()
ui.loadingProgress.value += 5
	


try
	guiVis("all",false)
ui.loadingProgress.value += 5

;ui.afkGui.show("x" cfg.guiX+45 " y" cfg.guiY+50 " w270 h140 noActivate")
winSetRegion("33-0 w500 h214",ui.mainGui)
ui.mainGui.Show("x" cfg.guix " y" cfg.guiy " w562 h214 NoActivate")

ui.gameSettingsGui.show("x" cfg.guiX+34 " y" cfg.guiY+30 " w495 h182 noActivate")
ui.gameTabGui.show("w495 h32 noActivate x" cfg.guiX+34 " y" cfg.guiY+183)
ui.loadingProgress.value += 5

if (cfg.startMinimizedEnabled)
	ui.mainGui.hide()


	ui.loadingProgress.value += 5
	monitorResChanged()

ui.MainGuiTabs.Choose(cfg.mainTabList[cfg.activeMainTab])

ui.loadingProgress.value += 5

; initGuiState()


ui.loadingProgress.value += 5
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

if cfg.topDockEnabled
	ui.topDockPrevTab := ui.mainGuiTabs.text

;if ui.incursionDebug
;	incursionNotice("manualFire")
;OnMessage(0x0201, wm_lButtonDown)
	if (cfg.AlwaysOnTopEnabled) {
		ui.MainGui.Opt("+AlwaysOnTop")
	} else {
		ui.MainGui.Opt("-AlwaysOnTop")
		ui.AfkGui.Opt("-AlwaysOnTop")	
	}
	
	
cfg.consoleVisible := !cfg.consoleVisible	

;toggleConsole()
;statusBar()
;listhotkeys()
d2AutoGameConfigOverride()

ui.isActiveWindow:=""
setTimer () => (ui.isActiveWindow:=(winActive("ahk_exe destiny2.exe")) ? (ui.isActiveWindow) ? 1 : (setCapsLockState(cfg.d2AlwaysRunEnabled),1) : (ui.isActiveWindow) ? (0,setCapsLockState(0)) : 0),500
;winSetTransparent(150,ui.mainGui)
loadScreen(0)
