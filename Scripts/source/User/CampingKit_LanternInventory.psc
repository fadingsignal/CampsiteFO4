ScriptName CampingKit_LanternInventory extends ObjectReference

Activator Property ActivatorLantern Auto
GlobalVariable Property IsManagingInventory Auto

; Events ===================================

Event OnContainerChanged(ObjectReference akNewContainer, ObjectReference akOldContainer)
	;Only run if it's dropped, not placed into a new container
	If (!akNewContainer && !IsManagingInventory.GetValue() As Bool)
		Game.GetPlayer().PlaceAtMe(ActivatorLantern as Form, 1, True, False, False)
		Self.Delete()
	EndIf
EndEvent