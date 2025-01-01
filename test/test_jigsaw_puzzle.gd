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
  var pieces = jigsaw_puzzle.get_pieces()
  assert_eq(pieces[0].texture, jigsaw_puzzle.texture)


func test_can_change_texture_to_null():
  jigsaw_puzzle.texture = null
  assert_null(jigsaw_puzzle.texture)
  jigsaw_puzzle.split_dimension = Vector2(2, 2)
  var pieces = jigsaw_puzzle.get_pieces()
  assert_eq(jigsaw_puzzle.split_dimension, Vector2i(2, 2))
  assert_eq(pieces.size(), 0)


func test_shuffle_randomly_changes_piece_position():
  jigsaw_puzzle.texture = create_empty_image_texture(100, 100)
  jigsaw_puzzle.split_dimension = Vector2i(2, 2)
  jigsaw_puzzle.shuffle(0, 100)
  var pieces = jigsaw_puzzle.get_pieces()
  assert_ne(pieces[0].position, Vector2(0, 0))
  assert_ne(pieces[1].position, Vector2(50, 0))
  assert_ne(pieces[2].position, Vector2(0, 50))
  assert_ne(pieces[3].position, Vector2(50, 50))


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
  var double_rand = partial_double(RandomTools).new()
  jigsaw_puzzle.random_tools = double_rand

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

  assert_eq(
    pieces[4].dimple.y,
    -1 * (pieces[3].dimple.w / abs(pieces[3].dimple.w)) * (100 - abs(pieces[3].dimple.w))
  )
  assert_eq(
    pieces[4].dimple.x,
    -1 * (pieces[1].dimple.z / abs(pieces[1].dimple.z)) * (100 - abs(pieces[1].dimple.z))
  )


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


func test_connected_pieces_adjust_position_automatically():
  jigsaw_puzzle.texture = create_empty_image_texture(150, 150)
  jigsaw_puzzle.split_dimension = Vector2i(3, 3)
  jigsaw_puzzle.margin = 20
  var pieces = jigsaw_puzzle.get_pieces()
  # connects the first and the second piece.
  jigsaw_puzzle._on_piece_connected(pieces[0], pieces[1])
  assert_eq(pieces[0].position, Vector2(20, 0))
  # connecting a piece to a chunck moves the chunck to the piece
  jigsaw_puzzle._on_piece_connected(pieces[1], pieces[2])
  # the third piece is at (140,0) so the first piece is moved to (40,0)
  assert_eq(pieces[0].position, Vector2(40, 0))


func test_pieces_dont_connect_to_a_non_adjacent_piece():
  jigsaw_puzzle.texture = create_empty_image_texture(150, 150)
  jigsaw_puzzle.split_dimension = Vector2i(3, 3)
  var pieces = jigsaw_puzzle.get_pieces()
  # connects the first and fifth piece.
  jigsaw_puzzle._on_piece_connected(pieces[0], pieces[4])
  assert_eq(jigsaw_puzzle.get_piece_chunks(), [])


func test_connected_pieces_wont_connect_again():
  jigsaw_puzzle.texture = create_empty_image_texture(150, 150)
  jigsaw_puzzle.split_dimension = Vector2i(3, 3)
  var pieces = jigsaw_puzzle.get_pieces()
  # connects the first and second piece.
  jigsaw_puzzle._on_piece_connected(pieces[0], pieces[1])
  # connects the first and second again.
  jigsaw_puzzle._on_piece_connected(pieces[0], pieces[1])
  assert_eq(jigsaw_puzzle.get_piece_chunks(), [[pieces[0], pieces[1]]])


func test_a_piece_connects_to_a_chunk():
  jigsaw_puzzle.texture = create_empty_image_texture(150, 150)
  jigsaw_puzzle.split_dimension = Vector2i(3, 3)
  var pieces = jigsaw_puzzle.get_pieces()
  # connects the first and second piece.
  jigsaw_puzzle._on_piece_connected(pieces[0], pieces[1])
  # connects the first and fourth piece (chunk on piece)
  jigsaw_puzzle._on_piece_connected(pieces[0], pieces[3])
  # connects the second and third piece (piece on chunk)
  jigsaw_puzzle._on_piece_connected(pieces[2], pieces[1])

  assert_eq(jigsaw_puzzle.get_piece_chunks().size(), 1)
  assert_eq(jigsaw_puzzle.get_piece_chunks()[0].size(), 4)
  assert_eq(jigsaw_puzzle.get_piece_chunks(), [[pieces[0], pieces[1], pieces[3], pieces[2]]])


