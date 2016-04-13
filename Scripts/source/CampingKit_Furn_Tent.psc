ScriptName CampingKit_Furn_Tent extends ObjectReference

Message Property Menu_WS_TentMenu Auto

Float Property OffsetHorizontal = 0 Auto
Float Property LanternOffsetHeight = 0 Auto
Float Property LanternOffsetAngle = 0 Auto
Float Property LanternOffsetDistance = 0 Auto
Activator Property HangingLantern Auto
ObjectReference HangingLanternREF

Int RotationAmountZ = 8
Bool IsLanternActive = False

Import CampingKit_UtilityFunctions

; Menu Functions ================================

Function ShowMainMenu(Int iButton = 0)
	
	iButton = Menu_WS_TentMenu.Show(0, 0, 0, 0, 0, 0, 0, 0, 0)

	If iButton == 0 ;Sleep
		GoToSleep()
	ElseIf iButton == 1 ;Pick Up
		ToggleLantern()
	ElseIf iButton == 4 ;Do Nothing & Exit
		;Exit
	EndIf
	
EndFunction

; Event Functions ====================================

Function OnWorkshopObjectPlaced(ObjectReference akReference)
	;Debug.MessageBox("Object Placed")
	;Attach our lamp
	HangingLanternREF = Self.PlaceAtMe(HangingLantern As Form, 1, True, False, False)
	HangingLanternREF.MoveTo(Self, 0, 0, LanternOffsetHeight, True)
	
	If(LanternOffsetDistance>0)
		MoveRelative(HangingLanternREF, HangingLanternREF, LanternOffsetAngle, LanternOffsetDistance)
	EndIf
	
	Self.BlockActivation(true, false)	
EndFunction

Function OnWorkshopObjectGrabbed(ObjectReference akReference)
	HangingLanternREF.Disable(False)
EndFunction

Function OnWorkshopObjectMoved(ObjectReference akReference)
	;Debug.MessageBox("Object Moved")
	HangingLanternREF.MoveTo(Self, 0, 0, LanternOffsetHeight, True)

	If(LanternOffsetDistance>0)
		MoveRelative(HangingLanternREF, HangingLanternREF, LanternOffsetAngle, LanternOffsetDistance)
	EndIf	
	HangingLanternRef.Enable(False)
EndFunction

Function OnWorkshopObjectDestroyed(ObjectReference akReference)
	;Debug.MessageBox("Object Destroyed")
	HangingLanternREF.Disable(false)
	HangingLanternREF.Delete()
EndFunction


Function OnActivate(ObjectReference akActionRef)
	If(self.IsActivationBlocked() && akActionRef == Game.GetPlayer())
		ShowMainMenu()
	EndIf
EndFunction

Function OnPlayerSleepStop(bool abInterrupted, ObjectReference akBed)
	;Putting in waits because Papyrus is still wildly unpredictable when it's fast
	Utility.Wait(0.05)
	Self.UnregisterForPlayerSleep()
	Utility.Wait(0.05)
	self.BlockActivation(true, false)
EndFunction

; Misc Internal Functions ===============================

Function MoveLantern()
	
EndFunction

Function ToggleLantern()
	
	If(HangingLanternRef.IsDisabled())
		HangingLanternRef.Enable(False)
	Else
		HangingLanternRef.Disable(False)
	EndIf
	
EndFunction

Function GoToSleep()
	self.BlockActivation(false, False)
	Self.RegisterForPlayerSleep()
	Utility.Wait(0.02)
	self.Activate(Game.GetPlayer() as ObjectReference, True)
	self.BlockActivation(true, false)	
EndFunction



