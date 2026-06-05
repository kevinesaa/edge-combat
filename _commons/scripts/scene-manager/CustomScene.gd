class_name CustomScene extends Node

var __parameters:Dictionary = {}

func setParameters(parameters:Dictionary) -> void:
	self.__parameters = parameters

func getParameters() -> Dictionary:
	return self.__parameters

func setupParameters() -> void:
	
	print("setupParameters")
	

func _ready() -> void:
	setupParameters()
