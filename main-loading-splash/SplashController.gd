extends Node

@export var firstCombatPathScena:String #= "res://levels/00-first-combat/first_combat.tscn"
@export var mainMenuPathScene:String #= "res://main-menu/main_menu_scene.tscn"

@onready var change_scene_controller_node: ChangeSceneController = $changeSceneController_Node
@onready var start_next_scene_timer: Timer = $start_next_scene_Timer

func _ready() -> void:
	
	createFileIfNotExist(Constants.SAVE_FILE_PATH,JSON.stringify({}))
	var gameState:Dictionary = self.loadJson(Constants.SAVE_FILE_PATH)
	var tutorialCompleted = gameState.get(Constants.TUTORIAL_COMPLETED_KEY,false)
	if (tutorialCompleted):
		change_scene_controller_node.path_to_next_scene = mainMenuPathScene	
	else:
		change_scene_controller_node.path_to_next_scene = firstCombatPathScena
	start_next_scene_timer.start()
	
func createFileIfNotExist(path:String,content:String) -> void:
	if(!FileAccess.file_exists(path)):
		var file = FileAccess.open(path, FileAccess.WRITE)
		file.store_string(content)
		file.close()

func loadJson(path:String) -> Dictionary:
	if(!FileAccess.file_exists(path)):
		return {}
	var fileRaw = FileAccess.open(path, FileAccess.READ)
	var fileContent = JSON.parse_string(fileRaw.get_as_text())
	fileRaw.close()
	return fileContent
	
func start_next_scene_load():
	change_scene_controller_node.load_next_scene()
	
func on_next_scene_is_ready_listener():
	change_scene_controller_node.change_scene() 
