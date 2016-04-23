ScriptName CampingKit_SleepingBag extends ObjectReference

Message Property MenuSleepingBag01 Auto
Message Property MoveMenu01 Auto
Message Property RotateMenu01 Auto
MiscObject Property ItemSleepingBag Auto
;Bool Property Property03 Auto
;Bool Property Property04 Auto
;Bool Property Property05 Auto
;Bool Property Property06 Auto

Import CampingKit_UtilityFunctions

Int RotationAmountZ = 6

; Menu Functions ================================

Function ShowMainMenu(Int iButton = 0)
	
	iButton = MenuSleepingBag01.Show(0, 0, 0, 0, 0, 0, 0, 0, 0)

	If iButton == 0 ;Sleep
		GoToSleep()
	ElseIf iButton == 1 ;Pick Up
		PickUp()
	ElseIf iButton == 2 ;Move
		ShowMoveMenu()
	ElseIf iButton == 3 ;Rotate
		ShowRotateMenu()
	ElseIf iButton == 4 ;Do Nothing & Exit
		;Exit
	EndIf
	
EndFunction

Function ShowMoveMenu(Int iButton = 0)

	iButton = MoveMenu01.Show(0, 0, 0, 0, 0, 0, 0, 0, 0)

	If iButton == 0 ;Up
		;GoToSleep()
		NudgeVertical(Self As ObjectReference, 1, 3)
		ShowMoveMenu()
	ElseIf iButton == 1 ;Down
		NudgeVertical(Self As ObjectReference, 0, 3)
		ShowMoveMenu()
	ElseIf iButton == 2 ;Left
		NudgeHorizontal(Self As ObjectReference, 270, 4)
		ShowMoveMenu()
		;Function NudgeHorizontal(ObjectReference objectToMove, Float angleToMove, Float distanceToNudge) Global
	ElseIf iButton == 3 ;Right
		NudgeHorizontal(Self As ObjectReference, 90, 4)
		ShowMoveMenu()
	ElseIf iButton == 4 ;Back
		NudgeHorizontal(Self As ObjectReference, 0, 4)
		ShowMoveMenu()
	ElseIf iButton == 5 ;Forward
		NudgeHorizontal(Self As ObjectReference, 180, 4)
		ShowMoveMenu()
	ElseIf iButton == 6 ;Done
		;Fixes the z-fighting blur problem with moved objects
		ResetObject(Self As ObjectReference)
		;ShowMainMenu()
		;Exit
	EndIf	
	
	;NudgeHorizontal(Self As ObjectReference, 270, 5)
EndFunction

Function ShowRotateMenu(Int iButton = 0)

	iButton = RotateMenu01.Show(0, 0, 0, 0, 0, 0, 0, 0, 0)

	If iButton == 0 ;Forward
		RotateHorizontal(Self As ObjectReference, 270, 2)
		ShowRotateMenu()
	ElseIf iButton == 1 ;Back
		RotateHorizontal(Self As ObjectReference, 90, 2)
		ShowRotateMenu()
	ElseIf iButton == 2 ;Left
		RotateHorizontal(Self As ObjectReference, 0, 2)
		ShowRotateMenu()
	ElseIf iButton == 3 ;Right
		RotateHorizontal(Self As ObjectReference, 180, 2)
		ShowRotateMenu()
	ElseIf iButton == 4 ;Rotate Z Left
		RotateVertical(Self As ObjectReference, 1, RotationAmountZ)
		ShowRotateMenu()
	ElseIf iButton == 5 ;Rotate Z Right
		RotateVertical(Self As ObjectReference, 0, RotationAmountZ)
		ShowRotateMenu()
	ElseIf iButton == 6 ;Reset angle
		ResetAngle(Self As ObjectReference)
		ShowRotateMenu()
	ElseIf iButton == 7 ;Done
		;Fixes the z-fighting blur problem with moved objects
		ResetObject(Self As ObjectReference)
		;ShowMainMenu()
		;Exit
	EndIf

EndFunction

; Event Functions ====================================

Event OnInit()
	Actor playerRef = Game.GetPlayer()
	Self.SetPosition(playerRef.X, playerRef.Y, playerRef.Z)
	MoveRelative(Self as ObjectReference, playerRef, 0, 30)
	Self.SetAngle(0, 0, playerRef.GetAngleZ()+90)
	ResetObject(Self) ;Because z-fighting blur happens otherwise >:|
	;Self.MoveToNearestNavMeshLocation()
	self.BlockActivation(true, false)	
EndEvent

Event OnActivate(ObjectReference akActionRef)
	If(self.IsActivationBlocked() && akActionRef == Game.GetPlayer())
		ShowMainMenu()
	EndIf
EndEvent

Event OnPlayerSleepStop(bool abInterrupted, ObjectReference akBed)
	;Putting in waits because Papyrus is still wildly unpredictable when it's fast
	Utility.Wait(0.02)
	Self.UnregisterForPlayerSleep()
	Utility.Wait(0.02)
	self.BlockActivation(true, false)
EndEvent

; Misc Internal Functions ===============================

Function GoToSleep()
	self.BlockActivation(false, False)
	Utility.Wait(0.1)
	Self.RegisterForPlayerSleep()
	Utility.Wait(0.1)
	self.Activate(Game.GetPlayer() as ObjectReference, True)
	self.BlockActivation(true, false)	
EndFunction

Function PickUp()
	Self.Disable(false)
	Self.Delete()
	Game.GetPlayer().AddItem(ItemSleepingBag, 1, false)
EndFunction
