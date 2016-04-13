ScriptName CampingKit_Divider extends ObjectReference

Message Property MenuDivider01 Auto
Message Property MoveMenu01 Auto
Message Property RotateMenu01 Auto
MiscObject Property ItemDivider Auto

Import CampingKit_UtilityFunctions

Int RotationAmountZ = 6

; Menu Functions ================================

Function ShowMainMenu(Int iButton = 0)
	
	iButton = MenuDivider01.Show(0, 0, 0, 0, 0, 0, 0, 0, 0)

	If iButton == 0 ;Pick Up
		PickUp()
	ElseIf iButton == 1 ;Move
		ShowMoveMenu()
	ElseIf iButton == 2 ;Rotate
		ShowRotateMenu()
	ElseIf iButton == 3 ;Do Nothing & Exit
		;empty
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

Function OnInit()
	;Self.SetScale(0.7) ;because no matter what I do the collision mesh in the NIF stays the same >:|
	Actor playerRef = Game.GetPlayer()
	Self.SetPosition(playerRef.X, playerRef.Y, playerRef.Z)
	MoveRelative(Self as ObjectReference, playerRef, 0, 45)
	Self.SetAngle(0, 0, (playerRef.GetAngleZ()+90))
	;Function MoveRelative(ObjectReference objectToMove, ObjectReference targetObject, Float angleToMove, Float distanceToMove) Global
	self.BlockActivation(true, false)	
EndFunction

Function OnActivate(ObjectReference akActionRef)
	If(akActionRef == Game.GetPlayer())
		ShowMainMenu()
	EndIf
EndFunction

; Misc Internal Functions ===============================

Function PickUp()
	Self.Disable(false)
	Self.Delete()
	Game.GetPlayer().AddItem(ItemDivider, 1, false)
EndFunction
