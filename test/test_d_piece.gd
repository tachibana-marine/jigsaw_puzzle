# Gut leaks if the file name is test_piece.gd somehow.
extends GutTest

var piece = null
var sprite = null
var background = null


func create_empty_image_texture(width: int, height: int):
  var image = Image.create_empty(width, height, false, Image.FORMAT_RGB8)
  return ImageTexture.create_from_image(image)


func before_each():
  piece = autofree(Piece.new())
  sprite = piece.get_node("Sprite")
  background = piece.get_node("Background")


func test_piece_properties():
  var image_texture = create_empty_image_texture(1000, 1000)
  piece.size = Vector2(10, 10)
  var collision_shape = piece.get_node("CollisionShape")
  # collision shape is larger than the piece itself by 20%
  assert_eq(collision_shape.shape.size, Vector2(12, 12))
  # background covers twice as large area as the piece_shape
  # so that the dimples can be covered
  assert_eq(background.size, Vector2(20, 20))
  assert_eq(background.position, Vector2(-5, -5))
  assert_property(piece, "texture", null, image_texture)
  assert_property(piece, "image_offset", Vector2.ZERO, Vector2(-3, -5))
  assert_eq(sprite.texture, image_texture)
  assert_eq(sprite.offset, Vector2(-3, -5))

  piece.size = Vector2(20, 20)
  assert_eq(collision_shape.shape.size, Vector2(24, 24))
  assert_eq(collision_shape.position, Vector2(10, 10))
  assert_eq(background.size, Vector2(40, 40))
  assert_eq(background.position, Vector2(-10, -10))


func test_piece_can_connect_to_other_piece():
  watch_signals(piece)
  piece.size = Vector2(10, 10)
  var piece2 = autofree(Piece.new())
  piece2.size = Vector2(10, 10)
  piece.connect_piece(piece2)
  assert_signal_emitted_with_parameters(piece, "piece_connected", [piece, piece2])


class TestPieceInput:
  extends GutTest

  var _sender = InputSender.new(Input)

  func before_each():
    _sender.mouse_warp = true

  func after_each():
    _sender.release_all()
    _sender.clear()

  func should_skip_script():
    if DisplayServer.get_name() == "headless":
      return "Skip Input tests when running headless"

  func test_piece_connects_on_drop():
    # this test fails if the piece size is smaller. IDK why.
    var piece = add_child_autofree(Piece.new())
    piece.size = Vector2(20, 20)
    piece.position = Vector2(0, 0)
    var piece2 = add_child_autofree(Piece.new())
    piece2.size = Vector2(20, 20)
    piece2.position = Vector2(20, 20)

    var mouse_init_pos = Vector2(0, 0)
    var mouse_final_pos = Vector2(20, 20)
    # the wait is a bit larger than other tests
    # since it fails if run from Godot GUI
    watch_signals(piece)
    (
      _sender
      . mouse_set_position(mouse_init_pos)
      . mouse_left_button_down(mouse_init_pos)
      . wait(.2)
      . mouse_motion(mouse_final_pos)
      . wait(.2)
      . mouse_left_button_up(mouse_final_pos)
      . wait(.2)
    )
    await (_sender.idle)
    assert_eq(piece.position, Vector2(20, 20))
    assert_signal_emitted_with_parameters(piece, "piece_connected", [piece, piece2])

# use this if you add null check to texture
# func test_change_image_texture_to_null():
#     var image_texture = create_empty_image_texture(1000, 1000)
#     piece.texture = image_texture
#     piece.texture = null
#     assert_null(piece.texture)
