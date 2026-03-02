extends CustomScene

const MAIN_MENU_SCENE_PATH:String = "res://main-menu/main_menu_scene.tscn"

@onready var change_scene_controller_node:ChangeSceneController = $changeSceneController_Node


func on_android_back_press_key_listener() -> void:
	pass

func on_back_press_click_listener() -> void:
	
	if(!change_scene_controller_node.is_loading_next_scene):
		
		change_scene_controller_node.path_to_next_scene = MAIN_MENU_SCENE_PATH
		change_scene_controller_node.load_next_scene()
		(change_scene_controller_node
			.progressing_loading_scene_completed
			.connect(
				func():change_scene_controller_node.change_scene({})
			)
		)
	
func on_confirm_character_click_listener() -> void:
	pass

func on_confirm_ia_character_click_listener() -> void:
	pass

func _ready() -> void:
	super._ready()
	change_scene_controller_node.debug_loading = true
	
	
