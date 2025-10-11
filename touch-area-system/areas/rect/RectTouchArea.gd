class_name ReactTouchArea
extends TouchArea

@export var initLeftCornerPosition:Vector2
@export var horizontalSize:float
@export var verticalSize:float

#region corners
var leftUpCorner:Vector2
var leftDownCorner:Vector2
var rightUpCorner:Vector2
var rightDownCorner:Vector2
#endregion

var centerPosition:Vector2


@export var debug_draw:bool = true
@onready var debug_draw_line: Line2D = $debugDraw

func draw_debug_lines() -> void:
	if(debug_draw):
		debug_draw_line.clear_points()
		debug_draw_line.add_point(leftUpCorner)
		debug_draw_line.add_point(leftDownCorner)
		debug_draw_line.add_point(rightDownCorner)
		debug_draw_line.add_point(rightUpCorner)
		debug_draw_line.add_point(leftUpCorner)
		

func setPosition(leftUpPosition:Vector2):
	self.leftUpCorner = leftUpPosition
	calcArea()

func setHorizontalSize(h:float):
	self.horizontalSize = h
	calcArea()

func setVeticalSize(v:float):
	self.verticalSize = v
	calcArea()

func setSize(h:float,v:float):
	self.horizontalSize = h
	self.verticalSize = v
	calcArea()

func calcArea():
	var verticalSizeVector:Vector2 = verticalSize * Vector2.DOWN
	var horizontalSizeVector:Vector2 = horizontalSize * Vector2.RIGHT
	leftDownCorner = leftUpCorner + verticalSizeVector
	rightUpCorner = leftUpCorner + horizontalSizeVector
	rightDownCorner = leftUpCorner + verticalSizeVector + horizontalSizeVector
	centerPosition = rightDownCorner / 2
	
func isVectorInside(point:Vector2) -> bool:
	
	var c1 = point.x > leftUpCorner.x && point.y > leftUpCorner.y
	var c2 = point.x > leftDownCorner.x && point.y < leftDownCorner.y
	var c3 = point.x < rightDownCorner.x && point.y < rightDownCorner.y
	var c4 = point.x < rightUpCorner.x && point.y > rightUpCorner.y
	
	return c1 && c2 && c3 && c4


func _ready() -> void:
	leftUpCorner = Vector2(initLeftCornerPosition)
	calcArea()
	
