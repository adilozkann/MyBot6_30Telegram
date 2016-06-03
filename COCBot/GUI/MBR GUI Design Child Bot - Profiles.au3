; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file Includes GUI Design
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Global $txtPresetSaveFilename, $txtSavePresetMessage, $lblLoadPresetMessage,$btnGUIPresetDeleteConf, $chkCheckDeleteConf
Global $cmbPresetList, $txtPresetMessage,$btnGUIPresetLoadConf,  $lblLoadPresetMessage,$btnGUIPresetDeleteConf, $chkCheckDeleteConf

$hGUI_Profiles = GUICreate("", $_GUI_MAIN_WIDTH - 28, $_GUI_MAIN_HEIGHT - 255 - 28, 5, 25, BitOR($WS_CHILD, $WS_TABSTOP), -1, $hGUI_BOT)
;GUISetBkColor($COLOR_WHITE, $hGUI_Profiles)

GUISwitch($hGUI_Profiles)

Local $x = 20, $y = 25
	$grpProfiles = GUICtrlCreateGroup(GetTranslated(637,1, "Switch Profiles"), $x - 20, $y - 20, 440, 85)
		;$y -= 5
		$x -= 5
		;$lblProfile = GUICtrlCreateLabel(GetTranslated(7,27, "Current Profile") & ":", $x, $y, -1, -1)
		;$y += 15
		$cmbProfile = GUICtrlCreateCombo("", $x - 3, $y + 1, 130, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$txtTip = GetTranslated(637,2, "Use this to switch to a different profile")& @CRLF & GetTranslated(637,3, "Your profiles can be found in") & ": " & @CRLF & $sProfilePath
			GUICtrlSetTip(-1, $txtTip)
			setupProfileComboBox()
			PopulatePresetComboBox()
			GUICtrlSetState(-1, $GUI_SHOW)
			GUICtrlSetOnEvent(-1, "cmbProfile")
		$txtVillageName = GUICtrlCreateInput(GetTranslated(637,4, "MyVillage"), $x - 3, $y, 130, 22, $ES_AUTOHSCROLL)
			GUICtrlSetLimit (-1, 100, 0)
			GUICtrlSetFont(-1, 9, 400, 1)
			GUICtrlSetTip(-1, GetTranslated(637,5, "Your village/profile's name"))
			GUICtrlSetState(-1, $GUI_HIDE)
			; GUICtrlSetOnEvent(-1, "txtVillageName") - No longer needed

		$bIconAdd = _GUIImageList_Create(22, 22, 4)
			_GUIImageList_AddBitmap($bIconAdd, @ScriptDir & "\images\Button\iconAdd.bmp")
			_GUIImageList_AddBitmap($bIconAdd, @ScriptDir & "\images\Button\iconAdd_2.bmp")
			_GUIImageList_AddBitmap($bIconAdd, @ScriptDir & "\images\Button\iconAdd_2.bmp")
			_GUIImageList_AddBitmap($bIconAdd, @ScriptDir & "\images\Button\iconAdd_4.bmp")
			_GUIImageList_AddBitmap($bIconAdd, @ScriptDir & "\images\Button\iconAdd.bmp")
		$bIconConfirm = _GUIImageList_Create(22, 22, 4)
			_GUIImageList_AddBitmap($bIconConfirm, @ScriptDir & "\images\Button\iconConfirm.bmp")
			_GUIImageList_AddBitmap($bIconConfirm, @ScriptDir & "\images\Button\iconConfirm_2.bmp")
			_GUIImageList_AddBitmap($bIconConfirm, @ScriptDir & "\images\Button\iconConfirm_2.bmp")
			_GUIImageList_AddBitmap($bIconConfirm, @ScriptDir & "\images\Button\iconConfirm_4.bmp")
			_GUIImageList_AddBitmap($bIconConfirm, @ScriptDir & "\images\Button\iconConfirm.bmp")
		$bIconDelete = _GUIImageList_Create(22, 22, 4)
			_GUIImageList_AddBitmap($bIconDelete, @ScriptDir & "\images\Button\iconDelete.bmp")
			_GUIImageList_AddBitmap($bIconDelete, @ScriptDir & "\images\Button\iconDelete_2.bmp")
			_GUIImageList_AddBitmap($bIconDelete, @ScriptDir & "\images\Button\iconDelete_2.bmp")
			_GUIImageList_AddBitmap($bIconDelete, @ScriptDir & "\images\Button\iconDelete_4.bmp")
			_GUIImageList_AddBitmap($bIconDelete, @ScriptDir & "\images\Button\iconDelete.bmp")
		$bIconCancel = _GUIImageList_Create(22, 22, 4)
			_GUIImageList_AddBitmap($bIconCancel, @ScriptDir & "\images\Button\iconCancel.bmp")
			_GUIImageList_AddBitmap($bIconCancel, @ScriptDir & "\images\Button\iconCancel_2.bmp")
			_GUIImageList_AddBitmap($bIconCancel, @ScriptDir & "\images\Button\iconCancel_2.bmp")
			_GUIImageList_AddBitmap($bIconCancel, @ScriptDir & "\images\Button\iconCancel_4.bmp")
			_GUIImageList_AddBitmap($bIconCancel, @ScriptDir & "\images\Button\iconCancel.bmp")
		$bIconEdit = _GUIImageList_Create(22, 22, 4)
			_GUIImageList_AddBitmap($bIconEdit, @ScriptDir & "\images\Button\iconEdit.bmp")
			_GUIImageList_AddBitmap($bIconEdit, @ScriptDir & "\images\Button\iconEdit_2.bmp")
			_GUIImageList_AddBitmap($bIconEdit, @ScriptDir & "\images\Button\iconEdit_2.bmp")
			_GUIImageList_AddBitmap($bIconEdit, @ScriptDir & "\images\Button\iconEdit_4.bmp")
			_GUIImageList_AddBitmap($bIconEdit, @ScriptDir & "\images\Button\iconEdit.bmp")

		$btnAdd = GUICtrlCreateButton("", $x + 135, $y, 22, 22)
			_GUICtrlButton_SetImageList($btnAdd, $bIconAdd, 4)
			GUICtrlSetOnEvent(-1, "btnAddConfirm")
			GUICtrlSetState(-1, $GUI_SHOW)
			GUICtrlSetTip(-1, GetTranslated(637,6, "Add New Profile"))
		$btnConfirmAdd = GUICtrlCreateButton("", $x + 135, $y, 22, 22)
			_GUICtrlButton_SetImageList($btnConfirmAdd, $bIconConfirm, 4)
			GUICtrlSetOnEvent(-1, "btnAddConfirm")
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetTip(-1, GetTranslated(637,7, "Confirm"))
		$btnConfirmRename = GUICtrlCreateButton("", $x + 135, $y, 22, 22)
			_GUICtrlButton_SetImageList($btnConfirmRename, $bIconConfirm, 4)
			GUICtrlSetOnEvent(-1, "btnRenameConfirm")
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetTip(-1, GetTranslated(637,7, -1))
		$btnDelete = GUICtrlCreateButton("", $x + 162, $y, 22, 22)
			_GUICtrlButton_SetImageList($btnDelete, $bIconDelete, 4)
			GUICtrlSetOnEvent(-1, "btnDeleteCancel")
			GUICtrlSetState(-1, $GUI_SHOW)
			GUICtrlSetTip(-1, GetTranslated(637,8, "Delete Profile"))
			If GUICtrlRead($cmbProfile) = "<No Profiles>" Then
				GUICtrlSetState(-1, $GUI_DISABLE)
			Else
				GUICtrlSetState(-1, $GUI_ENABLE)
			EndIf
		$btnCancel = GUICtrlCreateButton("", $x + 162, $y, 22, 22)
			_GUICtrlButton_SetImageList($btnCancel, $bIconCancel, 4)
			GUICtrlSetOnEvent(-1, "btnDeleteCancel")
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetTip(-1, GetTranslated(637,9, "Cancel"))
		$btnRename = GUICtrlCreateButton("", $x + 190, $y, 22, 22)
			_GUICtrlButton_SetImageList($btnRename, $bIconEdit, 4)
			GUICtrlSetOnEvent(-1, "btnRenameConfirm")
			GUICtrlSetTip(-1, GetTranslated(637,10, "Rename Profile"))
			If GUICtrlRead($cmbProfile) = "<No Profiles>" Then
				GUICtrlSetState(-1, $GUI_DISABLE)
			Else
				GUICtrlSetState(-1, $GUI_ENABLE)
			EndIf
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	; Close When Training Settings
	Local $x = 20, $y = 110
	$grpTrainingClose = GUICtrlCreateGroup("Training Settings", $x - 20, $y - 20, 440, 275)
		$x -= 5
		GUICtrlCreateIcon ($pIconLib, $eIcnSleepMode, $x - 0, $y + 40, 48, 48)
		$chkUseTrainingClose = GUICtrlCreateCheckbox("Enable Close While Training", $x + 50, $y - 5, -1, -1)
			$txtTip = "Enable this option to cause the bot to close when there is more than 5 mins remaining on training times." & @CRLF & @CRLF & _
				      "     Doctor's Recommendation: Use this setting to reduce overall time spent online."
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkUseTrainingClose")
		$lblExtraTimeMin = GUICtrlCreateLabel("Extra Time Min: ", $x + 67, $y + 24, 90, -1, $SS_RIGHT)
		$lblExtraTimeMinNumber = GUICtrlCreateLabel("10", $x + 165, $y + 24, 15, 15, $SS_RIGHT)
		$lblExtraTimeMinUnit = GUICtrlCreateLabel("minutes", $x + 185, $y + 24, -1, -1)
		$sldExtraTimeMin = GUICtrlCreateSlider($x + 235, $y + 22, 150, 25, BITOR($TBS_TOOLTIPS, $TBS_AUTOTICKS)) ;,
			$txtTip = "Select the minimum number of mins to add extra to the log out time for training." & @CRLF & _
				      "     Value can be from 0 to 30 mins."
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetBkColor(-1, $COLOR_WHITE)
			_GUICtrlSlider_SetTipSide(-1, $TBTS_BOTTOM)
			_GUICtrlSlider_SetTicFreq(-1, 1)
			GUICtrlSetLimit(-1, 30)
			GUICtrlSetData(-1, 10)
			GUICtrlSetOnEvent(-1, "sldExtraTimeMin")
		$lblExtraTimeMax = GUICtrlCreateLabel("Extra Time Max: ", $x + 70, $y + 50, 90, -1, $SS_RIGHT)
		$lblExtraTimeMaxNumber = GUICtrlCreateLabel("20", $x + 165, $y + 50, 15, 15, $SS_RIGHT)
		$lblExtraTimeMaxUnit = GUICtrlCreateLabel("minutes", $x + 185, $y + 50, -1, -1)
		$sldExtraTimeMax = GUICtrlCreateSlider($x + 235, $y + 47, 150, 25, BITOR($TBS_TOOLTIPS, $TBS_AUTOTICKS)) ;,
			$txtTip = "Select the maximum number of mins to add extra to the log out time for training." & @CRLF & _
				      "     Value can be from 0 to 30 mins."
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetBkColor(-1, $COLOR_WHITE)
			_GUICtrlSlider_SetTipSide(-1, $TBTS_BOTTOM)
			_GUICtrlSlider_SetTicFreq(-1, 1)
			GUICtrlSetLimit(-1, 30)
			GUICtrlSetData(-1, 20)
			GUICtrlSetOnEvent(-1, "sldExtraTimeMax")
		$radLeaveCoCOpen = GUICtrlCreateRadio("Leave CoC open and disconnect by inactivity", $x + 81, $y + 70, -1, -1)
			GUICtrlSetTip(-1, "While training the bot will leave CoC open and disconnect by inactivity.")
			;GUICtrlSetOnEvent(-1, "chkLeaveOpenOrClose")
			;GUICtrlSetState(-1, $GUI_DISABLE)
		$radCloseCoCGame = GUICtrlCreateRadio("Close CoC game and stay on home screen", $x + 81, $y + 90, -1, -1)
			GUICtrlSetTip(-1, "While training the bot will close CoC game and stay on android home screen.")
			;GUICtrlSetOnEvent(-1, "chkLeaveOpenOrClose")
			;GUICtrlSetState(-1, $GUI_DISABLE)
		$radRandomCoCOpen = GUICtrlCreateRadio("Random Close or Leave! ", $x + 81, $y + 110, -1, -1)
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetTip(-1, "Random between leave coc open or Close the game.")
			;GUICtrlSetOnEvent(-1, "chkLeaveOpenOrClose")
			;GUICtrlSetState(-1, $GUI_DISABLE)
		$chkRandomStayORClose = GUICtrlCreateCheckbox("Random Stay or Close the Game while Training", $x + 50, $y + 127, -1, -1)
			GUICtrlSetTip(-1, "Random Stay in the Game and Close the Game with your previous settings!")
			;GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

;GUISetState()