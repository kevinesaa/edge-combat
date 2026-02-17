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

func __markInitArea(event:InputWrapper):
	
	for b in buttons:
		if (b.isVectorInside(event.initPosition)):
			event.initTouchAreaId = b.areaId
			event.initTouchAreaName = b.areaName
			break

func __markEndArea(event:InputWrapper):
	
	for b in buttons:
		if (b.isVectorInside(event.endPosition)):
			event.endTouchAreaId = b.areaId
			event.endTouchAreaName = b.areaName
			break
			
func on_click_listener(event:InputWrapper) -> void:
	__markInitArea(event)
	notify_click.emit(event)
	print(str("simple click: ",event.initTouchAreaName))

func on_double_click_listener(event:InputWrapper) -> void:
	print("double click")

func on_long_click_listener(event:InputWrapper) -> void:
	print("long click")

func on_swipe_listener(event:InputWrapper) -> void:
	__markInitArea(event)
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
