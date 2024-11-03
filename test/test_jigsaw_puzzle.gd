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
    var i = 0
    for y in range(2):
        for x in range(2):
            print(i)
            assert_eq(pieces[i].vframes, 2)
            assert_eq(pieces[i].hframes, 2)
            assert_eq(pieces[i].frame_coords, Vector2i(x, y))
            assert_eq(pieces[i].position, Vector2(x * 5, y * 5))
            i += 1
