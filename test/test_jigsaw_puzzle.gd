extends GutTest

var jigsaw_puzzle = null
var piece_holder = null
var double_rand = null


func create_empty_image_texture(width: int, height: int):
  var image = Image.create_empty(width, height, false, Image.FORMAT_RGB8)
  return ImageTexture.create_from_image(image)


func before_each():
  double_rand = partial_double(RandomTools).new()
  jigsaw_puzzle = autofree(JigsawPuzzle.new())
  jigsaw_puzzle.random_tool = double_rand
  piece_holder = jigsaw_puzzle.get_node("PieceHolder")


func test_split_dim_can_be_set_but_must_be_greater_than_zero():
  assert_property(jigsaw_puzzle, "split_dimension", Vector2i(2, 2), Vector2i(3, 3))
  jigsaw_puzzle.split_dimension = Vector2i(0, 0)
  assert_eq(jigsaw_puzzle.split_dimension, Vector2i(3, 3))
  jigsaw_puzzle.split_dimension = Vector2i(2, 0)
  assert_eq(jigsaw_puzzle.split_dimension, Vector2i(3, 3))
  jigsaw_puzzle.split_dimension = Vector2i(0, 2)
  assert_eq(jigsaw_puzzle.split_dimension, Vector2i(3, 3))


func test_can_set_texture():
  var image_texture = create_empty_image_texture(100, 100)
  assert_property(jigsaw_puzzle, "texture", null, image_texture)
  var pieces = jigsaw_puzzle.get_pieces()
  assert_eq(pieces[0].texture, jigsaw_puzzle.texture)


func test_can_change_texture_to_null():
  jigsaw_puzzle.texture = null
  assert_null(jigsaw_puzzle.texture)
  jigsaw_puzzle.split_dimension = Vector2(2, 2)
  var pieces = jigsaw_puzzle.get_pieces()
  assert_eq(jigsaw_puzzle.split_dimension, Vector2i(2, 2))
  assert_eq(pieces.size(), 0)


func test_edge_dimples_do_not_exist():
  jigsaw_puzzle.texture = create_empty_image_texture(400, 400)
  jigsaw_puzzle.split_dimension = Vector2i(3, 3)
  var pieces = jigsaw_puzzle.get_pieces()
  # Top left
  assert_eq(pieces[0].dimple.x, 0)
  assert_eq(pieces[0].dimple.y, 0)
  # Top Middle
  assert_eq(pieces[1].dimple.x, 0)
  # Top Right
  assert_eq(pieces[2].dimple.x, 0)
  assert_eq(pieces[2].dimple.w, 0)
  # Middle Left
  assert_eq(pieces[3].dimple.y, 0)
  # Middle Right
  assert_eq(pieces[5].dimple.w, 0)
  # Bottom Left
  assert_eq(pieces[6].dimple.y, 0)
  assert_eq(pieces[6].dimple.z, 0)
  # Bottom Middle
  assert_eq(pieces[7].dimple.z, 0)
  # Bottom Right
  assert_eq(pieces[8].dimple.z, 0)
  assert_eq(pieces[8].dimple.w, 0)


func test_piece_dimple_does_not_intersect_each_other():
  jigsaw_puzzle.texture = create_empty_image_texture(150, 150)
  jigsaw_puzzle.split_dimension = Vector2i(3, 3)
  var dimple_image = jigsaw_puzzle.dimple_image

  var size = dimple_image.get_size()
  size *= jigsaw_puzzle.dimple_magnification
  size.y += 2  # margin
  var piece = jigsaw_puzzle.get_pieces()[4]
  var rand_range_params = get_call_parameters(double_rand, "a_randi_range")
  assert_eq(rand_range_params, [size.y, piece.get_size().x - size.y])


func test_center_piece_has_aligned_dimples():
  jigsaw_puzzle.texture = create_empty_image_texture(300, 300)
  jigsaw_puzzle.split_dimension = Vector2i(3, 3)
  var pieces = jigsaw_puzzle.get_pieces()
  var middle_piece = pieces[4]

  # assert piece shapes
  assert_eq(middle_piece.size, Vector2(100, 100))
  assert_ne(middle_piece.dimple, Vector4i(0, 0, 0, 0))
  assert_ne(middle_piece.dimple_shape, PackedVector2Array([]))

  # assert_eq(pieces[1].dimple.z, 100 - pieces[4].dimple.x)
  assert_eq(
    pieces[4].dimple.y,
    -1 * (pieces[3].dimple.w / abs(pieces[3].dimple.w)) * (100 - abs(pieces[3].dimple.w))
  )
  assert_eq(
    pieces[4].dimple.x,
    -1 * (pieces[1].dimple.z / abs(pieces[1].dimple.z)) * (100 - abs(pieces[1].dimple.z))
  )
  # assert_eq(pieces[5].dimple.y, 100 - pieces[4].dimple.w)
  # assert_eq(pieces[7].dimple.x, 100 - pieces[4].dimple.z)


func test_dimple_ratio_correctly_scales_dimple_shape():
  # currently dimple_shape is 40x40 image
  jigsaw_puzzle.texture = create_empty_image_texture(150, 300)
  jigsaw_puzzle.split_dimension = Vector2i(3, 3)
  jigsaw_puzzle.dimple_ratio = 30  # 30%
  assert_eq(jigsaw_puzzle.dimple_magnification * 40, 50 * 0.3)
  # dimple_magnification is determined by the smaller side
  jigsaw_puzzle.texture = create_empty_image_texture(300, 150)
  jigsaw_puzzle.split_dimension = Vector2i(3, 3)
  jigsaw_puzzle.dimple_ratio = 30  # 30%
  assert_eq(jigsaw_puzzle.dimple_magnification * 40, 50 * 0.3)
