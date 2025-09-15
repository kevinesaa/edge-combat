class_name Sandbox
extends Node

signal notify_swipe(event:InputWrapper)

func _ready():
	pass

func _process(delta):
	if(Input.is_action_just_pressed("right")):
		notify_swipe_right()
	if(Input.is_action_just_pressed("left")):
		notify_swipe_left()


func notify_swipe_right():
	var input:InputWrapper = InputWrapper.new()
	input.initPosition= Vector2.ZERO
	input.endPosition=Vector2.RIGHT
	notify_swipe.emit(input)

func notify_swipe_left():
	var input:InputWrapper = InputWrapper.new()
	input.initPosition= Vector2.ZERO
	input.endPosition= Vector2.LEFT
	notify_swipe.emit(input)
