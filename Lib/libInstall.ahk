#SingleInstance
#Requires AutoHotKey v2.0+
#Warn All, Off

if (InStr(A_LineFile,A_ScriptFullPath)){
	Run(A_ScriptDir "/../d2app.ahk")
	ExitApp
	Return
}

preAutoExec(InstallDir,ConfigFileName) {
	Global
	data			:= object()
	cfg				:= object()
	ui 				:= object()
	afk				:= object()
	this			:= object()
	setting 		:= object()
	result 			:= object()
	libVaultInit()
	
	if (A_IsCompiled)
	{
		if StrCompare(A_ScriptDir,InstallDir)
  		{
			createPbConsole("d2app Install")
			pbConsole("Running standalone executable, attempting to install")
			installLog("Running standalone executable, attempting to auto-install")
			if !(DirExist(InstallDir))
			{
				pbConsole("Attempting to create install folder")
				installLog("Attempting to create install folder")
				try
				{
					DirCreate(InstallDir)
					SetWorkingDir(InstallDir)
				} catch {
					installLog("Couldn't create install location")
					sleep(1500)
					pbConsole("Cannot Create Folder at the Install Location.")
					pbConsole("Suspect permissions issue with the desired install location")
					pbConsole("`n`nTERMINATING")
					sleep(4000)
					ExitApp
				}
				pbConsole("Successfully created install location at " InstallDir)
				installLog("Successfully created install location at " InstallDir)
				sleep(1000)
			}
			pbConsole("Copying executable to install location")
			installLog("Copying executable to install location")
			sleep(1000)
			try{
				FileCopy(A_ScriptFullPath, InstallDir "/" A_AppName ".exe", true)
			}

			if (FileExist(InstallDir "/d2app.ini"))
			{
				msgBoxResult := MsgBox("Previous install detected. `nAttempt to preserve your existing settings?",, "Y/N T300")
				
				switch msgBoxResult {
					case "No": 
					{
						sleep(1000)
						pbConsole("`nReplacing existing configuration files with updated and clean files")
						FileInstall("./d2app.ini",InstallDir "/d2app.ini",1)
						FileInstall("./d2app.themes",InstallDir "/d2app.themes",1)
						FileInstall("./AfkData.csv",InstallDir "/AfkData.csv",1)
						fileInstall("./d2app.db",installDir "/d2app.db",1)
					} 
					case "Yes": 
					{
						cfg.ThemeFont1Color := "00FFFF"
						sleep(1000)
						pbConsole("`nPreserving existing configuration may cause issues.")
						pbConsole("If you encounter issues,try installing again, choosing NO.")
						if !(FileExist(InstallDir "/AfkData.csv"))
							FileInstall("./AfkData.csv",InstallDir "/AfkData.csv",1)
						if !(FileExist(InstallDir "/d2app.themes"))
							FileInstall("./d2app.themes",InstallDir "/d2app.themes",1)
						if !(fileExist(installDir "/d2app.db"))
							fileInstall("./d2app.db",installDir "/d2app.db",1)
					}
					case "Timeout":
					{
						setTimer () => pbNotify("Timed out waiting for your response.`Attempting to update using your exiting config files.`nIf you encounter issues, re-run the install `nselecting the option to replace your existing files.",5000),-100
						if !fileExist("./d2app.ini")
							fileInstall("./d2app.ini",installDir "/d2app.ini")
						if !(FileExist(InstallDir "/AfkData.csv"))
							FileInstall("./AfkData.csv",InstallDir "/AfkData.csv",1)
						if !(FileExist(InstallDir "/d2app.themes"))
							FileInstall("./d2app.themes",InstallDir "/d2app.themes",1)
						if !(fileExist(installDir "/d2app.db"))
							fileInstall("./d2app.db",installDir "/d2app.db",1)	
					}
				}
			} else {
				sleep(1000)
				pbConsole("This seems to be the first time you're running d2app.")
				pbConsole("A fresh install to " A_MyDocuments "\d2app is being performed.")

				FileInstall("./d2app.ini",InstallDir "/d2app.ini",1)
				FileInstall("./d2app.themes",InstallDir "/d2app.themes",1)
				FileInstall("./AfkData.csv",InstallDir "/AfkData.csv",1)
				fileInstall("./d2app.db",installDir "/d2app.db",1)

			}
			if !(DirExist(InstallDir "\lib"))
			{
				DirCreate(InstallDir "\lib")
			}			
			if !(DirExist(InstallDir "\Img"))
			{
				DirCreate(InstallDir "\Img")
			}
			if !(DirExist(InstallDir "\Img2"))
			{
				DirCreate(InstallDir "\Img2")
			}
			if !(DirExist(InstallDir "\Img2\infogfx"))
			{
				DirCreate(InstallDir "\Img2\infogfx")
			}
			if !(DirExist(InstallDir "\Img2\infogfx\vod"))
			{
				DirCreate(InstallDir "\Img2\infogfx\vod")
			}
			if !(DirExist(InstallDir "\Redist"))
			{
				DirCreate(InstallDir "\Redist")
			}
			installLog("Created Img folder")
			
			if !dirExist(installDir "/img/infogfx")
				dirCreate(installDir "/img/infogfx")
			
			if !dirExist(installDir "/img/infogfx/vod")
				dirCreate(installDir "/img/infogfx/vod")

			if !dirExist(installDir "/redist/mouseSC")
				dirCreate(installDir "/redist/mouseSC")
			
			fileInstall("./redist/mouseSC_x64.exe",installDir "/redist/mouseSC_x64.exe",1)
			FileInstall("./Img/keyboard_key_up.png",InstallDir "/img/keyboard_key_up.png",1)
			FileInstall("./Img/keyboard_key_down.png",InstallDir "/img/keyboard_key_down.png",1)
			FileInstall("./Img/attack_icon.png",InstallDir "/Img/attack_icon.png",true)
			FileInstall("./Img/sleep_icon.png",InstallDir "/Img/sleep_icon.png",true)
			FileInstall("./Img/arrow_left.png",InstallDir "/Img/arrow_left.png",true)
			FileInstall("./Img/arrow_right.png",InstallDir "/Img/arrow_right.png",true)
			FileInstall("./Img/status_stopped.png",InstallDir "/Img/status_stopped.png",true)
			FileInstall("./Img/status_running.png",InstallDir "/Img/status_running.png",true)
			FileInstall("./Img/label_left_trim.png",InstallDir "/Img/label_left_trim.png",true)
			FileInstall("./Img/label_right_trim.png",InstallDir "/Img/label_right_trim.png",true)
			FileInstall("./Img/label_timer_off.png",InstallDir "/Img/label_timer_off.png",true)
			FileInstall("./Img/label_anti_idle_timer.png",InstallDir "/Img/label_anti_idle_timer.png",true)
			FileInstall("./Img/label_infinite_tower.png",InstallDir "/Img/label_infinite_tower.png",true)
			FileInstall("./Img/label_celestial_tower.png",InstallDir "/Img/label_celestial_tower.png",true)			
			FileInstall("./Img/color_swatches.png",InstallDir "/Img/color_swatches.png",1)
			FileInstall("./Img/towerToggle_celestial.png",InstallDir "/Img/towerToggle_celestial.png",1)
			FileInstall("./Img/towerToggle_infinite.png",InstallDir "/Img/towerToggle_infinite.png",1)
			FileInstall("./Img/toggle_off.png",InstallDir "/Img/toggle_off.png",1)
			FileInstall("./Img/toggle_on.png",InstallDir "/Img/toggle_on.png",1)
			FileInstall("./Img/toggle_left.png",InstallDir "/Img/toggle_left.png",1)
			FileInstall("./Img/toggle_right.png",InstallDir "/Img/toggle_right.png",1)
			fileInstall("./img/toggle_vertical_trans_on.png",installDir "/img/toggle_vertical_trans_on.png",1)
			fileInstall("./img/toggle_vertical_trans_off.png",installDir "/img/toggle_vertical_trans_off.png",1)
			FileInstall("./Img/button_update.png",InstallDir "/img/button_update.png",1)
			FileInstall("./Img/button_exit_gaming.png",InstallDir "/img/button_exit_gaming.png",1)
			FileInstall("./Img/button_execute.png",InstallDir "/Img/button_execute.png",true)
			FileInstall("./Img/button_ready.png",InstallDir "/Img/button_ready.png",1)
			FileInstall("./Img/button_on.png",InstallDir "/Img/button_on.png",1)
			FileInstall("./Img/button_plus.png",InstallDir "/Img/button_plus.png",1)
			FileInstall("./Img/button_power.png",InstallDir "/Img/button_power.png",1)
			FileInstall("./Img/button_minus.png",InstallDir "/Img/button_minus.png",1)
			FileInstall("./Img/button_x.png",InstallDir "/Img/button_x.png",1)
			FileInstall("./Img/button_x2.png",InstallDir "/Img/button_x2.png",1)
			FileInstall("./Img/button_change.png",InstallDir "/Img/button_change.png",1)
			FileInstall("./Img/button_select.png",InstallDir "/Img/button_select.png",1)
			FileInstall("./Img/button_set.png",InstallDir "/Img/button_set.png",1)
			FileInstall("./Img/button_add.png",InstallDir "/Img/button_add.png",1)
			FileInstall("./Img/button_remove.png",InstallDir "/Img/button_remove.png",1)
			FileInstall("./Img/button_popout_ready.png",InstallDir "/Img/button_popout_ready.png",1)
			FileInstall("./Img/button_popout_on.png",InstallDir "/Img/button_popout_on.png",1)
			FileInstall("./Img/button_refresh.png",InstallDir "/Img/button_refresh.png",1)
			FileInstall("./Img/button_hide.png",InstallDir "/Img/button_hide.png",1)
			FileInstall("./Img/button_autoFire1_on.png",InstallDir "/Img/button_autoFire1_on.png",1)
			FileInstall("./Img/button_autoFire1_ready.png",InstallDir "/Img/button_autoFire1_ready.png",1)
			FileInstall("./Img/button_autoFire2_on.png",InstallDir "/Img/button_autoFire2_on.png",1)
			FileInstall("./Img/button_autoFire2_ready.png",InstallDir "/Img/button_autoFire2_ready.png",1)			
			FileInstall("./Img/button_autoFire1_disabled.png",InstallDir "/Img/button_autoFire1_disabled.png",1)			
			FileInstall("./Img/button_autoFire2_disabled.png",InstallDir "/Img/button_autoFire2_disabled.png",1)
			FileInstall("./Img/button_swapHwnd.png",InstallDir "/Img/button_swapHwnd.png",1)
			FileInstall("./Img/button_autoFire_ready.png",InstallDir "/Img/button_autoFire_ready.png",1)
			FileInstall("./Img/button_autoFire1_on.png",InstallDir "/Img/button_autoFire1_on.png",1)
			FileInstall("./Img/button_autoFire2_on.png",InstallDir "/Img/button_autoFire2_on.png",1)
			FileInstall("./Img/button_autoClicker_ready.png",InstallDir "/Img/button_autoClicker_ready.png",1)
			FileInstall("./Img/button_swapHwnd_enabled.png",InstallDir "/Img/button_swapHwnd_enabled.png",1)
			FileInstall("./Img/button_swapHwnd_disabled.png",InstallDir "/Img/button_swapHwnd_disabled.png",1)
			FileInstall("./Img/button_autoClicker_on.png",InstallDir "/Img/button_autoClicker_on.png",1)
			FileInstall("./Img/button_quit.png",InstallDir "/Img/button_quit.png",true)
			FileInstall("./Img/button_minimize.png",InstallDir "/Img/button_minimize.png",true)
			FileInstall("./Img/button_tower.png",InstallDir "/Img/button_tower.png",true)
			FileInstall("./Img/button_afk.png",InstallDir "/Img/button_afk.png",true)
			FileInstall("./Img/button_antiIdle.png",InstallDir "/Img/button_antiIdle.png",true)
			FileInstall("./Img/button_tower_ready.png",InstallDir "/Img/button_tower_ready.png",true)
			FileInstall("./Img/button_tower_on.png",InstallDir "/Img/button_tower_on.png",true)
			FileInstall("./Img/button_dockright.png",InstallDir "/Img/button_dockright.png",true)
			FileInstall("./Img/button_afk_on.png",InstallDir "/Img/button_afk_on.png",true)
			FileInstall("./Img/button_antiIdle_ready.png",InstallDir "/Img/button_antiIdle_ready.png",true)
			FileInstall("./Img/button_antiIdle_on.png",InstallDir "/Img/button_antiIdle_on.png",true)
			FileInstall("./Img/button_plus_ready.png",InstallDir "/Img/button_plus_ready.png",true)
			FileInstall("./Img/button_plus_on.png",InstallDir "/Img/button_plus_on.png",true)
			FileInstall("./Img/button_minus_ready.png",InstallDir "/Img/button_minus_ready.png",true)
			FileInstall("./Img/button_minus_on.png",InstallDir "/Img/button_minus_on.png",true)
			FileInstall("./Img/button_OpsDock.png",InstallDir "/Img/button_OpsDock.png",true)
			FileInstall("./Img/button_launchLightGG.png",InstallDir "/Img/button_launchLightGG.png",1)
			FileInstall("./Img/button_launchLightGG_down.png",InstallDir "/Img/button_launchLightGG_down.png",1)
			FileInstall("./Img/button_launchDIM.png",InstallDir "/Img/button_launchDIM.png",1)
			FileInstall("./Img/button_launchDIM_down.png",InstallDir "/Img/button_launchDIM_down.png",1)
			FileInstall("./Img/button_launchBlueberries.png",InstallDir "/Img/button_launchBlueberries.png",1)
			FileInstall("./Img/button_launchBlueberries_down.png",InstallDir "/Img/button_launchBlueBerries_down.png",1)
			fileInstall("./img/button_dockDown_on.png",installDir "/img/button_dockDown_on.png",1)
			fileInstall("./img/button_dockUp_on.png",installDir "/img/button_dockUp_on.png",1)
			FileInstall("./Img/button_dockleft_on.png",InstallDir "/Img/button_dockleft_on.png",1)
			FileInstall("./Img/button_dockright_on.png",InstallDir "/Img/button_dockright_on.png",1)			
			fileInstall("./img/button_dockDown_ready.png",installDir "/img/button_dockDown_ready.png",1)
			fileInstall("./img/button_dockUp_ready.png",installDir "/img/button_dockUp_ready.png",1)
			FileInstall("./Img/button_dockleft_ready.png",InstallDir "/Img/button_dockleft_ready.png",1)
			FileInstall("./Img/button_dockright_ready.png",InstallDir "/Img/button_dockright_ready.png",1)
			FileInstall("./Img/button_dockleft.png",InstallDir "/Img/button_dockleft.png",1)
			FileInstall("./Img/button_dockright.png",InstallDir "/Img/button_dockright.png",1)
			FileInstall("./Img/button_power.png",InstallDir "/Img/button_power.png",1)
			FileInstall("./Img/button_power_on.png",InstallDir "/Img/button_power_on.png",1)
			FileInstall("./Img/button_power_ready.png",InstallDir "/Img/button_power_ready.png",1)
			FileInstall("./Img/button_save_up.png",InstallDir "/Img/button_save_up.png",1)
			FileInstall("./Img/button_up.png",InstallDir "/Img/button_up.png",1)
			FileInstall("./Img/button_down.png",InstallDir "/Img/button_down.png",1)
			FileInstall("./Img/button_help.png",InstallDir "/Img/button_help.png",1)
			FileInstall("./Img/button_help_ready.png",InstallDir "/Img/button_help_ready.png",1)
			FileInstall("./Img/button_help_on.png",InstallDir "/Img/button_help_on.png",1)			
			FileInstall("./Img/button_console_ready.png",InstallDir "/Img/button_console_ready.png",1)
			FileInstall("./Img/button_console_on.png",InstallDir "/Img/button_console_on.png",1)
			fileInstall("./img/icon_running.png",installDir "/img/icon_running.png",1)
			fileInstall("./img/icon_DIM.png",installDir "/img/icon_dim.png",1)
			fileInstall("./img/icon_blueberries.png",installDir "/img/icon_blueberries.png",1)
			fileInstall("./img/button_vault_up.png",installDir "/img/button_vault_up.png",1)
			fileInstall("./img/button_vault_down.png",installDir "/img/button_vault_down.png",1)
			fileInstall("./img/icon_d2Checklist.png",installDir "/img/icon_d2Checklist.png",1)
			fileInstall("./img/icon_brayTech.png",installDir "/img/icon_brayTech.png",1)
			fileInstall("./img/icon_steeringwheel.png",installDir "/img/icon_steeringwheel.png",1)		
			FileInstall("./Img/keyboard_key_up.png",InstallDir "/img/keyboard_key_up.png",1)
			FileInstall("./Img/keyboard_key_down.png",InstallDir "/img/keyboard_key_down.png",1)
			fileInstall("./redist/Discord.exe",installDir "/redist/Discord.exe",1)
			fileInstall("./redist/getNir.exe",installDir "/redist/getNir.exe",1)
			fileInstall("./redist/soundVolumeView.exe",installDir "/redist/soundVolumeView.exe",1)
			fileInstall("./redist/sqlite3.dll",installDir "/redist/sqlite3.dll",1)
			fileInstall("./redist/incursionAudio.mp3",installDir "/redist/incursionAudio.mp3",1)
			FileInstall("./lib/ColorChooser.exe",InstallDir "/lib/ColorChooser.exe",1)
			FileInstall("./Redist/nircmd.exe",InstallDir "/Redist/nircmd.exe",1)
			FileInstall("./d2app_updater.exe",InstallDir "/d2app_updater.exe",1)
			FileInstall("./Img/help.png",InstallDir "/Img/help.png",1)
			FileInstall("./d2app_currentBuild.dat",InstallDir "/d2app_currentBuild.dat",1)			
			FileInstall("./img/button_afk_ready.png",InstallDir "/img/button_afk_ready.png",true)
			fileInstall("./img/button_countdown.png",installDir "/img/button_countdown.png",1)
			fileInstall("./img/button_dockLeftRight.png",installDir "/img/button_dockLeftRight.png",1)
			fileInstall("./img/button_loadouts_ready.png",installDir "/img/button_loadouts_ready.png",1)
			fileInstall("./img/button_keyBindTarget.png",installDir "/img/button_keybindTarget.png",1)
			fileInstall("./img/button_dock_up.png",installDir "/img/button_dock_up.png",1)
			fileInstall("./img/button_power.png",installDir "/img/button_power.png",1)
			fileInstall("./img/button_power_down.png",installDir "/img/button_power_down.png",1)
			fileInstall("./img/button_quit.png",installDir "/img/button_quit.png",1)
			fileInstall("./img/button_crouch.png",installDir "/img/button_crouch.png",1)
			fileInstall("./img/checkbox_true.png",installDir "/img/checkbox_true.png",1)
			fileInstall("./img/checkbox_false.png",installDir "/img/checkbox_false.png",1)
			fileInstall("./img/d2_button_d2Foundry.png",installDir "/img/d2_button_d2Foundry.png",1)
			fileInstall("./img/d2_button_d2Foundry_down.png",installDir "/img/d2_button_d2Foundry_down.png",1)
			fileInstall("./img/d2_button_brayTech.png",installDir "/img/d2_button_brayTech.png",1)
			fileInstall("./img/d2_button_brayTech_down.png",installDir "/img/d2_button_brayTech_down.png",1)
			fileInstall("./img/d2_button_DestinyTracker.png",installDir "/img/d2_button_DestinyTracker.png",1)
			fileInstall("./img/d2_button_DestinyTracker_down.png",installDir "/img/d2_button_DestinyTracker_down.png",1)
			fileInstall("./img/d2_button_dim.png",installDir "/img/d2_button_dim.png",1)
			fileInstall("./img/d2_button_dim_down.png",installDir "/img/d2_button_dim_down.png",1)
			fileInstall("./img/d2_button_bbgg.png",installDir "/img/d2_button_bbgg.png",1)
			fileInstall("./img/d2_button_bbgg_down.png",installDir "/img/d2_button_bbgg_down.png",1)
			fileInstall("./img/button_vault_up.png",installDir "/img/button_vault_up.png",1)
			fileInstall("./img/button_vault_down.png",installDir "/img/button_vault_down.png",1)
			fileInstall("./img/d2_button_d2Checklist.png",installDir "/img/d2_button_d2Checklist.png",1)
			fileInstall("./img/d2_button_d2Checklist_down.png",installDir "/img/d2_button_d2Checklist_down.png",1)
			fileInstall("./img/d2ClassIconWarlock_on.png",installDir "/img/d2ClassIconWarlock_on.png",1)
			fileInstall("./img/d2ClassIconHunter_on.png",installDir "/img/d2ClassIconHunter_on.png",1)
			fileInstall("./img/d2ClassIconTitan_on.png",installDir "/img/d2ClassIconTitan_on.png",1)
			fileInstall("./img/d2ClassIconWarlock_off.png",installDir "/img/d2ClassIconWarlock_off.png",1)
			fileInstall("./img/d2ClassIconHunter_off.png",installDir "/img/d2ClassIconHunter_off.png",1)
			fileInstall("./img/d2ClassIconTitan_off.png",installDir "/img/d2ClassIconTitan_off.png",1)
			fileInstall("./img/d2CodeMorgeth.png",installDir "/img/d2CodeMorgeth.png",1)		
			fileInstall("./img/infogfx/vod/activate.png", installDir "/img/infogfx/vod/activate.png",1)
			fileInstall("./img/infogfx/vod/ascendant.png", installDir "/img/infogfx/vod/ascendant.png",1)
			fileInstall("./img/infogfx/vod/black_garden.png", installDir "/img/infogfx/vod/black_garden.png",1)
			fileInstall("./img/infogfx/vod/black_heart.png", installDir "/img/infogfx/vod/black_heart.png",1)
			fileInstall("./img/infogfx/vod/darkness.png", installDir "/img/infogfx/vod/darkness.png",1)
			fileInstall("./img/infogfx/vod/drink.png", installDir "/img/infogfx/vod/drink.png",1)
			fileInstall("./img/infogfx/vod/earth.png", installDir "/img/infogfx/vod/earth.png",1)
			fileInstall("./img/infogfx/vod/enter.png", installDir "/img/infogfx/vod/enter.png",1)
			fileInstall("./img/infogfx/vod/grieve.png", installDir "/img/infogfx/vod/grieve.png",1)
			fileInstall("./img/infogfx/vod/guardian.png", installDir "/img/infogfx/vod/guardian.png",1)
			fileInstall("./img/infogfx/vod/hive.png", installDir "/img/infogfx/vod/hive.png",1)
			fileInstall("./img/infogfx/vod/kill.png", installDir "/img/infogfx/vod/kill.png",1)
			fileInstall("./img/infogfx/vod/light.png", installDir "/img/infogfx/vod/light.png",1)
			fileInstall("./img/infogfx/vod/love.png", installDir "/img/infogfx/vod/love.png",1)
			fileInstall("./img/infogfx/vod/pyramid.png", installDir "/img/infogfx/vod/pyramid.png",1)
			fileInstall("./img/infogfx/vod/redacted.png", installDir "/img/infogfx/vod/redacted.png",1)
			fileInstall("./img/infogfx/vod/remember.png", installDir "/img/infogfx/vod/remember.png",1)
			fileInstall("./img/infogfx/vod/savathun.png", installDir "/img/infogfx/vod/savathun.png",1)
			fileInstall("./img/infogfx/vod/scorn.png", installDir "/img/infogfx/vod/scorn.png",1)
			fileInstall("./img/infogfx/vod/stop.png", installDir "/img/infogfx/vod/stop.png",1)
			fileInstall("./img/infogfx/vod/tower.png", installDir "/img/infogfx/vod/tower.png",1)
			fileInstall("./img/infogfx/vod/traveler.png", installDir "/img/infogfx/vod/traveler.png",1)
			fileInstall("./img/infogfx/vod/witness.png", installDir "/img/infogfx/vod/witness.png",1)
			fileInstall("./img/infogfx/vod/worm.png", installDir "/img/infogfx/vod/worm.png",1)
			fileInstall("./img/infogfx/vod/worship.png", installDir "/img/infogfx/vod/worship.png",1)
			fileInstall("./img/tab_selected.png", installDir "/img/tab_selected.png",1)
			fileInstall("./img/tab_unselected.png", installDir "/img/tab_unselected.png",1)
			fileInstall("./img/attack_icon.ico",installDir "/img/attack_icon.ico",1)
			fileInstall("./img/handlebar_vertical.png",installDir "/img/handlebar_vertical.png",true)
			fileInstall("./img/right_handlebar_vertical.png",installDir "/img/right_handlebar_vertical.png",true)
			pbConsole("`nINSTALL COMPLETED SUCCESSFULLY!")
			installLog("Copied Assets to: " InstallDir)		
			fileCreateShortcut(installDir "/d2app.exe", A_Desktop "\d2app.lnk",installDir,,"d2app Gaming Assistant",installDir "/img/attack_icon.ico")
			fileCreateShortcut(installDir "/d2app.exe", A_StartMenu "\Programs\d2app.lnk",installDir,,"d2app Gaming Assistant",installDir "/img/attack_icon.ico")
			IniWrite(installDir,installDir "/d2app.ini","System","InstallDir")
			Run(InstallDir "\" A_AppName ".exe")
			sleep(4500)
			ExitApp
		}
	}
}

createPbConsole(title) {
	transColor := "010203"
	ui.pbConsoleBg := gui()
	ui.pbConsoleBg.backColor := "304030"
	ui.pbConsoleHandle := ui.pbConsoleBg.addPicture("w700 h400 background203020","")
	ui.pbConsoleBg.show("w700 h400 noActivate")
	winSetTransparent(160,ui.pbConsoleBg)
	ui.pbConsole := gui()
	ui.pbConsole.opt("-caption AlwaysOnTop")
	ui.pbConsole.backColor := transColor
	ui.pbConsole.color := transColor
	winSetTransColor(transColor,ui.pbConsole)
	ui.pbConsoleTitle := ui.pbConsole.addText("x8 y4 w700 h35 section center background303530 c859585",title)
	ui.pbConsoleTitle.setFont("s20","Verdana Bold")
	drawOutlineNamed("pbConsoleTitle",ui.pbConsole,6,4,692,35,"253525","202520",2)
	ui.pbConsoleData := ui.pbConsole.addText("xs+10 w680 h380 backgroundTrans cA5C5A5","")
	ui.pbConsoleData.setFont("s16")
	drawOutlineNamed("pbConsoleOutside",ui.pbConsole,2,2,698,398,"355535","355535",2)
	drawOutlineNamed("pbConsoleOutside2",ui.pbConsole,3,3,696,396,"457745","457745",1)
	drawOutlineNamed("pbConsoleOutside3",ui.pbConsole,4,4,694,394,"353535","353535",2)
	ui.pbConsole.show("w700 h400 noActivate")
	ui.pbConsoleBg.opt("-caption owner" ui.pbConsole.hwnd)
}

hidePbConsole(*) {
	guiVis(ui.pbConsole,false)
	guiVis(ui.pbConsoleBg,false)
}

showPbConsole(*) {
	guiVis(ui.pbConsole,false)
	guiVis(ui.pbConsoleBg,false)
}
pbConsole(msg) {
	if !hasProp(ui,"pbConsole")
		createPbConsole("d2app Console")
	ui.pbConsoleData.text := msg "`n" ui.pbConsoleData.text
}

testPbConsole() {
	createPbConsole("Test Console")
	loop 40 {
		pbConsole("This is test console message #" a_index)
		sleep(1500)
	}
	ui.pbConsole.destroy()
}

pbNotify(NotifyMsg,Duration := 10,YN := "",confirmCustomScript:="notifyConfirm",cancelCustomScript:="notifyCancel") {
	Transparent := 250
	ui.notifyGui			:= Gui()
	ui.notifyGui.Title 		:= "Notify"

	ui.notifyGui.Opt("+AlwaysOnTop -Caption +ToolWindow")  ; +ToolWindow avoids a taskbar button and an alt-tab menu item.
	ui.notifyGui.BackColor := "353535" ; Can be any RGB color (it will be made transparent below).
	ui.notifyGui.SetFont("s16")  ; Set a large font size (32-point).
	ui.notifyGui.AddText("c00FFFF center BackgroundTrans",NotifyMsg)  ; XX & YY serve to 00auto-size the window.
	ui.notifyGui.AddText("xs hidden")
	
	if (YN) {
		ui.notifyGui.AddText("xs hidden")
		ui.notifyGui.SetFont("s10")
		ui.notifyYesButton := ui.notifyGui.AddButton("ys section w60 h25","Proceed")
		ui.notifyYesButton.OnEvent("Click",%confirmCustomScript%)
		ui.notifyNoButton := ui.notifyGui.AddButton("xs w60 h25","Cancel")
		ui.notifyNoButton.OnEvent("Click",%cancelCustomScript%)
	}
	
	ui.notifyGui.Show("AutoSize")
	winGetPos(&x,&y,&w,&h,ui.notifyGui.hwnd)
	drawOutline(ui.notifyGui,0,0,w,h,"202020","808080",3)
	drawOutline(ui.notifyGui,5,5,w-10,h-10,"BBBBBB","DDDDDD",2)
	canProceed:=""
	timeout:=0
	if (YN) {
		while timeout < 90 && ui.waitingForPrompt {
				timeout+=1
				sleep(500)
		}
		ui.waitingForPrompt:=true
		if timeout > 89 {
			notifyOSD("Timed out waiting for response. Cancelling")
			setTimer () => (fadeOSD()),-1
			Exit
		} else {
			if !ui.notifyResponse {
				setTimer () => (fadeOSD()),-1
				
				exit
			} else {
				setTimer () => (sleep(duration),fadeOSD()),-1
			}
				
		} 
		timeout:=0
	} else
			setTimer () => (sleep(duration),fadeOSD()),duration
} 

pbWaitOSD() {
	ui.notifyGui.destroy()
	pbNotify("Timed out waiting for response.`nPlease try your action again",-1000)
}

FileFound(fileName,destination,fileDescription) {
	source := fileName
	dest := destination
	PreserveData := pbNotify('
	(
	' fileName ' - (' fileDescription ')
	from previous installation found. 
	Would you like to preserve it?
	)'
	,,1)
	
	if !(PreserveData) {
		MsgBox("FileInstall('" source "','" dest "',1)")
	} else {
		pbNotify('
		(
			If you encounter any issues with your saved data
			please re-run this install and answer "No" when
			asked if you would like to preserve the file.
		)'
		,3000)
	}
}
			
installLog(LogMsg) {
 	if !(DirExist(InstallDir "\Logs"))
	{
		DirCreate(InstallDir "\Logs")
		FileAppend(A_YYYY A_MM A_DD " [" A_Hour ":" A_Min ":" A_Sec "] Created Logs Folder`n",InstallDir "/Logs/persist.log")
	}

	FileAppend(A_YYYY A_MM A_DD " [" A_Hour ":" A_Min ":" A_Sec "] " LogMsg "`n",InstallDir "/Logs/persist.log")
}

bail(*) {
	return
}
	
autoUpdate() {		
	runWait("cmd /C start /b /wait ping -n 1 8.8.8.8 > " a_scriptDir "/.tmp",,"Hide")
	if !inStr(fileRead(a_scriptDir "/.tmp"),"100% loss") {
		checkForUpdates(0)
	} else {
		setTimer () => pbNotify("Network Down. Bypassing Auto-Update.",1000),-100
	}
	try
	if fileExist("./.tmp")
		fileDelete("./.tmp")
}	

CheckForUpdates(msg,*) {
	;winSetAlwaysOnTop(0,ui.mainGui.hwnd)
	ui.installedVersion := fileRead("./d2app_currentBuild.dat")
	ui.installedVersionText.text := "Installed:`t" substr(ui.installedVersion,1,1) "." substr(ui.installedVersion,2,1) "." substr(ui.installedVersion,3,1) "." substr(ui.installedVersion,4,1)
	ui.installedVersionText.redraw()
	try {
		whr := ComObject("WinHttp.WinHttpRequest.5.1")
		whr.Open("GET", "https://raw.githubusercontent.com/obcache/d2app/main/d2app_currentBuild.dat", true)
			whr.Send()
			whr.WaitForResponse()
			ui.latestVersion := whr.ResponseText
			ui.latestVersionText.text := "Available:`t" substr(ui.latestVersion,1,1) "." substr(ui.latestVersion,2,1) "." substr(ui.latestVersion,3,1) "." substr(ui.latestVersion,4,1)
	} catch {
			if(msg != 0) {
				ui.latestVersionText.text := "Available:`t--No Network--"
				notifyOSD("Network down.`nTry again later.",3000)
			ui.latestVersion := ui.installedVersion
		}
	}

	if (ui.installedVersion < ui.latestVersion) {
		try {
			winSetAlwaysOnTop(0,"ahk_id ui.mainGui.hwnd")
		} 
		try {
			winSetAlwaysOnTop(0,"ahk_id ui.titleBarButtonGui.hwnd")
		} 
		try {
			winSetAlwaysOnTop(0,"ahk_id ui.afkGui.hwnd")
		} 
		try {
			winSetAlwaysOnTop(0,"ahk_id ui.gameSettingsGui.hwnd")
		} 
		try {
			winSetAlwaysOnTop(0,"ahk_id ui.gameTabGui.hwnd")
		} 
		sleep(1500)
		runWait("./d2app_updater.exe")
	} else {
		if(msg != 0) {
			ui.latestVersionText.text := "Available:`t" substr(ui.latestVersion,1,1) "." substr(ui.latestVersion,2,1) "." substr(ui.latestVersion,3,1) "." substr(ui.latestVersion,4,1)
			notifyOSD("No upgraded needed.`nInstalled: " substr(ui.installedVersion,1,1) "." substr(ui.installedVersion,2,1) "." substr(ui.installedVersion,3,1) "." substr(ui.installedVersion,4,1) "`nAvailable: " substr(ui.latestVersion,1,1) "." substr(ui.latestVersion,2,1) "." substr(ui.latestVersion,3,1) "." substr(ui.latestVersion,4,1),2500)
		}
	}
	
}
