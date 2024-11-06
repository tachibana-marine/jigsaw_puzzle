@tool
class_name PieceShape
extends Node2D

@export var size: Vector2 = Vector2.ZERO:
    get: return size
    set(value):
        size = value
        _update_polygon()

@export var dimple: Vector4i = Vector4i(0, 0, 0, 0):
    get: return dimple
    set(value):
        dimple = value
        _update_polygon()

@export var dimple_shape: PackedVector2Array = []:
    get: return dimple_shape
    set(value):
        dimple_shape = value
        _update_polygon()

func _get_dimple_shape(x, y) -> PackedVector2Array:
    var shape = dimple_shape
    for vertex in shape:
        vertex += Vector2(x, y)
    return shape

func _update_polygon():
    # vertices = [Vector2(0, 0)]
    # if (dimple.x > 0):
    #     vertices.append(Vector2(dimple.x, 0))
    #     vertices += (_get_dimple_shape(dimple.x, 0))
    queue_redraw()

var vertices: PackedVector2Array = [Vector2(0, 0), Vector2(10, 0), Vector2(10, -20), Vector2(40, -20), Vector2(40, 0), Vector2(100, 0),
    Vector2(100, 20), Vector2(80, 20), Vector2(80, 50), Vector2(100, 50), Vector2(100, 100),
    Vector2(70, 100), Vector2(70, 120), Vector2(40, 120), Vector2(40, 100), Vector2(0, 100),
    Vector2(0, 70), Vector2(20, 70), Vector2(20, 40), Vector2(0, 40)]

var draw_log: String = "":
    get: return draw_log

    
func _draw() -> void:
    draw_log = ""
    draw_polygon(vertices, [Color.WHITE])
