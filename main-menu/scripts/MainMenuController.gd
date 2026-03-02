extends CustomScene

const CHARACTER_SELECT_SCENE_PATH:String = "res://character-selector/character_selector.tscn"

@onready var change_scene_controller_node:ChangeSceneController = $changeSceneController_Node


func on_story_click_listener() -> void:
	pass

func on_arcade_story_click_listener() -> void:
	
	if(!change_scene_controller_node.is_loading_next_scene):
		
		change_scene_controller_node.path_to_next_scene = CHARACTER_SELECT_SCENE_PATH
		change_scene_controller_node.load_next_scene()
		(change_scene_controller_node
			.progressing_loading_scene_completed
			.connect(
				func():change_scene_controller_node.change_scene({})
			)
		)

func on_training_mode_click_listener() -> void:
	
	if(!change_scene_controller_node.is_loading_next_scene):
		
		change_scene_controller_node.path_to_next_scene = CHARACTER_SELECT_SCENE_PATH
		change_scene_controller_node.load_next_scene()
		(change_scene_controller_node
			.progressing_loading_scene_completed
			.connect(
				func():change_scene_controller_node.change_scene({})
			)
		)

func on_setting_click_listener() -> void:
	pass

func on_credits_click_listener() -> void:
	pass

func on_exit_click_listener() -> void:
	get_tree().quit()


func _ready() -> void:
	super._ready()
	change_scene_controller_node.debug_loading = true
