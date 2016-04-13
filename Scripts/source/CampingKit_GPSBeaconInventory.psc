ScriptName CampingKit_GPSBeaconInventory extends ObjectReference

Activator Property ActivatorGPSBeacon Auto

; Events ===================================

Function OnContainerChanged(ObjectReference akNewContainer, ObjectReference akOldContainer)
	;Only run if it's dropped, not placed into a new container
	If (!akNewContainer)
		Game.GetPlayer().PlaceAtMe(ActivatorGPSBeacon as Form, 1, True, False, False)
		Self.Delete()
	EndIf
EndFunction
