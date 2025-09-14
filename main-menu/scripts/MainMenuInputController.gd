class_name MainMenuInputController
extends Node

enum InputType {
	CLICK,
	DOBLE_CLICK,
	LONG_CLICK,
	SWIPE
}

const CLICK_TIME_MIN = 0.025
const CLICK_TIME_MAX = 0.150

const LONG_CLICK_TIME_MIN:float = 0.4

const DOUBLE_CLICK_TIME_MAX:float = 0.2

const SWIPE_DISTANCE_MIN:float = 30
const SQUARE_SWIPE_DISTANCE_MIN:float = SWIPE_DISTANCE_MIN * SWIPE_DISTANCE_MIN

var TACTIL_SCREEN_EVENTS:Array = (
	[
		InputEventScreenTouch, 
		InputEventScreenDrag
	]
)


class InputWrapper:
	static var inputTypesNames={}
	var type:InputType
	var typeName:String
	
	var pressDuration:float = 0
	var emited:bool = false
	var continueAddingTime:bool = false
	var isPrssing:bool = false
	
	var isDrawing:bool = false
	var initPosition:Vector2
	var endPosition:Vector2
	
	
	func setType(type:InputType):
		self.type = type
		self.typeName = inputTypesNames[type]
	pass
		
signal notify_input(input:InputWrapper)
signal notify_double_click(postion:Vector2)
signal notify_long_click(position:Vector2)
signal notify_click(position:Vector2)
signal notify_swipe(initPosition:Vector2,endPosition:Vector2)

var runningInputs:Array[InputWrapper] = []

func _init() -> void:
	if(InputWrapper.inputTypesNames == null):
		var inputTypesNames={}
		for i in (InputType.values()):
			var keyName = InputType.find_key(i)
			inputTypesNames[i] = keyName
			InputWrapper.inputTypesNames = inputTypesNames
	

func _ready() -> void:
	runningInputs.resize(10)
	for i in len(runningInputs):
		runningInputs[i] = InputWrapper.new()
		
func _input(event: InputEvent) -> void:
	
	if(TACTIL_SCREEN_EVENTS.any(func(t): return is_instance_of(event,t))):
		handledTactilScreen(event)
		
func _process(delta: float) -> void:
	
	for event in runningInputs:
		
		if( event.emited):
			event.emited = false
			continue
		
		if(!event.continueAddingTime):
			continue
		
		event.pressDuration += delta
		if(!event.isDrawing):
			
			var e : InputWrapper
			if(event.pressDuration >= LONG_CLICK_TIME_MIN):
				e = sendEvent(event,InputType.LONG_CLICK)
				notify_long_click.emit(e.initPosition)
				continue
			
			if(event.pressDuration >= CLICK_TIME_MIN && event.pressDuration <= CLICK_TIME_MAX):
				e = sendEvent(event,InputType.CLICK)
				notify_click.emit(e.initPosition)
				continue
		

func sendEvent(event:InputWrapper,type:InputType):
	event.setType(type)
	notify_input.emit(event)
	event.continueAddingTime = false
	event.emited = true
	event.pressDuration = 0
	
	return event

func handledTactilScreen(event: InputEvent):
	
	if( event.index == 0 ):
		
		if(event is InputEventScreenDrag):
			handledDraw(event)
		
		if(event is InputEventScreenTouch):
			handledTouch(event)
		

var t
func handledTouch(event: InputEventScreenTouch):
	var wrapper = runningInputs[event.index]
	var e : InputWrapper
	if(event.double_tap):
		wrapper.pressDuration = DOUBLE_CLICK_TIME_MAX
		wrapper.setType(InputType.DOBLE_CLICK)
		e = sendEvent(wrapper,InputType.DOBLE_CLICK )
		notify_double_click.emit(e.initPosition)
		
	if(event.is_pressed()):
		Time.get_unix_time_from_system()
		wrapper.initPosition = event.position
		wrapper.continueAddingTime = true
		
	if(event.is_released()):
		wrapper.endPosition = event.position
		if(wrapper.isDrawing):
			
			var distance = (wrapper.endPosition - wrapper.initPosition).length_squared()
			if(distance >= SQUARE_SWIPE_DISTANCE_MIN):
				e = sendEvent(wrapper,InputType.SWIPE)
				notify_swipe.emit(e.initPosition,e.endPosition)
		
		wrapper.isDrawing = false
		
func handledDraw(event: InputEventScreenDrag):
	var wrapper = runningInputs[event.index]
	wrapper.isDrawing = true
