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

const  SWIPE_DISTANCE_MIN:float = 30


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
	
	var isDrawing:bool = false
	var initPosition:Vector2
	var endPosition:Vector2
	var source
	
	func setType(type:InputType):
		self.type = type
		self.typeName = inputTypesNames[type]
		

signal notify_double_click(input:InputWrapper)
signal notify_long_click(input:InputWrapper)
signal notify_click(input:InputWrapper)
signal notify_swipe(input:InputWrapper)

var runningInputs:Array[InputWrapper] = []

func _ready() -> void:
	runningInputs.resize(10)
	var inputTypesNames={}
	for i in (InputType.values()):
		var keyName = InputType.find_key(i)
		inputTypesNames[i] = keyName
	InputWrapper.inputTypesNames = inputTypesNames
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
				notify_long_click.emit(e)
				continue
			
			if(event.pressDuration >= CLICK_TIME_MIN && event.pressDuration <= CLICK_TIME_MAX):
				e = sendEvent(event,InputType.CLICK)
				notify_click.emit(e)
				continue
		

func sendEvent(event:InputWrapper,type:InputType):
	event.setType(type)
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
		


func handledTouch(event: InputEventScreenTouch):
	var wrapper = runningInputs[event.index]
	var e : InputWrapper
	if(event.double_tap):
		wrapper.pressDuration = DOUBLE_CLICK_TIME_MAX
		wrapper.setType(InputType.DOBLE_CLICK)
		e = sendEvent(wrapper,InputType.DOBLE_CLICK )
		notify_double_click.emit(e)
		
	if(event.is_pressed()):
		wrapper.initPosition = event.position
		wrapper.continueAddingTime = true
		
	if(event.is_released()):
		wrapper.endPosition = event.position
		if(wrapper.isDrawing):
			e = sendEvent(wrapper,InputType.SWIPE)
			notify_swipe.emit(e)
		
		wrapper.isDrawing = false
		
func handledDraw(event: InputEventScreenDrag):
	var wrapper = runningInputs[event.index]
	wrapper.isDrawing = true
