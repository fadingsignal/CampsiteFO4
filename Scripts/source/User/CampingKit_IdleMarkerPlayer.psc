ScriptName CampingKit_IdleMarkerPlayer extends ObjectReference

Bool Property Property01 Auto

Event OnExitFurniture(ObjectReference akActionRef)
	Utility.Wait(0.1)
	Self.BlockActivation(true, False)
EndEvent