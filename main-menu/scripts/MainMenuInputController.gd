class_name MainMenuInputController
extends Node

enum InputType {
	CLICK,
	DOUBLE_CLICK,
	LONG_CLICK,
	SWIPE
}

const CLICK_TIME_MIN = 0.025
const CLICK_TIME_MAX = 0.150

const LONG_CLICK_TIME_MIN:float = 0.4



const SWIPE_DISTANCE_MIN:float = 30
const SQUARE_SWIPE_DISTANCE_MIN:float = SWIPE_DISTANCE_MIN * SWIPE_DISTANCE_MIN

var TACTIL_SCREEN_EVENTS:Array = (
	[
		InputEventScreenTouch, 
		InputEventScreenDrag
	]
)


class InputHolder:
	
	static var __inputTypesNames = {}
	
	static var fingersPressingCount:int = 0
	static var fingersReleasedCount:int = 0
	static var fingersDrawingCount:int = 0
	
	var isSendLongClick:bool = false
	var isPressing:bool = false
	var isDrawing:bool = false
	
	var fingerId:int
	var type:InputType
	var typeName:String
	# microseconds
	var initMomentTime:int
	var endMomentTime:int
	var accTimeDuration:float
	var initPosition:Vector2
	var endPosition:Vector2
	
	static func plusOne(current):
		var t = current + 1
		return max(0,t)
	
	static func minusOne(current):
		var t = current - 1
		return max(0,t)
		
	func setType(type:InputType):
		self.type = type
		self.typeName = __inputTypesNames[type]
	pass
		
signal notify_hold_pressing(event:InputHolder)
signal notify_click(position:Vector2)
signal notify_swipe(initPosition:Vector2,endPosition:Vector2)

var runningInputs:Array[InputHolder] = []

func _init() -> void:
	if(InputHolder.__inputTypesNames == null):
		var __inputTypesNames={}
		for i in (InputType.values()):
			var keyName = InputType.find_key(i)
			__inputTypesNames[i] = keyName
			InputHolder.__inputTypesNames = __inputTypesNames
	

func _ready() -> void:
	runningInputs.resize(10)
	for i in len(runningInputs):
		runningInputs[i] = InputHolder.new()
		
func _input(event: InputEvent) -> void:
	
	if(TACTIL_SCREEN_EVENTS.any(func(t): return is_instance_of(event,t))):
		handledTactilScreen(event)
		
func _process(deltaTime: float) -> void:
	
	for event in runningInputs:
		
		if(event.isPressing):
			event.accTimeDuration += deltaTime
			notify_hold_pressing.emit(event)
			if(!event.isSendLongClick):
				event.isSendLongClick = true
			


func handledTactilScreen(event: InputEvent):
	
	if(event is InputEventScreenDrag):
		handledDraw(event)
	
	if(event is InputEventScreenTouch):
		handledTouch(event)
		


func handledTouch(event: InputEventScreenTouch):
	var wrapper = runningInputs[event.index]
	
	
	wrapper.fingerId = event.index + 1
	
	if(event.is_pressed()):
		InputHolder.fingersPressingCount = InputHolder.plusOne(InputHolder.fingersPressingCount)
		InputHolder.fingersReleasedCount = InputHolder.minusOne(InputHolder.fingersReleasedCount)
		wrapper.isPressing = true
		wrapper.initPosition = event.position
		
		wrapper.initMomentTime = Time.get_ticks_msec()
		
		
	if(event.is_released()):
		wrapper.isPressing = false
		wrapper.endPosition = event.position
		wrapper.endMomentTime = Time.get_ticks_msec()
		
		if(event.double_tap):
			pass
		
		if(wrapper.isDrawing):
			
			var distance = (wrapper.endPosition - wrapper.initPosition).length_squared()
			if(distance >= SQUARE_SWIPE_DISTANCE_MIN):
				
				notify_swipe.emit(wrapper.initPosition,wrapper.endPosition)
		
		wrapper.isSendLongClick = false
		wrapper.accTimeDuration = 0
		wrapper.isDrawing = false
		
func handledDraw(event: InputEventScreenDrag):
	var wrapper = runningInputs[event.index]
	wrapper.isDrawing = true
	wrapper.endPosition = event.position 
	InputHolder.fingersDrawingCount = InputHolder.plusOne(InputHolder.fingersDrawingCount)
