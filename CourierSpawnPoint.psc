Scriptname CourierSpawnPoint extends Quest  
 
ObjectReference Property Near Auto
ReferenceAlias Property aNear Auto
 
ObjectReference Property Mid Auto
ReferenceAlias Property aMid Auto
 
ObjectReference Property Far Auto
ReferenceAlias Property aFar Auto
 
Event OnInit()
	Utility.Wait(5.0)
	Near = aNear.GetRef()
	Mid = aMid.GetRef()
	far = aFar.GetRef()
EndEvent