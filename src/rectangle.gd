class_name Rectangle
extends Node2D

var size: Vector2 = Vector2.ZERO:
  get:
    return size
  set(value):
    size = value

var color: Color = Color.WHITE:
  get:
    return color
  set(value):
    color = value

var log_string: String = "":
  get:
    return log_string


func _draw() -> void:
  log_string = "(0,0,{0},{1})".format([size.x, size.y])
  draw_rect(Rect2(Vector2.ZERO, size), color)
