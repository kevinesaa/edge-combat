class_name EventCanvasSystemContainer extends Node

@export var debug_draw:bool = true

var input_controller_node: TouchInputManager
var canvas_system_node: MyCanvasSystemNode

func  _enter_tree() -> void:
	var eventInput = find_children("*","TouchInputManager",false,true)
	var canvasSystem = find_children("*","MyCanvasSystemNode",false,true)
	var buttons:Array[TouchArea]= []
	var nodes = find_children("*","TouchArea",true,true)
	for b in nodes:
		b.debug_draw = debug_draw
		buttons.append(b)	
	
	eventInput = eventInput[0] as TouchInputManager
	canvasSystem = canvasSystem[0] as MyCanvasSystemNode
	canvasSystem.setInputManager(eventInput)
	canvasSystem.setButtons(buttons)
