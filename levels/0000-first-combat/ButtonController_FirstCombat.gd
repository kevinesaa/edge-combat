class_name ButtonController_FirstCombat extends Node

#region dev option and debug
@export var dev_options:bool
@onready var debug_button: Button = $CanvasLayer/VBoxContainer/pausePanel/CenterContainer/VBoxContainer/debug_Button
#endregion

@onready var change_scene_controller_node: ChangeSceneController = $changeSceneController_Node

@onready var event_canvas_system_container_node: EventCanvasSystemContainer = $EventCanvasSystemContainer_Node
@onready var pause_panel: Control  = $CanvasLayer/VBoxContainer/pausePanel
@onready var topbar_container: Control  = $CanvasLayer/VBoxContainer/PanelContainer/topbar_Container


func __onTopBarPressListner() -> void:
	#pause game (change game state)
	__disconnectTopBar()
	showPauseMenu()
	
var EVENT_MAP_ACTIONS = {
	"topBar": self.__onTopBarPressListner,
}

func on_touch_listener(event:InputWrapper) -> void:
	var funcAction = EVENT_MAP_ACTIONS.get(event.initTouchAreaName)
	if(funcAction != null):
		funcAction.call()

func on_resume_game_listener() -> void:
	__connectTopbar()
	hidePauseMenu()
	#resume game (change game state)
	
func on_close_game_listener() -> void:
	get_tree().quit()

func showPauseMenu() -> void:
	pause_panel.visible = true
	topbar_container.visible = false
	
func hidePauseMenu() -> void:
	pause_panel.visible = false
	topbar_container.visible = true

func __devOptionsSetting() -> void:
	if(dev_options):
		__setupDevOption()
	else:
		__tierDownDevOptions()
		
func __setupDevOption() -> void:
	debug_button.visible = true
	debug_button.pressed.connect(__jumpFirstCombat)
	
func __tierDownDevOptions() -> void:
	debug_button.visible = false
	debug_button.pressed.disconnect(__jumpFirstCombat)
	
func __jumpFirstCombat() -> void:
	var fileRaw = FileAccess.open(Constants.SAVE_FILE_PATH, FileAccess.READ)
	var fileContent = JSON.parse_string(fileRaw.get_as_text())
	fileRaw.close()
	fileContent[Constants.TUTORIAL_COMPLETED_KEY] = true
	fileRaw = FileAccess.open(Constants.SAVE_FILE_PATH, FileAccess.WRITE)
	fileRaw.store_string(JSON.stringify(fileContent))
	fileRaw.close()
	change_scene_controller_node.debug_loading = true
	change_scene_controller_node.load_next_scene()
	(change_scene_controller_node
		.progressing_loading_scene_completed
		.connect(
			func():change_scene_controller_node.change_scene()
		)
	)
	
func __connectTopbar() -> void:
	var customCanvas = event_canvas_system_container_node.canvas_system_node
	customCanvas.notify_click.connect(on_touch_listener)

func __disconnectTopBar() -> void:
	var customCanvas = event_canvas_system_container_node.canvas_system_node
	customCanvas.notify_click.disconnect(on_touch_listener)

func _ready() -> void:
	
	__connectTopbar()
	hidePauseMenu()
	__devOptionsSetting()
	
