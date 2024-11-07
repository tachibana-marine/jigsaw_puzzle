extends GutTest

var piece_shape_script = load("res://src/piece_shape.gd")
var piece_shape = null


func before_each():
    piece_shape = add_child_autofree(piece_shape_script.new())

func test_piece_dimple_properties():
    assert_property(piece_shape, "size", Vector2.ZERO, Vector2(100, 100))
    assert_property(piece_shape, "dimple", Vector4i(0, 0, 0, 0), Vector4i(10, -20, 30, -30))
    # 30x20
    assert_property(piece_shape, "dimple_shape", PackedVector2Array([]), PackedVector2Array([Vector2(0, 0), Vector2(0, -20), Vector2(30, -20), Vector2(30, 0)]))
    assert_eq(piece_shape.vertices, PackedVector2Array([Vector2(0, 0), Vector2(10, 0), Vector2(10, -20), Vector2(40, -20), Vector2(40, 0), Vector2(100, 0),
    Vector2(100, 20), Vector2(80, 20), Vector2(80, 50), Vector2(100, 50), Vector2(100, 100),
    Vector2(70, 100), Vector2(70, 120), Vector2(40, 120), Vector2(40, 100), Vector2(0, 100),
    Vector2(0, 70), Vector2(20, 70), Vector2(20, 40), Vector2(0, 40)]))

func test_dimple_accuracy_to_the_4th_digit():
    piece_shape.size = Vector2(100, 100)
    piece_shape.dimple_shape = PackedVector2Array([Vector2(0, 0), Vector2(0, -12.345), Vector2(23.456, -12.345), Vector2(23.456, 0)])
    piece_shape.dimple = Vector4i(0, 10, 0, 0)
    assert_eq(piece_shape.vertices, PackedVector2Array([Vector2(0, 0), Vector2(100, 0), Vector2(100, 10), Vector2(112.345, 10), Vector2(112.345, 33.456), Vector2(100, 33.456), Vector2(100, 100), Vector2(0, 100)]))
