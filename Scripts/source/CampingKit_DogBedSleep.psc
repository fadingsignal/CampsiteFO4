ScriptName CampingKit_DogBedSleep extends ObjectReference

Message Property MenuDogBed01 Auto
Message Property MoveMenu01 Auto
Message Property RotateMenu01 Auto
Message Property MessageDogMeatTooFar Auto
Sound Property DogSleepLoop Auto

Sound Property PlayerGreetDogmeatFemale Auto
Sound Property PlayerGreetDogmeatMale Auto

MiscObject Property ItemDogBed Auto
Int DogSleepLoopID
Int SnoreTimerID = 1
Int TimeUntilSnore = 3 ;seconds

Actor PlayerREF
Actor DogUsingBed

bool dogSleeping = False

Int RotationAmountZ = 10

Idle Property PairedDogmeatHumanGreetPetKneel Auto mandatory
ReferenceAlias Property Alias_Dogmeat Auto

Import CampingKit_UtilityFunctions

Function OnInit()
	 PlayerREF = Game.GetPlayer()
	Self.BlockActivation(True, False)
	Self.SetPosition(playerRef.X, playerRef.Y, playerRef.Z)
	MoveRelative(Self as ObjectReference, playerRef, 0, 30)
	Self.SetAngle(0, 0, playerRef.GetAngleZ()+90)
	ResetObject(Self)
EndFunction

Function OnActivate(ObjectReference akActionRef)
	;debug.Notification(akActionRef + " entering sleep mat")
	
	If(akActionRef != PlayerREF)
		DogUsingBed = akActionRef As Actor
		DogUsingBed.SetHeadTracking(False)
		
		Self.StartTimer(TimeUntilSnore, SnoreTimerID)
	EndIf

	If(akActionRef == PlayerREF)
		ShowMainMenu()
	EndIf
EndFunction

Function PlaySleepSound(ObjectReference akSoundRef)
	DogSleepLoopID = DogSleepLoop.Play(akSoundRef)
EndFunction

Function StopSleepSound()
	Sound.StopInstance(DogSleepLoopID)
EndFunction

Function OnTimer(int aiTimerID)
	If(aiTimerID == SnoreTimerID)
		PlaySleepSound(DogUsingBed)
	EndIf
EndFunction

Function OnExitFurniture(ObjectReference akActionRef)
	;debug.Notification(akActionRef + " exiting sleep mat")
	If(akActionRef != PlayerREF)
		DogUsingBed = akActionRef As Actor
		DogUsingBed.SetHeadTracking(True)
		StopSleepSound()
		Self.CancelTimer(SnoreTimerID)
	EndIf
EndFunction


; Internal Functions ========================================================================================

Function PickUp()
	Self.Disable(false)
	Self.Delete()
	Game.GetPlayer().AddItem(ItemDogBed, 1, false)
EndFunction

Function PetDogmeat()
	;ObjectReference dogMeatAlias = Alias_Dogmeat.GetActorRef()
	;dogMeatAlias.IsCompanionAndFollowing(Game.GetPlayer())
	
	;Is Dogmeat our follower?
	;If yes, is he close
	
	If(DogSleepLoopID)
		StopSleepSound()
	EndIf
		
	Int GreetMaleID
	Int GreetFemaleID
	
	If (PlayerREF.GetDistance(Alias_Dogmeat.getActorRef()) <= 300)
	
		Self.Disable(False) ;Eject the dog out of the furniture hopefully
		Self.Enable(False)
	
		PlayerREF.playIdleWithTarget(PairedDogmeatHumanGreetPetKneel, Alias_Dogmeat.getActorRef() as ObjectReference)
		
		If ((PlayerREF.GetBaseObject() as ActorBase).GetSex() == 1)
			GreetFemaleID = PlayerGreetDogmeatFemale.play(PlayerREF)
		Else
			GreetMaleID = PlayerGreetDogmeatMale.play(PlayerREF)
		EndIf		
		
	Else
		debug.Notification(MessageDogMeatTooFar)
	EndIf
EndFunction

; Menu Functions ==========================================================================================

Function ShowMainMenu(Int iButton = 0)
	
	iButton = MenuDogBed01.Show(0, 0, 0, 0, 0, 0, 0, 0, 0)

	If iButton == 0 ;Pick Up
		PickUp()
	ElseIf iButton == 1 ;Move
		ShowMoveMenu()
	ElseIf iButton == 2 ;Rotate
		ShowRotateMenu()
	ElseIf iButton == 3 ;Pet Dogmeat
		PetDogmeat()
	ElseIf iButton == 3 ;Do Nothing & Exit
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
		;Exit
	EndIf

EndFunction