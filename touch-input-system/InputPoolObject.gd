class_name InputPoolObject
	
static var CONST_POOLING_TIME:float = 100
var timmer:float = 0
var input:InputWrapper = InputWrapper.new()

func copyInput(source:InputWrapper) -> void:
	
	input.isSendLongTime = source.isSendLongTime
	input.isPressing = source.isPressing
	input.isDoubleClickDetect = source.isDoubleClickDetect
	input.isDrawingStart = source.isDrawingStart
	input.isDrawing = source.isDrawing
	input.index = source.index
	input.fingerId = source.fingerId
	input.type = source.type
	input.typeName = source.typeName
	input.initMomentTime = source.initMomentTime
	input.endMomentTime = source.endMomentTime
	input.accTimeDuration = source.accTimeDuration
	
	if( input.initPosition == null):
		input.initPosition = Vector2()
	
	if( input.endPosition == null):
		input.endPosition = Vector2()
	
	input.initPosition.x = source.initPosition.x
	input.initPosition.y = source.initPosition.y
	
	input.endPosition.x = source.endPosition.x
	input.endPosition.y = source.endPosition.y
