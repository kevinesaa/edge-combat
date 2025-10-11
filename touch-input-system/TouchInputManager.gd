class_name TouchInputManager
extends Node

@export var is_double_click_enable:bool = false

var inputsSendQueue:Array[InputPoolObject] = []
var inputsPoolQueue:Array[InputPoolObject] = []
var runningInputs:Array[InputWrapper] = []

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

signal notify_input(event:InputWrapper) #
signal notify_pressed(event:InputWrapper) #
signal notify_release(event:InputWrapper) #
signal notify_draging_start(event:InputWrapper) #

signal notify_click(event:InputWrapper) #
signal notify_double_click(event:InputWrapper) #
signal notify_long_click(event:InputWrapper) #
signal notify_swipe(event:InputWrapper) #
signal notify_long_swipe(event:InputWrapper)

signal notify_hold_pressing(event:InputWrapper)
signal notify_draging(event:InputWrapper)
#endregion

#region signal dispatcher

func dispatchInput(input:InputWrapper) -> InputPoolObject:
	var inputPool:InputPoolObject = getInputPoolInstance()
	inputPool.timmer = InputPoolObject.CONST_POOLING_TIME
	inputPool.copyInput(input)
	notify_input.emit(inputPool.input)
	inputsSendQueue.push_back(inputPool)
	return inputPool

func dispatchPressed(input:InputWrapper):
	input.setType(InputWrapper.InputType.UNKNOW)
	var inputPool = dispatchInput(input)
	notify_pressed.emit(inputPool.input)

func dispatchRelease(input:InputWrapper):
	var inputPool = dispatchInput(input)
	notify_release.emit(inputPool.input)
	input.isSendLongTime = false
	input.isDrawingStart = false
	input.isDrawing = false
	input.accTimeDuration = 0

func dispatchDragingStart(input:InputWrapper):
	input.setType(InputWrapper.InputType.UNKNOW)
	var inputPool = dispatchInput(input)
	notify_draging_start.emit(inputPool.input)

func dispatchClick(input:InputWrapper):
	input.setType(InputWrapper.InputType.CLICK)
	var inputPool = dispatchInput(input)
	input.isDoubleClickDetect = false
	notify_click.emit(inputPool.input)

func dispatchDoubleClick(input:InputWrapper):
	input.setType(InputWrapper.InputType.DOUBLE_CLICK)
	var inputPool = dispatchInput(input)
	input.isDoubleClickDetect = false
	notify_double_click.emit(inputPool.input)

func dispatchLongClick(input:InputWrapper):
	input.setType(InputWrapper.InputType.LONG_CLICK)
	input.isSendLongTime = true
	var inputPool = dispatchInput(input)
	notify_long_click.emit(inputPool.event)

func dispatchSwipe(input:InputWrapper):
	var distance = (input.endPosition - input.initPosition).length_squared()
	if(distance >= SQUARE_SWIPE_DISTANCE_MIN && input.accTimeDuration < LONG_CLICK_TIME_MIN):
		input.setType(InputWrapper.InputType.SWIPE)
		var inputPool = dispatchInput(input)
		notify_swipe.emit(inputPool.input)

func dispatchLongTimeSwipe(input:InputWrapper):
	var distance = (input.endPosition - input.initPosition).length_squared()
	if(distance >= SQUARE_SWIPE_DISTANCE_MIN && input.accTimeDuration >= LONG_CLICK_TIME_MIN):
		input.setType(InputWrapper.InputType.LONG_SWIPE)
		input.isSendLongTime = true
		var inputPool = dispatchInput(input)
		notify_long_swipe.emit(inputPool.input)

func dispatchHoldPressing(input:InputWrapper):
	notify_hold_pressing.emit(input)

func dispatcDraging(event:InputWrapper):
	notify_draging.emit(event)

#endregion

func getInputPoolInstance() -> InputPoolObject:
	var element:InputPoolObject
	if( len(inputsPoolQueue) > 0):
		element = inputsPoolQueue.pop_front()
	else:
		element = InputPoolObject.new()
	return element

func _ready() -> void:
	inputsPoolQueue.resize(50)
	inputsPoolQueue.fill(InputPoolObject.new())
	runningInputs.resize(20)
	for i in len(runningInputs):
		runningInputs[i] = InputWrapper.new()
		
func _input(event: InputEvent) -> void:
	
	if(TACTIL_SCREEN_EVENTS.any(func(t): return is_instance_of(event,t))):
		handledTactilScreen(event)
		
func _process(deltaTime: float) -> void:
	
	for event in runningInputs:
		
		if(is_double_click_enable):
			
			if(!event.isPressing && event.type == InputWrapper.InputType.INTENT_CLICK):
				
				if(event.accTimeDuration >= CLICK_TIME_MAX):
					dispatchClick(event)
					continue
				event.accTimeDuration += deltaTime
			
		if(event.isPressing):
			
			event.accTimeDuration += deltaTime
			dispatchHoldPressing(event)
			
			if(
				!event.isSendLongTime 
				&& event.accTimeDuration >= LONG_CLICK_TIME_MIN
			):
				
				if(event.isDrawing):
					dispatchLongTimeSwipe(event)
				else:
					dispatchLongClick(event)
	
	var queueIndexHelper = len(inputsSendQueue)
	for i in queueIndexHelper:
		var e:InputPoolObject = inputsSendQueue.pop_front()
		e.timmer = e.timmer - deltaTime
		if(e.timmer >= 0):
			inputsSendQueue.push_back(e)
		else:
			inputsPoolQueue.push_back(e)
			
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
		if(is_double_click_enable && event.double_tap):
			wrapper.isDoubleClickDetect = true
		dispatchPressed(wrapper)
		
		
	if(event.is_released()):
		InputWrapper.fingersPressingCount = InputWrapper.minusOne(InputWrapper.fingersPressingCount)
		InputWrapper.fingersDrawingCount = InputWrapper.minusOne(InputWrapper.fingersDrawingCount)
		InputWrapper.fingersReleasedCount = InputWrapper.plusOne(InputWrapper.fingersReleasedCount)
		wrapper.isPressing = false
		wrapper.endPosition = event.position
		wrapper.endMomentTime = Time.get_ticks_msec()
		
		if(!wrapper.isDrawing && !wrapper.isSendLongTime):
		
			if(!is_double_click_enable):
				dispatchClick(wrapper)
			else:
				if(!wrapper.isDoubleClickDetect):
					wrapper.setType(InputWrapper.InputType.INTENT_CLICK)
				
		if(wrapper.isDrawing):
			dispatchSwipe(wrapper)
			
		if(is_double_click_enable && wrapper.isDoubleClickDetect):
			dispatchDoubleClick(wrapper)
		
		dispatchRelease(wrapper)
		

func handledDraw(event: InputEventScreenDrag):
	var wrapper = runningInputs[event.index]
	wrapper.isDrawing = true
	wrapper.endPosition = event.position 
	if(!wrapper.isDrawingStart):
		wrapper.isDrawingStart = true
		InputWrapper.fingersDrawingCount = InputWrapper.plusOne(InputWrapper.fingersDrawingCount)
		dispatchDragingStart(wrapper)
	dispatcDraging(wrapper)
