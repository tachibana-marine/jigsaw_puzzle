@tool
class_name PieceShape
extends Node2D

@export var size: Vector2 = Vector2.ZERO:
    get: return size
    set(value):
        size = value
        queue_redraw()

@export var dimple: Vector4i = Vector4i(0, 0, 0, 0):
    get: return dimple
    set(value):
        dimple = value
        queue_redraw()

@export var dimple_shape: PackedVector2Array = []:
    get: return dimple_shape
    set(value):
        dimple_shape = value


var vertices: PackedVector2Array = [Vector2(0, 0), Vector2(10, 0), Vector2(10, -20), Vector2(40, -20), Vector2(40, 0), Vector2(100, 0),
    Vector2(100, 20), Vector2(80, 20), Vector2(80, 50), Vector2(100, 50), Vector2(100, 100),
    Vector2(70, 100), Vector2(70, 120), Vector2(40, 120), Vector2(40, 100), Vector2(0, 100),
    Vector2(0, 70), Vector2(20, 70), Vector2(20, 40), Vector2(0, 40)]

var draw_log: String = "":
    get: return draw_log

    
func _draw() -> void:
    draw_log = ""
    draw_polygon(vertices, [Color.WHITE])
    # draw_rect(Rect2(0, 0, size.x, size.y), Color.WHITE)
    # draw_log += "base " + str(size.x) + "," + str(size.y) + "\n"
    # var dimple_radius = 15
    # var dimple_height = 35
    # draw_rect(Rect2(30 - dimple_radius, -dimple_height, 2 * dimple_radius, dimple_height), Color.WHITE)
    # draw_log += "dimple 30,0\n"
    # draw_rect(Rect2(30 - dimple_radius, 100 - dimple_height, 2 * dimple_radius, dimple_height), Color.BLACK)
    # draw_log += "dimple 30,0\n"
