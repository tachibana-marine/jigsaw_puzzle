extends GutTest

var jigsaw_puzzle = null
var piece_holder = null


func create_empty_image_texture(width: int, height: int):
  var image = Image.create_empty(width, height, false, Image.FORMAT_RGB8)
  return ImageTexture.create_from_image(image)


func before_each():
  jigsaw_puzzle = autofree(JigsawPuzzle.new())
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
  jigsaw_puzzle.split_dimension = Vector2i(2, 2)
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


# func test_piece_dimple_does_not_intersect_each_other():
#   jigsaw_puzzle.texture = create_empty_image_texture(400, 400)
#   jigsaw_puzzle.split_dimension = Vector2i(2, 2)


func test_center_piece_has_aligned_dimples():
  jigsaw_puzzle.texture = create_empty_image_texture(300, 300)
  jigsaw_puzzle.split_dimension = Vector2i(3, 3)
  var pieces = jigsaw_puzzle.get_pieces()
  var middle_piece = pieces[4]

  # assert piece shapes
  assert_eq(middle_piece.size, Vector2(100, 100))
  assert_ne(middle_piece.dimple, Vector4i(0, 0, 0, 0))
  assert_ne(middle_piece.dimple_shape, PackedVector2Array([]))

  # assert piece edges
  # top left

#   assert_eq(pieces[0].dimple.z, 120 - pieces[3].dimple.z)
#   assert_eq(pieces[0].dimple.w, 120 - pieces[1].dimple.y)

#   # top middle
#   assert_eq(pieces[1].dimple.x, 0)
#   assert_eq(pieces[1].dimple.z, 120 - pieces[4].dimple.x)
#   assert_eq(pieces[1].dimple.w, 120 - pieces[2].dimple.y)
#   # top right
#   assert_eq(pieces[2].dimple.x, 0)
#   assert_eq(pieces[2].dimple.z, 120 - pieces[5].dimple.x)
#   assert_eq(pieces[2].dimple.w, 0)
#   # center left
#   assert_eq(pieces[3].dimple.y, 0)
#   assert_eq(pieces[3].dimple.z, 120 - pieces[6].dimple.x)
#   assert_eq(pieces[3].dimple.w, 120 - pieces[5].dimple.y)
#   # center right
#   assert_eq(pieces[5].dimple.z, 120 - pieces[7].dimple.x)
#   assert_eq(pieces[5].dimple.w, 0)
#   # bottom left
#   assert_eq(pieces[6].dimple.y, 0)
#   assert_eq(pieces[6].dimple.z, 0)
#   assert_eq(pieces[6].dimple.w, 120 - pieces[7].dimple.y)
#   # bottom middle
#   assert_eq(pieces[7].dimple.z, 0)
#   assert_eq(pieces[7].dimple.w, 120 - pieces[8].dimple.y)
#   # bottom right
#   assert_eq(pieces[8].dimple.w, 0)
#   assert_eq(pieces[8].dimple.z, 0)

# assert adjacent piece dimples
# assert_eq(pieces[1].dimple.y, 100)
