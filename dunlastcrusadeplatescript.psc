Scriptname dunLastCrusadePlateSCRIPT extends TrapTriggerBase  
{script for the pressure plates in The Last Crusade}

; //if we're one of the safe tiles to walk on
BOOL PROPERTY bSafe=FALSE AUTO
SPELL PROPERTY spellDmg AUTO

PERK PROPERTY karthLightFoot AUTO

BOOL PROPERTY plateTriggered=FALSE AUTO HIDDEN Conditional		; set to true when the player triggers a plate

BOOL PROPERTY plateSolved=FALSE AUTO HIDDEN Conditional

; //main script variable
dunKarthspirePuzzleMaster mainScript

OBJECTREFERENCE PROPERTY castSource AUTO

OBJECTREFERENCE victim

EVENT onLoad()

	mainScript = castSource AS dunKarthspirePuzzleMaster
	
endEVENT

auto STATE Active
			
	EVENT OnTriggerEnter( objectReference triggerRef )	
; 		;debug.TRACE(self + " has been entered by " + triggerRef)
		objectsInTrigger = self.GetTriggerObjectCount()
		
		IF(triggerRef == game.getPlayer() && game.getPlayer().hasPerk(karthLightFoot))
			playAnimation("Down")
			
		ELSE	

			IF(!plateSolved)
				spellDmg.cast(castSource, triggerRef)
				IF(triggerRef == game.getPlayer())
					game.getPlayer().damageActorValue("Health", 50.0)
				ENDIF
				TriggerSound.play(self)
			ENDIF
			
			playAnimation("Down")
		
		ENDIF
		
	endEVENT
	
	EVENT OnTriggerLeave( objectReference triggerRef )
; 		;debug.TRACE(self + " has been exited by " + triggerRef)
		objectsInTrigger = self.GetTriggerObjectCount()
		if objectsInTrigger == 0
			playAnimation("Up")
		endif
	endEVENT
	
endSTATE

STATE DoNothing			;Dummy state, don't do anything if animating
	EVENT OnTriggerEnter( objectReference triggerRef )	
; 		;debug.TRACE(self + " has been entered by " + triggerRef)
		objectsInTrigger = self.GetTriggerObjectCount()
	endEVENT
	
	EVENT OnTrigger( objectReference triggerRef )	
	ENDEVENT
	
	EVENT OnTriggerLeave( objectReference triggerRef )
; 		;debug.TRACE(self + " has been exited by " + triggerRef)
		objectsInTrigger = self.GetTriggerObjectCount()
		IF(objectsInTrigger == 0)
			goToState ("Inactive")
			playAnimation("Up")
		
		ENDIF
		
	endEVENT
endSTATE
