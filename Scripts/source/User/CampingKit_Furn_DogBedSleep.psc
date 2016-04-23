ScriptName CampingKit_Furn_DogBedSleep extends ObjectReference

;When used by a dog, their headtracking turns off and they snore

Sound Property DogSleepLoop Auto

Actor PlayerREF
Actor DogUsingBed

Int DogSleepLoopID
Int SnoreTimerID = 1
Int TimeUntilSnore = 3 ;seconds
bool dogSleeping = False

Event OnActivate(ObjectReference akActionRef)
	;debug.Notification(akActionRef + " entering sleep mat")
	
	If(akActionRef != PlayerREF)
		DogUsingBed = akActionRef As Actor
		DogUsingBed.SetHeadTracking(False)
		
		Self.StartTimer(TimeUntilSnore, SnoreTimerID)
	EndIf
EndEvent

Event OnExitFurniture(ObjectReference akActionRef)
	;debug.Notification(akActionRef + " exiting sleep mat")
	If(akActionRef != PlayerREF)
		DogUsingBed = akActionRef As Actor
		DogUsingBed.SetHeadTracking(True)
		StopSleepSound()
		Self.CancelTimer(SnoreTimerID)
	EndIf
EndEvent

Event OnTimer(int aiTimerID)
	If(aiTimerID == SnoreTimerID)
		PlaySleepSound(DogUsingBed)
	EndIf
EndEvent

;== internal functions

Function PlaySleepSound(ObjectReference akSoundRef)
	DogSleepLoopID = DogSleepLoop.Play(akSoundRef)
EndFunction

Function StopSleepSound()
	Sound.StopInstance(DogSleepLoopID)
EndFunction

