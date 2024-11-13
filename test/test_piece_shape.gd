extends GutTest

var piece_shape_script = load("res://src/piece_shape.gd")
var piece_shape = null


func before_each():
    piece_shape = add_child_autofree(piece_shape_script.new())

func test_piece_dimple_properties():
    assert_property(piece_shape, "size", Vector2.ZERO, Vector2(100, 100))
    assert_property(piece_shape, "dimple", Vector4i(0, 0, 0, 0), Vector4i(10, -20, 30, -30))
    # 30x20
    assert_property(piece_shape, "dimple_shape", PackedVector2Array([]), PackedVector2Array([Vector2(0, 0), Vector2(0, -20), Vector2(-30, -20), Vector2(-30, 0)]))
    assert_eq(piece_shape.vertices, PackedVector2Array([Vector2(100, 0), Vector2(90, 0), Vector2(90, -20), Vector2(60, -20), Vector2(60, 0), Vector2(0, 0),
    Vector2(0, 20), Vector2(20, 20), Vector2(20, 50), Vector2(0, 50), Vector2(0, 100),
    Vector2(30, 100), Vector2(30, 120), Vector2(60, 120), Vector2(60, 100), Vector2(100, 100),
    Vector2(100, 70), Vector2(80, 70), Vector2(80, 40), Vector2(100, 40)]))

func test_dimple_shape_starts_from_bottom_right():
    piece_shape.dimple_shape = PackedVector2Array([Vector2(10, -20), Vector2(0, 0), Vector2(20, 0)])
    assert_eq(piece_shape.dimple_shape, PackedVector2Array([Vector2(0, 0), Vector2(-10, -20), Vector2(-20, 0)]))

func test_set_empty_dimple_shape():
    piece_shape.dimple_shape = PackedVector2Array([])
    assert_eq(piece_shape.dimple_shape, PackedVector2Array([]))

func test_shape_changes_based_on_size():
    piece_shape.size = Vector2(200, 150)
    assert_eq(piece_shape.vertices, PackedVector2Array([Vector2(200, 0), Vector2(0, 0), Vector2(0, 150), Vector2(200, 150)]))

func test_has_dimple_image_property():
    var img = Image.create_empty(30, 20, false, Image.FORMAT_RGB8)
    assert_property(piece_shape, "dimple_image", null, img)

func test_dimple_accuracy_to_the_4th_digit():
    piece_shape.size = Vector2(100, 100)
    piece_shape.dimple_shape = PackedVector2Array([Vector2(0, 0), Vector2(0, -12.345), Vector2(-23.456, -12.345), Vector2(-23.456, 0)])
    piece_shape.dimple = Vector4i(0, 10, 0, 0)
    assert_eq(piece_shape.vertices, PackedVector2Array([Vector2(100, 0), Vector2(0, 0), Vector2(0, 10), Vector2(-12.345, 10), Vector2(-12.345, 33.456), Vector2(0, 33.456), Vector2(0, 100), Vector2(100, 100)]))

func test_dp():
    var image = Image.load_from_file("res://asset/piece_dimple.png")
    var bitmap = BitMap.new()
    bitmap.create_from_image_alpha(image)
    print(bitmap.opaque_to_polygons(Rect2i(0, 0, 40, 40)))
    var img = Image.create_empty(30, 20, false, Image.FORMAT_RGB8)
    bitmap.create_from_image_alpha(img)
    print(bitmap.opaque_to_polygons(Rect2i(0, 0, 40, 40)))