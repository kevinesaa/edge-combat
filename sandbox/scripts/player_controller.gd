extends Node2D

@onready var input:Sandbox = $input
@onready var player_root_node = $PlayerRootNode

var left_side=Vector2(252,248)
var right_side=Vector2(452,248)
var center=Vector2(352,248)

@export var duration := 0.2 # movimiento
@export var duration_at_side := 0.4 # pausa en los lados

var start_position: Vector2
var target_position: Vector2
var elapsed_time := 0.0
var elapsed_time_at_side := 0.0
var moving := false

func on_swipe_listener(input: InputWrapper):
	if input.endPosition > input.initPosition:
		start_movement(right_side)
	if input.initPosition > input.endPosition:
		start_movement(left_side)

func start_movement(new_target: Vector2):
	start_position = player_root_node.position
	target_position = new_target
	elapsed_time = 0.0
	elapsed_time_at_side = 0.0
	moving = true

func _ready():
	input.notify_swipe.connect(on_swipe_listener)

func _process(delta):
	if moving:
		elapsed_time += delta
		var t = clamp(elapsed_time / duration, 0.0, 1.0)
		player_root_node.position = lerp(start_position, target_position, ease_out(t))
		if t >= 1:#SI ya llego al destino
			if target_position == center:
				moving = false
			else:
				elapsed_time_at_side += delta
				if elapsed_time_at_side >= duration_at_side:
					start_movement(center)

func ease_in(t):
	return t ** 2

func flip(x):
	return 1 - x

func ease_out(t):
	return flip(ease_in(flip(t)))
