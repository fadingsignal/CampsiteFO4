ScriptName CampingKit_CampfireController extends ObjectReference

;================================================================
; Campsite
; by fadingsignal 2016
; fadingsignalmods@gmail.com
;================================================================

Message Property MenuCampfire01 Auto
Message Property MenuCampfire01CookingPotPlace Auto
Message Property MenuCampfire01CookingPotPickup Auto
Message Property MenuCampfire02 Auto

Message Property MenuCampfireDead01 Auto
Message Property MenuCampfireDead01CookingPotPickup Auto

Message Property MoveMenu01 Auto
Message Property RotateMenu01 Auto
Furniture Property FurnNPCGroundSit Auto
Furniture Property FurnPlayerGroundSit Auto
Furniture Property FurnPlayerWarmHands Auto
Furniture Property FurnPlayerWarmHandsKneel Auto
Furniture Property FurnCookingPot Auto
MiscObject Property CookingPotInventory Auto
MiscObject Property FireKitInventory Auto

Sound Property SoundFireLight Auto
Sound Property SoundFireDestroy Auto

Int SoundFireLightREF
Int SoundFireDestroyREF

Static Property FXSmoke Auto

;Fires -- Using activators because reasons, but they cannot be interacted with
Activator Property CampfireOn Auto
Activator Property CampfireOff Auto

Float Property OffsetHorizontal = 0 Auto

ObjectReference FurnNPCGroundSitRef
ObjectReference FurnCurrentPlayerIdle
ObjectReference FurnCookingPotREF
ObjectReference CampfireOnREF
ObjectReference CampfireOffREF
ObjectReference FXSmokeREF
ObjectReference FXSmokeSmallREF

GlobalVariable Property IsManagingInventory Auto ;Stop inventory objects from running their drop code when removed from inventory
GlobalVariable Property CampfireTimeGameHours Auto ;How long fires burn in game time

Bool IsCookingPotActive = False ;pot placed state
Bool IsFireActive = True ;on or off state

const Int RotationAmountZ = 10
const Int TiltAmount = 2
const Int MoveAmountVertical = 3
const Int MoveAmountHorizontal = 4
const Float SmokeScaleFireOn = 0.5
const Float SmokeScaleFireOff = 0.20

Int TimerFireLitID = 1
Int CampfireDuration ;In-game hours (default 4)

;Placed object offsets from primary controller at 90deg angles
const Int OffsetController = 35
const Int OffsetFireOnBackward = 50
const Int OffsetFireOnRight = 20
const Int OffsetFireOffRight = 0
const Int OffsetNPCIdleForward = 100
const Int OffsetSmokeBackward = 15

camerashot Property myCameraShot Auto

Import CampingKit_UtilityFunctions

; Event Functions ====================================

Function OnInit()

	IsFireActive = True
	CampfireDuration = CampfireTimeGameHours.GetValue() As Int
	
	Actor playerRef = Game.GetPlayer()

	Self.SetPosition(playerRef.X, playerRef.Y, playerRef.Z)
	Self.SetAngle(0, 0, playerRef.GetAngleZ())

	;Nudge our "self" forward
	MoveRelative(Self As ObjectReference, Self As ObjectReference, 0, OffsetController)

	SoundFireLightREF = SoundFireLight.Play(Self)
	
	;Place the relative objects
	FurnNPCGroundSitRef = Self.PlaceAtMe(FurnNPCGroundSit As Form, 1, True, False, False)
	CampfireOnREF = Self.PlaceAtMe(CampfireOn As Form, 1, True, False, False)
	CampfireOffREF = Self.PlaceAtMe(CampfireOff As Form, 1, True, True, False)
	FurnCookingPotREF = Self.PlaceAtMe(FurnCookingPot As Form, 1, True, True, False)
	FXSmokeREF = Self.PlaceAtMe(FXSmoke As Form, 1, True, False, False)
	FXSmokeSmallREF = Self.PlaceAtMe(FXSmoke As Form, 1, True, True, False)
	FXSmokeREF.SetScale(SmokeScaleFireOn)
	FXSmokeSmallREF.SetScale(SmokeScaleFireOff)
	
	;Update their relative positions
	ResetObjectPositions()

	;Countdown to fire burnout
	Self.StartTimerGameTime(CampfireDuration, TimerFireLitID)

EndFunction

Function OnTimerGameTime(int aiTimerID)
	If(aiTimerID == TimerFireLitID)
		DisableFire()
	EndIf
EndFunction

