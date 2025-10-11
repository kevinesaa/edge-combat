extends Node
@onready var input_controller_node: TouchInputManager = $inputController_node

@onready var left_rect_touch_area_node: ReactTouchArea = $touchAreasContainerNode/leftRectTouchAreaNode
@onready var right_rect_touch_area_node: ReactTouchArea = $touchAreasContainerNode/rightRectTouchAreaNode


var screen_size:Vector2
var center_screen:Vector2
@onready var center_vertical_line_2d: Line2D = $Node/center_vertical_Line2D
@onready var center_horizontal_line_2d: Line2D = $Node/center_horizontal_Line2D

@export var debug_draw:bool = true
func draw_debug_lines() -> void:
	if(debug_draw):
		left_rect_touch_area_node.draw_debug_lines()
		right_rect_touch_area_node.draw_debug_lines()
		#center_vertical_line_2d.clear_points()
		#center_vertical_line_2d.add_point(Vector2(center_screen.x,0))
		#center_vertical_line_2d.add_point(Vector2(center_screen.x,screen_size.y))
		#
		#center_horizontal_line_2d.clear_points()
		#center_horizontal_line_2d.add_point(Vector2(0,center_screen.y))
		#center_horizontal_line_2d.add_point(Vector2(screen_size.x,center_screen.y))

func on_resize_screen_listener() -> void:
	print("on resize")
	calc_center_screen()
	draw_debug_lines()


func on_click_listener(event:InputWrapper) -> void:
	
	print("simple click")
	
	if(left_rect_touch_area_node.isVectorInside(event.initPosition)):
		print("in left rect")
	if(right_rect_touch_area_node.isVectorInside(event.initPosition)):
		print("in right rect")

func on_double_click_listener(event:InputWrapper) -> void:
	print("double click")

func on_long_click_listener(event:InputWrapper) -> void:
	print("long click")

func on_swipe_listener(event:InputWrapper) -> void:
	print("swipe")

func on_long_swipe_listener(event:InputWrapper) -> void:
	print("long swipe")


func _ready() -> void:
	calc_center_screen()
	get_viewport().size_changed.connect(on_resize_screen_listener)
	
	left_rect_touch_area_node.setPosition(Vector2(0,0))
	left_rect_touch_area_node.setSize(center_screen.x,screen_size.y)
	
	right_rect_touch_area_node.setPosition(Vector2(center_screen.x,0))
	right_rect_touch_area_node.setSize(center_screen.x,screen_size.y)
	
	input_controller_node.notify_click.connect(on_click_listener)
	input_controller_node.notify_double_click.connect(on_double_click_listener)
	input_controller_node.notify_long_click.connect(on_long_click_listener)
	input_controller_node.notify_swipe.connect(on_swipe_listener)
	input_controller_node.notify_long_swipe.connect(on_long_swipe_listener)
	
	draw_debug_lines() 
	
func calc_center_screen():
	var viewport = get_viewport()
	screen_size = viewport.size
	center_screen = screen_size / 2
