class_name ButtonController_FirstCombat extends Node

@onready var event_canvas_system_container_node: EventCanvasSystemContainer = $EventCanvasSystemContainer_Node

func __onTopBarPressListner():
	#pause game
	#open pause menu
	print("hello")
	pass

var EVENT_MAP_ACTIONS = {
	"topBar": self.__onTopBarPressListner,
}

func on_touch_listener(event:InputWrapper):
	var funcAction = EVENT_MAP_ACTIONS.get(event.initTouchAreaName)
	if(funcAction != null):
		funcAction.call()
	
func _ready() -> void:
	var customCanvas = event_canvas_system_container_node.canvas_system_node
	customCanvas.notify_click.connect(on_touch_listener)
