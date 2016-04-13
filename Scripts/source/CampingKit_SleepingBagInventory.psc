ScriptName CampingKit_SleepingBagInventory extends ObjectReference

Furniture Property FurnitureSleepingBag Auto
;Bool Property Property02 Auto
;Bool Property Property03 Auto

; Events ===================================

Function OnContainerChanged(ObjectReference akNewContainer, ObjectReference akOldContainer)
	;Only run if it's dropped, not placed into a new container
	If (!akNewContainer)
		Game.GetPlayer().PlaceAtMe(FurnitureSleepingBag as Form, 1, True, False, False)
		Self.Delete()
	EndIf
EndFunction
