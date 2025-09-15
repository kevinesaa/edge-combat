class_name TouchInputManager
extends Node

var TACTIL_SCREEN_EVENTS:Array = (
	[
		InputEventScreenTouch, 
		InputEventScreenDrag
	]
)

const SECOND_AS_MILISECOND  = 1000
const SECOND_AS_MICROSECOND = 1000000


const CLICK_TIME_MAX = 0.08
const LONG_CLICK_TIME_MIN:float = 0.4

const SWIPE_DISTANCE_MIN:float = 30
const SQUARE_SWIPE_DISTANCE_MIN:float = SWIPE_DISTANCE_MIN * SWIPE_DISTANCE_MIN

#region notification signals

signal notify_pressed(event:InputWrapper)
signal notify_release(event:InputWrapper)
signal notify_hold_pressing(event:InputWrapper)
signal notify_draging(event:InputWrapper)

signal notify_click(event:InputWrapper)
signal notify_double_click(event:InputWrapper)
signal notify_long_click(event:InputWrapper)
signal notify_swipe(event:InputWrapper)
signal notify_long_swipe(event:InputWrapper)

#endregion

#region signal dispatcher

#endregion


var runningInputs:Array[InputWrapper] = []

func _ready() -> void:
	runningInputs.resize(10)
	for i in len(runningInputs):
		runningInputs[i] = InputWrapper.new()
		
func _input(event: InputEvent) -> void:
	
	if(TACTIL_SCREEN_EVENTS.any(func(t): return is_instance_of(event,t))):
		handledTactilScreen(event)
		
func _process(deltaTime: float) -> void:
	
	for event in runningInputs:
		
		if(!event.isPressing && event.type == InputWrapper.InputType.INTENT_CLICK):
			
			if(event.accTimeDuration >= CLICK_TIME_MAX):
				event.setType(InputWrapper.InputType.CLICK)
				notify_click.emit(event)
				event.isDoubleClickDetect = false
				continue
			event.accTimeDuration += deltaTime
			
		if(event.isPressing):
			event.accTimeDuration += deltaTime
			notify_hold_pressing.emit(event)
			
			if(
				!event.isSendLongTime 
				&& event.accTimeDuration >= LONG_CLICK_TIME_MIN
			):
				event.isSendLongTime = true
				if(event.isDrawing):
					event.setType(InputWrapper.InputType.LONG_SWIPE)
					notify_long_swipe.emit(event)
				else:
					event.setType(InputWrapper.InputType.LONG_CLICK)
					notify_long_click.emit(event)


func handledTactilScreen(event: InputEvent):
	
	if(event is InputEventScreenDrag):
		handledDraw(event)
	
	if(event is InputEventScreenTouch):
		handledTouch(event)


func handledTouch(event: InputEventScreenTouch):
	
	var wrapper:InputWrapper = runningInputs[event.index]
	wrapper.index = event.index
	wrapper.fingerId = event.index + 1
	
	if(event.is_pressed()):
		InputWrapper.fingersPressingCount = InputWrapper.plusOne(InputWrapper.fingersPressingCount)
		InputWrapper.fingersReleasedCount = InputWrapper.minusOne(InputWrapper.fingersReleasedCount)
		wrapper.isPressing = true
		wrapper.initPosition = event.position
		wrapper.initMomentTime = Time.get_ticks_msec()
		wrapper.setType(InputWrapper.InputType.UNKNOW)
		if(event.double_tap):
			wrapper.setType(InputWrapper.InputType.DOUBLE_CLICK)
			wrapper.isDoubleClickDetect = true
		notify_pressed.emit(wrapper)
		
	if(event.is_released()):
		InputWrapper.fingersPressingCount = InputWrapper.minusOne(InputWrapper.fingersPressingCount)
		InputWrapper.fingersDrawingCount = InputWrapper.minusOne(InputWrapper.fingersDrawingCount)
		InputWrapper.fingersReleasedCount = InputWrapper.plusOne(InputWrapper.fingersReleasedCount)
		wrapper.isPressing = false
		wrapper.endPosition = event.position
		wrapper.endMomentTime = Time.get_ticks_msec()
		
		if(!wrapper.isDoubleClickDetect && !wrapper.isDrawing && !wrapper.isSendLongTime):
			wrapper.setType(InputWrapper.InputType.INTENT_CLICK)
			
		if(wrapper.isDrawing):
			var distance = (wrapper.endPosition - wrapper.initPosition).length_squared()
			if(distance >= SQUARE_SWIPE_DISTANCE_MIN && wrapper.accTimeDuration <= LONG_CLICK_TIME_MIN):
				wrapper.setType(InputWrapper.InputType.SWIPE)
				notify_swipe.emit(wrapper)
				
		if(wrapper.isDoubleClickDetect):
			wrapper.setType(InputWrapper.InputType.DOUBLE_CLICK)
			notify_double_click.emit(wrapper)
			wrapper.isDoubleClickDetect = false
			
		notify_release.emit(wrapper)
		wrapper.isSendLongTime = false
		wrapper.isDrawing = false
		wrapper.accTimeDuration = 0

	
	
func handledDraw(event: InputEventScreenDrag):
	var wrapper = runningInputs[event.index]
	wrapper.isDrawing = true
	wrapper.endPosition = event.position 
	InputWrapper.fingersDrawingCount = InputWrapper.plusOne(InputWrapper.fingersDrawingCount)
