extends GutTest

var jigsaw_puzzle = null
var piece_holder = null

func create_empty_image_texture(width: int, height: int):
    var image = Image.create_empty(width, height, false, Image.FORMAT_RGB8)
    return ImageTexture.create_from_image(image)
    

func before_each():
    jigsaw_puzzle = autofree(JigsawPuzzle.new())
    piece_holder = jigsaw_puzzle.get_node("PieceHolder")

func test_setting_split_creates_pieces():
    jigsaw_puzzle.texture = create_empty_image_texture(360, 360)
    assert_property(jigsaw_puzzle, "split_dimension", Vector2i(1, 1), Vector2i(3, 3))
    assert_property(jigsaw_puzzle, "margin", 2, 20)
    var pieces = jigsaw_puzzle.get_pieces()
    assert_eq(pieces.size(), 9)
    assert_eq(pieces[0].texture, jigsaw_puzzle.texture)

    # assert piece positions
    assert_eq(pieces[4].image_offset, Vector2(-120, -120))
    assert_eq(pieces[4].position, Vector2(120 + 20, 120 + 20))
    assert_eq(pieces[5].position, Vector2(240 + 20 * 2, 120 + 20))

    # assert piece shapes
    assert_eq(pieces[0].size, Vector2(120, 120))
    assert_ne(pieces[4].dimple, Vector4i(0, 0, 0, 0))
    assert_not_null(pieces[4].dimple_image)
    assert_ne(pieces[4].dimple_shape, PackedVector2Array([]))

    # assert piece edges
    # top left
    assert_eq(pieces[0].dimple.x, 0)
    assert_eq(pieces[0].dimple.y, 0)
    assert_eq(pieces[0].dimple.z, 120 - pieces[3].dimple.z)
    assert_eq(pieces[0].dimple.w, 120 - pieces[1].dimple.y)
    # top middle
    assert_eq(pieces[1].dimple.x, 0)
    assert_eq(pieces[1].dimple.z, 120 - pieces[4].dimple.x)
    assert_eq(pieces[1].dimple.w, 120 - pieces[2].dimple.y)
    # top right
    assert_eq(pieces[2].dimple.x, 0)
    assert_eq(pieces[2].dimple.z, 120 - pieces[5].dimple.x)
    assert_eq(pieces[2].dimple.w, 0)
    # center left
    assert_eq(pieces[3].dimple.y, 0)
    assert_eq(pieces[3].dimple.z, 120 - pieces[6].dimple.x)
    assert_eq(pieces[3].dimple.w, 120 - pieces[5].dimple.y)
    # center right
    assert_eq(pieces[5].dimple.z, 120 - pieces[7].dimple.x)
    assert_eq(pieces[5].dimple.w, 0)
    # bottom left
    assert_eq(pieces[6].dimple.y, 0)
    assert_eq(pieces[6].dimple.z, 0)
    assert_eq(pieces[6].dimple.w, 120 - pieces[7].dimple.y)
    # bottom middle
    assert_eq(pieces[7].dimple.z, 0)
    assert_eq(pieces[7].dimple.w, 120 - pieces[8].dimple.y)
    # bottom right
    assert_eq(pieces[8].dimple.w, 0)
    assert_eq(pieces[8].dimple.z, 0)

    # assert adjacent piece dimples
    # assert_eq(pieces[1].dimple.y, 100)
    
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

func test_can_change_texture_to_null():
    jigsaw_puzzle.texture = null
    assert_null(jigsaw_puzzle.texture)
    jigsaw_puzzle.split_dimension = Vector2(2, 2)
    var pieces = jigsaw_puzzle.get_pieces()
    assert_eq(jigsaw_puzzle.split_dimension, Vector2i(2, 2))
    assert_eq(pieces.size(), 0)