Function OnActivate(ObjectReference akActionRef)

	If(IsFireActive) ;burning fire
	
		If(Game.GetPlayer().GetItemCount(CookingPotInventory) && !IsCookingPotActive)
			ShowMainMenuCookingPotPlace()
		ElseIf(IsCookingPotActive)
			ShowMainMenuCookingPotPickUp()
		Else
			ShowMainMenu()
		EndIf
		
	Else ;dead fire
	
		If(IsCookingPotActive)
			ShowDeadFireMenuWithPot()
		Else
			ShowDeadFireMenuNoPot()
		EndIf
	
	EndIf

EndFunction

; Misc Internal Functions ===============================

Function DisableFire()
	IsFireActive=False
	CampfireOffREF.Enable(True)
	CampfireOnREF.Disable(True)
	
	FXSmokeREF.Disable(True)
	FXSmokeSmallREF.Enable(True)
	
	;Don't allow the player to cook without fire, cooking pot has its own script to handle being blocked
	FurnCookingPotREF.BlockActivation(True, False)
EndFunction

Function ReLightFire()

	If(Game.GetPlayer().GetItemCount(FireKitInventory))

		IsManagingInventory.SetValue(1)
		Utility.Wait(0.05) 
		Game.GetPlayer().RemoveItem(FireKitInventory, 1, False, None)
		Utility.Wait(0.05)
		IsManagingInventory.SetValue(0)

		SoundFireLightREF = SoundFireLight.Play(Self)
		
		IsFireActive=True
		CampfireOffREF.Disable(True)
		CampfireOnREF.Enable(False)
		
		FXSmokeSmallREF.Disable(True)
		FXSmokeREF.Enable(True)
		
		;Unblock the cooking pot now that we have Fire
		FurnCookingPotREF.BlockActivation(False, False)
		
		;Start the timer again
		Self.StartTimerGameTime(CampfireDuration, TimerFireLitID)
	EndIf
EndFunction

Function EnableCookingPot()
	Game.GetPlayer().RemoveItem(CookingPotInventory, 1, False, None)
	FurnCookingPotREF.Enable(False)
	IsCookingPotActive = True
EndFunction

Function DisableCookingPotReturnToInventory()
	Game.GetPlayer().AddItem(CookingPotInventory, 1, False)
	FurnCookingPotREF.Disable(False)
	IsCookingPotActive = False
EndFunction

Function PlayCampfireIdle(Furniture idleToPlay)

	Actor playerRef = Game.GetPlayer()
		
	;Remove any leftover idle mats if they're sitting around
	If(FurnCurrentPlayerIdle)
		FurnCurrentPlayerIdle.Disable(false)
		FurnCurrentPlayerIdle.Delete()
	EndIf
	
	FurnCurrentPlayerIdle = playerRef.PlaceAtMe(idleToPlay As Form, 1, True, False, False)
	FurnCurrentPlayerIdle.SetAngle(0, 0, playerRef.GetAngleZ())
	FurnCurrentPlayerIdle.Activate(playerRef as ObjectReference, False)
	
EndFunction

Function ResetObjectPositions()

	;This is called every time the main activator is moved to re-position everything correctly
	;Each object has different rotation axis and don't rotate together smoothly otherwise

	MoveRelative(CampfireOnREF, Self As ObjectReference, 180, OffsetFireOnBackward)
	MoveRelative(CampfireOnREF, CampfireOnREF, 90, OffsetFireOnRight)
	MoveRelative(FurnCookingPotREF, Self As ObjectReference, 180, OffsetFireOnBackward)
	MoveRelative(FurnCookingPotREF, FurnCookingPotREF, 90, OffsetFireOnRight)
	MoveRelative(CampfireOffREF, Self As ObjectReference, 90, OffsetFireOffRight)
	MoveRelative(FurnNPCGroundSitRef, Self As ObjectReference, 0, OffsetNPCIdleForward)
	MoveRelative(FXSmokeRef, Self As ObjectReference, 180, OffsetSmokeBackward)
	MoveRelative(FXSmokeSmallREF, Self As ObjectReference, 180, OffsetSmokeBackward)

EndFunction

Function ResetObjectZFighting()
	ResetObject(FurnNPCGroundSitRef)
	ResetObject(FXSmokeRef)
	ResetObject(FXSmokeSmallREF)
	
	If(IsFireActive)
		ResetObject(CampfireOnREF)
	Else
		ResetObject(CampfireOffREF)
	EndIf

	If(IsCookingPotActive)
		ResetObject(FurnCookingPotREF)
	EndIf
	
EndFunction

