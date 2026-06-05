extends CustomScene

const MAIN_MENU_SCENE_PATH:String = "res://main-menu/main_menu_scene.tscn"

@onready var change_scene_controller_node:ChangeSceneController = $changeSceneController_Node

var __settings_config_cpu:bool = true
var players:Array[PlayerSelectorCorner.PlayerSelectorWrapper] = []



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
	
	if(!__settings_config_cpu):
		var allHumanConfir:bool = (players
			.filter( __isPerson)
			.all(func(p): p.isConfirmed())
		)
		if(allHumanConfir):
			load_combat_scene()
	

func on_confirm_cpu_character_click_listener() -> void:
	pass

func setupParameters() -> void:
	var parameters = self.getParameters()
	var playerSettings = parameters["player_settings"]
	self.__settings_config_cpu = playerSettings.get("confirm_cpu",true)
	
	for p in playerSettings["players"]:
		var playerObject = PlayerSelectorCorner.PlayerSelectorWrapper.new(p["playerId"],p["cornderId"])
		players.append(playerObject)
		
func load_combat_scene():
	pass

func _ready() -> void:
	super._ready()
	change_scene_controller_node.debug_loading = true
	
func __isPlayerTypeEquls(t1:PlayerTypeWrapper.PlayerTypeEnum,t2:PlayerTypeWrapper.PlayerTypeEnum) -> bool:
		return t1 == t2

func __isPerson(p:PlayerSelectorCorner.PlayerSelectorWrapper) -> bool:
	var t =  p.getPlayerType().getType() 
	return __isPlayerTypeEquls(t,PlayerTypeWrapper.PlayerTypeEnum.PLAYER)

func __isCpu(p:PlayerSelectorCorner.PlayerSelectorWrapper) -> bool:
	var t =  p.getPlayerType().getType() 
	return __isPlayerTypeEquls(t,PlayerTypeWrapper.PlayerTypeEnum.CPU)
