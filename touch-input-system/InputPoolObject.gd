class_name InputPoolObject



static var CONST_POOLING_TIME:float = 5000

var timmer:float = 0
var input:InputWrapper = InputWrapper.new()

func setupTimeToLive():
	
	var startTimeInMicrosecond:float = Time.get_ticks_msec()
	self.timmer = startTimeInMicrosecond + CONST_POOLING_TIME
	
func isTimeOut() -> bool:
	var currentTime:float = Time.get_ticks_msec()
	return currentTime >= self.timmer

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
