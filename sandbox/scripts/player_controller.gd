extends Node2D

@onready var input:Sandbox = $input

func _ready():
	input.notify_swipe.connect(on_swipe_right_listener)
	pass

func on_swipe_right_listener(input: InputWrapper):
	print("onichan")
	pass
