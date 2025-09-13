class_name CombatMovement
extends Node

enum CombatState {
	IDLE_CENTER,
	PUNCH_RIGHT,
	PUNCH_LEFT,
	DODGE_LEFT,
	DODGE_RIGHT,
	STUN,
	KO
}

var combatStateDict:Dictionary
func _init() -> void:
	var dict={}
	for i in (CombatState.values()):
		var k = CombatState.find_key(i)
		dict[k] = i
	combatStateDict = dict

var indexId:int
var keyName:String
var isCancelMove:bool

var init:CombatState
var initMid_transitionTime:float
var mid:CombatState

#@export var midEnd_transitionTime:float
#@export var end:CombatState
