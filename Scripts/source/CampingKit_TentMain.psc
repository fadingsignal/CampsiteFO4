ScriptName CampingKit_TentMain extends ObjectReference

Message Property MenuTent01 Auto
Message Property MenuTent01a_LanternPlace Auto
Message Property MenuTent01b_LanternPickup Auto
Message Property MoveMenu01 Auto
Message Property RotateMenu01 Auto

MiscObject Property ItemTent Auto
MiscObject Property LanternInventory Auto

Sound Property SoundTentPlace Auto
Sound Property SoundTentPickUp Auto

Int SoundTentPlaceREF
Int SoundTentPickUpREF

Float Property OffsetDistance Auto
Float Property OffsetRotation Auto
Float Property OffsetHorizontal = 0 Auto
Float Property LanternOffsetHeight = 0 Auto
Float Property LanternOffsetAngle = 0 Auto
Float Property LanternOffsetDistance = 0 Auto

Activator Property HangingLantern Auto
ObjectReference HangingLanternREF

GlobalVariable Property IsManagingInventory Auto

Int RotationAmountZ = 8
Bool IsLanternActive = False
Import CampingKit_UtilityFunctions

; Menu Functions ================================

Function ShowMainMenu(Int iButton = 0)
	
	iButton = MenuTent01.Show(0, 0, 0, 0, 0, 0, 0, 0, 0)

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

Function ShowMainMenuLanternPlace(Int iButton = 0)
	
	iButton = MenuTent01a_LanternPlace.Show(0, 0, 0, 0, 0, 0, 0, 0, 0)

	If iButton == 0 ;Sleep
		GoToSleep()
	ElseIf iButton == 1 ;Pick Up
		PickUp()
	ElseIf iButton == 2 ;Lantern place
		EnableLantern()
	ElseIf iButton == 3 ;Move
		ShowMoveMenu()
	ElseIf iButton == 4 ;Rotate
		ShowRotateMenu()
	ElseIf iButton == 5 ;Do Nothing & Exit
		;Exit
	EndIf
	
EndFunction

Function ShowMainMenuLanternPickup(Int iButton = 0)
	
	iButton = MenuTent01b_LanternPickup.Show(0, 0, 0, 0, 0, 0, 0, 0, 0)

	If iButton == 0 ;Sleep
		GoToSleep()
	ElseIf iButton == 1 ;Pick Up
		PickUp()
	ElseIf iButton == 2 ;Lantern pickup
		DisableLantern()
	ElseIf iButton == 3 ;Move
		ShowMoveMenu()
	ElseIf iButton == 4 ;Rotate
		ShowRotateMenu()
	ElseIf iButton == 5 ;Do Nothing & Exit
		;Exit
	EndIf
	
EndFunction


Function ShowMoveMenu(Int iButton = 0)

	iButton = MoveMenu01.Show(0, 0, 0, 0, 0, 0, 0, 0, 0)

	If iButton == 0 ;Up
		;GoToSleep()
		NudgeVertical(Self As ObjectReference, 1, 3)
		NudgeVertical(HangingLanternREF, 1, 3)
		ShowMoveMenu()
	ElseIf iButton == 1 ;Down
		NudgeVertical(Self As ObjectReference, 0, 3)
		NudgeVertical(HangingLanternREF, 0, 3)
		ShowMoveMenu()
	ElseIf iButton == 2 ;Left
		NudgeHorizontal(Self As ObjectReference, 270, 4)
		NudgeHorizontal(HangingLanternREF, 270, 4)
		ShowMoveMenu()
		;Function NudgeHorizontal(ObjectReference objectToMove, Float angleToMove, Float distanceToNudge) Global
	ElseIf iButton == 3 ;Right
		NudgeHorizontal(Self As ObjectReference, 90, 4)
		NudgeHorizontal(HangingLanternREF, 90, 4)
		ShowMoveMenu()
	ElseIf iButton == 4 ;Back
		NudgeHorizontal(Self As ObjectReference, 0, 4)
		NudgeHorizontal(HangingLanternREF, 0, 4)
		ShowMoveMenu()
	ElseIf iButton == 5 ;Forward
		NudgeHorizontal(Self As ObjectReference, 180, 4)
		NudgeHorizontal(HangingLanternREF, 180, 4)
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
		RotateHorizontal(HangingLanternREF, 270, 2)
		ShowRotateMenu()
	ElseIf iButton == 1 ;Back
		RotateHorizontal(Self As ObjectReference, 90, 2)
		RotateHorizontal(HangingLanternREF, 90, 2)
		ShowRotateMenu()
	ElseIf iButton == 2 ;Left
		RotateHorizontal(Self As ObjectReference, 0, 2)
		RotateHorizontal(HangingLanternREF, 0, 2)
		ShowRotateMenu()
	ElseIf iButton == 3 ;Right
		RotateHorizontal(Self As ObjectReference, 180, 2)
		RotateHorizontal(HangingLanternREF, 180, 2)
		ShowRotateMenu()
	ElseIf iButton == 4 ;Rotate Z Left
		RotateVertical(Self As ObjectReference, 0, RotationAmountZ)
		RotateVertical(HangingLanternREF, 1, 3)
		ShowRotateMenu()
	ElseIf iButton == 5 ;Rotate Z Right
		RotateVertical(Self As ObjectReference, 1, RotationAmountZ)
		RotateVertical(HangingLanternREF, 0, 3)
		ShowRotateMenu()
	ElseIf iButton == 6 ;Reset angle
		ResetAngle(Self As ObjectReference)
		ResetAngle(HangingLanternRef)
		ShowRotateMenu()
	ElseIf iButton == 7 ;Done
		;Fixes the z-fighting blur problem with moved objects
		ResetObject(Self As ObjectReference)
		
		HangingLanternREF.MoveTo(Self, 0,0, LanternOffsetHeight, True)
			
		If(LanternOffsetDistance>0)
			MoveRelative(HangingLanternREF, HangingLanternREF, LanternOffsetAngle, LanternOffsetDistance)
		EndIf
		
		;ShowMainMenu()
		;Exit
	EndIf

