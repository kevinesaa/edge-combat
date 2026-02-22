class_name TouchArea
extends Node

static var areaMaxId:int = 0
var areaId:int

@export var debug_draw:bool = true
@export var areaName:String

func _init():
	TouchArea.areaMaxId = TouchArea.areaMaxId + 1
	self.areaId = TouchArea.areaMaxId
	self.areaName = str("",self.areaName).strip_edges()
	if(len(self.areaName) < 1):
		self.areaName = str("touch_area","_", self.areaId)

#abstract
func isInside(point:Vector2) -> bool:
	return false

#abstract
func draw_debug_lines() -> void:
	if(debug_draw):
		return
