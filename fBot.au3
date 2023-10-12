#include <Misc.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <WinAPI.au3>

Global $iUpdateInterval = 1000
Global $iTimer = TimerInit()

Global $iSquareLeft, $iSquareTop, $iSquareRight, $iSquareBottom


Local $hGUI_Main = GUICreate("MFB", 300, 115, -1, -1, $WS_POPUP, $WS_EX_TOPMOST)
_WinAPI_SetLayeredWindowAttributes($hGUI_Main, 0x00, 0, $LWA_COLORKEY)
WinSetTrans($hGUI_Main, "", 200)
GUISetState(@SW_HIDE)

Local $hLabel_FishCount = GUICtrlCreateLabel("Fish Caught: 0", 10, 10, 280, 20)
GUICtrlSetFont(-1, 12, 800)

Local $hLabel_ElapsedTime = GUICtrlCreateLabel("Runtime: 00:00:00", 10, 35, 280, 20)
GUICtrlSetFont(-1, 12, 800)

Local $hStatus_Status = GUICtrlCreateLabel("Status:", 10, 70, 280, 400)
GUICtrlSetColor($hStatus_Status, 0xBE2B27)
GUICtrlSetFont(-1, 9, 800)

Local $hStatus = GUICtrlCreateLabel("", 10, 90, 280, 400)
GUICtrlSetFont(-1, 11, 800)


Local $iFishCount = 0
Local $iStartTime = TimerInit()

Global $sElapsedTime
Global $iNoRedCount = 0

HotKeySet("{ESC}", "_Exit")
HotKeySet("{F2}", "_main")

$width = 150
$heigth = 150
$mpos = MouseGetPos()
Local $hGUI_Rect = GUICreate("", $width, $heigth, $mpos[0] - $width / 2, $mpos[1] - $heigth / 2, $WS_POPUP, $WS_EX_TOOLWINDOW + $WS_EX_TOPMOST + $WS_EX_LAYERED)
GUISetBkColor(0x00)
_WinAPI_SetLayeredWindowAttributes($hGUI_Rect, 0x00, 0xD0, 0)
GUICtrlCreateGraphic(0, 0, $width, $heigth)
GUICtrlSetGraphic(-1, $GUI_GR_COLOR, 0xFFFFFF)
GUICtrlSetGraphic(-1, $GUI_GR_PENSIZE, 3)
GUICtrlSetGraphic(-1, $GUI_GR_RECT, 0, 0, $width, $heigth)
GUISetState(@SW_HIDE)

#include <Misc.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <WinAPI.au3>

_edge()

Func _edge()
	do
		sleep(100)
	Until WinActive("Minecraft", "")
	GUISetState(@SW_SHOW, $hGUI_Main)
	WinActivate("Minecraft", "")

	GUICtrlSetData($hStatus, "Face water w/ fishing rod and press F2")
	While 1
		If _IsPressed("1B") Then
			Exit
		EndIf
		GUI_MainUpdate()
		Sleep(50)
	WEnd
EndFunc   ;==>_edge

Func _main()
	GUISetState(@SW_SHOW, $hGUI_Rect)
	WinActivate("Minecraft", "")

	GUI_SquareUpdate()

	Local $aRedPixel = PixelSearch($iSquareLeft, $iSquareTop, $iSquareRight, $iSquareBottom, 0xBE2B27, 50)

	If Not IsArray($aRedPixel) Then
		ConsoleWrite("Cast a rod" & @CRLF)
		GUICtrlSetData($hStatus, "Cast")
		MouseClick('right')
		Sleep(3000)
	EndIf


	While True
		If _IsPressed("1B") Then
			Exit
		EndIf

		If TimerDiff($iTimer) >= $iUpdateInterval Then
			GUI_MainUpdate()
			GUI_TimeUpdate()
			GUICtrlSetData($hLabel_FishCount, "Fish Caught: " & $iFishCount)
			$iTimer = TimerInit()
		EndIf

		Local $aRedPixel = PixelSearch($iSquareLeft, $iSquareTop, $iSquareRight, $iSquareBottom, 0xBE2B27, 50)

		If IsArray($aRedPixel) Then
			ConsoleWrite("Red color found at X: " & $aRedPixel[0] & " Y: " & $aRedPixel[1] & @CRLF)
			GUICtrlSetData($hStatus, "Red color [X: " & $aRedPixel[0] & " Y: " & $aRedPixel[1] & "]")
			$iNoRedCount = 0
		Else
			$iNoRedCount += 1
			If $iNoRedCount >= 3 Then
				ConsoleWrite("Red color not found for 3 ticks: Catch the Fish" & @CRLF)
				GUICtrlSetData($hStatus, "Catch the Fish")
				MouseClick('right')
				$iNoRedCount = 0
				$iFishCount += 1

				Local $iDelay = Random(1000, 2000, 1)
				TimerLoop($iDelay)

				Local $aRedPixel = PixelSearch($iSquareLeft, $iSquareTop, $iSquareRight, $iSquareBottom, 0xBE2B27, 50)

				If Not IsArray($aRedPixel) Then
					ConsoleWrite("Red color not found on the screen: Recast" & @CRLF)
					GUICtrlSetData($hStatus, "Recast")
					MouseClick('right')
				EndIf

				TimerLoop(2000)

			EndIf
		EndIf

		Sleep(90)

		Local $iMsg = GUIGetMsg()
		Switch $iMsg
			Case $GUI_EVENT_CLOSE
				ExitLoop
		EndSwitch

		GUICtrlSetData($hLabel_FishCount, "Fish Caught: " & $iFishCount)

		GUI_TimeUpdate()

	WEnd
