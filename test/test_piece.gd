extends GutTest

var piece_script = load("res://src/piece.gd")
var piece = null
var sprite = null
var background = null

func create_empty_image_texture(width: int, height: int):
    var image = Image.create_empty(width, height, false, Image.FORMAT_RGB8)
    return ImageTexture.create_from_image(image)

func before_each():
    piece = autofree(piece_script.new())
    sprite = piece.get_node("Sprite")
    background = piece.get_node("Background")

func test_piece_properties():
    var image_texture = create_empty_image_texture(1000, 1000)
    piece.size = Vector2(10, 10)
    # background covers twice as large area as the piece_shape
    # so that the dimples can be covered
    assert_eq(background.size, Vector2(20, 20))
    assert_eq(background.position, Vector2(-5, -5))
    assert_property(piece, "texture", null, image_texture)
    assert_eq(sprite.texture, image_texture)
    assert_property(piece, "dimensions", Vector2i(1, 1), Vector2i(10, 10))
    assert_property(piece, "frame_coords", Vector2i(0, 0), Vector2i(1, 1))
    assert_eq(sprite.offset, Vector2(-10, -10))
    assert_property(piece, "region_rect", Rect2(0, 0, 0, 0), Rect2(0, 0, 100, 100))