func test_chunk_merges():
  jigsaw_puzzle.texture = create_empty_image_texture(150, 150)
  jigsaw_puzzle.split_dimension = Vector2i(3, 3)
  var pieces = jigsaw_puzzle.get_pieces()
  # connects the first and second piece.
  jigsaw_puzzle._on_piece_connected(pieces[0], pieces[1])
  # connects the third and fourth piece
  jigsaw_puzzle._on_piece_connected(pieces[2], pieces[5])
  # connects a piece in chunk with a piece in chunk
  jigsaw_puzzle._on_piece_connected(pieces[1], pieces[2])

  assert_eq(jigsaw_puzzle.get_piece_chunks().size(), 1)
  assert_eq(jigsaw_puzzle.get_piece_chunks()[0].size(), 4)
  assert_eq(jigsaw_puzzle.get_piece_chunks(), [[pieces[0], pieces[1], pieces[2], pieces[5]]])


class TestJigsawPuzzle:
  extends GutTest
  # Might as well move this to Integration test

  var _sender = InputSender.new(Input)

  func create_empty_image_texture(width: int, height: int):
    var image = Image.create_empty(width, height, false, Image.FORMAT_RGB8)
    return ImageTexture.create_from_image(image)

  func before_each():
    _sender.mouse_warp = true

  func after_each():
    _sender.release_all()
    _sender.clear()

  func should_skip_script():
    if DisplayServer.get_name() == "headless":
      return "Skip Input tests when running headless"

  func test_listens_to_piece_connect():
    var jigsaw_puzzle = add_child_autofree(JigsawPuzzle.new())
    jigsaw_puzzle.texture = create_empty_image_texture(150, 150)
    jigsaw_puzzle.split_dimension = Vector2i(3, 3)
    jigsaw_puzzle.margin = 20

    var pieces = jigsaw_puzzle.get_pieces()
    var mouse_init_pos = Vector2(0, 0)
    # Drop the first piece on 4th piece. Remember the dimple_offset is 1/2 of the size.
    var mouse_final_pos = Vector2(25, 95)
    watch_signals(jigsaw_puzzle)
    (
      _sender
      . mouse_set_position(mouse_init_pos)
      . mouse_left_button_down(mouse_init_pos)
      . wait(.1)
      . mouse_motion(mouse_final_pos)
      . wait(.1)
      . mouse_left_button_up(mouse_final_pos)
      . wait(.1)
    )
    await (_sender.idle)

    assert_signal_emit_count(jigsaw_puzzle, "piece_connected", 1)
    assert_eq(jigsaw_puzzle.get_piece_chunks(), [[pieces[0], pieces[3]]])

  func test_connected_pieces_moves_as_one_chunk():
    var jigsaw_puzzle = add_child_autofree(JigsawPuzzle.new())
    jigsaw_puzzle.texture = create_empty_image_texture(150, 150)
    jigsaw_puzzle.split_dimension = Vector2i(3, 3)
    var pieces = jigsaw_puzzle.get_pieces()
    # connects the first and second piece.
    jigsaw_puzzle._on_piece_connected(pieces[0], pieces[1])

    var mouse_init_pos = Vector2(0, 0)
    var mouse_final_pos = Vector2(-30, -30)

    # move the connected pieces to the top left
    watch_signals(jigsaw_puzzle)
    (
      _sender
      . mouse_set_position(mouse_init_pos)
      . mouse_left_button_down(mouse_init_pos)
      . wait(.1)
      . mouse_motion(mouse_final_pos)
      . wait(.1)
      . mouse_left_button_up(mouse_final_pos)
      . wait(.1)
    )
    await (_sender.idle)

    assert_eq(pieces[0].position, Vector2(-55, -55))
    assert_eq(pieces[1].position, Vector2(-5, -55))
