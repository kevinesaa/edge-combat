class_name MyCanvasSystemNode extends Node

var inputManager:TouchInputManager
var buttons:Array[TouchArea] = []

#region signals
#signal notify_input(event:InputWrapper) #
#signal notify_pressed(event:InputWrapper) #
#signal notify_release(event:InputWrapper) #
#signal notify_draging_start(event:InputWrapper) #

signal notify_click(event:InputWrapper) #
#signal notify_double_click(event:InputWrapper) #
#signal notify_long_click(event:InputWrapper) #
signal notify_swipe(event:InputWrapper) #
#signal notify_long_swipe(event:InputWrapper)

#signal notify_hold_pressing(event:InputWrapper)
#signal notify_draging(event:InputWrapper)
#endregion

func setInputManager(inputManager:TouchInputManager):
	
	if(self.inputManager != null):
		__disconnect_all()
	self.inputManager = inputManager
	if(inputManager != null):
		__connect_all()

func setButtons( buttons:Array[TouchArea] ):
	self.buttons = buttons

func __markInsideArea(point:Vector2) -> TouchArea:
	var area : TouchArea = null
	for b in buttons:
		if (b.isInside(point)):
			area = b
			break
	return area

func __markInitArea(event:InputWrapper) -> bool:
	var area = __markInsideArea(event.initPosition)
	var result = area != null
	if(result):
		event.initTouchAreaId = area.areaId
		event.initTouchAreaName = area.areaName
	return result
	
func __markEndArea(event:InputWrapper) -> bool:
	var area = __markInsideArea(event.endPosition)
	var result = area != null
	if(result):
		event.endTouchAreaId = area.areaId
		event.endTouchAreaName = area.areaName
	return result
	
func on_click_listener(event:InputWrapper) -> void:
	if(__markInitArea(event)):
		notify_click.emit(event)
		print(str("simple click: ",event.initTouchAreaName))

func on_double_click_listener(event:InputWrapper) -> void:
	print("double click")

func on_long_click_listener(event:InputWrapper) -> void:
	print("long click")

func on_swipe_listener(event:InputWrapper) -> void:
	if(__markInitArea(event)):
		__markEndArea(event)
		notify_swipe.emit(event)
		print(str("swipe: ",event.initTouchAreaName," to ", event.endTouchAreaName))

func on_long_swipe_listener(event:InputWrapper) -> void:
	print("long swipe")


func __connect_all() -> void:
	inputManager.notify_click.connect(self.on_click_listener)
	inputManager.notify_swipe.connect(self.on_swipe_listener)

func __disconnect_all() -> void:
	inputManager.notify_click.disconnect(self.on_click_listener)
	inputManager.notify_swipe.disconnect(self.on_swipe_listener)
