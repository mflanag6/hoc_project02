Scriptname LastCrusadeCourierScript extends Quest

import Utility

ReferenceAlias Property CourierCellMarker Auto

ReferenceAlias Property Courier Auto

ReferenceAlias Property ContainerAlias Auto

GlobalVariable Property LastCrusadeCourierCount Auto

Bool Function DisableDeliveries(Bool DisableMe = True) ; Allows you to turn off deliveries, in case
; you want to fiddle with the containers and courier settings without interruption.
    If DisableMe
        While GetState() != "Waiting" ; wait until the courier is finished with any deliveries.
; Just want to make sure it stays disabled once it is.
        EndWhile
        GoToState("Disabled")
        return True
    else
;Debug.Notification("Enabling Courier")
        GoToState("Waiting") ; Courier will enable itself when it has something to deliver.
        Return False
    endif
EndFunction

function addItemToContainer(form FormToAdd, int countToAdd = 1)
    ContainerAlias.GetRef().addItem(FormToAdd, countToAdd) ;add parameter object to container
    LastCrusadeCourierCount.Value += 1
endFunction
 
function addRefToContainer(objectReference objectRefToAdd)
    ContainerAlias.GetRef().addItem(objectRefToAdd) ;add parameter object to container
    LastCrusadeCourierCount.Value += 1
endFunction
 
function addAliasToContainer(ReferenceAlias refAliasToAdd)
    addRefToContainer(( refAliasToAdd.getRef() as ObjectReference))
EndFunction
 
function GiveItemsToPlayer()
    LastCrusadeCourierCount.SetValue(0)
    ContainerAlias.GetRef().RemoveAllItems(Game.GetPlayer())
    Debug.Notification("Item(s) Added.")
EndFunction

ObjectReference Function FindBeaminLocation() 
 
; Used if we are not in an area with preset courier spawn points. Release 3 bouncers
 
    ObjectReference PlaceTarget = Game.GetPlayer().PlaceAtMe(MarkerType,1)
    ObjectReference[] Bouncer = new ObjectReference[3]
    PlaceTarget.MoveTo(Game.GetPlayer(),5000.0,5000.0,5000.0)
    Bouncer[0] = PlaceTarget.PlaceAtme(BouncerType,1)
    PlaceTarget.MoveTo(Game.GetPlayer(),-5000.0,-5000.0,5000.0)
    Bouncer[1] = PlaceTarget.PlaceAtme(BouncerType,1)
    PlaceTarget.MoveTo(Game.GetPlayer(),-5000.0,5000.0,5000.0) ; Place them at 3 corners of a square.
    Bouncer[2] = PlaceTarget.PlaceAtme(BouncerType,1)
    Wait(5.0) ; Let them fall to the ground. We don't want to bounce our poor courier around too much.
    ObjectReference sorthold
    if Game.GetPlayer().GetDistance(Bouncer[0]) > Game.GetPlayer().GetDistance(Bouncer[2])
        SortHold = Bouncer[2]
        Bouncer[2] = Bouncer[0]
        Bouncer[0] = SortHold
    endif
    if Game.GetPlayer().GetDistance(Bouncer[0]) > Game.GetPlayer().GetDistance(Bouncer[1])
        SortHold = Bouncer[0]
        Bouncer[0] = Bouncer[1]
        Bouncer[1] = SortHold
    endif
    if Game.GetPlayer().GetDistance(Bouncer[1]) > Game.GetPlayer().GetDistance(Bouncer[2])
        SortHold = Bouncer[2]
        Bouncer[2] = Bouncer[1]
        Bouncer[1] = SortHold
    endif
    ObjectReference Loc1 = Bouncer[0]
    ObjectReference Loc2 = Bouncer[1]
    ObjectReference Loc3 = Bouncer[2]
    ObjectReference BILoc
 
    if Loc3 && Loc3.GetDistance(Game.GetPlayer()) <= 10000.0 ; Didn't fall through the world
                    BiLoc = Loc3
    endif
    if !BiLoc && Loc2 && Loc2.GetDistance(Game.GetPlayer()) <= 10000.0 ; Ditto previous comment
                    BiLoc = Loc2
    endif
    if !BiLoc
            BiLoc = Loc1
    endif
    return BiLoc
