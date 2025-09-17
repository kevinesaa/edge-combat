class_name  InputWrapper

enum InputType {
	UNKNOW,
	INTENT_CLICK,
	CLICK,
	DOUBLE_CLICK,
	LONG_CLICK,
	SWIPE,
	LONG_SWIPE
}

static var __initTypeName:bool = false
static var __inputTypesNames:Dictionary
static var fingersPressingCount:int = 0
static var fingersReleasedCount:int = 0
static var fingersDrawingCount:int = 0

var isSendLongTime:bool = false
var isPressing:bool = false
var isDoubleClickDetect = false
var isDrawingStart:bool = false
var isDrawing:bool = false

var index:int
var fingerId:int
var type:InputType = InputType.UNKNOW
var typeName:String

var initMomentTime:int # microseconds
var endMomentTime:int # microseconds
var accTimeDuration:float # seconds
var initPosition:Vector2
var endPosition:Vector2

static func plusOne(current):
	var t = current + 1
	return max(0,t)

static func minusOne(current):
	var t = current - 1
	return max(0,t)
	
func setType(type:InputType):
	__initTypeNames()
	self.type = type
	self.typeName = InputWrapper.__inputTypesNames.get(type,null)

func __initTypeNames():
	if(! InputWrapper.__initTypeName ):
		var inputTypesNames = { }
		for i in (InputType.values()):
			var keyName = InputType.find_key(i)
			inputTypesNames[i] = keyName
		InputWrapper.__inputTypesNames = inputTypesNames
		InputWrapper.__initTypeName = true
