
;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 7
Scriptname QF_TheLastCrusadeQuest_02005D28 Extends Quest Hidden

;BEGIN ALIAS PROPERTY GrailDiary
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_GrailDiary Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Cave
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Cave Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Knight
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Knight Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_3
Function Fragment_3()
;BEGIN CODE
SetObjectiveCompleted(20)
SetObjectiveDisplayed(30)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN CODE
SetObjectiveCompleted(10)
SetObjectiveDisplayed(20)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_4
Function Fragment_4()
;BEGIN CODE
SceneWin.Start()

SetObjectiveCompleted(30)

; Perk LastCrusadeReward as LastCrusadeReward

Utility.Wait(12.0)

Game.GetPlayer().AddPerk( LastCrusadeReward)

Game.GetPlayer().moveto(Exit)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_5
Function Fragment_5()
;BEGIN CODE
SceneToStart.Start()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_1
Function Fragment_1()
;BEGIN CODE
SetObjectiveDisplayed(10)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
; Start the quest

Alias_GrailDiary.ForceRefTo(Game.GetPlayer().PlaceAtMe(Diary))

(WICourier as WICourierScript).addAliasToContainer(Alias_GrailDiary)
 
Debug.MessageBox("COURIER - LAST CRUSADE")
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Quest Property WICourier  Auto  

Book Property Diary  Auto  

Perk Property LastCrusadeReward  Auto  

Scene Property SceneToStart  Auto  

Scene Property SceneWin  Auto  

ObjectReference Property Exit  Auto  
