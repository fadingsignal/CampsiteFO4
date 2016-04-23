ScriptName CampingKit_UtilityFunctions extends ObjectReference

Function MoveInFrontOfPlayer(ObjectReference objectToMove, Float depthOffset, Float horizontalOffset, Float rotationOffset) Global

	;This is a little bit deprecated, consider replacing it in calling code with the more general MoveRelative
	
	Actor playerRef = Game.GetPlayer()
	Float characterAngle = playerRef.GetAngleZ()
	
	Float playerPosX = playerRef.GetPositionX()
	Float playerPosY = playerRef.GetPositionY()
	Float playerPosZ = playerRef.GetPositionZ()
	
	Float finalOffsetX = depthOffset*Math.Sin(characterAngle)
	Float finalOffsetY = depthOffset*Math.Cos(characterAngle)
	
	;Use SetPosition instead of MoveTo so we can tightly control values
	objectToMove.SetPosition(playerPosX+finalOffsetX, playerPosY+finalOffsetY, playerPosZ)
	
	;objectToMove.MoveTo(playerRef,finalOffsetX, finalOffsetY, 0, True)
	
	;Apply angle offset
	objectToMove.SetAngle(0,0,objectToMove.GetAngleZ()+rotationOffset)

	;Apply position offset
	;objectToMove.SetPosition(objectToMove.GetPositionX()+horizontalOffset, objectToMove.GetPositionY(), objectToMove.GetPositionZ())
EndFunction

Function MoveRelative(ObjectReference objectToMove, ObjectReference targetObject, Float angleToMove, Float distanceToMove) Global
	;Angles are from the perspective of the object, not the player: 0 forward, 180 back, 90 left, 270 right (can't use negative numbers)

	Float offsetX = distanceToMove * Math.Sin(targetObject.GetAngleZ()+angleToMove)
	Float offsetY = distanceToMove * Math.Cos(targetObject.GetAngleZ()+angleToMove)
	
	objectToMove.MoveTo(targetObject, offsetX, offsetY, 0, True)

EndFunction

Function RotateHorizontal(ObjectReference objectToMove, Float angleToMove, Float distanceToNudge) Global
	;NOTE If furniture has a sharper angle than 8.5 degrees +/-, it will not allow the user to activate it :(
	;Baseline for X and Y is always zero (flat)
	
	Float offsetAngleX = distanceToNudge * Math.Sin(objectToMove.GetAngleZ()+angleToMove)
	Float offsetAngleY = distanceToNudge * Math.Cos(objectToMove.GetAngleZ()+angleToMove)
	
	Float finalAngleX = objectToMove.GetAngleX()+offsetAngleX
	Float finalAngleY = objectToMove.GetAngleY()+offsetAngleY
	
	If(finalAngleX > 8 || finalAngleY > 8 || finalAngleX < -8 || FinalAngleY < -8)
		Debug.MessageBox("Maximum usable angle reached.")
	Else
		objectToMove.SetAngle(finalAngleX, finalAngleY, objectToMove.GetAngleZ())
	EndIf
	
EndFunction

Function RotateVertical(ObjectReference objectToMove, Bool direction, Float distanceToRotate) Global

	Float finalOffsetZ = 0

	If(direction)
		finalOffsetZ = objectToMove.GetAngleZ() + distanceToRotate
	Else
		finalOffsetZ = objectToMove.GetAngleZ() - distanceToRotate
	EndIf

	objectToMove.SetAngle(objectToMove.GetAngleX(), objectToMove.GetAngleY(), finalOffsetZ)

EndFunction

Function ResetAngle(ObjectReference objectToReset) Global
	objectToReset.SetAngle(0,0,objectToReset.GetAngleZ())
EndFunction

Function NudgeHorizontal(ObjectReference objectToMove, Float angleToMove, Float distanceToNudge) Global
	;Angles are from the perspective of the object, not the player: 0 forward, 180 back, 90 left, 270 right (can't use negative numbers)

	Float offsetX = distanceToNudge * Math.Sin(objectToMove.GetAngleZ()+angleToMove)
	Float offsetY = distanceToNudge * Math.Cos(objectToMove.GetAngleZ()+angleToMove)
	objectToMove.MoveTo(objectToMove, offsetX, offsetY, 0, True)

EndFunction

Function NudgeVertical(ObjectReference objectToMove, Bool direction, Float distanceToNudge) Global

	Float finalOffsetZ = 0

	If(direction)
		finalOffsetZ = objectToMove.GetPositionZ() + distanceToNudge
	Else
		finalOffsetZ = objectToMove.GetPositionZ() - distanceToNudge
	EndIf

	objectToMove.SetPosition(objectToMove.GetPositionX(), ObjectToMove.GetPositionY(), finalOffsetZ)

EndFunction

Function ResetObject(ObjectReference objectToReset) Global
	;When moving objects, they become blurry due to weird positional z-fighting with the textures
	;Disabling and Enabling the object stops this, so we run this last after our positional changes
	
	objectToReset.Disable(False)
	Utility.Wait(0.02)
	objectToReset.Enable(False)
EndFunction


;Function NudgeLeft(ObjectReference objectToMove, Float distanceToNudge) Global
	;Float offsetX = distanceToNudge * Math.Sin(objectToMove.GetAngleZ()+270)
	;Float offsetY = distanceToNudge * Math.Cos(objectToMove.GetAngleZ()+270)

	;objectToMove.MoveTo(objectToMove, offsetX, offsetY, 0, True)

	;Int gridSize = 5
	;Float objectAngle = objectToMove.GetAngleZ()	
	;objectToMove.MoveTo(objectToMove, gridSize*(Math.Floor(depthOffset*Math.sin(objectAngle) / gridSize + 0.5)), gridSize*(Math.Floor(depthOffset*Math.cos(objectAngle) / gridSize + 0.5)), 0, True)
;EndFunction

;Function NudgeRight()

;EndFunction

;Function NudgeAway()

;EndFunction 

;Function NudgeCloser()

;EndFunction
