extends GutTest

var jigsaw_puzzle_script = load("res://src/jigsaw_puzzle.gd")
var jigsaw_puzzle = null
var sprite = null

func before_each():
    jigsaw_puzzle = autofree(jigsaw_puzzle_script.new())
    sprite = jigsaw_puzzle.get_node("Sprite")
    
func test_can_set_texture():
    var image = Image.create_empty(10, 10, false, Image.FORMAT_RGB8)
    var image_texture = ImageTexture.create_from_image(image)
    assert_property(jigsaw_puzzle, "texture", null, image_texture)
    assert_eq(sprite.texture.get_image().get_data(), image.get_data())


func test_get_4_pieces_sorted_row_first():
    var image = Image.create_empty(10, 10, false, Image.FORMAT_RGB8)
    var image_texture = ImageTexture.create_from_image(image)
    jigsaw_puzzle.texture = image_texture

    var pieces = jigsaw_puzzle.get_pieces()
    assert_eq(pieces.size(), 4)
    assert_eq(pieces[0].region_rect, Rect2(0, 0, 4, 4))
    assert_eq(pieces[0].frame_coords, Vector2(0, 0))
    assert_eq(pieces[0].position, Vector2(0, 0))
    assert_eq(pieces[0].size, Vector2(5, 5))

    assert_eq(pieces[1].region_rect, Rect2(5, 0, 9, 4))
    assert_eq(pieces[1].position, Vector2(5, 0))
    assert_eq(pieces[1].size, Vector2(5, 5))
    
    assert_eq(pieces[2].region_rect, Rect2(0, 5, 4, 9))
    assert_eq(pieces[2].position, Vector2(0, 5))
    assert_eq(pieces[2].size, Vector2(5, 5))

    assert_eq(pieces[3].region_rect, Rect2(5, 5, 9, 9))
    assert_eq(pieces[3].position, Vector2(5, 5))
    assert_eq(pieces[3].size, Vector2(5, 5))
