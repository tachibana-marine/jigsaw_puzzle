extends GutTest

func test_rectangle_properties():
    var rectangle = autofree(Rectangle.new())
    assert_property(rectangle, "size", Vector2(0, 0), Vector2(10, 10))
    assert_property(rectangle, "color", Color.WHITE, Color.RED)

func test_rectangle_draw():
    var rectangle = Rectangle.new()
    rectangle.size = Vector2(10, 10)
    add_child_autofree(rectangle)
    await wait_frames(1)
    assert_eq(rectangle.log_string, "(0,0,10,10)")