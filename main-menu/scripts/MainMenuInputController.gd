class_name MainMenuInputController
extends Node

var TACTIL_SCREEN_EVENTS:Array = (
	[
		InputEventScreenTouch, 
		InputEventScreenDrag
	]
)

func _ready() -> void:
	pass

func _input(event: InputEvent) -> void:
	
	if(TACTIL_SCREEN_EVENTS.any(func(t): return is_instance_of(event,t))):
		handledTactilScreen(event)
		

func handledTactilScreen(event: InputEvent):
	
	if(event.index==0):
		
		if(event is InputEventScreenTouch):
			handledTouch(event)
		
		if(event is InputEventScreenDrag):
			handledDraw(event)


func handledTouch(event: InputEventScreenTouch):
	if(event.is_pressed()):
		print("click/touch")
	if(event.is_released()):
		print("realeas: click/touch")

func handledDraw(event: InputEventScreenDrag):
	print("drag")
