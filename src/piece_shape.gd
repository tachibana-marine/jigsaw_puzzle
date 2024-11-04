@tool
class_name PieceShape
extends Node2D

@export var size: Vector2 = Vector2.ZERO:
    get: return size
    set(value):
        size = value
        queue_redraw()

@export var dimple: Vector4i = Vector4i(-1, -1, -1, -1):
    get: return dimple
    set(value):
        dimple = value
        queue_redraw()

var draw_log: String = "":
    get: return draw_log

func _draw() -> void:
    draw_log = ""
    draw_rect(Rect2(0, 0, size.x, size.y), Color.RED)
    draw_log += "base " + str(size.x) + "," + str(size.y) + "\n"
    var dimple_radius = 15
    var dimple_height = 35
    draw_rect(Rect2(30 - dimple_radius, -dimple_height, 2 * dimple_radius, dimple_height), Color.RED)
    draw_log += "dimple 30,0\n"
