; #FUNCTION# ====================================================================================================================
; Name ..........:
; Description ...: This file contens the attack algorithm SCRIPTED
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Sardo (2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Global $MAINSIDE = "BOTTOM-RIGHT"
Global $FRONT_LEFT = "BOTTOM-RIGHT-DOWN"
Global $FRONT_RIGHT = "BOTTOM-RIGHT-UP"
Global $RIGHT_FRONT = "TOP-RIGHT-DOWN"
Global $RIGHT_BACK = "TOP-RIGHT-UP"
Global $LEFT_FRONT = "BOTTOM-LEFT-DOWN"
Global $LEFT_BACK = "BOTTOM-LEFT-UP"
Global $BACK_LEFT = "TOP-LEFT-DOWN"
Global $BACK_RIGHT = "TOP-LEFT-UP"


Global $PixelTopLeftDropLine
Global $PixelTopRightDropLine
Global $PixelBottomLeftDropLine
Global $PixelBottomRightDropLine
Global $PixelTopLeftUPDropLine
Global $PixelTopLeftDOWNDropLine
Global $PixelTopRightUPDropLine
Global $PixelTopRightDOWNDropLine
Global $PixelBottomLeftUPDropLine
Global $PixelBottomLeftDOWNDropLine
Global $PixelBottomRightUPDropLine
Global $PixelBottomRightDOWNDropLine

Local $DeployableLRTB = [0, $GAME_WIDTH - 1, 0, 626]
Local $OuterDiamondLeft = -18, $OuterDiamondRight = 857, $OuterDiamondTop = 20, $OuterDiamondBottom = 679 ; set the diamond shape based on reference village
Local $DiamondMiddleX = ($OuterDiamondLeft + $OuterDiamondRight) / 2
Local $DiamondMiddleY = ($OuterDiamondTop + $OuterDiamondBottom) / 2
Local $InnerDiamandDiffX = 55 ; set the diamond shape based on reference village
Local $InnerDiamandDiffY = 47 ; set the diamond shape based on reference village
Local $InnerDiamondLeft = $OuterDiamondLeft + $InnerDiamandDiffX, $InnerDiamondRight = $OuterDiamondRight - $InnerDiamandDiffX, $InnerDiamondTop = $OuterDiamondTop + $InnerDiamandDiffY, $InnerDiamondBottom = $OuterDiamondBottom - $InnerDiamandDiffY

Global $ExternalArea[8][3]
Global $ExternalAreaRef[8][3] = [ _
		[$OuterDiamondLeft, $DiamondMiddleY, "LEFT"], _
		[$OuterDiamondRight, $DiamondMiddleY, "RIGHT"], _
		[$DiamondMiddleX, $OuterDiamondTop, "TOP"], _
		[$DiamondMiddleX, $OuterDiamondBottom, "BOTTOM"], _
		[$OuterDiamondLeft + ($DiamondMiddleX - $OuterDiamondLeft) / 2, $OuterDiamondTop + ($DiamondMiddleY - $OuterDiamondTop) / 2, "TOP-LEFT"], _
		[$DiamondMiddleX + ($OuterDiamondRight - $DiamondMiddleX) / 2, $OuterDiamondTop + ($DiamondMiddleY - $OuterDiamondTop) / 2, "TOP-RIGHT"], _
		[$OuterDiamondLeft + ($DiamondMiddleX - $OuterDiamondLeft) / 2, $DiamondMiddleY + ($OuterDiamondBottom - $DiamondMiddleY) / 2, "BOTTOM-LEFT"], _
		[$DiamondMiddleX + ($OuterDiamondRight - $DiamondMiddleX) / 2, $DiamondMiddleY + ($OuterDiamondBottom - $DiamondMiddleY) / 2, "BOTTOM-RIGHT"] _
		]
Global $InternalArea[8][3]
Global $InternalAreaRef[8][3] = [ _
		[$InnerDiamondLeft, $DiamondMiddleY, "LEFT"], _
		[$InnerDiamondRight, $DiamondMiddleY, "RIGHT"], _
		[$DiamondMiddleX, $InnerDiamondTop, "TOP"], _
		[$DiamondMiddleX, $InnerDiamondBottom, "BOTTOM"], _
		[$InnerDiamondLeft + ($DiamondMiddleX - $InnerDiamondLeft) / 2, $InnerDiamondTop + ($DiamondMiddleY - $InnerDiamondTop) / 2, "TOP-LEFT"], _
		[$DiamondMiddleX + ($InnerDiamondRight - $DiamondMiddleX) / 2, $InnerDiamondTop + ($DiamondMiddleY - $InnerDiamondTop) / 2, "TOP-RIGHT"], _
		[$InnerDiamondLeft + ($DiamondMiddleX - $InnerDiamondLeft) / 2, $DiamondMiddleY + ($InnerDiamondBottom - $DiamondMiddleY) / 2, "BOTTOM-LEFT"], _
		[$DiamondMiddleX + ($InnerDiamondRight - $DiamondMiddleX) / 2, $DiamondMiddleY + ($InnerDiamondBottom - $DiamondMiddleY) / 2, "BOTTOM-RIGHT"] _
		]

Func ConvertInternalExternArea()
	Local $x, $y
	For $i = 0 To 7
		$x = $ExternalAreaRef[$i][0]
		$y = $ExternalAreaRef[$i][1]
		ConvertToVillagePos($x, $y)
		$ExternalArea[$i][0] = $x
		$ExternalArea[$i][1] = $y
		$ExternalArea[$i][2] = $ExternalAreaRef[$i][2]
		debugAttackCSV("External Area Point " & $ExternalArea[$i][2] & ": " & $x & ", " & $y)
	Next
	For $i = 0 To 7
		$x = $InternalAreaRef[$i][0]
		$y = $InternalAreaRef[$i][1]
		ConvertToVillagePos($x, $y)
		$InternalArea[$i][0] = $x
		$InternalArea[$i][1] = $y
		$InternalArea[$i][2] = $InternalAreaRef[$i][2]
		debugAttackCSV("Internal Area Point " & $InternalArea[$i][2] & ": " & $x & ", " & $y)
	Next
EndFunc   ;==>ConvertInternalExternArea

Func CheckAttackLocation(ByRef $x, ByRef $y)
	;If $x < 1 Then $x = 1
	;If $x > $GAME_WIDTH - 1 Then $x = $GAME_WIDTH - 1
	;If $y < 1 Then $y = 1
	If $y > $DeployableLRTB[3] Then $y = $DeployableLRTB[3]
	Return True
	#cs
	Local $sPoints = GetDeployableNextTo($x & "," & $y)
	Local $aPoints = StringSplit($sPoints, "|", $STR_NOCOUNT)
	If UBound($aPoints) > 0 Then
		Local $aPoint = StringSplit($aPoints[0], ",", $STR_NOCOUNT)
		If UBound($aPoint) > 1 Then
			$x = $aPoint[0]
			$y = $aPoint[1]
			Return True
		EndIf
	EndIf
	#ce

	#cs
	Local $aPoint = [$x, $y]
	If isInsideDiamondRedArea($aPoint) = True Then Return False

	; find closest red line point

	Local $isLeft = ($x <= $ExternalArea[2][0])
	Local $isTop = ($y <=  $ExternalArea[0][1])

	Local $aPoints
	If $isLeft = True Then
		If $isTop = True Then
			$aPoints = $PixelTopLeft
		Else
			$aPoints = $PixelBottomLeft
		EndIf
	Else
		If $isTop = True Then
			$aPoints = $PixelTopRight
		Else
			$aPoints = $PixelBottomRight
		EndIf
	EndIf

	Local $aP = [0, 0, 9999]
	For $aPoint In $aPoints
		Local $a = $x - $aPoint[0]
		Local $b = $y - $aPoint[1]
		Local $d = Round(Sqrt($a * $a + $b * $b))
		If $d < $aP[2] Then
			Local $aP = [$aPoint[0], $aPoint[1], $d]
			If $d < 5 Then ExitLoop
		EndIf
	Next

	If $aP[2] < 9999 Then
		$x = $aP[0]
		$y = $aP[1]
		Return True
	EndIf
	#ce

	;debugAttackCSV("CheckAttackLocation: Failed: " & $x & ", " & $y)
EndFunc   ;==>CheckAttackLocation

; #FUNCTION# ====================================================================================================================
; Name ..........: Algorithm_AttackCSV
; Description ...:
; Syntax ........: Algorithm_AttackCSV([$testattack = False])
; Parameters ....: $testattack          - [optional]
; Return values .: None
; Author ........: Sardo (2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func Algorithm_AttackCSV($testattack = False, $captureredarea = True)

	;00 read attack file SIDE row and valorize variables
	ParseAttackCSV_Read_SIDE_variables()
	If _Sleep($iDelayRespond) Then Return

	;01 - TROOPS ------------------------------------------------------------------------------------------------------------------------------------------
	debugAttackCSV("Troops to be used (purged from troops) ")
	For $i = 0 To UBound($atkTroops) - 1 ; identify the position of this kind of troop
		debugAttackCSV("SLOT n.: " & $i & " - Troop: " & NameOfTroop($atkTroops[$i][0]) & " (" & $atkTroops[$i][0] & ") - Quantity: " & $atkTroops[$i][1])
	Next

	Local $hTimerTOTAL = TimerInit()
	;02.01 - REDAREA -----------------------------------------------------------------------------------------------------------------------------------------
	Local $hTimer = TimerInit()

	_CaptureRegion2()
	If $captureredarea Then _GetRedArea()
	If _Sleep($iDelayRespond) Then Return

	Local $htimerREDAREA = Round(TimerDiff($hTimer) / 1000, 2)
	debugAttackCSV("Calculated  (in " & $htimerREDAREA & " seconds) :")
	debugAttackCSV("	[" & UBound($PixelTopLeft) & "] pixels TopLeft")
	debugAttackCSV("	[" & UBound($PixelTopRight) & "] pixels TopRight")
	debugAttackCSV("	[" & UBound($PixelBottomLeft) & "] pixels BottomLeft")
	debugAttackCSV("	[" & UBound($PixelBottomRight) & "] pixels BottomRight")

	;02.02  - CLEAN REDAREA BAD POINTS -----------------------------------------------------------------------------------------------------------------------
	CleanRedArea($PixelTopLeft)
	CleanRedArea($PixelTopRight)
	CleanRedArea($PixelBottomLeft)
	CleanRedArea($PixelBottomRight)
	debugAttackCSV("RedArea cleaned")
	debugAttackCSV("	[" & UBound($PixelTopLeft) & "] pixels TopLeft")
	debugAttackCSV("	[" & UBound($PixelTopRight) & "] pixels TopRight")
	debugAttackCSV("	[" & UBound($PixelBottomLeft) & "] pixels BottomLeft")
	debugAttackCSV("	[" & UBound($PixelBottomRight) & "] pixels BottomRight")
	If _Sleep($iDelayRespond) Then Return

	;02.03 - MAKE FULL DROP LINE EDGE--------------------------------------------------------------------------------------------------------------------------
	$PixelTopLeftDropLine = MakeDropLine($PixelTopLeft, StringSplit($InternalArea[0][0] - 27 & "," & $InternalArea[0][1], ",", $STR_NOCOUNT), StringSplit($InternalArea[2][0] & "," & $InternalArea[2][1] - 22, ",", $STR_NOCOUNT))
	$PixelTopRightDropLine = MakeDropLine($PixelTopRight, StringSplit($InternalArea[2][0] & "," & $InternalArea[2][1] - 22, ",", $STR_NOCOUNT), StringSplit($InternalArea[1][0] + 27 & "," & $InternalArea[1][1], ",", $STR_NOCOUNT))
	$PixelBottomLeftDropLine = MakeDropLine($PixelBottomLeft, StringSplit($InternalArea[0][0] - 27 & "," & $InternalArea[0][1], ",", $STR_NOCOUNT), StringSplit($InternalArea[3][0] & "," & $InternalArea[3][1] + 22, ",", $STR_NOCOUNT))
	$PixelBottomRightDropLine = MakeDropLine($PixelBottomRight, StringSplit($InternalArea[3][0] & "," & $InternalArea[3][1] + 22, ",", $STR_NOCOUNT), StringSplit($InternalArea[1][0] + 27 & "," & $InternalArea[1][1], ",", $STR_NOCOUNT))

	;02.04 - MAKE DROP LINE SLICE ----------------------------------------------------------------------------------------------------------------------------
	;-- TOP LEFT
	Local $tempvectstr1 = ""
	Local $tempvectstr2 = ""
	For $i = 0 To UBound($PixelTopLeftDropLine) - 1
		$pixel = $PixelTopLeftDropLine[$i]
		Switch StringLeft(Slice8($pixel), 1)
			Case "6"
				$tempvectstr1 &= $pixel[0] & "," & $pixel[1] & "|"
			Case "5"
				$tempvectstr2 &= $pixel[0] & "," & $pixel[1] & "|"
		EndSwitch
	Next
	If StringLen($tempvectstr1) > 0 Then $tempvectstr1 = StringLeft($tempvectstr1, StringLen($tempvectstr1) - 1)
	If StringLen($tempvectstr2) > 0 Then $tempvectstr2 = StringLeft($tempvectstr2, StringLen($tempvectstr2) - 1)
	$PixelTopLeftDOWNDropLine = GetListPixel($tempvectstr1, ",", "TL-DOWN")
	$PixelTopLeftUPDropLine = GetListPixel($tempvectstr2, ",", "TL-UP")

	;-- TOP RIGHT
	Local $tempvectstr1 = ""
	Local $tempvectstr2 = ""
	For $i = 0 To UBound($PixelTopRightDropLine) - 1
		$pixel = $PixelTopRightDropLine[$i]
		Switch StringLeft(Slice8($pixel), 1)
			Case "3"
				$tempvectstr1 &= $pixel[0] & "," & $pixel[1] & "|"
			Case "4"
				$tempvectstr2 &= $pixel[0] & "," & $pixel[1] & "|"
		EndSwitch
	Next
	If StringLen($tempvectstr1) > 0 Then $tempvectstr1 = StringLeft($tempvectstr1, StringLen($tempvectstr1) - 1)
	If StringLen($tempvectstr2) > 0 Then $tempvectstr2 = StringLeft($tempvectstr2, StringLen($tempvectstr2) - 1)
	$PixelTopRightDOWNDropLine = GetListPixel($tempvectstr1, ",", "TR-DOWN")
	$PixelTopRightUPDropLine = GetListPixel($tempvectstr2, ",", "TR-UP")

	;-- BOTTOM LEFT
	Local $tempvectstr1 = ""
	Local $tempvectstr2 = ""
	For $i = 0 To UBound($PixelBottomLeftDropLine) - 1
		$pixel = $PixelBottomLeftDropLine[$i]
		Switch StringLeft(Slice8($pixel), 1)
			Case "8"
				$tempvectstr1 &= $pixel[0] & "," & $pixel[1] & "|"
			Case "7"
				$tempvectstr2 &= $pixel[0] & "," & $pixel[1] & "|"
		EndSwitch
	Next
	If StringLen($tempvectstr1) > 0 Then $tempvectstr1 = StringLeft($tempvectstr1, StringLen($tempvectstr1) - 1)
	If StringLen($tempvectstr2) > 0 Then $tempvectstr2 = StringLeft($tempvectstr2, StringLen($tempvectstr2) - 1)
	$PixelBottomLeftDOWNDropLine = GetListPixel($tempvectstr1, ",", "BL-DOWN")
	$PixelBottomLeftUPDropLine = GetListPixel($tempvectstr2, ",", "BL-UP")

	;-- BOTTOM RIGHT
	Local $tempvectstr1 = ""
	Local $tempvectstr2 = ""
	For $i = 0 To UBound($PixelBottomRightDropLine) - 1
		$pixel = $PixelBottomRightDropLine[$i]
		Switch StringLeft(Slice8($pixel), 1)
			Case "1"
				$tempvectstr1 &= $pixel[0] & "," & $pixel[1] & "|"
			Case "2"
				$tempvectstr2 &= $pixel[0] & "," & $pixel[1] & "|"
		EndSwitch
	Next
	If StringLen($tempvectstr1) > 0 Then $tempvectstr1 = StringLeft($tempvectstr1, StringLen($tempvectstr1) - 1)
	If StringLen($tempvectstr2) > 0 Then $tempvectstr2 = StringLeft($tempvectstr2, StringLen($tempvectstr2) - 1)
	$PixelBottomRightDOWNDropLine = GetListPixel($tempvectstr1, ",", "BR-DOWN")
	$PixelBottomRightUPDropLine = GetListPixel($tempvectstr2, ",", "BR-UP")
	Setlog("> Drop Lines located in  " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds", $COLOR_INFO)
	If _Sleep($iDelayRespond) Then Return

	; 03 - TOWNHALL ------------------------------------------------------------------------
	If $searchTH = "-" Then

		If $attackcsv_locate_townhall = 1 Then
			SuspendAndroid()
			$hTimer = TimerInit()
			Local $searchTH = imgloccheckTownHallADV2(0, 0, False)
			;CODE NO LONGER NEEDED HAS imglcTHSearch retries 2 times
			;If $searchTH = "-" Then ; retry with autoit search after $iDelayVillageSearch5 seconds
			;	If _Sleep($iDelayAttackCSV1) Then Return
			;	If $debugsetlog = 1 Then SetLog("2nd attempt to detect the TownHall!", $COLOR_ERROR)
			;	$searchTH = checkTownhallADV2()
			;EndIf
			;If $searchTH = "-" Then ; retry with c# search, matching could not have been caused by heroes that partially hid the townhall
			;	If _Sleep($iDelayAttackCSV2) Then Return
			;	If $debugImageSave = 1 Then DebugImageSave("VillageSearch_NoTHFound2try_", False)
			;	THSearch()
			;EndIf


			Setlog("> Townhall located in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds", $COLOR_INFO)
			ResumeAndroid()
		Else
			Setlog("> Townhall search not needed, skip")
		EndIf
	Else
		Setlog("> Townhall has already been located in while searching for an image", $COLOR_INFO)
	EndIf
	If _Sleep($iDelayRespond) Then Return

	;_CaptureRegion2() ;

	;04 - MINES, COLLECTORS, DRILLS -----------------------------------------------------------------------------------------------------------------------

	;_CaptureRegion()

	;reset variables
	Global $PixelMine[0]
	Global $PixelElixir[0]
	Global $PixelDarkElixir[0]
	Local $PixelNearCollectorTopLeftSTR = ""
	Local $PixelNearCollectorBottomLeftSTR = ""
	Local $PixelNearCollectorTopRightSTR = ""
	Local $PixelNearCollectorBottomRightSTR = ""


	;04.01 If drop troop near gold mine
	If $attackcsv_locate_mine = 1 Then
		;SetLog("Locating mines")
		$hTimer = TimerInit()
		SuspendAndroid()
		$PixelMine = GetLocationMine()
		ResumeAndroid()
		If _Sleep($iDelayRespond) Then Return
		CleanRedArea($PixelMine)
		Local $htimerMine = Round(TimerDiff($hTimer) / 1000, 2)
		If (IsArray($PixelMine)) Then
			For $i = 0 To UBound($PixelMine) - 1
				$pixel = $PixelMine[$i]
				Local $str = $pixel[0] & "-" & $pixel[1] & "-" & "MINE"
				If isInsideDiamond($pixel) Then
					If $pixel[0] <= $InternalArea[2][0] Then
						If $pixel[1] <= $InternalArea[0][1] Then
							;Setlog($str & " :  TOP LEFT SIDE")
							$PixelNearCollectorTopLeftSTR &= $str & "|"
						Else
							;Setlog($str & " :  BOTTOM LEFT SIDE")
							$PixelNearCollectorBottomLeftSTR &= $str & "|"
						EndIf
					Else
						If $pixel[1] <= $InternalArea[0][1] Then
							;Setlog($str & " :  TOP RIGHT SIDE")
							$PixelNearCollectorTopRightSTR &= $str & "|"
						Else
							;Setlog($str & " :  BOTTOM RIGHT SIDE")
							$PixelNearCollectorBottomRightSTR &= $str & "|"
						EndIf
					EndIf
				EndIf
			Next
		EndIf
		Setlog("> Mines located in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds", $COLOR_INFO)
	Else
		Setlog("> Mines detection not needed, skip", $COLOR_INFO)
	EndIf
	If _Sleep($iDelayRespond) Then Return

	;04.02  If drop troop near elisir
	If $attackcsv_locate_elixir = 1 Then
		;SetLog("Locating elixir")
		$hTimer = TimerInit()
		SuspendAndroid()
		$PixelElixir = GetLocationElixir()
		ResumeAndroid()
		If _Sleep($iDelayRespond) Then Return
		CleanRedArea($PixelElixir)
		Local $htimerMine = Round(TimerDiff($hTimer) / 1000, 2)
		If (IsArray($PixelElixir)) Then
			For $i = 0 To UBound($PixelElixir) - 1
				$pixel = $PixelElixir[$i]
				Local $str = $pixel[0] & "-" & $pixel[1] & "-" & "ELIXIR"
				If isInsideDiamond($pixel) Then
					If $pixel[0] <= $InternalArea[2][0] Then
						If $pixel[1] <= $InternalArea[0][1] Then
							;Setlog($str & " :  TOP LEFT SIDE")
							$PixelNearCollectorTopLeftSTR &= $str & "|"
						Else
							;Setlog($str & " :  BOTTOM LEFT SIDE")
							$PixelNearCollectorBottomLeftSTR &= $str & "|"
						EndIf
					Else
						If $pixel[1] <= $InternalArea[0][1] Then
							;Setlog($str & " :  TOP RIGHT SIDE")
							$PixelNearCollectorTopRightSTR &= $str & "|"
						Else
							;Setlog($str & " :  BOTTOM RIGHT SIDE")
							$PixelNearCollectorBottomRightSTR &= $str & "|"
						EndIf
					EndIf
				EndIf
			Next
		EndIf
		Setlog("> Elixir collectors located in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds", $COLOR_INFO)
	Else
		Setlog("> Elixir collectors detection not needed, skip", $COLOR_INFO)
	EndIf
	If _Sleep($iDelayRespond) Then Return

	;04.03 If drop troop near drill
	If $attackcsv_locate_drill = 1 Then
		;SetLog("Locating drills")
		$hTimer = TimerInit()
		SuspendAndroid()
		$PixelDarkElixir = GetLocationDarkElixir()
		ResumeAndroid()
		If _Sleep($iDelayRespond) Then Return
		CleanRedArea($PixelDarkElixir)
		Local $htimerMine = Round(TimerDiff($hTimer) / 1000, 2)
		If (IsArray($PixelDarkElixir)) Then
			For $i = 0 To UBound($PixelDarkElixir) - 1
				$pixel = $PixelDarkElixir[$i]
				Local $str = $pixel[0] & "-" & $pixel[1] & "-" & "DRILL"
				If isInsideDiamond($pixel) Then
					If $pixel[0] <= $InternalArea[2][0] Then
						If $pixel[1] <= $InternalArea[0][1] Then
							;Setlog($str & " :  TOP LEFT SIDE")
							$PixelNearCollectorTopLeftSTR &= $str & "|"
						Else
							;Setlog($str & " :  BOTTOM LEFT SIDE")
							$PixelNearCollectorBottomLeftSTR &= $str & "|"
						EndIf
					Else
						If $pixel[1] <= $InternalArea[0][1] Then
							;Setlog($str & " :  TOP RIGHT SIDE")
							$PixelNearCollectorTopRightSTR &= $str & "|"
						Else
							;Setlog($str & " :  BOTTOM RIGHT SIDE")
							$PixelNearCollectorBottomRightSTR &= $str & "|"
						EndIf
					EndIf
				EndIf
			Next
		EndIf
		Setlog("> Drills located in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds", $COLOR_INFO)
	Else
		Setlog("> Drills detection not needed, skip", $COLOR_INFO)
	EndIf
	If _Sleep($iDelayRespond) Then Return

	If StringLen($PixelNearCollectorTopLeftSTR) > 0 Then $PixelNearCollectorTopLeftSTR = StringLeft($PixelNearCollectorTopLeftSTR, StringLen($PixelNearCollectorTopLeftSTR) - 1)
	If StringLen($PixelNearCollectorTopRightSTR) > 0 Then $PixelNearCollectorTopRightSTR = StringLeft($PixelNearCollectorTopRightSTR, StringLen($PixelNearCollectorTopRightSTR) - 1)
	If StringLen($PixelNearCollectorBottomLeftSTR) > 0 Then $PixelNearCollectorBottomLeftSTR = StringLeft($PixelNearCollectorBottomLeftSTR, StringLen($PixelNearCollectorBottomLeftSTR) - 1)
	If StringLen($PixelNearCollectorBottomRightSTR) > 0 Then $PixelNearCollectorBottomRightSTR = StringLeft($PixelNearCollectorBottomRightSTR, StringLen($PixelNearCollectorBottomRightSTR) - 1)
	$PixelNearCollectorTopLeft = GetListPixel3($PixelNearCollectorTopLeftSTR)
	$PixelNearCollectorTopRight = GetListPixel3($PixelNearCollectorTopRightSTR)
	$PixelNearCollectorBottomLeft = GetListPixel3($PixelNearCollectorBottomLeftSTR)
	$PixelNearCollectorBottomRight = GetListPixel3($PixelNearCollectorBottomRightSTR)

	If $attackcsv_locate_gold_storage = 1 Then
		SuspendAndroid()
		$GoldStoragePos = GetLocationGoldStorage()
		ResumeAndroid()
	EndIf

	If $attackcsv_locate_elixir_storage = 1 Then
		SuspendAndroid()
		$ElixirStoragePos = GetLocationElixirStorage()
		ResumeAndroid()
	EndIf


	; 05 - DARKELIXIRSTORAGE ------------------------------------------------------------------------
	If $attackcsv_locate_dark_storage = 1 Then
		$hTimer = TimerInit()
		SuspendAndroid()
		Local $PixelDarkElixirStorage = GetLocationDarkElixirStorageWithLevel()
		ResumeAndroid()
		If _Sleep($iDelayRespond) Then Return
		CleanRedArea($PixelDarkElixirStorage)
		Local $pixel = StringSplit($PixelDarkElixirStorage, "#", 2)
		If UBound($pixel) >= 2 Then
			Local $pixellevel = $pixel[0]
			Local $pixelpos = StringSplit($pixel[1], "-", 2)
			If UBound($pixelpos) >= 2 Then
				Local $temp = [Int($pixelpos[0]), Int($pixelpos[1])]
				$darkelixirStoragePos = $temp
			EndIf
		EndIf
		Setlog("> Dark Elixir Storage located in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds", $COLOR_INFO)
	Else
		Setlog("> Dark Elixir Storage detection not need, skip", $COLOR_INFO)
	EndIf

	; 06 - EAGLEARTILLERY ------------------------------------------------------------------------

	$EagleArtilleryPos[0] = "" ; reset pixel position to null
	$EagleArtilleryPos[1] = ""
	If $searchTH = "-" Or Int($searchTH) > 10 Then
		If $attackcsv_locate_Eagle = 1 Then
			$hTimer = TimerInit()
			SuspendAndroid()
			Local $result = returnSingleMatch(@ScriptDir & "\imgxml\WeakBase\Eagle")
			ResumeAndroid()
			If UBound($result) > 1 Then
				Local $tempeaglePos = $result[1][5] ;assign eagle x,y sub array to temp variable
				If $debugsetlog = 1 Then
					Setlog(": ImageName: " & $result[1][0], $COLOR_DEBUG)
					Setlog(": ObjectName: " & $result[1][1], $COLOR_DEBUG)
					Setlog(": ObjectLevel: " & $result[1][2], $COLOR_DEBUG)
				EndIf
				If $tempeaglePos[0][0] <> "" Then
					$EagleArtilleryPos[0] = $tempeaglePos[0][0]
					$EagleArtilleryPos[1] = $tempeaglePos[0][1]
					Setlog("> Eagle located in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds", $COLOR_INFO)
					If $debugsetlog = 1 Then
						Setlog(": $EagleArtilleryPosition X:Y= " & $EagleArtilleryPos[0] & ":" & $EagleArtilleryPos[1], $COLOR_DEBUG)
					EndIf
				Else
					Setlog("> Eagle detection error", $COLOR_WARNING)
				EndIf
			Else
				Setlog("> Eagle detection error", $COLOR_WARNING)
			EndIf
		Else
			Setlog("> Eagle Artillery detection not need, skip", $COLOR_INFO)
		EndIf
	Else
		Setlog("> TH Level to low for Eagle detection, skip", $COLOR_INFO)
	EndIf

	Setlog(">> Total time: " & Round(TimerDiff($hTimerTOTAL) / 1000, 2) & " seconds", $COLOR_INFO)

	; 06 - DEBUGIMAGE ------------------------------------------------------------------------
	If $makeIMGCSV = 1 Then AttackCSVDEBUGIMAGE() ;make IMG debug

	; 07 - START TH SNIPE BEFORE ATTACK CSV IF NEED ------------------------------------------
	If $THSnipeBeforeDBEnable = 1 And $searchTH = "-" Then FindTownHall(True) ;search townhall if no previous detect
	If $THSnipeBeforeDBEnable = 1 Then
		If $searchTH <> "-" Then
			If SearchTownHallLoc() Then
				Setlog(_PadStringCenter(" TH snipe Before Scripted Attack ", 54, "="), $COLOR_INFO)
				$THusedKing = 0
				$THusedQueen = 0
				AttackTHParseCSV()
			Else
				If $debugsetlog = 1 Then Setlog("TH snipe before scripted attack skip, th internal village", $COLOR_DEBUG)
			EndIf
		Else
			If $debugsetlog = 1 Then Setlog("TH snipe before scripted attack skip, no th found", $COLOR_DEBUG)
		EndIf
	EndIf

	; 08 - LAUNCH PARSE FUNCTION -------------------------------------------------------------
	SetSlotSpecialTroops()
	If _Sleep($iDelayRespond) Then Return

	If TestCapture() = True Then
		; no launch when testing with image
		Return
	EndIf

	ParseAttackCSV($testattack)

EndFunc   ;==>Algorithm_AttackCSV
