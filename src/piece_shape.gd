@tool
class_name PieceShape
extends Node2D

@export var size: Vector2 = Vector2.ZERO:
    get = get_size,
    set = set_size
    
# these functions must be declared so that child classes can override the setter
func get_size():
    return size
func set_size(value):
    size = value
    _update_polygon()


@export var dimple: Vector4i = Vector4i(0, 0, 0, 0):
    get: return dimple
    set(value):
        dimple = value
        _update_polygon()

@export var dimple_image: Texture2D = null:
    get: return dimple_image
    set(value):
        dimple_image = value
        if value == null:
            dimple_shape = PackedVector2Array([])
            return
        var bitmap = BitMap.new()
        bitmap.create_from_image_alpha(value.get_image())
        dimple_shape = bitmap.opaque_to_polygons(Rect2(0, 0, 40, 40))[0]

@export var dimple_shape: PackedVector2Array = []:
    get: return dimple_shape
    set(value):
        dimple_shape = _reshape_dimple_shape_to_start_from_bottom_right(value)
        _mirrored_dimple_shape = _get_mirrored_dimple_shape()
        _update_polygon()

var _mirrored_dimple_shape: PackedVector2Array = []

func _get_mirrored_dimple_shape() -> PackedVector2Array:
    var res: PackedVector2Array = dimple_shape.duplicate()
    res.reverse()
    for i in range(res.size()):
        res[i].x *= -1
    res = _reshape_dimple_shape_to_start_from_bottom_right(res)
    return res

func _get_bottom_right_of_polygon(input: PackedVector2Array):
    var bottom_right = -Vector2.INF
    for vertex in input:
        if vertex.x >= bottom_right.x && vertex.y >= bottom_right.y:
            bottom_right = vertex
    return bottom_right

func _get_bottom_left_of_polygon(input: PackedVector2Array):
    var bottom_left = Vector2(INF, -INF)
    for vertex in input:
        if vertex.x <= bottom_left.x && vertex.y >= bottom_left.y:
            bottom_left = vertex
    return bottom_left

func _get_dimple_shape(x, y, angle, is_cavity = false) -> PackedVector2Array:
    var shape = []
    var logger = []
    var local_dimple_shape = dimple_shape
    if is_cavity:
        local_dimple_shape = _mirrored_dimple_shape
    for vertex in local_dimple_shape:
        var tmp = vertex
        if is_cavity:
            tmp.y *= -1
        # round the result to the 4th digit
        tmp = (tmp.rotated(angle) * 1000).round() / 1000
        shape.append(tmp + Vector2(x, y))
        logger.append(tmp.rotated(angle))
    # print(logger, "logger")
    return shape

func _reshape_dimple_shape_to_start_from_bottom_right(input: PackedVector2Array):
    if input.is_empty():
        return input
    var bottom_right = _get_bottom_right_of_polygon(input)
    var index = input.find(bottom_right)
    var array: Array[Vector2] = []
    for i in range(input.size()):
        array.append(input[i] - bottom_right)

    return PackedVector2Array(array.slice(index, -1) + [array[-1]] + array.slice(0, index))
    
func _update_polygon():
    var coords = ["x", "y", "z", "w"]
    var is_cavity = []
    var positions = []
    
    var center_x = _get_bottom_right_of_polygon(dimple_shape).x - _get_bottom_left_of_polygon(dimple_shape).x
    center_x /= 2
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
        vertices += (_get_dimple_shape(size.x - (positions[0] - center_x), 0, 0, is_cavity[0]))
    vertices.append(Vector2(0, 0))
    if (is_cavity[1] != null):
        vertices += (_get_dimple_shape(0, positions[1] - center_x, 1.5 * PI, is_cavity[1]))
    vertices.append(Vector2(0, size.y))
    if (is_cavity[2] != null):
        vertices += (_get_dimple_shape(positions[2] - center_x, size.y, PI, is_cavity[2]))
    vertices.append(Vector2(size.x, size.y))
    if (is_cavity[3] != null):
        vertices += (_get_dimple_shape(size.x, size.y - (positions[3] - center_x), 0.5 * PI, is_cavity[3]))
    queue_redraw()

var vertices: PackedVector2Array = []

var draw_log: String = "":
    get: return draw_log

func _ready():
    if dimple_shape.is_empty():
        # dimple_shape = PackedVector2Array([Vector2(14, 4), Vector2(9, 4), Vector2(4, 10), Vector2(3, 10), Vector2(3, 17), Vector2(10, 25), Vector2(11, 25), Vector2(12, 30), Vector2(13, 30), Vector2(10, 37), Vector2(10, 40), Vector2(27, 40), Vector2(26, 36), Vector2(26, 28), Vector2(29, 20), Vector2(30, 20), Vector2(26, 9), Vector2(26, 7), Vector2(14, 3)])
        pass
func _draw() -> void:
    draw_log = ""
    draw_polygon(vertices, [Color.WHITE])
    # for i in range(vertices.size()):
    #     if i == 0:
    #      continue
    #     draw_line(vertices[i - 1], vertices[i], Color.WHITE, 5)