EndFunction
 
Function StateChange(String Which)
    GoToState(Which)
EndFunction

Bool Updating = False
 
Event OnUpdate()
    GoToState("Waiting") ; Starts us in the waiting state, in case we somehow got in the empty state.
EndEvent
 
State Waiting
    Event OnUpdate() ; Make sure all variables are reset.
    Updating = False
    WhereToGo = None
           Courier.Getref().MoveTo(CourierCellMarker.GetRef())
    Courier.GetRef().Disable()
            If LastCrusadeCourierCount.value >= 1.0
        SetStage(100)
            endif
    EndEvent
EndState
 
State Seeking
   Event OnUpdate() ; First, find a map marker near the player.
 
    if Courier.GetRef().GetDistance(Game.GetPlayer()) <= 500.0
        WhereToGo = None ; Clear out the property for the next delivery.
        SetStage(200)
    elseif Courier.GetRef().IsEnabled() && Courier.GetRef().GetDistance(Game.GetPlayer()) > 30000.0 
; Player has eluded the courier. Put it away.
        WhereToGo = None ; If at first you don't succeed...
            Courier.Getref().MoveTo(CourierCellMarker.GetRef())
            Courier.Getref().Disable() ; Go to sleep until the next update cycle.
    endif
    if !Updating && Courier.Getref().IsDisabled()
; Courier is not in the world yet, and we're not already trying to place one.
        Updating = True
        If !WhereToGo ; If we haven't updated yet this delivery
            if ReloadOptionals.IsRunning()
                ReloadOptionals.Stop()
                Wait (1.0)
            Endif
            ReloadOptionals.Start() 
; Force a reload of the optional aliases in case we're in a city cell.
            ReloadOptionals.SetStage(0)
            Wait(2.0)
        endif
        ObjectReference Loc1 = Gvar.Near
        ObjectReference Loc2 = Gvar.Mid
        ObjectReference Loc3 = Gvar.Far
        if Loc3
            WhereToGo = Loc3
        endif
        if Loc2 && (!Loc3 || (Loc3 && Game.GetPlayer().GetDistance(Loc3) > 10000.0))
            WhereToGo = Loc2
        endif
        if Loc1 && (!Loc2 || (Loc2 && Game.GetPlayer().GetDistance(Loc2) > 10000.0))
            WhereToGo = Loc1
        Endif
 
        if !WhereToGo || Game.GetPlayer().GetDistance(WhereToGo) < 900.0 
; No location found yet, or it's too close. (Player is in a cell with no viable markers)
            WhereToGo = FindBeaminLocation()
            if WhereToGo ; Found a spot!
                Courier.Getref().MoveTo(WhereToGo)
                Courier.Getref().Enable()
            endif
        else
            Courier.Getref().MoveTo(WhereToGo)
            Courier.Getref().Enable()
        endif
        Updating = False
    endif
 
;float DeltaX = Game.GetPlayer().X - Courier.GetRef().X
;float DeltaY = Game.GetPlayer().Y - Courier.GetRef().Y
;float DeltaZ = Game.GetPlayer().Z - Courier.GetRef().Z
 
;Debug.Notification("Courier Seeking: "+DeltaX+","+DeltaY+","+DeltaZ) 
; Show the player where the courier is for testing.
 
   EndEvent
EndState
 
 
State Delivering
    Event OnUpdate()
            If LastCrusadeCourierCount.value == 0
                    SetStage(300)
            endif
    EndEvent
EndState
 
 
State Departing
    Event OnUpdate()
; Debug.Notification("Courier Leaving")
            If !Game.GetPlayer().HasLOS(Courier.GetRef())
               Courier.Getref().MoveTo(CourierCellMarker.GetRef())
               Courier.Getref().Disable()
               Updating = False
               SetStage(0)
            endif
    EndEvent
EndState
 
State Disabled
 
    Event OnUpdate() ; Courier is out. Come back later.
;        Debug.Notification("Courier Disabled")
    EndEvent
 
EndState
 
ObjectReference Property WhereToGo Auto
Activator Property BouncerType Auto
Activator property MarkerType Auto
Quest Property ReloadOptionals  Auto  
 
CourierSpawnPoint Property Gvar Auto