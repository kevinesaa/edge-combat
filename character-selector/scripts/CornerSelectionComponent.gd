class_name CornerSelectionComponent
extends Control

var __cornerId:PlayerSelectorCorner.PlayerSelectorCornerEnum
var __isShow:bool = false
var __isSelected:bool = false
@onready var backgroundPanel: Panel = $backgroundPanel
@onready var textLabel: Label = $textLabel

func setCornerId(id:PlayerSelectorCorner.PlayerSelectorCornerEnum) -> void:
	self.__cornerId = id

func getCornerId() -> PlayerSelectorCorner.PlayerSelectorCornerEnum:
	return self.__cornerId
	
func setIsShowing(show:bool) -> void:
	self.__isShow = show

func isShowing() -> bool:
	return self.__isShow

func bind() -> void:
	if(!__isShow):
		self.visible = __isShow
	else:
		pass