Function PickUp()
	
	SoundFireDestroyREF = SoundFireDestroy.Play(Game.GetPlayer())
	
	;Clean up markers
	FurnNPCGroundSitRef.Disable(false)
	FurnNPCGroundSitRef.Delete()
	
	;Clean up campfires on/off and smoke
	CampfireOnREF.Disable(false)
	CampfireOnREF.Delete()
	
	CampfireOffREF.Disable(false)
	CampfireOffREF.Delete()
	
	FXSmokeREF.Disable(False)
	FXSmokeREF.Delete()
	FXSmokeSmallREF.Disable(False)
	FXSmokeSmallREF.Delete()

	;Leftover player idle mat
	If(FurnCurrentPlayerIdle)
		FurnCurrentPlayerIdle.Disable(false)
		FurnCurrentPlayerIdle.Delete()
	EndIf
	
	;Return cooking pot to inventory if placed or disable invisible pot
	If(IsCookingPotActive)
		DisableCookingPotReturnToInventory()
		FurnCookingPotREF.Delete()
	Else
		FurnCookingPotREF.Disable(False)
		FurnCookingPotREF.Delete()
	EndIf
	
	;Lastly, clean up ourself, the activator controller
	Self.Disable(false)
	Self.Delete()
	
EndFunction

; =====================================================================================
; OMG Menus
; =====================================================================================

; Active Fire Menu Functions ================================

Function ShowMainMenu(Int iButton = 0)
	
	iButton = MenuCampfire01.Show(0, 0, 0, 0, 0, 0, 0, 0, 0)

	If iButton == 0 ;Relax
		ShowIdleMenu()
	ElseIf iButton == 1 ;Extinguish Fire
		PickUp()
	ElseIf iButton == 2 ;Move
		ShowMoveMenu()
	ElseIf iButton == 3 ;Rotate
		ShowRotateMenu()
	ElseIf iButton == 4 ;Do Nothing & Exit
		;Exit
	EndIf
	
EndFunction

Function ShowMainMenuCookingPotPlace(Int iButton = 0)
	iButton = MenuCampfire01CookingPotPlace.Show(0, 0, 0, 0, 0, 0, 0, 0, 0)

	If iButton == 0 ; Place cooking pot
		EnableCookingPot() ;cooking pot method
	ElseIf iButton == 1 ;Relax
		ShowIdleMenu()
	ElseIf iButton == 2 ;Extinguish Fire
		PickUp()
	ElseIf iButton == 3 ;Move
		ShowMoveMenu()
	ElseIf iButton == 4 ;Rotate
		ShowRotateMenu()
	ElseIf iButton == 5 ;Do Nothing & Exit
		;Exit
	EndIf
	
EndFunction

Function ShowMainMenuCookingPotPickUp(Int iButton = 0)
	iButton = MenuCampfire01CookingPotPickup.Show(0, 0, 0, 0, 0, 0, 0, 0, 0)

	If iButton == 0 ; Pick Up cooking pot
		DisableCookingPotReturnToInventory() ;cooking pot method
	ElseIf iButton == 1 ;Relax
		ShowIdleMenu()
	ElseIf iButton == 2 ;Extinguish Fire
		PickUp()
	ElseIf iButton == 3 ;Move
		ShowMoveMenu()
	ElseIf iButton == 4 ;Rotate
		ShowRotateMenu()
	ElseIf iButton == 5 ;Do Nothing & Exit
		;Exit
	EndIf
	
EndFunction


; Dead Fire Menus ===============================

Function ShowDeadFireMenuNoPot(Int iButton = 0)
	
	iButton = MenuCampfireDead01.Show(0, 0, 0, 0, 0, 0, 0, 0, 0)

	If iButton == 0 ;Re-Light Fire (only shows if player has more fire kits)
		ReLightFire() ;Grab another fire kit from the inventory and turn fire back on for 4 hrs
	Elseif iButton == 1 ;Relax
		ShowIdleMenu()
	ElseIf iButton == 2 ;Destroy Fire
		PickUp()
	ElseIf iButton == 3 ;Move
		ShowMoveMenu()
	ElseIf iButton == 4 ;Rotate
		ShowRotateMenu()
	ElseIf iButton == 5 ;Do Nothing & Exit
		;Exit
	EndIf
	
EndFunction

