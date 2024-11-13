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
        dimple_shape = _reshape_dimple_shape_to_start_from_bottom_left(value)
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
    # print(logger, "logger")
    return shape

func _reshape_dimple_shape_to_start_from_bottom_left(input: PackedVector2Array):
    if input.is_empty():
        return input
    var array: Array[Vector2] = []
    var bottom_right = Vector2(-INF, -INF)
    var index = 0
    var i = 0
    for vertex in input:
        if vertex.x > bottom_right.x && vertex.y > bottom_right.y:
            bottom_right = vertex
            index = i
        array.append(vertex)
        i += 1
    print("bottom_right, ", bottom_right)
    for j in range(array.size()):
        array[j] -= bottom_right
        
    return PackedVector2Array(array.slice(index, -1) + [array[-1]] + array.slice(0, index))
    
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
    vertices = [Vector2(size.x, 0)]
    if (is_cavity[0] != null):
        vertices += (_get_dimple_shape(size.x - positions[0], 0, 0, is_cavity[0]))
    vertices.append(Vector2(0, 0))
    if (is_cavity[1] != null):
        vertices += (_get_dimple_shape(0, positions[1], 1.5 * PI, is_cavity[1]))
    vertices.append(Vector2(0, size.y))
    if (is_cavity[2] != null):
        vertices += (_get_dimple_shape(positions[2], size.y, PI, is_cavity[2]))
    vertices.append(Vector2(size.x, size.y))
    if (is_cavity[3] != null):
        vertices += (_get_dimple_shape(size.x, size.y - positions[3], 0.5 * PI, is_cavity[3]))
    print(vertices)
    queue_redraw()

var vertices: PackedVector2Array = []

var draw_log: String = "":
    get: return draw_log

func _ready():
    if dimple_shape.is_empty():
        dimple_shape = PackedVector2Array([Vector2(14, 4), Vector2(9, 4), Vector2(4, 10), Vector2(3, 10), Vector2(3, 17), Vector2(10, 25), Vector2(11, 25), Vector2(12, 30), Vector2(13, 30), Vector2(10, 37), Vector2(10, 40), Vector2(27, 40), Vector2(26, 36), Vector2(26, 28), Vector2(29, 20), Vector2(30, 20), Vector2(26, 9), Vector2(26, 7), Vector2(14, 3)])
        pass
func _draw() -> void:
    draw_log = ""
    draw_polygon(vertices, [Color.WHITE])
