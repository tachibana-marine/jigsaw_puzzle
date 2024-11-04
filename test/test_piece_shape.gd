extends GutTest

var piece_shape_script = load("res://src/piece_shape.gd")
var piece_shape = null


func before_each():
    piece_shape = add_child_autofree(piece_shape_script.new())

func test_piece_shape_properties():
    assert_property(piece_shape, "size", Vector2.ZERO, Vector2(100, 100))
    assert_property(piece_shape, "dimple", Vector4i(-1, -1, -1, -1), Vector4i(10, -1, -1, 20))
    await wait_frames(1)
    assert_eq(piece_shape.draw_log, "base 100,100\ndimple 10,0\n")
