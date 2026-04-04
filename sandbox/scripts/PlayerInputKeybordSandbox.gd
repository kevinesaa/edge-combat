class_name Sandbox
extends Node

signal notify_swipe(event:InputWrapper)
signal notify_click(event:InputWrapper)

var inputTopBar:String = "topBar"
var inputLeftUpButton:String = "leftUpButton"
var inputRightUpButton:String = "rightUpButton"
var inputLeftDownButton:String = "leftDownButton"
var inputRightDownButton:String = "rightDownButton"

var vectorUpLeft:Vector2 = Vector2(0,0)
var vectorUpRight:Vector2 = Vector2(1,0)
var vectorDownLeft:Vector2 = Vector2(0,1)
var vectorDownRight:Vector2 = Vector2(0,1)
var vectorCenter:Vector2 = Vector2(0.5,0.5)

func _ready():
	pass

func _process(delta):
	if(Input.is_action_just_pressed("swipe_right")):
		notify_swipe_right()
	if(Input.is_action_just_pressed("swipe_left")):
		notify_swipe_left()
	if(Input.is_action_just_pressed("click_up_left")):
		notify_click_left_up()
	if(Input.is_action_just_pressed("click_up_right")):
		notify_click_right_up()
	if(Input.is_action_just_pressed("click_down_left")):
		notify_click_left_down()
	if(Input.is_action_just_pressed("click_down_right")):
		notify_click_right_down()


func notify_swipe_right():
	var input:InputWrapper = InputWrapper.new()
	input.initPosition= vectorUpLeft
	input.endPosition= vectorUpRight
	input.initTouchAreaName = inputLeftUpButton
	input.endTouchAreaName = inputRightUpButton
	notify_swipe.emit(input)

func notify_swipe_left():
	var input:InputWrapper = InputWrapper.new()
	input.initPosition= vectorUpRight
	input.endPosition= vectorUpLeft
	input.initTouchAreaName = inputRightUpButton
	input.endTouchAreaName = inputLeftUpButton
	notify_swipe.emit(input)

func notify_click_left_up():
	var input:InputWrapper = InputWrapper.new()
	input.initPosition= vectorUpLeft
	input.endPosition= vectorUpLeft
	input.initTouchAreaName = inputLeftUpButton
	input.endTouchAreaName = inputLeftUpButton
	notify_click.emit(input)


func notify_click_right_up():
	var input:InputWrapper = InputWrapper.new()
	input.initPosition= vectorUpRight
	input.endPosition= vectorUpRight
	input.initTouchAreaName = inputRightUpButton
	input.endTouchAreaName = inputRightUpButton
	notify_click.emit(input)

func notify_click_left_down():
	var input:InputWrapper = InputWrapper.new()
	input.initPosition= vectorDownLeft
	input.endPosition= vectorDownLeft
	input.initTouchAreaName = inputLeftDownButton
	input.endTouchAreaName = inputLeftDownButton
	notify_click.emit(input)

func notify_click_right_down():
	var input:InputWrapper = InputWrapper.new()
	input.initPosition= vectorDownRight
	input.endPosition= vectorDownRight
	input.initTouchAreaName = inputRightDownButton
	input.endTouchAreaName = inputRightDownButton
	notify_click.emit(input)
