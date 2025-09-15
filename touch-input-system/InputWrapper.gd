class_name  InputWrapper

enum InputType {
	CLICK,
	DOUBLE_CLICK,
	LONG_CLICK,
	SWIPE,
	LONG_SWIPE
}

static var __inputTypesNames = {}
static var fingersPressingCount:int = 0
static var fingersReleasedCount:int = 0
static var fingersDrawingCount:int = 0

var isSendLongTime:bool = false
var isPressing:bool = false
var isDrawing:bool = false

var fingerId:int
var type:InputType
var typeName:String

var initMomentTime:int # microseconds
var endMomentTime:int # microseconds
var accTimeDuration:float # milliseconds
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
