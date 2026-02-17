class_name CombatScreenLayout
extends Node

@export var topBarVerticalSize:int #= 30

var screen_size:Vector2
var center_screen:Vector2

@onready var top_bar_rect_touch_area_node: ReactTouchArea = $topBar_rectTouchAreaNode

@onready var left_up_button_rect_touch_area_node: ReactTouchArea = $leftUpButton_rectTouchAreaNode
@onready var right_up_button_rect_touch_area_node: ReactTouchArea = $rightUpButton_rectTouchAreaNode
@onready var left_down_button_rect_touch_area_node: ReactTouchArea = $leftDownButton_rectTouchAreaNode
@onready var right_down_button_rect_touch_area_node: ReactTouchArea = $rightDownButton_rectTouchAreaNode


func on_resize_screen_listener() -> void:
	calc_center_screen()
	setupButtonsPosition()

func _ready() -> void:
	calc_center_screen()
	setupButtonsPosition()
	get_viewport().size_changed.connect(on_resize_screen_listener)
	
	
func calc_center_screen():
	var viewport = get_viewport()
	screen_size = viewport.size
	center_screen = screen_size / 2

func setupButtonsPosition() -> void:
	
	top_bar_rect_touch_area_node.setPosition(Vector2(0,0))
	top_bar_rect_touch_area_node.setSize(screen_size.x,topBarVerticalSize)
	
	left_up_button_rect_touch_area_node.setPosition(Vector2(0,topBarVerticalSize))
	left_up_button_rect_touch_area_node.setSize(center_screen.x,center_screen.y - (topBarVerticalSize/2))
	
	right_up_button_rect_touch_area_node.setPosition(Vector2(center_screen.x,topBarVerticalSize))
	right_up_button_rect_touch_area_node.setSize(center_screen.x,center_screen.y - (topBarVerticalSize/2))
	
	left_down_button_rect_touch_area_node.setPosition( Vector2(0,center_screen.y + (topBarVerticalSize/2) ) )
	left_down_button_rect_touch_area_node.setSize(center_screen.x, center_screen.y - (topBarVerticalSize/2) )
	
	right_down_button_rect_touch_area_node.setPosition( Vector2(center_screen.x, center_screen.y + (topBarVerticalSize/2) ) )
	right_down_button_rect_touch_area_node.setSize(center_screen.x, center_screen.y - (topBarVerticalSize/2) )
	