Function ShowDeadFireMenuWithPot(Int iButton = 0)
	
	iButton = MenuCampfireDead01CookingPotPickup.Show(0, 0, 0, 0, 0, 0, 0, 0, 0)

	If iButton == 0 ;Pick Up Cooking Pot
		DisableCookingPotReturnToInventory()
	ElseIf iButton == 1 ;Re-Light Fire (only shows if player has more fire kits)
		ReLightFire() ;Grab another fire kit from the inventory and turn fire back on for 4 hrs
	Elseif iButton == 2 ;Relax
		ShowIdleMenu()
	ElseIf iButton == 3 ;Destroy Fire
		PickUp()
	ElseIf iButton == 4 ;Move
		ShowMoveMenu()
	ElseIf iButton == 5 ;Rotate
		ShowRotateMenu()
	ElseIf iButton == 6 ;Do Nothing & Exit
		;Exit
	EndIf
	
EndFunction

; Shared Menus ===============================

Function ShowIdleMenu(Int iButton = 0)
	iButton = MenuCampfire02.Show(0, 0, 0, 0, 0, 0, 0, 0, 0)

	If iButton == 0 ;SitDown
		PlayCampfireIdle(FurnPlayerGroundSit)
	ElseIf iButton == 1 ;Warm Hands
		PlayCampfireIdle(FurnPlayerWarmHands)
	ElseIf iButton == 2 ;Warm Hands (Kneel)
		PlayCampfireIdle(FurnPlayerWarmHandsKneel)
	ElseIf iButton == 3 ;Do Nothing & Exit
		;empty
	EndIf	
EndFunction

Function ShowMoveMenu(Int iButton = 0)

	iButton = MoveMenu01.Show(0, 0, 0, 0, 0, 0, 0, 0, 0)

	If iButton == 0 ;Up
		;GoToSleep()
		NudgeVertical(Self As ObjectReference, 1, MoveAmountVertical)
		NudgeVertical(FurnNPCGroundSitRef, 1, MoveAmountVertical)
		NudgeVertical(CampfireOnREF, 1, MoveAmountVertical)
		NudgeVertical(CampfireOffREF, 1, MoveAmountVertical)
		NudgeVertical(FurnCookingPotREF, 1, MoveAmountVertical)
		NudgeVertical(FXSmokeRef, 1, MoveAmountVertical)
		;MoveRelative(FurnNPCGroundSitRef, Self As ObjectReference, 0, 135)
		ShowMoveMenu()
	ElseIf iButton == 1 ;Down
		NudgeVertical(Self As ObjectReference, 0, MoveAmountVertical)
		NudgeVertical(FurnNPCGroundSitRef, 0, MoveAmountVertical)
		NudgeVertical(CampfireOnREF, 0, MoveAmountVertical)
		NudgeVertical(CampfireOffREF, 0, MoveAmountVertical)
		NudgeVertical(FurnCookingPotREF, 0, MoveAmountVertical)
		NudgeVertical(FXSmokeRef, 0, MoveAmountVertical)
		;MoveRelative(FurnNPCGroundSitRef, Self As ObjectReference, 0, 135)
		ShowMoveMenu()
	ElseIf iButton == 2 ;Left
		NudgeHorizontal(Self As ObjectReference, 270, MoveAmountHorizontal)
		NudgeHorizontal(FurnNPCGroundSitRef, 270, MoveAmountHorizontal)
		NudgeHorizontal(CampfireOnREF, 270, MoveAmountHorizontal)
		NudgeHorizontal(CampfireOffREF, 270, MoveAmountHorizontal)
		NudgeHorizontal(FurnCookingPotREF, 270, MoveAmountHorizontal)
		NudgeHorizontal(FXSmokeRef, 270, MoveAmountHorizontal)
		;MoveRelative(FurnNPCGroundSitRef, Self As ObjectReference, 0, 135)
		ShowMoveMenu()
		;Function NudgeHorizontal(ObjectReference objectToMove, Float angleToMove, Float distanceToNudge) Global
	ElseIf iButton == 3 ;Right
		NudgeHorizontal(Self As ObjectReference, 90, MoveAmountHorizontal)
		NudgeHorizontal(FurnNPCGroundSitRef, 90, MoveAmountHorizontal)
		NudgeHorizontal(CampfireOnREF, 90, MoveAmountHorizontal)
		NudgeHorizontal(CampfireOffREF, 90, MoveAmountHorizontal)
		NudgeHorizontal(FurnCookingPotREF, 90, MoveAmountHorizontal)
		NudgeHorizontal(FXSmokeRef, 90, MoveAmountHorizontal)
		ShowMoveMenu()
	ElseIf iButton == 4 ;Back
		NudgeHorizontal(Self As ObjectReference, 0, MoveAmountHorizontal)
		NudgeHorizontal(FurnNPCGroundSitRef, 0, MoveAmountHorizontal)
		NudgeHorizontal(CampfireOnREF, 0, MoveAmountHorizontal)
		NudgeHorizontal(CampfireOffREF, 0, MoveAmountHorizontal)
		NudgeHorizontal(FurnCookingPotREF, 0, MoveAmountHorizontal)
		NudgeHorizontal(FXSmokeRef, 0, MoveAmountHorizontal)
		;MoveRelative(FurnNPCGroundSitRef, Self As ObjectReference, 0, 135)
		ShowMoveMenu()
	ElseIf iButton == 5 ;Forward
		NudgeHorizontal(Self As ObjectReference, 180, MoveAmountHorizontal)
		NudgeHorizontal(FurnNPCGroundSitRef, 180, MoveAmountHorizontal)
		NudgeHorizontal(CampfireOnREF, 180, MoveAmountHorizontal)
		NudgeHorizontal(CampfireOffREF, 180, MoveAmountHorizontal)
		NudgeHorizontal(FurnCookingPotREF, 180, MoveAmountHorizontal)
		NudgeHorizontal(FXSmokeRef, 180, MoveAmountHorizontal)
		;MoveRelative(FurnNPCGroundSitRef, Self As ObjectReference, 0, 135)
		ShowMoveMenu()
	ElseIf iButton == 6 ;Done
		;Fixes the z-fighting blur problem with moved objects
		ResetObject(Self As ObjectReference)
		ResetObjectZFighting()
		;Exit
	EndIf	

	;NudgeHorizontal(Self As ObjectReference, 270, 5)