EndFunc   ;==>_main

Func TimerLoop($duration)
	Local $startTime = TimerInit()
	While True
		If TimerDiff($startTime) >= $duration Then
			ExitLoop
		EndIf

		GUI_TimeUpdate()
		GUI_SquareUpdate()
		GUICtrlSetData($hLabel_FishCount, "Fish Caught: " & $iFishCount)

		Sleep(100)
	WEnd
EndFunc   ;==>TimerLoop

Func GUI_TimeUpdate()
	Local $iElapsedTime = TimerDiff($iStartTime) / 1000
	Local $iHours = Int($iElapsedTime / 3600)
	Local $iMinutes = Mod(Int($iElapsedTime / 60), 60)
	Local $iSeconds = Mod($iElapsedTime, 60)

	If StringLen($iHours) < 2 Then $iHours = "0" & $iHours
	If StringLen($iMinutes) < 2 Then $iMinutes = "0" & $iMinutes
	If StringLen($iSeconds) < 2 Then $iSeconds = "0" & $iSeconds
	$sElapsedTime = $iHours & ":" & $iMinutes & ":" & Round($iSeconds)

	GUICtrlSetData($hLabel_ElapsedTime, "Runtime: " & $sElapsedTime)

EndFunc   ;==>GUI_TimeUpdate

Func GUI_SquareUpdate()
	$aMousePos = MouseGetPos()

	$iSquareLeft = $aMousePos[0] - 75
	$iSquareTop = $aMousePos[1] - 75
	$iSquareRight = $aMousePos[0] + 75
	$iSquareBottom = $aMousePos[1] + 75

	WinMove($hGUI_Rect, "", $iSquareLeft, $iSquareTop)
EndFunc   ;==>GUI_SquareUpdate

Func _Exit()
	Do
		Sleep(10)
	Until _IsPressed("1B")
	GUISetState(@SW_HIDE)
	GUICtrlSetData($hStatus, "F2 to Resume : ESC to Exit")
	Sleep(150)
	While 1
		If _IsPressed("1B") Then
			Exit
		EndIf
		Sleep(10)
		GUI_MainUpdate()
	WEnd
EndFunc   ;==>_Exit

Func _GuiRoundCorners($h_win, $i_x1, $i_y1, $i_x2, $i_y2, $i_x3, $i_y3)
	Local $XS_pos, $XS_reta, $XS_retb, $XS_ret2
	$XS_pos = WinGetPos($h_win)
	$XS_reta = _WinAPI_CreateRoundRectRgn(0, 0, $XS_pos[2], $XS_pos[3], $i_x3, $i_y3)
	$XS_retb = _WinAPI_CreateRectRgn(0, $XS_pos[2] - $XS_pos[1] / 2, $XS_pos[2], $XS_pos[3])
	$XS_retc = _WinAPI_CombineRgn($XS_reta, $XS_reta, $XS_retb, $RGN_OR)
	_WinAPI_DeleteObject($XS_retb)
	_WinAPI_SetWindowRgn($h_win, $XS_reta)
EndFunc   ;==>_GuiRoundCorners

Func GUI_MainUpdate()
	Global $hGUI_Main, $iSquareWidth, $iSquareHeight
	Local $aMinecraftPos = WinGetPos("Minecraft")

	If Not @error Then
		_GuiRoundCorners($hGUI_Main, 10, 10, 10, 10, 10, 10)
		$iMinecraftCenterX = $aMinecraftPos[0] + $aMinecraftPos[2] / 2

		If Not IsHWnd($hGUI_Main) Then
			$iGUITopX = $iMinecraftCenterX - 150
			$iGUITopY = $aMinecraftPos[1]

			$hGUI_Main = GUICreate("MFB", 300, 200, $iGUITopX, $iGUITopY, $WS_POPUP, $WS_EX_TOPMOST)
		Else
			WinMove($hGUI_Main, "", $iMinecraftCenterX - 150, $aMinecraftPos[1] + 40)
		EndIf

		$iMinecraftWidth = $aMinecraftPos[2]
		$iMinecraftHeight = $aMinecraftPos[3]

		$iScreenWidth = @DesktopWidth
		$iScreenHeight = @DesktopHeight

		$iSquareWidth = $iMinecraftWidth / 2
		$iSquareHeight = $iMinecraftHeight / 2
	ElseIf IsHWnd($hGUI_Main) Then
		GUIDelete($hGUI_Main)
	EndIf
EndFunc   ;==>GUI_MainUpdate
