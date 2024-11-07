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

func _get_dimple_shape(x, y, angle, is_cavity = false) -> PackedVector2Array:
    var shape = []
    var logger = []
    for vertex in dimple_shape:
        var tmp = vertex
        if is_cavity:
            tmp.y *= -1
        # round the result to the 4th digit
        tmp = (tmp.rotated(angle) * 1000).round() / 1000
        shape.append(tmp + Vector2(x, y))
        logger.append(tmp.rotated(angle))
    print(logger, "logger")
    return shape

func _update_polygon():
    var coords = ["x", "y", "z", "w"]
    var is_cavity = []
    var positions = []
    for coord in coords:
       var d = dimple[coord]
       positions.append(abs(d))
       if (d > 0):
           is_cavity.append(false)
       elif (d < 0):
           is_cavity.append(true)
       else:
           is_cavity.append(null)

    vertices = [Vector2(0, 0)]
    if (is_cavity[0] != null):
        vertices += (_get_dimple_shape(positions[0], 0, 0, is_cavity[0]))
    vertices.append(Vector2(100, 0))
    if (is_cavity[1] != null):
        vertices += (_get_dimple_shape(100, positions[1], 0.5 * PI, is_cavity[1]))
    vertices.append(Vector2(100, 100))
    if (is_cavity[2] != null):
        vertices += (_get_dimple_shape(100 - positions[2], 100, PI, is_cavity[2]))
    vertices.append(Vector2(0, 100))
    if (is_cavity[3] != null):
        vertices += (_get_dimple_shape(0, 100 - positions[3], 1.5 * PI, is_cavity[3]))
    print(vertices)
    queue_redraw()

var vertices: PackedVector2Array = []

var draw_log: String = "":
    get: return draw_log

    
func _draw() -> void:
    draw_log = ""
    draw_polygon(vertices, [Color.WHITE])
