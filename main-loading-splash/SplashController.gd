extends Node

@onready var change_scene_controller_node: ChangeSceneController = $changeSceneController_Node
@onready var start_next_scene_timer: Timer = $start_next_scene_Timer

func _ready() -> void:
	#start_next_scene_timer.start()
	pass
	
func start_next_scene_load():
	change_scene_controller_node.load_next_scene()

	
func on_next_scene_is_ready_listener():
	change_scene_controller_node.change_scene() 
