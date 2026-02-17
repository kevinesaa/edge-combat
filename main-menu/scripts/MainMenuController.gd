extends Node


@onready var left_rect_touch_area_node: ReactTouchArea = $EventCanvasSystemContainer_Node/leftRectTouchAreaNode
@onready var right_rect_touch_area_node: ReactTouchArea = $EventCanvasSystemContainer_Node/rightRectTouchAreaNode


var screen_size:Vector2
var center_screen:Vector2
@onready var center_vertical_line_2d: Line2D = $Node/center_vertical_Line2D
@onready var center_horizontal_line_2d: Line2D = $Node/center_horizontal_Line2D


func on_resize_screen_listener() -> void:
	calc_center_screen()
	

func _ready() -> void:
	calc_center_screen()
	get_viewport().size_changed.connect(on_resize_screen_listener)
	
	left_rect_touch_area_node.setPosition(Vector2(0,0))
	left_rect_touch_area_node.setSize(center_screen.x,screen_size.y)
	
	right_rect_touch_area_node.setPosition(Vector2(center_screen.x,0))
	right_rect_touch_area_node.setSize(center_screen.x,screen_size.y)

func calc_center_screen():
	var viewport = get_viewport()
	screen_size = viewport.size
	center_screen = screen_size / 2