EndFunction

; Event Functions ====================================

Function OnInit()
	Actor playerRef = Game.GetPlayer()

	Self.SetPosition(playerRef.X, playerRef.Y, playerRef.Z)
	Self.SetAngle(0, 0, playerRef.GetAngleZ())

	;TODO this could use some cleanup, ditch the MoveInFrontOfPlayer method, use NudgeVertical for hanging lamp etc.
	
	;Global function in the utility 'class' 
	MoveInFrontOfPlayer(Self as ObjectReference, OffsetDistance, OffsetHorizontal, OffsetRotation)
	
	SoundTentPlaceREF = SoundTentPlace.Play(Self)
	
	;Attach our lamp
	HangingLanternREF = Self.PlaceAtMe(HangingLantern As Form, 1, True, True, False)

	;test node stuff (works!)
	;HangingLanternREF.SetAngle(0,0,playerRef.GetAngleZ())
	;Utility.Wait(3)
	;HangingLanternREF.MoveToNode(Self, "LanternNode", "")

	HangingLanternREF.MoveTo(Self, 0,0, LanternOffsetHeight, True)
	
	If(LanternOffsetDistance>0)
		MoveRelative(HangingLanternREF, HangingLanternREF, LanternOffsetAngle, LanternOffsetDistance)
	EndIf
	
	;HangingLanternREF.SetPosition(HangingLanternREF.GetPositionX(), HangingLanternREF.GetPositionY(), HangingLanternRef.GetPositionZ()+LanternOffsetHeight)

	self.BlockActivation(true, false)	
EndFunction

Function OnActivate(ObjectReference akActionRef)
	If(self.IsActivationBlocked() && akActionRef == Game.GetPlayer())
		
		If(Game.GetPlayer().GetItemCount(LanternInventory) && !IsLanternActive)
			ShowMainMenuLanternPlace()
		ElseIf(IsLanternActive)
			ShowMainMenuLanternPickup()
		Else
			ShowMainMenu()
		EndIf
		
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

Function EnableLantern()
	
	If(Game.GetPlayer().GetItemCount(LanternInventory))
	
		IsManagingInventory.SetValue(1)
		Utility.Wait(0.05)
		Game.GetPlayer().RemoveItem(LanternInventory, 1, False, None)
		Utility.Wait(0.05)
		IsManagingInventory.SetValue(0)
		
		IsLanternActive=True
		HangingLanternREF.Enable(False)
	
	EndIf
	
EndFunction

Function DisableLantern()
	IsLanternActive=False
	HangingLanternREF.Disable(False)
	Game.GetPlayer().AddItem(LanternInventory, 1, False)
EndFunction

Function ToggleObjectVisibility(ObjectReference objectToToggle)
	If(objectToToggle.IsDisabled())
		objectToToggle.Enable(False)
	Else
		objectToToggle.Disable(False)
	EndIf
EndFunction

Function GoToSleep()
	self.BlockActivation(false, False)
	Self.RegisterForPlayerSleep()
	Utility.Wait(0.02)
	self.Activate(Game.GetPlayer() as ObjectReference, True)
	self.BlockActivation(true, false)	
EndFunction

Function PickUp()

	SoundTentPickUpREF = SoundTentPickUp.Play(Game.GetPlayer())

	Self.Disable(false)
	Self.Delete()
	
	If(IsLanternActive)
		DisableLantern()
	Else
		HangingLanternREF.Disable(false)
	EndIf
	
	HangingLanternREF.Delete()
	
	Game.GetPlayer().AddItem(ItemTent, 1, false)
	
EndFunction

