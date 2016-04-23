ScriptName CampingKit_CookingPot extends ObjectReference

Message Property MessageCantCook Auto

Import CampingKit_UtilityFunctions

Event OnActivate(ObjectReference akActionRef)
	If(self.IsActivationBlocked() && akActionRef == Game.GetPlayer())
		MessageCantCook.Show(0, 0, 0, 0, 0, 0, 0, 0, 0)
		;debug.Notification(MessageCantCook)
	EndIf
EndEvent