EndFunction

Function ShowRotateMenu(Int iButton = 0)

	iButton = RotateMenu01.Show(0, 0, 0, 0, 0, 0, 0, 0, 0)

	If iButton == 0 ;Forward
		RotateHorizontal(Self As ObjectReference, 270, 2)
		ResetObjectPositions()
		
		;RotateHorizontal(FurnCookingPotREF, 270, 2)
		;MoveRelative(FurnNPCGroundSitRef, Self As ObjectReference, 0, 135)
		ShowRotateMenu()
	ElseIf iButton == 1 ;Back
		RotateHorizontal(Self As ObjectReference, 90, 2)
		
		ResetObjectPositions()		
		;RotateHorizontal(FurnCookingPotREF, 90, 2)
		;MoveRelative(FurnNPCGroundSitRef, Self As ObjectReference, 0, 135)
		ShowRotateMenu()
	ElseIf iButton == 2 ;Left
		RotateHorizontal(Self As ObjectReference, 0, 2)
		
		ResetObjectPositions()
		;RotateHorizontal(FurnCookingPotREF, 0, 2)
		;MoveRelative(FurnNPCGroundSitRef, Self As ObjectReference, 0, 135)
		ShowRotateMenu()
	ElseIf iButton == 3 ;Right
		RotateHorizontal(Self As ObjectReference, 180, 2)
		ResetObjectPositions()
		;RotateHorizontal(FurnCookingPotREF, 180, 2)
		;MoveRelative(FurnNPCGroundSitRef, Self As ObjectReference, 0, 135)
		ShowRotateMenu()
	ElseIf iButton == 4 ;Rotate Z Left
		RotateVertical(Self As ObjectReference, 0, RotationAmountZ)
		ResetObjectPositions()
		;RotateVertical(FurnCookingPotREF, 1, RotationAmountZ)
		;MoveRelative(FurnNPCGroundSitRef, Self As ObjectReference, 0, 135)
		ShowRotateMenu()
	ElseIf iButton == 5 ;Rotate Z Right
		RotateVertical(Self As ObjectReference, 1, RotationAmountZ)
		ResetObjectPositions()
		;RotateVertical(FurnCookingPotREF, 0, RotationAmountZ)
		;MoveRelative(FurnNPCGroundSitRef, Self As ObjectReference, 0, 135)
		ShowRotateMenu()
	ElseIf iButton == 6 ;Reset angle
		ResetAngle(Self As ObjectReference)
		ResetObjectPositions()
		;ResetAngle(FurnCookingPotREF)
		;MoveRelative(FurnNPCGroundSitRef, Self As ObjectReference, 0, 135)
		ShowRotateMenu()
	ElseIf iButton == 7 ;Done
		;Fixes the z-fighting blur problem with moved objects
		ResetObject(Self As ObjectReference)
		ResetObjectZFighting()
		;Exit
	EndIf

EndFunction