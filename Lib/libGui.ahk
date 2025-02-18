#SingleInstance
#Requires AutoHotKey v2.0+
#Warn All, Off

if (InStr(A_LineFile,A_ScriptFullPath))
{
	Run(A_ScriptDir "/../d2app.ahk")
	ExitApp
	Return
}

tabsChanged(*) {
	ui.activeTab := ui.mainGuiTabs.Text

	cfg.activeMainTab := ui.mainGuiTabs.value
	(ui.activeTab=="5_Lists")
		? tabDisabled()
		: 1
	(ui.activeTab=="1_Game")
		? (guiVis(ui.gameSettingsGui,true)
			, guiVis(ui.gameTabGui,true)
			, ui.gameSettingsGui.opt("-toolWindow")
			, ui.mainGui.opt("+toolWindow"))
		: ( guiVis(ui.gameSettingsGui,false)
			, guiVis(ui.gameTabGui,false)
			, ui.gameSettingsGui.opt("+toolWindow")
			, ui.mainGui.opt("+toolWindow"))
		
	for tab in cfg.mainTabList {
		ui.%tab%ButtonBg.value := 
			(cfg.activeMainTab==a_index) 
				? "./img/tab_selected.png" 
				: "./img/tab_unselected.png"
				}
}


	initGui(&cfg, &ui) {
	ui.TransparentColor 	:= "010203"
	ui.MainGui 				:= Gui()
	ui.MainGui.Name 		:= "d2app"
	ui.mainGui.Title		:= "d2app"
	ui.TaskbarHeight 		:= GetTaskBarHeight()
	ui.MainGui.BackColor 	:= ui.transparentColor
	ui.MainGui.Color 		:= ui.TransparentColor
	ui.MainGui.Opt("-Caption -Border")
	if (cfg.AlwaysOnTopEnabled)
	{
		ui.MainGui.Opt("+AlwaysOnTop 0x4000000")
	}	
	ui.MainGui.MarginX := 0
	ui.MainGui.MarginY := 0
	ui.MainGui.SetFont("s13 c" cfg.ThemeFont1Color,"Calibri")
	ui.mainGuiAnchor := ui.mainGui.addText("x0 y0 w0 h0 section hidden")

	ui.mainBg := ui.mainGui.addText("x34 y0 w490 h210 background" cfg.themePanel2Color,"")

	;ui.topHandlebar := ui.mainGui.addPicture("x-5 y2 w528 h28 backgroundTrans","./img/handlebar_horz.png")
	;ui.5_titleBar:=ui.mainGui.addText("y0 x272 w310 h30 left backgroundTrans c" cfg.themeFont1Color,"d2app v" a_fileVersion)
	ui.1_GameButtonBg := ui.mainGui.addPicture("x34 y0 w80 h30 background" cfg.themePanel2Color,(cfg.activeMainTab==1) ? "./img/tab_selected.png" : "./img/tab_unselected.png")
	ui.1_GameButton := ui.mainGui.addText("x34 y3 w80 h22 center backgroundTrans","Game")
	;ui.1_GameButtonBg.onEvent("click",gameTabClicked)

	gameTabClicked(*) {
		ui.mainGuiTabs.choose(1)
	}
	setupTabClicked(*) {
		ui.mainGuiTabs.choose(2)
	}
	ui.2_SetupButtonBg := ui.mainGui.addPicture("x114 y0 w80 h30 background" cfg.themePanel2Color,(cfg.activeMainTab==6) ? "./img/tab_selected.png" : "./img/tab_unselected.png")
	; ui.2_SetupButtonBg.onEvent("click",setupTabClicked)
	ui.2_SetupButton := ui.mainGui.addText("y3 x114 w80 h22 center backgroundTrans","Setup")
	;msgBox(cfg.mainTabList[1])
	ui.3_FillOutline:=ui.mainGui.addText("x194 y0 w310 h30 background" cfg.themePanel1Color,"")
	ui.3_FillBg:=ui.mainGui.addPicture("y0 x194 w310 h30 background" cfg.themePanel1Color,"./img/tab_unselected.png")
	ui.3_FillBg.onEvent("click",WM_LBUTTONDOWN_callback)
	ui.mainGuiTabs := ui.MainGui.AddTab3("x34 y0 w494 h213 Buttons -redraw Background" cfg.ThemePanel2Color " -E0x200",["1_Game","2_Setup"])
	ui.MainGuiTabs.useTab("")
	ui.mainGuiTabs.setFont("s13")
	ui.MainGuiTabs.OnEvent("Change",TabsChanged)
	; ui.mainGuiTabs.useTab("")
	
	ui.activeTab := ui.mainGuiTabs.Text
	ui.previousTab := ui.activeTab
	ui.MainGui.SetFont("s12 c" cfg.ThemeFont1Color,"Calibri")
	ui.handleBarBorder := ui.mainGui.addText("x0 y0 w34 h220 background" cfg.themeBright1Color,"")
	ui.handleBarImage := ui.MainGui.AddPicture("x1 y2 w33 h220 backgroundTrans","./img/handlebar_vertical.png")
	ui.ButtonHandlebarDebug := ui.MainGui.AddPicture( 
	(cfg.consoleVisible) 
		? "x2 y185 w30 h27 section hidden Background" cfg.ThemeButtonOnColor 
		: "x2 y185 w30 h27 section hidden Background" cfg.ThemeButtonReadyColor,
	(cfg.consoleVisible) 
		? "./Img/button_console_ready.png" 
		: "./Img/button_console_ready.png")
	ui.handleBarImage.ToolTip := "Drag Handlebar to Move.`nDouble-Click to collapse/uncollapse."
	
	ui.rightHandlebarBg := ui.mainGui.addText("x529 y32 w31 h182 background" cfg.themeBright1Color,"")
	ui.rightHandlebarImage2 := ui.mainGui.AddPicture("x528 w31 y33 h180 section","./img/right_handlebar_vertical.png")
	ui.handleBarImage.OnEvent("DoubleClick",ToggleGuiCollapse)

	ui.rightHandleBarImage2.OnEvent("DoubleClick",ToggleGuiCollapse)
	ui.handleBarImage.OnEvent("Click",WM_LBUTTONDOWN_callback)
	ui.rightHandleBarImage2.OnEvent("Click",WM_LBUTTONDOWN_callback)
	;ui.gameTabTopDockButtonOutline := ui.mainGui.addText("x0 y0 w33 h33 background" cfg.themeBright1Color)
	;ui.gameTabTopDockButtonOutline2 := ui.mainGui.addText("x1 y1 w33 h31 background" cfg.themeDark1Color)
	;ui.gameTabTopDockButton := ui.mainGui.addPicture("x0 y0 w34 h33 background" cfg.themeButtonOnColor,"./img/button_dock_up.png")
	;ui.gameTabTopDockButton.onEvent("click",topDockOn)
	;ui.gameTabTopDockButton.toolTip := "Dock to top of screen"
	ui.exitButtonBg := ui.mainGui.addText("x502 y2 w58 h30 background" cfg.themeBright1Color,"")
	ui.DownButton := ui.mainGui.AddPicture("x502 y0 w26 h30 section Background" cfg.ThemeFont1Color,"./Img/button_minimize.png")
	ui.DownButton.OnEvent("Click",HideGui)
	ui.DownButton.ToolTip := "Minimizes d2app App"
	ui.ExitButtonBorder 	:= ui.mainGui.AddText("x+2 ys0 section w30 h30 Background" cfg.ThemeBright1Color,"")
	ui.ExitButton 	:= ui.mainGui.AddPicture("x+-32 ys0 w31 h32 Background" cfg.ThemeButtonOnColor,"./Img/button_power_ready.png")
	ui.ExitButton.OnEvent("Click",ExitButtonPushed)
	ui.ExitButton.ToolTip := "Terminates d2app App"
	

	
	ui.ButtonHandlebarDebug.OnEvent("Click",toggleConsole)	
	;line(ui.mainGui,2,184,33,1,cfg.themeBright1Color)
	
	ui.loadingProgress.value += 5
	; for tab in cfg.mainTabList {
		; if a_index == cfg.activeMainTab {
			; ui.%tab%ButtonBg.value := "./img/tab_selected.png"
		
			; ui.%tab%ButtonBg.value := "./img/tab_unselected.png"
			; }
	; msgBox(cfg.mainTabList[cfg.activeMainTab] "`n" a_index "`n" tab)
			;	if ui.mainGuiTabs[cfg.activeMainTab.Text].text = tab.text ui.%tab%ButtonBg.value := "./img/tab_unselected.png"
	
	ui.gvConsole := ui.MainGui.AddListBox("x0 y214 w560 h192 +Background" cfg.ThemePanel1Color)
	ui.gvConsole.Color := cfg.ThemeBright1Color	
	afk 						:= Object()	
	ui.loadingProgress.value += 5
	;GuiAFKTab(&ui,&afk)
	ui.loadingProgress.value += 5
	;GuiOperationsTab(&ui,&cfg,&afk)	
	ui.loadingProgress.value += 5
	;GuiDockTab(&ui)

	GuiSetupTab(&ui,&cfg)
	;GuiListsTab(&ui,&cfg)
	
	ui.loadingProgress.value += 5
	GuiGameTab()
	ui.loadingProgress.value += 5
	OnMessage(0x0200, WM_MOUSEMOVE)
	OnMessage(0x0202, WM_LBUTTONDOWN)
	OnMessage(0x47, WM_WINDOWPOSCHANGED)
	; if (FileExist("./Logs/persist.log"))
	; {
		; try
			; Loop Read, "./Logs/persist.log" {
				; ui.gvConsole.Add([A_LoopReadLine])
			; }
		; try
			; FileDelete("./Logs/persist.log")
	; }
	
	; ui.titleBarButtonGui := Gui()
	; ui.titleBarButtonGui.Opt("-Caption -Border AlwaysOnTop +ToolWindow owner" ui.mainGui.hwnd)
	; ui.titleBarButtonGui.BackColor := ui.TransparentColor
	; ui.titleBarButtonGui.Color := ui.TransparentColor

	; ui.buttonUndockAfk := ui.mainGui.AddPicture("x+6 ys w35 h35 hidden Background" cfg.ThemeButtonAlertColor,"./Img/button_dockright_ready.png")
	; ui.buttonUndockAfk.OnEvent("Click",ToggleAfkDock)
	; ui.buttonUndockAfk.ToolTip := "Undocks AFK Window"
	;ui.rightPadding 	:= ui.titleBarButtonGui.addText("x73 y0 w1 h38 background" cfg.themeBorderLightColor," ")
	
	ui.loadingProgress.value += 5
	;InitOSDGui()
	
	ui.loadingProgress.value += 5
	; if (cfg.consoleVisible) {
		; (cfg.consoleVisible := !cfg.consoleVisible)
		; toggleConsole()
	; }
	

	debugLog("Interface Initialized")
	
	ui.MainGuiTabs.UseTab("")
	line(ui.mainGui,33,210,495,2,cfg.themeDark2Color)
	line(ui.mainGui,34,32,2,210,cfg.themeBright1Color)
	line(ui.mainGui,528,34,2,210,cfg.themeBright1Color)
	;line(ui.gameSettingsGui,250,190,280,2,cfg.themeBright2Color)

}

line(this_gui,startingX,startingY,length,thickness,color,vertical:=false) {
	this_guid := comObject("Scriptlet.TypeLib").GUID
	if (vertical) {
		this_guid := this_gui.addText("x" startingX " y" startingY " w" thickness " h" length " background" color)
	} else {
		this_guid := this_gui.addText("x" startingX " y" startingY " w" length " h" thickness " background" color)
	}
	return this_guid
}


toggleChanged(toggleControl,*) {
	toggleControl.value := 
		(cfg.%toggleControl.name%Enabled := !cfg.%toggleControl.name%Enabled)
			? (toggleControl.Opt("Background" cfg.ThemeButtonOnColor),cfg.toggleOn)
			: (toggleControl.Opt("Background" cfg.ThemeButtonReadyColor),cfg.toggleOff)
			iniWrite(cfg.%toggleControl.name%Enabled,cfg.file,"Toggles",toggleControl.name "Enabled")
			trayTip(toggleControl.name " changed to " ((cfg.%toggleControl.name%Enabled) ? "On" : "Off"),"d2app Config Change","Iconi Mute")

		; reload()
		}
		
toggleChange(name,onOff := "",toggleOnImg := cfg.toggleOn,toggleOffImg := cfg.toggleOff,toggleOnColor := cfg.themeButtonOnColor,toggleOffColor := cfg.themeButtonReadyColor) {
	 (onOff)
		? (%name%.Opt("Background" toggleOnColor),toggleOnImg) 
		: (%name%.Opt("Background" toggleOffColor),toggleOffImg)
}
ui.isFading := false

hotIf(isFading)
	hotkey("LButton",(*) => ui.isFading := true)
hotIf()

isFading(*) {
	if ui.isFading
		return 1
	else
		return 0
}
fadeIn() {

	if (cfg.AnimationsEnabled) {
		ui.isFading := true
		winGetPos(&mainGuiX,&mainGuiY,,,ui.mainGui)
		transparency := 0
		if cfg.topDockEnabled {
			guiVis(ui.mainGui,false)
			;guiVis(ui.titleBarButtonGui,false)
			showDockBar()
			while transparency < 253 {
				transparency += 2.5
				winSetTransparent(round(transparency),ui.dockBarGui)
				sleep(1)
			}
			guiVis(ui.dockBarGui,true)
		} else {
			switch ui.mainGuiTabs.text {
				case "3_AFK":
					while transparency < 253 {
						transparency += 2.5
						winSetTransparent(round(transparency),ui.mainGui)			
						winSetTransparent(round(transparency),ui.afkGui)
						;winSetTransparent(round(transparency),ui.titleBarButtonGui)
						sleep(1)
					}
				case "1_Game":
					guiVis(ui.gameTabGui,true)
					while transparency < 223 {
						transparency += 4
						winSetTransparent(min(round(transparency)+60,255),	ui.gameTabGui)
						;winSetTransparent(round(transparency),ui.titleBarButtonGui)
						winSetTransparent(round(transparency),ui.mainGui)	
						winSetTransparent(min(round(transparency)+0,255),ui.gameSettingsGui)
						sleep(1)
					}
				guiVis(ui.gameTabGui,true)
					
				default:
				while transparency < 253 {
					transparency += 2.5
					winSetTransparent(round(transparency),ui.mainGui)
					;winSetTransparent(round(transparency),ui.titleBarButtonGui)
					sleep(1)
				}

			}
			guiVis(ui.mainGui,true)
			;guiVis(ui.titleBarButtonGui,true)
		}
		ui.isFading := false
	}
	if (cfg.alwaysOnTopEnabled) {
		ui.mainGui.opt("alwaysOnTop")
		;ui.titleBarButtonGui.opt("alwaysOnTop")
	} else {
		ui.mainGui.opt("-alwaysOnTop")
		;ui.titleBarButtonGui.opt("-alwaysOnTop")
	}
	ui.mainGuiTabs.useTab("")
}

autoFireButtonClicked(*) {
	ToggleAutoFire()
}

toggleGuiCollapse(*) {
	static activeMainTab := ui.mainGuiTabs.value
		
	(ui.GuiCollapsed := !ui.GuiCollapsed) 
		? CollapseGui() 
		: UncollapseGui()
}

CollapseGui() {
	winGetPos(&mainX,&mainY,&mainW,&mainH,ui.mainGui)
	GuiWidth := mainW
	;guiVis(ui.titleBarButtonGui,false)
	guiVis(ui.afkGui,false)
	guiVis(ui.gameSettingsGui,false)
	if (cfg.AnimationsEnabled) {
		While GuiWidth > 250 {
			ui.MainGui.Move(mainX,mainY,GuiWidth,)
			GuiWidth -= 30
			sleep(20)
		}		
		guiVis(ui.gameTabGui,false)
		While GuiWidth > 5 {
			ui.MainGui.Move(mainX,mainY,GuiWidth,)
			GuiWidth -= 30
			sleep(20)
		}	
	}
	ui.MainGui.Move(mainX,mainY,35,)
}

redrawGuis(GuiWidth,mainX,mainY) {
}

UncollapseGui() {
	winGetPos(&mainX,&mainY,&mainW,&mainH,ui.mainGui)
	GuiWidth := 0
	;guiVis(ui.titleBarButtonGui,false)
	if (cfg.AnimationsEnabled) {
		While GuiWidth < 160 {
			ui.MainGui.Move(mainX,mainY,GuiWidth,)
			GuiWidth += 30
			sleep(20)
		}
	}

	if (cfg.AnimationsEnabled) {
		While GuiWidth < 575 {
			ui.MainGui.Move(mainX,mainY,GuiWidth,)
			GuiWidth += 30
			sleep(20)
		}
	}
	ui.mainGui.move(,,562,)
	guiVis(ui.gameTabGui,true)
	tabsChanged()
}

exitMenuShow(this_button) {
	if this_button == ui.dockBarExitButton {
		winGetPos(&dbX,&dbY,&dbW,&dbH,ui.dockBarGui)
		ui.exitMenuGui := gui()
		ui.exitMenuGui.Opt("-caption -border toolWindow AlwaysOnTop Owner" ui.dockBarGui.hwnd)
		ui.exitMenuGui.BackColor := ui.transparentColor
		ui.stopGamingButton := ui.exitMenuGui.addPicture("x0 y2 section w35 h35 background" cfg.themeFont2Color,"./img/button_quit.png")
		ui.startGamingButton := ui.exitMenuGui.addPicture("x+2 ys w35 h35 background" cfg.themeFont2Color,"./img/button_exit_gaming.png")
		ui.stopGamingButton.toolTip := "Shut down all apps defined in the Gaming Mode AppDock list"
		ui.startGamingButton.toolTip := "Start apps defined in the Gaming Mode AppDock list"
		ui.stopGamingButton.onEvent("Click",exitAppCallback)
		ui.startGamingButton.onEvent("Click",stopGaming)
		WinSetTransColor(ui.transparentColor,ui.exitMenuGui)
		ui.gamingModeLabel := ui.exitMenuGui.addText("x0 y37 w72 h15 center background" cfg.themePanel3color " c" cfg.themeFont3Color," Gaming Mode")
		ui.gamingModeLabel.setFont("s8")
		drawOutlineNamed("exitMenuBorder",ui.exitMenuGui,0,0,74,52,cfg.themeFont3Color,cfg.themeFont3Color,1)
		drawOutlineNamed("exitMenuBorder",ui.exitMenuGui,1,1,72,50,cfg.themeBorderLightColor,cfg.themeBorderDarkColor,1)
		drawOutlineNamed("exitMenuBorder",ui.exitMenuGui,2,2,72,50,cfg.themeDark1Color,cfg.themeDark2Color,1)
		ui.exitMenuGui.show("x" dbX+dbW-71 " y" dbY+dbH-37 " w74 h52 noActivate")
		loop 75 {
			ui.exitMenuGui.move(dbX+dbW-71+a_index,dbY+dbH-37)
		}
	} else {
		winGetPos(&tbX,&tbY,,,ui.mainGui)
		ui.exitMenuGui := gui()
		ui.exitMenuGui.Opt("-caption -border toolWindow AlwaysOnTop Owner" ui.mainGui.hwnd)
		ui.exitMenuGui.BackColor := ui.transparentColor
		ui.gamingModeLabel := ui.exitMenuGui.addText("x0 y2 w72 h15 center background" cfg.themePanel3color " c" cfg.themeButtonOnColor," Gaming Mode")
		ui.gamingModeLabel.setFont("s8")
		ui.gamingLabels := ui.exitMenuGui.addText("x0 y16 w72 h52 center background" cfg.themePanel3color " c" cfg.themeButtonAlertColor," Stop   Start ")
		ui.gamingLabels.setFont("s10")
		ui.stopGamingButton := ui.exitMenuGui.addPicture("x0 y32 section w35 h35 background" cfg.themeFont2Color,"./img/button_quit.png")
		ui.startGamingButton := ui.exitMenuGui.addPicture("x+2 ys w35 h35 background" cfg.themeFont2Color,"./img/button_exit_gaming.png")
		ui.stopGamingButton.onEvent("Click",exitAppCallback)
		ui.startGamingButton.onEvent("Click",stopGaming)
		WinSetTransColor(ui.transparentColor,ui.exitMenuGui)
		drawOutlineNamed("exitMenuBorder",ui.exitMenuGui,0,0,74,68,cfg.themeFont3Color,cfg.themeFont3Color,2)
		ui.exitMenuGui.show("x" tbX+490 " y" tbY-70 " AutoSize noActivate")
		loop 70 {
			ui.exitMenuGui.move(tbX+490,tbY-a_index)
		}
	}
}

exitButtonPushed(this_button,*) {
	if !keyWait("LButton","T.450") {
		exitMenuShow(this_button)
		keyWait("LButton")
		if this_button == ui.dockBarExitButton {
			mouseGetPos(,,,&ctrlUnderMouse,2)
			winGetPos(&menuX,&menuY,,&menuH,ui.exitMenuGui.hwnd)
			switch ctrlUnderMouse {
				case ui.startGamingButton.hwnd:
					loop 69 {
						ui.exitMenuGui.move(menuX,menuY+a_index,,menuH-a_index)
					}
					ui.exitMenuGui.destroy()
					startGaming()
				case ui.stopGamingButton.hwnd:
					loop 69 {
						ui.exitMenuGui.move(menuX,menuY+a_index,,menuH-a_index)	
					}
					ui.exitMenuGui.destroy()
					stopGaming()
				case ui.dockBarExitButton.hwnd:
				loop 69 {
						ui.exitMenuGui.move(menuX,menuY+a_index,,menuH-a_index)
					}
					ui.exitMenuGui.destroy()
					exitApp()	
				case ui.exitButton.hwnd:
					loop 69 {
						ui.exitMenuGui.move(menuX,menuY+a_index,,menuH-a_index)
					}
					ui.exitMenuGui.destroy()
					exitApp()
				default: 
					loop 69 {
						ui.exitMenuGui.move(menuX,menuY+a_index,,menuH-a_index)
					}
					ui.exitMenuGui.destroy()
			}
		} else {
			mouseGetPos(,,,&ctrlUnderMouse,2)
			winGetPos(&menuX,&menuY,,&menuH,ui.exitMenuGui.hwnd)	
			switch ctrlUnderMouse {
				case ui.startGamingButton.hwnd:
					loop 69 {
						ui.exitMenuGui.move(menuX,menuY+a_index,,menuH-a_index)
					}
					ui.exitMenuGui.destroy()
					startGaming()
				case ui.stopGamingButton.hwnd:
					loop 69 {
						ui.exitMenuGui.move(menuX,menuY+a_index,,menuH-a_index)
					}
					ui.exitMenuGui.destroy()
					stopGaming()
				case ui.exitButton.hwnd:
					loop 69 {
						ui.exitMenuGui.move(menuX,menuY+a_index,,menuH-a_index)
					}
					ui.exitMenuGui.destroy()
					exitApp()
				default: 
					loop 69 {
						ui.exitMenuGui.move(menuX,menuY+a_index,,menuH-a_index)
					}
					ui.exitMenuGui.destroy()
			}
		} 
	} else 
			exitApp
}
	
stopGaming(*) {
	winCloseAll("Gaming Mode")
	exitApp()
}

startGaming(*) {
	applyWinPos("Gaming Mode")
}

quickOSD()
quickOSD(*) {
	ui.quickOsdBg := gui()
	ui.quickOsdBg.opt("-caption -border toolWindow alwaysOnTop")
	ui.quickOsdBg.backColor := "010203"


	ui.quickOSD := gui()
	ui.quickOSD.opt("-caption -border toolWindow alwaysOnTop")
	ui.quickOSD.backColor := "010203"
	ui.msgLog := ui.quickOSD.AddText("x10 y15 w600 h800 backgroundTrans cLime","")
	ui.msgLog.setFont("s12")
	winSetTransparent(155,ui.quickOsdBg.hwnd)
	winSetTransColor("010203",ui.quickOSD.hwnd)
}


osdLog(msg) {
	if cfg.debugEnabled {
		ui.quickOsdBg.show("x5 y200 w610 h810 noActivate")
		ui.quickOSD.show("x5 y200 w610 h810 noActivate")
		setTimer () => (ui.quickOsdBg.hide(),ui.quickOSD.hide()),-5000
	} else {
		ui.quickOsdBg.hide()
		ui.quickOSD.hide()
	}
	ui.msgLog.text := msg "`n" ui.msgLog.text
}

exitAppCallback(*) {
	ExitApp
}
	


savePrevGuiPos(*) {
	winGetPos(&prevGuiX,&prevGuiY,,,ui.mainGui)
	ui.prevGuiX := prevGuiX
	ui.prevGuiY := prevGuiY
}

saveGuiPos(*) {
	Global
	winGetPos(&GuiX,&GuiY,,,ui.MainGui.hwnd)
	cfg.GuiX := GuiX
	cfg.GuiY := GuiY
	IniWrite(cfg.GuiX,cfg.file,"Interface","GuiX")
	IniWrite(cfg.GuiY,cfg.file,"Interface","GuiY")
	debugLog("Saving Window Location at x" GuiX " y" GuiY)
}

showGui(*) {
	
	ui.mainGui.move(cfg.GuiX,cfg.GuiY)	
	debugLog("Showing Interface")
}

toggleConsole(*) {
	Global
	if (cfg.ConsoleVisible == false)
	{
		cfg.ConsoleVisible := true
		
		ui.ButtonDebug.Value := "./Img/button_console_on.png"
		ui.ButtonDebug.Opt("Background" cfg.ThemeButtonOnColor)
		ui.buttonHandlebarDebug.value := "./img/button_console_on.png"
		ui.buttonHandlebarDebug.opt("background" cfg.themeButtonOnColor)
		;MsgBox("here")
		if (cfg.AnimationsEnabled) {
		GuiH := 214	
			While (GuiH < 395)
			{
				GuiH += 10
				ui.mainGui.move(,,,GuiH) 
				Sleep(10)
			}
		}
		GuiH := 430
		ui.mainGui.Move(,,,GuiH)
		winGetPos(&GuiX,&GuiY,&GuiW,&GuiH,ui.mainGui)
		;MsgBox(GuiX "`n" GuiY "`n" GuiW "`n" GuiH)
		debugLog("Showing Log")
	} else {
		cfg.ConsoleVisible := false
		ui.ButtonDebug.Value := "./Img/button_console_ready.png"
		ui.ButtonDebug.Opt("Background" cfg.ThemeButtonReadyColor)
		ui.buttonHandlebarDebug.value := "./img/button_console_ready.png"
		ui.buttonHandlebarDebug.opt("background" cfg.themeButtonReadyColor)

		winGetPos(&GuiX,&GuiY,&GuiW,&GuiH,ui.mainGui)
		if (cfg.AnimationsEnabled) {
			While (GuiH > 225)
			{
				GuiH -= 10
				ui.MainGui.move(,,,GuiH)
				Sleep(10)
			}
		}
		GuiH := 214
		ui.MainGui.move(,,,GuiH)
		debugLog("Hiding Log")
	}
}



initConsole(&ui) {
	ui.gvMonitorSelectGui := Gui()
	ui.gvMonitorSelectGui.Opt("-Theme -Border -Caption toolWindow +AlwaysOnTop +Parent" ui.MainGui.Hwnd " +Owner" ui.MainGui.Hwnd)
	ui.gvMonitorSelectGui.BackColor := "212121"
	ui.gvMonitorSelectGui.SetFont("s16 c00FFFF","Calibri Bold")
	ui.gvMonitorSelectGui.Add("Text",,"Click anywhere on the screen`nyou'd like your AppDock on.")
}

{ ;Draw Outline Functions
	drawOutlineMainGui(X, Y, W, H, Color1 := "Black", Color2 := "Black", Thickness := 1) {	
		ui.MainGui.AddProgress("x" X " y" Y " w" W " h" Thickness " Background" Color1) 
		ui.MainGui.AddProgress("x" X " y" Y " w" Thickness " h" H " Background" Color1) 
		ui.MainGui.AddProgress("x" X " y" Y + H - Thickness " w" W " h" Thickness " Background" Color2) 
		ui.MainGui.AddProgress("x" X + W - Thickness " y" Y " w" Thickness " h" H " Background" Color2) 	
	}

	drawOutlineDialogBoxGui(X, Y, W, H, Color1 := "Black", Color2 := "Black", Thickness := 1) {	
		ui.dialogBoxGui.AddProgress("x" X " y" Y " w" W " h" Thickness " Background" Color1) 
		ui.dialogBoxGui.AddProgress("x" X " y" Y " w" Thickness " h" H " Background" Color1) 
		ui.dialogBoxGui.AddProgress("x" X " y" Y + H - Thickness " w" W " h" Thickness " Background" Color2) 
		ui.dialogBoxGui.AddProgress("x" X + W - Thickness " y" Y " w" Thickness " h" H " Background" Color2) 	
	}

	drawOutlineNewGameGui(X, Y, W, H, Color1 := "Black", Color2 := "Black", Thickness := 1) {	
		ui.NewGameGui.AddProgress("x" X " y" Y " w" W " h" Thickness " Background" Color1) 
		ui.NewGameGui.AddProgress("x" X " y" Y " w" Thickness " h" H " Background" Color1) 
		ui.NewGameGui.AddProgress("x" X " y" Y + H - Thickness " w" W " h" Thickness " Background" Color2) 
		ui.NewGameGui.AddProgress("x" X + W - Thickness " y" Y " w" Thickness " h" H " Background" Color2) 	
		}

	drawOutlineNotifyGui(X, Y, W, H, Color1 := "Black", Color2 := "Black", Thickness := 1) {	
		ui.NotifyGui.AddProgress("x" X " y" Y " w" W " h" Thickness " Background" Color1) 
		ui.NotifyGui.AddProgress("x" X " y" Y " w" Thickness " h" H " Background" Color1) 
		ui.NotifyGui.AddProgress("x" X " y" Y + H - Thickness " w" W " h" Thickness " Background" Color2) 
		ui.NotifyGui.AddProgress("x" X + W - Thickness " y" Y " w" Thickness " h" H " Background" Color2) 	
	}

	drawOutlineAfkGui(X, Y, W, H, Color1 := "Black", Color2 := "Black", Thickness := 1) {	
		
		ui.AfkGui.AddProgress("x" X " y" Y " w" W " h" Thickness " Background" Color1) 
		ui.AfkGui.AddProgress("x" X " y" Y " w" Thickness " h" H " Background" Color1) 
		ui.AfkGui.AddProgress("x" X " y" Y + H - Thickness " w" W " h" Thickness " Background" Color2) 
		ui.AfkGui.AddProgress("x" X + W - Thickness " y" Y " w" Thickness " h" H " Background" Color2) 	
	}

	drawOutline(guiName, X, Y, W, H, Color1 := "Black", Color2 := "Black", Thickness := 1) {	
		
		guiName.AddProgress("x" X " y" Y " w" W " h" Thickness " Background" Color1) 
		guiName.AddProgress("x" X " y" Y " w" Thickness " h" H " Background" Color1) 
		guiName.AddProgress("x" X " y" Y + H - Thickness " w" W " h" Thickness " Background" Color2) 
		guiName.AddProgress("x" X + W - Thickness " y" Y " w" Thickness " h" H " Background" Color2) 	
	}	
	
	drawOutlineNamed(outLineName, guiName, X, Y, W, H, Color1 := "Black", Color2 := "Black", Thickness := 1) {	
		outLineName1	:= outLineName "1"
		outLineName2	:= outLineName "2"
		outLineName3	:= outLineName "3"
		outLineName4	:= outLineName "4"
		(outLineName1 := outLineName "1") := guiName.AddProgress("x" X " y" Y " w" W " h" Thickness " Background" Color1) 
		(outLineName2 := outLineName "2") := guiName.AddProgress("x" X " y" Y " w" Thickness " h" H " Background" Color1) 
		(outLineName3 := outLineName "3") := guiName.AddProgress("x" X " y" Y + H - Thickness " w" W " h" Thickness " Background" Color2) 
		(outLineName4 := outLineName "4") := guiName.AddProgress("x" X + W - Thickness " y" Y " w" Thickness " h" H " Background" Color2) 	
	}


	; drawOutlineTitleBarButtonGui(X, Y, W, H, Color1 := "Black", Color2 := "Black", Thickness := 1) {	
		
		; ui.titleBarButtonGui.AddProgress("x" X " y" Y " w" W " h" Thickness " Background" Color1) 
		; ui.titleBarButtonGui.AddProgress("x" X " y" Y " w" Thickness " h" H " Background" Color1) 
		; ui.titleBarButtonGui.AddProgress("x" X " y" Y + H - Thickness " w" W " h" Thickness " Background" Color2) 
		; ui.titleBarButtonGui.AddProgress("x" X + W - Thickness " y" Y " w" Thickness " h" H " Background" Color2) 	
	
	; }
} ;End Draw Outline Functions

{ ;BEGIN = outline parameters
	; drawAfkOutlines() {	
	; ui.mainGuiTabs.UseTab("3_AFK")
		; drawOutlineNamed("afkToolbarOutline",ui.afkGui,5,0,132,35,cfg.ThemeBright1Color,cfg.ThemeBright1Color,1)
		; drawOutlineNamed("afkPopoutButtonOutline",ui.afkGui,216,0,34,35,cfg.ThemeBright1Color,cfg.ThemeBright1Color,1)
		 ; drawOutlineNamed("win1statusRow",ui.afkGui,4,40,246,26,cfg.themeBright1Color,cfg.themeBright1Color,2)
		 ; drawOutlineNamed("win2statusRow",ui.afkGui,4,74,246,26,cfg.themeBright1Color,cfg.themeBright1Color,2)
	; drawOutlineNamed("afkTimeStatusOutline",ui.afkGui,4,106,246,28,cfg.themeBright1Color,cfg.themeBright1Color,2)
	
		; drawOutlineNamed("afkRoutine1Outline",ui.mainGui,322,34,205,84,cfg.ThemeBright1Color,cfg.ThemeBright1Color,1)
		; drawOutlineNamed("afkRoutine2Outline",ui.mainGui,322,122,205,84,cfg.ThemeBright1Color,cfg.ThemeBright1Color,1)

; }

	drawMainOutlines() {
	ui.mainGuiTabs.useTab("")
		drawOutlineNamed("consolePanelOutline",ui.mainGui,35,150,498,6,cfg.ThemeBorderDarkColor,cfg.ThemeBorderLightColor,2) 		;Log Panel Outline
		drawOutlineNamed("consolePanelOutline2",ui.mainGui,35,220,498,184,cfg.ThemeBorderDarkColor,cfg.ThemeBorderLightColor,1)		;Log Panel 3D Effect
	}

	drawOpsOutlines() {
		ui.mainGuiTabs.useTab("")

		; ui.mainGuiTabs.useTab("2_SYS")
		; drawGridlines()
		; drawOutlineNamed("bottomLine",ui.mainGui,34,211,495,2,cfg.themeBright2Color,cfg.themeBright2Color,2)
		; drawOutlineNamed("bottomLine2",ui.mainGui,34,211,495,1,cfg.themeBright1Color,cfg.themeBright1Color,1)
		; drawOutlineNamed("tabsUnderline",ui.MainGui,33,29,502,3,cfg.ThemeBackgroundColor,cfg.ThemeBackgroundColor,2)
		; drawOutlineNamed("opsClock",ui.mainGui,101,33,139,28,cfg.ThemeBorderDarkColor,cfg.ThemeBorderDarkColor,2)		;Ops Clock
		; drawOutlineNamed("opsClassDDL",ui.mainGui,323,33,138,28,cfg.ThemeBorderDarkColor,cfg.ThemeBorderDarkColor,1)		;Ops Clock
		; drawOutlineNamed("opsToolbarOutline2",ui.mainGui,34,33,494,30,cfg.ThemeBright1Color,cfg.ThemeBright1Color,1)	;Ops Toolbar Outline
		; drawOutlineNamed("opsToolbarCenter",ui.mainGui,267,34,29,30,cfg.ThemeBright1Color,cfg.ThemeBright1Color,1)	;Ops Toolbar Outline

		; drawOutlineNamed("opsMiddleColumnOutlineDark",ui.mainGui,256,62,54,138,cfg.themeBright1Color,cfg.themeBright1Color,3)	;Ops Toolbar Outline
		; drawOutlineNamed("opsMiddleColumnOutlineLight",ui.mainGui,258,63,50,135,cfg.themeDark1Color,cfg.themeDark1Color,1)		;Ops Toolbar
		; drawOutlineNamed("opsMiddleColumnOutlineDark",ui.mainGui,259,64,48,133,cfg.themeBright2Color,cfg.themeBright2Color,1)	;Ops Toolbar Outline
		; drawOutlineNamed("opsAfkStatusLeft",ui.mainGui,34,104,67,25,cfg.themeBright1Color,cfg.themeBright1Color,1)
		; drawOutlineNamed("opsAfkStatusRight",ui.mainGui,462,104,66,25,cfg.themeBright1Color,cfg.themeBright1Color,1)	
		; drawOutlineNamed("opsAfkStatusLeft",ui.mainGui,34,130,67,32,cfg.themeBright1Color,cfg.themeBright1Color,1)
		; drawOutlineNamed("opsAfkStatusRight",ui.mainGui,462,130,66,32,cfg.themeBright1Color,cfg.themeBright1Color,1)
	}

	drawGridLines() {
	ui.MainGuiTabs.UseTab("2_SETUP")
		drawOutline(ui.MainGui,101,62,157,100,cfg.ThemeBright2Color,cfg.ThemeBright2Color,2) 	;Win1 Info Frame
		drawOutline(ui.MainGui,102,62,156,100,cfg.ThemeBright1Color,cfg.ThemeBright1Color,1) 	;Win1 Info Frame
		drawOutline(ui.MainGui,101,76,157,16,cfg.ThemeBright2Color,cfg.ThemeBright2Color,2)		;Win1 Info Gridlines  
		drawOutline(ui.MainGui,102,76,156,15,cfg.ThemeBright1Color,cfg.ThemeBright1Color,1)		;Win1 Line above ClassDDL
		drawOutline(ui.MainGui,101,90,157,17,cfg.ThemeBright2Color,cfg.ThemeBright2Color,2)		;Win1 Line above ClassDDL
		drawOutline(ui.MainGui,102,90,156,15,cfg.ThemeBright1Color,cfg.ThemeBright1Color,1)		;Win1 Line above ClassDDL

		drawOutline(ui.MainGui,306,62,156,100,cfg.ThemeBright2Color,cfg.ThemeBright2Color,1)		;WIn2 Info Frame
		drawOutline(ui.MainGui,306,62,155,100,cfg.ThemeBright1Color,cfg.ThemeBright1Color,2)	;WIn2 Info Frame

		drawOutline(ui.MainGui,306,76,156,16,cfg.ThemeBright2Color,cfg.ThemeBright2Color,2)		;Win2 Info Gridlines
		drawOutline(ui.MainGui,306,76,155,15,cfg.ThemeBright1Color,cfg.ThemeBright1Color,1)		;Win2 Line above ClassDDL
		drawOutline(ui.MainGui,306,90,156,16,cfg.ThemeBright2Color,cfg.ThemeBright2Color,2)		;Win2 Line above ClassDDL
		drawOutline(ui.MainGui,306,90,155,15,cfg.ThemeBright1Color,cfg.ThemeBright1Color,1)		;Win2 Line above ClassDDL

	}
} ;END - outline parameters



			
	; ui.afkGui.opt("toolWindow")
	; ui.gameSettingsGui.opt("toolWindow")
	; ui.gameTabGui.opt("toolWindow")
	; switch ui.activeTab {
		; case "1_Game":
			; if tabDisabled()
				; return
			; guiVis(ui.afkGui,false)
			; guiVis(ui.gameSettingsGui,true)
			; guiVis(ui.gameTabGui,true)
			; ui.gameSettingsGui.opt("-toolWindow")
			; ui.mainGui.opt("+toolWindow")
			; ui.1_gameButtonBg.value := "./img/tab_selected.png"
		; case "2_Sys":
			; guiVis(ui.gameSettingsGui,false)
			; guiVis(ui.gameTabGui,false)
			; guiVis(ui.afkGui,false)
			; ui.mainGui.opt("-toolWindow")
			; ui.2_sysButtonBg.value := "./img/tab_selected.png"
		; case "3_AFK":
			; guiVis(ui.afkGui,true)
			; guiVis(ui.gameSettingsGui,false)
			; guiVis(ui.gameTabGui,false)
			; ui.afkGui.opt("-toolWindow")
			; ui.mainGui.opt("+toolWindow")
			; ui.3_afkButtonBg.value := "./img/tab_selected.png"
		; case "4_AppDock":
			; guiVis(ui.gameSettingsGui,false)
			; guiVis(ui.gameTabGui,false)
			; guiVis(ui.afkGui,false)
			; ui.mainGui.opt("-toolWindow")
			; ui.4_appDockButtonBg.value := "./img/tab_selected.png"
		; case "5_Lists":
			; tabDisabled()
				; Return
			; guiVis(ui.afkGui,false)
			; guiVis(ui.gameSettingsGui,false)
			; guiVis(ui.gameTabGui,false)
			; ui.5_listsButtonBg.value := "./img/tab_selected.png"
		; case "6_Setup":
			; guiVis(ui.gameSettingsGui,false)
			; guiVis(ui.gameTabGui,false)
			; guiVis(ui.afkGui,false)
			; ui.mainGui.opt("-toolWindow")
			;ui.6_setupButtonBg.value := "./img/tab_selected.png"
		; default:
			; guiVis(ui.gameSettingsGui,false)
			; guiVis(ui.gameTabGui,false)
			; guiVis(ui.afkGui,false)
			; ui.mainGui.opt("-toolWindow")
		;	ui.%tab%ButtonBg.value := "./img/tab_unselected.png"
	; }
		
	controlFocus(ui.mainGuiTabs,ui.mainGui)
	; controlFocus(ui.d2ToggleAppFunctions,ui.gameSettingsGui)
	; controlFocus(ui.buttonTower,ui.afkGui)
	ui.previousTab := ui.activeTab
	;guiVis(ui.mainGui,true)


tabDisabled() {
		ui.mainGuiTabs.choose(ui.previousTab)
		tabsChanged()
		sleep(300)
		notifyOSD("This tab has been`ndisabled by the developer",2000)
		return 1
} 
			


guiVis(guiName,isVisible:= true) {
	if (isVisible) {
		if guiName != "all" {
			WinSetTransparent(255,guiName)
			WinSetTransparent("Off",guiName)
			WinSetTransColor(ui.TransparentColor,guiName)
			winSetAlwaysOnTop(cfg.alwaysOnTopEnabled,guiName)
		} else {
			try {
				winSetTransparent(255,ui.mainGui)
				winSetAlwaysOnTop(cfg.AlwaysOnTopenabled,ui.mainGui)
			}
			try { 
				winSetTransparent(255,ui.gameSettingsGui)
				winSetAlwaysOnTop(cfg.AlwaysOnTopenabled,ui.gameSettingsGui)
			}
			try {
				winSetTransparent(255,ui.gameTabGui)
				winSetAlwaysOnTop(cfg.AlwaysOnTopenabled,ui.gameTabGui)
			}
		}
	} else {
		if guiName != "all" {
			WinSetTransparent(0,guiName)
			winSetAlwaysOnTop(cfg.alwaysOnTopEnabled,guiName)
		} else {
			try {
				winSetTransparent(0,ui.mainGui)
				winSetAlwaysOnTop(cfg.AlwaysOnTopenabled,ui.mainGui)
			}
			try {
				winSetTransparent(0,ui.gameSettingsGui)
				winSetAlwaysOnTop(cfg.AlwaysOnTopenabled,ui.gameSettingsGui)
			}
			try {
				winSetTransparent(0,ui.gameTabGui)
				winSetAlwaysOnTop(cfg.AlwaysOnTopEnabled,ui.gameTabGui)
			}
		}
	}
}

ui.dockBarWidth := 0

createDockBar() {
	try
		ui.dockBarGui.destroy()
	ui.dockBarGui := gui()
	ui.dockBarGui.opt("alwaysOnTop +toolWindow -caption")
	ui.dockBarGui.backColor := cfg.themeBackgroundColor
	ui.dockBarGui.color := cfg.themeBackgroundColor
	guiVis(ui.dockBarGui,false)
	ui.dockBarWidth := 0
	ui.dockBarGui.SetFont("s14","Calibri Thin")
	ui.docktopMoveButton := ui.dockBarGui.addPicture("x1 y0 w32 h33 section background" cfg.themeButtonOnColor,"./img/button_dockLeftRight.png")
	ui.docktopMoveButton.onEvent("click",topDockMove)
	ui.docktopMoveButton.toolTip := "Dock to top of screen"
	ui.dockBarWidth += 32
	ui.docktopDockButton := ui.dockBarGui.addPicture("x+0 ys w32 h33 section background" cfg.themeButtonOnColor,"./img/button_dockDown_ready.png")
	ui.docktopDockButton.onEvent("click",topDockOff)
	ui.docktopDockButton.toolTip := "Dock to top of screen"
	ui.dockBarWidth += 32
	ui.dockAutoClicker 		:= ui.dockBarGui.addPicture("x+0 ys w32 h33 section background" cfg.themeButtonReadyColor,"./img/button_AutoClicker_ready.png")
	ui.dockAutoClicker.onEvent("click", ToggleAutoClicker)
	ui.dockAutoClicker.ToolTip := "AutoClicker Status. (Use settings screen to adjust timing)"
	ui.dockBarWidth += 32
	ui.dockPadBar1 			:= ui.dockBarGui.addText("x+0 ys w1 h33 section background" cfg.themeBright1Color,"")
	ui.dockBarWidth += 1

	ui.dockBarWin1Cmd		:= ui.dockBarGui.addText("x+0 ys w32 h33 section center background" cfg.themePanel3Color " c" cfg.themeFont3Color,"--")
	ui.dockBarWin1Cmd.setFont("s20")
	ui.dockBarWidth += 32
	ui.dockBarGui.addPicture("x+0 ys w32 h34 section background" cfg.themeBackgroundColor,"./img/arrow_left.png")
	ui.dockBarWidth += 32
	ui.dockBarGui.addText("x+0 ys w1 h33 section background" cfg.themeBright1Color,"")
	ui.dockBarWidth += 1
	ui.dockBarWin1Icon		:= ui.dockBarGui.addPicture("x+0 ys w32 h33 section background" cfg.themePanel1Color,"./img/sleep_icon.png")

	ui.dockBarWidth	+= 32
	ui.dockGameDDL := ui.dockBarGui.AddDropDownList("x+0 ys+2 w185 Background" cfg.ThemeEditboxColor " -E0x200 Choose" cfg.game,cfg.GameList)
	ui.dockBarWidth += 185
	ui.dockGameDDL.ToolTip := "Select the Game You Are Playing"
	;ui.dockGameDDL.OnEvent("Change",changeDockGameDDL)
	; postMessage("0x153", -1, 35,, "AHK_ID " ui.gameDDL.Hwnd ) ; CB_SETITEMHEIGHT = 0x153
	; postMessage("0x153", 0, 35,, "AHK_ID " ui.gameDDL.Hwnd ) ; CB_SETITEMHEIGHT = 0x153
	ui.dockbarWin2Icon		:= ui.dockBarGui.addPicture("x+0 ys w32 h33 background" cfg.themePanel1Color,"./img/sleep_icon.png")

	ui.dockBarWidth += 32	
	ui.dockBarGui.addText("x+0 ys w1 h33 section background" cfg.themeBright1Color,"")
	ui.dockBarWidth += 1
	
	ui.dockBarGui.addPicture("x+0 ys w32 h34 section backgroundTrans","./img/arrow_right.png")
	ui.dockBarWidth += 32
	ui.dockBarWin2Cmd		:= ui.dockBarGui.addText("x+0 ys w32 h33 section center background" cfg.themePanel3Color " c" cfg.themeFont3Color,"--")
	ui.dockBarWin2Cmd.setFont("s20")
	ui.dockBarWidth += 32
	ui.dockBarGui.addText("x+0 ys+1 w0 h33 section background" cfg.themeBright1Color,"")
	; ui.dockBarWidth += 1
	
		switch ui.dockGameDDL.text {
		case "Destiny 2":
			dockBarIcons("Destiny 2","Add")
		case "World//Zero":
			dockBarIcons("World//Zero","Add")
	}
	ui.dockBarGui.addText("x+-3 ys+0 w2 h30 section background" cfg.themeBright2Color,"")
	ui.dockBarWidth -= 0
	ui.dockBarExitButton := ui.dockBarGui.addPicture("x+0 ys+0 w30 h31 section background" cfg.themeButtonOnColor,"./img/button_power.png")
	ui.dockBarWidth += 32
	ui.dockBarExitButton.onEvent("click",ExitButtonPushed)
	ui.dockBarExitButton.toolTip := "Exit d2app"
	
	topDockMove(*) {
		postMessage("0xA1",2,,,"A")
		keyWait("LButton")
		winGetPos(&dockBarx,&dockbarY,,,ui.dockBarGui)
		loop monitorGetCount() {
			monitorGet(a_index,&monLeft,,&monRight,)
			if dockbarx > monLeft && dockbarx < monRight {
				cfg.dockbarMon := a_index
				iniWrite(cfg.dockBarMon,cfg.file,"Interface","DockbarMonitor")
				break
			}
		}
		showDockBar()
	}

	topDockPowerButtonPushed(this,*) {
		this.value := "./img/button_power_down.png"
		setTimer () => (this.value := "./img/button_power.png",exitAppCallback()),-400
		;setTimer () => exitAppCallback(),-100
	}
}

dockBarIcons(game,operation := "") {
	if (operation == "Add") {
		switch game {
			case "Shatterline":
				;TBD
			case "Destiny 2":
				ui.dockBarGui.addText("x+0 ys w1 h33 section background" cfg.themeBright1Color,"")
				ui.dockBarWidth 		+= 1
				ui.topDockDIMbutton			:= ui.dockBarGui.addPicture("x+8 ys+6 w24 h24 section backgroundTrans","./img/icon_DIM.png")
				ui.dockBarWidth 		+= 32
		 		ui.topDocklightGGbutton		:= ui.dockBarGui.addPicture("x+2 ys-2 w28 h28 section backgroundTrans","./img/button_vault_up.png")
				ui.topDockBBGGbutton		:= ui.dockBarGui.addPicture("x+0 ys w28 h28 section backgroundTrans","./img/icon_blueberries.png")
				ui.dockBarWidth 		+= 30
				ui.dockBarWidth 		+= 28
				ui.topDockBrayTechbutton		:= ui.dockBarGui.addPicture("x+0  ys w28 h28 section backgroundTrans","./img/icon_braytech.png")
				 ui.dockBarWidth 		+= 28
				ui.topDockd2Checklistbutton		:= ui.dockBarGui.addPicture("x+0  ys w28 h28 section backgroundTrans","./img/icon_d2Checklist.png")
				 ui.dockBarWidth 		+= 28
				ui.topDockDIMbutton.onEvent("click",d2LaunchDIMButtonClicked)
				ui.topDockLightGGbutton.onEvent("click",d2LaunchVaultCleanerButtonClicked)
				ui.topDockBBGGbutton.onEvent("click",d2LaunchBlueBerriesButtonClicked)
				ui.topDockBrayTechbutton.onEvent("click",d2LaunchBrayTechButtonClicked)
				ui.topDockd2Checklistbutton.onEvent("click",d2Launchd2ChecklistButtonClicked)
				ui.topDockLightGGbutton.toolTip := "Launch light.gg"
				ui.topDockDIMbutton.toolTip := "Launch DIM"
				ui.topDockBBGGbutton.toolTip := "Launch Blueberries"
				ui.topDockd2Checklistbutton.toolTip := "Launch D2 Checklist"
				ui.topDockBrayTechbutton.toolTip := "Launch Bray.Tech"
				; ui.dockBarWidth 		+= 32
				 ui.dockBarGui.addText("x+5 ys-2 w1 h32 section background" cfg.themeBright1Color,"")
				

				ui.dockBarGui.addText("x+0 ys+0 w1 h32 section background" cfg.themeBright1Color,"")
				ui.dockBarWidth			+= 6
				ui.dockBarAfkButton 	:= ui.dockBarGui.addPicture("x+-2 ys-1 w32 h32 section background" cfg.themeButtonReadyColor,ui.buttonStartAfk.value)
				ui.dockBarWidth 		+= 30
				ui.dockBarGui.addText("x+0 ys+0 w1 h32 section background" cfg.themeBright1Color,"")
				
				ui.dockBarD2HoldToCrouch 	:= ui.dockBarGui.addPicture("x+-2 ys+0 w32 h32 section background" cfg.ThemeButtonOnColor,"./img/button_crouch.png")	
				ui.dockBarWidth 		+= 30
				ui.dockBarD2HoldToCrouch.onEvent("click",d2AppHoldToCrouchKeyClicked)				
				ui.dockBarLoadouts		:= ui.dockBarGui.addPicture("x+-2 ys+0 w32 h32 section background" cfg.themeButtonOnColor,"./img/button_loadouts_ready.png")
				ui.dockBarWidth			+= 30
				ui.dockBarRunIcon 		:= ui.dockBarGui.addPicture("x+-2 ys+0 w28 h32 section background" cfg.themeDisabledColor, "./img/icon_running.png")
				ui.dockBarWidth 		+= 30
				ui.dockBarRunIcon.opt("Background" cfg.ThemeButtonOnColor)
				ui.dockBarD2AlwaysRun 	:= ui.dockBarGui.addPicture("x+0 ys+1 w22 h28 section " 
				((cfg.d2AlwaysRunEnabled) 
					? ("Background" cfg.ThemeButtonOnColor) 
						: ("Background" cfg.themeButtonReadyColor)),
				((cfg.d2AlwaysRunEnabled) 
					? ("./img/toggle_vertical_trans_on.png") 
						: ("./img/toggle_vertical_trans_off.png")))			
				ui.dockBarWidth 		+= 24
				ui.dockBarD2AlwaysRun.onEvent("click",d2ToggleAppFunctions)





				ui.dockBarAfkButton.onEvent("click",dockToggleAfk)
				ui.dockBarGui.addText("x+1 ys-1 w1 h33 section background" cfg.themeBright1Color,"")
				ui.dockBarWidth -= 2
				
		case "World//Zero":
				ui.dockBarAfkButton 	:= ui.dockBarGui.addPicture("x+0 ys w32 h33 section background" cfg.themeButtonReadyColor,ui.buttonStartAfk.value)
				ui.dockBarWidth 		+= 32
				ui.dockBarTowerButton	:= ui.dockBarGui.addPicture("x+0 ys w32 h33 section background" cfg.themeButtonReadyColor,ui.buttonTower.value)
				ui.dockBarWidth 		+= 32
				ui.dockBarGui.AddText("x+0 ys+0 w0 h32 background" cfg.themeBright1Color)
				((ui.towerEnabled) 
					? ("Background" cfg.ThemeButtonOnColor) 
						: ("Background" cfg.themeButtonReadyColor),
				((ui.towerEnabled) 
					? ("./img/toggle_vertical_trans_on.png") 
						: ("./img/toggle_vertical_trans_off.png")))
						
				ui.dockBarAfkButton.onEvent("click",dockToggleAfk)
				ui.dockBarTowerButton.onEvent("click",dockToggleTower)
				dockToggleAfk(*) {
					toggleAfk()
					controlFocus(ui.docktopDockButton)
				}
				dockToggleTower(*) {
					toggleTower()
					controlFocus(ui.dockBarTowerButton)
				}
			; case "Clear": 
				; ui.dockBarGui.destroy()
				; createDockBar()
		}
	}
}

showDockBar() {
	cfg.dockbarMonitor := iniRead(cfg.file,"Interface","DockbarMonitor",monitorGetPrimary())
	if cfg.dockBarMonitor > monitorGetCount() 
		cfg.dockBarMonitor := 1
	monitorGet(cfg.dockbarMonitor,&dockbarMonitorL,&dockbarMonitorT,&dockbarMonitorR,&dockbarMonitorB,)
	dockbarPosx := ((dockbarMonitorL + dockbarMonitorR)/2)-(ui.dockbarWidth/2)
	dockbarPosY := dockbarMonitorT
	if cfg.alwaysOnTopEnabled {
		ui.dockBarGui.opt("+alwaysOnTop")
	} else {
		ui.dockBarGui.opt("-alwaysOnTop")
	}
	ui.dockBarGui.show("x" dockbarPosx " y" dockbarPosY " w" ui.dockBarWidth " h34 noActivate")
	drawOutlineNamed("dockBarOutline2",ui.dockBarGui,1,0,ui.dockBarWidth,34,cfg.themeDark1Color,cfg.themeBright2Color,2)
	drawOutlineNamed("dockBarOutline",ui.dockBarGui,0,0,ui.dockBarWidth,35,cfg.themeBorderDarkColor,cfg.themeBorderDarkColor,2)
}


ui.topDocPrevTab	:= ""

toggleTopDock(*) {
		(cfg.topDockEnabled := !cfg.topDockEnabled)
			? topDockOn()
			: topDockOff()
}

fadeOut(*) {
	if (cfg.AnimationsEnabled) {
		ui.disableMouseClick := true
		activeTab := ui.mainGuiTabs.text
		transValue := 255
		switch activeTab {
			case "3_AFK":
				while (transValue > 20) {
					transValue -= 10
					;winSetTransparent(transValue,ui.titleBarButtonGui)
					winSetTransparent(transValue,ui.afkGui)
					winSetTransparent(transValue,ui.mainGui)
					sleep(10)
				}

				guiVis(ui.afkGui,false)
			case "1_GAME":
				while(transValue > 20) {
					transValue -= 10
					;winSetTransparent(transValue,ui.titleBarButtonGui)
					winSetTransparent(transValue,ui.mainGui)
					winSetTransparent(transValue,ui.gameSettingsGui)
					winSetTransparent(transValue,ui.gameTabGui)
					sleep(10)
				}
				guiVis(ui.gameSettingsGui,false)
				guiVis(ui.gameTabGui,false)
				
			default:
				while(transValue > 20) {
					transValue -= 10
					winSetTransparent(transValue,ui.mainGui)
					;winSetTransparent(transValue,ui.titleBarButtonGui)
					sleep(10)
				}
		}	
	}
	guiVis("all",false)
	ui.disableMouseClick := false

}

topDockOn(*) {
	createDockBar()
	cfg.topDockEnabled := true
	saveGuiPos()
	fadeOut()
	;guiVis(ui.titleBarButtonGui,false)
	; if cfg.AnimationsEnabled {
		; ui.disableMouseClick := true
		; transparent := 255
		; while transparent > 120 {
			; transparent -= 10
			; winSetTransparent(transparent,ui.mainGui)
			; winSetTransparent(transparent,ui.titleBarButtonGui)
			; if (tabGui)
				; winSetTransparent(min(transparent + 60,255),tabGui)
			; sleep(10)
		; }
		; ui.disableMouseClick := false
	; }
		
	; guiVis(ui.gameSettingsGui,false)
	; guiVis(ui.gameTabGui,false)
	; guiVis(ui.afkGui,false)
	
	; if cfg.AnimationsEnabled {
	
		; while transparent > 20 {
			; transparent -= 10
			; winSetTransparent(transparent,ui.mainGui)
			; sleep(10)
			; winSetTransparent(transparent,ui.titleBarButtonGui)
			; sleep(10)
		; }
		
	; }
	; guiVis(ui.mainGui,false)
	; guiVis(ui.titleBarButtonGui,false)
	showDockBar()
	
	try {	
		winGetPos(&vX,&vY,&vW,&vH,ui.mainGui)
		ui.prevGuiX := vX
		ui.prevGuiY := vY
		ui.prevGuiW := vW
		ui.prevGuiH := vH
	}
	transValue := 0
	if cfg.AnimationsEnabled {
		while transValue < 245 {
			transValue += 10
			winSetTransparent(transValue, ui.dockBarGui)
			sleep(10)
		}
	}
	ui.opsDockButton.opt("background" cfg.themeButtonOnColor)
		if (!ui.win1enabled && !ui.win2enabled) {
		ui.dockGameDDL.setFont("c" cfg.themeFont1Color,"calibri bold")
		ui.dockGameDDL.opt("background" cfg.themeEditboxColor)
		ui.dockGameDDL.redraw()
		controlFocus(ui.dockTopDockButton)
		} else {
		ui.dockGameDDL.setFont("c" cfg.themeFont3Color,"calibri bold")
		ui.dockGameDDL.opt("background" cfg.themePanel3Color)
		ui.dockGameDDL.redraw()
		controlFocus(ui.dockTopDockButton)
		}
	guiVis(ui.dockBarGui,true)	
}
;MsgBox("4: " cfg.guix "`n" cfg.guiy)
topDockOff(*) {
	cfg.topDockEnabled := false
		tabGui := ""
	switch ui.mainGUiTabs.text {
		case "1_GAME":
			tabGui := ui.gameSettingsGui
		case "3_AFK":
			tabGui := ui.afkGui
		default:
			tabGui := ""
	}
	
	;guiVis(ui.titleBarButtonGui,false)
	transparent := 255
	if (cfg.AnimationsEnabled) {
		while transparent > 10 {
			transparent -= 10
			winSetTransparent(transparent,ui.dockBarGui)
			sleep(10)

		}
	}
	guiVis(ui.dockBarGui,false)
	guiVis(ui.mainGui,false)
	;guiVis(ui.titleBarButtonGui,false)
	guiVis(ui.afkGui,false)
	guiVis(ui.gameSettingsGui,false)
	guiVis(ui.gameTabGui,false)
	if (cfg.animationsEnabled) {
		fadeIn()
	}
	;guiVis(ui.titleBarButtonGui,false)
	guiVis(ui.mainGui,true)
	tabsChanged()
	; winSetTransparent(0,ui.mainGui)
	; if (cfg.AnimationsEnabled) {
		; while transparent < 245 {
			; transparent += 10
			; winSetTransparent(transparent, ui.mainGui)
			; winSetTransparent(transparent, ui.titleBarButtonGui)
			; sleep(10)
		; }
	; }
	; guiVis(ui.mainGui,true)
	try {
		ui.mainGuiTabs.choose(ui.topDockPrevTab)
	}
	;guivis(ui.titleBarbuttonGui,true)
	try {
		ui.opsDockButton.opt("background" cfg.themeButtonReadyColor)
	}
}
d2KeybindGameTabClicked()
d2KeybindAppTabClicked()