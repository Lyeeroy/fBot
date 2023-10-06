#include <Misc.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <WinAPI.au3>

Global $iSquareLeft, $iSquareTop, $iSquareRight, $iSquareBottom


Local $hGUI_Main = GUICreate("MFB", 300, 200)
GUISetState(@SW_SHOW)

Local $hLabel_KillSwitch = GUICtrlCreateLabel("Close bind: ESC", 10, 10, 280, 20)
GUICtrlSetFont(-1, 12, 800)

Local $hLabel_FishCount = GUICtrlCreateLabel("Fish Caught: 0", 10, 40, 280, 20)
GUICtrlSetFont(-1, 12, 800)

Local $hLabel_ElapsedTime = GUICtrlCreateLabel("Runtime: 00:00:00", 10, 70, 280, 20)
GUICtrlSetFont(-1, 12, 800)

Local $hStatus_Status = GUICtrlCreateLabel("Status:", 10, 130, 280, 400)
GUICtrlSetColor($hStatus_Status, 0xBE2B27)
GUICtrlSetFont(-1, 9, 800)

Local $hStatus = GUICtrlCreateLabel("", 10, 150, 280, 400)
GUICtrlSetFont(-1, 11, 800)


Local $iFishCount = 0
Local $iStartTime = TimerInit()

Global $sElapsedTime
Global $iNoRedCount = 0

HotKeySet("{ESC}", "Get_Exit")

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

Local $aRedPixel = PixelSearch(0, 0, @DesktopWidth - 1, @DesktopHeight - 1, 0xBE2B27, 50)

If Not WinActive("Minecraft", "") Then
	GUISetState(@SW_HIDE)
	Do
		Sleep(420)
		ConsoleWrite("Waiting [Loop]: Minecraft isn't active" & @CRLF)
		GUICtrlSetData($hStatus, "Waiting [Loop]: Minecraft isn't active")
	Until WinActive("Minecraft", "")
EndIf

ConsoleWrite("Waiting [4s]: Set-up the minecraft" & @CRLF)
GUICtrlSetData($hStatus, "Waiting [4s]: Set-up the minecraft")
Sleep(4000)
GUISetState(@SW_SHOW)
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

	GUI_SquareUpdate()

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

			If Not IsArray($aRedPixel) Then ;
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

Func Get_Exit()
	GUIDelete($hGUI_Rect)
	Exit
EndFunc   ;==>Get_Exit
