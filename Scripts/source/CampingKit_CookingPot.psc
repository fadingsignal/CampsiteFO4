ScriptName CampingKit_CookingPot extends ObjectReference

Message Property MessageCantCook Auto

Import CampingKit_UtilityFunctions

Function OnActivate(ObjectReference akActionRef)
	If(self.IsActivationBlocked() && akActionRef == Game.GetPlayer())
		MessageCantCook.Show(0, 0, 0, 0, 0, 0, 0, 0, 0)
		;debug.Notification(MessageCantCook)
	EndIf
EndFunction
