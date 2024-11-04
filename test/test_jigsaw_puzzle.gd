extends GutTest

var jigsaw_puzzle_script = load("res://src/jigsaw_puzzle.gd")
var jigsaw_puzzle = null

func create_empty_image_texture(width: int, height: int):
    var image = Image.create_empty(width, height, false, Image.FORMAT_RGB8)
    return ImageTexture.create_from_image(image)
    

func before_each():
    jigsaw_puzzle = autofree(jigsaw_puzzle_script.new())
    
func test_can_set_texture():
    var image_texture = create_empty_image_texture(10, 10)
    assert_property(jigsaw_puzzle, "texture", null, image_texture)

func test_get_4_pieces_arranged_randomly():
    seed(1)
    jigsaw_puzzle.texture = create_empty_image_texture(10, 10)
    var pieces = jigsaw_puzzle.get_pieces()
    assert_eq(pieces.size(), 4)
    var i = 0
    var displaced_count = 0
    for y in range(2):
        for x in range(2):
            if (pieces[i].frame_coords != Vector2i(x, y)):
                displaced_count += 1
            i += 1
    assert_ne(displaced_count, 0)
