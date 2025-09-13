class_name CombatMovementBuilder

var __indexId:int
var __keyName:String
var __isCancelMove:bool
var __init:CombatMovement.CombatState
var __initMid_transitionTime:float
var __mid:CombatMovement.CombatState
#@export var midEnd_transitionTime:float
#@export var end:CombatState

func setIndexId(index:int) -> CombatMovementBuilder:
	self.__indexId = index
	return self

func setKeyName(key_name:String) -> CombatMovementBuilder:
	self.__keyName = key_name
	return self

func setIsCancelMove(is_cancel:bool) -> CombatMovementBuilder:
	self.__isCancelMove = is_cancel
	return self

func setInitMovement(init_state:CombatMovement.CombatState) -> CombatMovementBuilder:
	self.__init = init_state
	return self

func setInitMidTransitionTime(transition_time:float) -> CombatMovementBuilder:
	self.__initMid_transitionTime = transition_time
	return self

func setMidMovement(mid_state:CombatMovement.CombatState) -> CombatMovementBuilder:
	self.__mid = mid_state
	return self
	
func build() -> CombatMovement:
	var movement = CombatMovement.new()
	
	movement.indexId = self.__indexId
	movement.keyName = self.__keyName
	movement.isCancelMove = self.__isCancelMove
	movement.init = self.__init
	movement.initMid_transitionTime = self.__initMid_transitionTime
	movement.mid = self.__mid
	
	return movement
