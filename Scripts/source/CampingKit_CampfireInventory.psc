ScriptName CampingKit_CampfireInventory extends ObjectReference

Activator Property ActivatorCampfireSmall Auto
GlobalVariable Property IsManagingInventory Auto

; Events ===================================

Function OnContainerChanged(ObjectReference akNewContainer, ObjectReference akOldContainer)	
	If (!akNewContainer && !IsManagingInventory.GetValue() As Bool)
		Game.GetPlayer().PlaceAtMe(ActivatorCampfireSmall as Form, 1, True, False, False)
		Self.Delete()
	EndIf
EndFunction
