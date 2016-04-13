ScriptName CampingKit_IdleMarkerPlayer extends ObjectReference

Bool Property Property01 Auto

Function OnExitFurniture(ObjectReference akActionRef)
	Utility.Wait(0.1)
	Self.BlockActivation(true, False)
EndFunction