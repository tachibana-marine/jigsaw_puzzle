extends GutTest

var jigsaw_puzzle = null
var piece_holder = null

func create_empty_image_texture(width: int, height: int):
    var image = Image.create_empty(width, height, false, Image.FORMAT_RGB8)
    return ImageTexture.create_from_image(image)
    

func before_each():
    jigsaw_puzzle = autofree(JigsawPuzzle.new())
    piece_holder = jigsaw_puzzle.get_node("PieceHolder")

func test_can_split_image():
    jigsaw_puzzle.texture = create_empty_image_texture(15, 15)
    assert_property(jigsaw_puzzle, "split_dimension", Vector2i(1, 1), Vector2i(3, 3))
    var pieces = jigsaw_puzzle.get_pieces()
    assert_eq(pieces.size(), 9)
    assert_eq(pieces[0].size, Vector2(5, 5))
    assert_eq(pieces[0].texture, jigsaw_puzzle.texture)
    assert_eq(pieces[4].image_offset, Vector2(-5, -5))
    assert_eq(pieces[4].position, Vector2(7, 7))
    assert_eq(pieces[5].position, Vector2(14, 7))

    
func test_split_dim_must_be_greater_than_zero():
    jigsaw_puzzle.split_dimension = Vector2i(0, 0)
    assert_eq(jigsaw_puzzle.split_dimension, Vector2i(1, 1))
    jigsaw_puzzle.split_dimension = Vector2i(2, 0)
    assert_eq(jigsaw_puzzle.split_dimension, Vector2i(1, 1))
    jigsaw_puzzle.split_dimension = Vector2i(0, 2)
    assert_eq(jigsaw_puzzle.split_dimension, Vector2i(1, 1))

func test_can_set_texture():
    var image_texture = create_empty_image_texture(10, 10)
    assert_property(jigsaw_puzzle, "texture", null, image_texture)

# func test_can_change_texture_to_null():
#     var image_texture = create_empty_image_texture(10, 10)
#     assert_property(jigsaw_puzzle, "texture", null, image_texture)
#     jigsaw_puzzle.texture = null
#     assert_null(jigsaw_puzzle.texture)
