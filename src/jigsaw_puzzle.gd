@tool
class_name JigsawPuzzle
extends Node2D

@export var texture: Texture2D = null:
  get:
    return texture
  set(value):
    texture = value
    _reset_pieces()

@export var split_dimension: Vector2i = Vector2i(2, 2):
  get:
    return split_dimension
  set(value):
    if value.x >= 1 && value.y >= 1:
      split_dimension = value
      _reset_pieces()

@export var margin: int = 0:
  get:
    return margin
  set(value):
    margin = value
    _reset_pieces()

@export var dimple_ratio: float = 10:
  get:
    return dimple_ratio
  set(value):
    dimple_ratio = value
    _reset_pieces()

var dimple_image = load("res://asset/piece_dimple.png")

# coefficient to scale dimple shape with the piece size
var dimple_magnification: float = 1.0:
  get:
    return dimple_magnification

# just to make random functions testable
var random_tools: RandomTools = RandomTools.new():
  set(value):
    random_tools.free()
    random_tools = value

var _pieces: Array[Piece] = []


func _init():
  var sprite = Sprite2D.new()
  sprite.name = "Sprite"
  sprite.hide()
  add_child(sprite)

  var piece_holder = Node2D.new()
  piece_holder.name = "PieceHolder"
  add_child(piece_holder)


func _notification(what):
  if what == NOTIFICATION_PREDELETE:
    if is_instance_valid(random_tools):
      random_tools.free()


func get_pieces():
  return _pieces


func _create_dimple(
  x: int,
  y: int,
  width: int,
  height: int,
):
  var piece_size = _get_piece_size()
  var dimple_size_y = dimple_image.get_size().y * dimple_magnification
  var get_sign = func():
    if random_tools.a_randi() % 2 == 0:
      return -1
    return 1
  dimple_size_y += 2
  var dimple = Vector4i(
    random_tools.a_randi_range(dimple_size_y, piece_size.x - dimple_size_y) * get_sign.call(),
    random_tools.a_randi_range(dimple_size_y, piece_size.y - dimple_size_y) * get_sign.call(),
    random_tools.a_randi_range(dimple_size_y, piece_size.x - dimple_size_y) * get_sign.call(),
    random_tools.a_randi_range(dimple_size_y, piece_size.y - dimple_size_y) * get_sign.call()
  )
  # edges
  if y == 0:
    dimple.x = 0
  if x == 0:
    dimple.y = 0
  if y + 1 == height:
    dimple.z = 0
  if x + 1 == width:
    dimple.w = 0

  # align dimple position with previous pieces
  if x != 0:
    var left_piece = _get_piece_from_coord(x - 1, y, width, height)
    dimple.y = (
      -1
      * (left_piece.dimple.w / abs(left_piece.dimple.w))
      * (left_piece.size.y - abs(left_piece.dimple.w))
    )
  if y != 0:
    var piece_above = _get_piece_from_coord(x, y - 1, width, height)
    dimple.x = (
      -1
      * (piece_above.dimple.z / abs(piece_above.dimple.z))
      * (piece_above.size.x - abs(piece_above.dimple.z))
    )

  return dimple


func _get_piece_from_coord(x: int, y: int, width: int, _height: int):
  var index = y * width + x
  if index >= 0 && index < _pieces.size():
    return _pieces[index]
  return null


func _get_piece_size():
  if texture:
    return Vector2(
      texture.get_size().x / split_dimension.x, texture.get_size().y / split_dimension.y
    )
  return null


func _reset_pieces():
  for child in _pieces:
    child.queue_free()
  _pieces.clear()
  if texture == null:
    return

  var piece_size = _get_piece_size()
  var bitmap = BitMap.new()
  bitmap.create_from_image_alpha(dimple_image.get_image())
  var bitmap_size = bitmap.get_size()
  var smaller_piece_size = piece_size.x
  if piece_size.y < smaller_piece_size:
    smaller_piece_size = piece_size.y
  dimple_magnification = (dimple_ratio * smaller_piece_size) / (bitmap_size.x * 100)
  var dimple_shape = bitmap.opaque_to_polygons(Rect2(Vector2.ZERO, bitmap.get_size()))[0]
  for i in range(dimple_shape.size()):
    dimple_shape[i] *= dimple_magnification

  for j in range(split_dimension.y):
    for i in range(split_dimension.x):
      var piece = Piece.new()
      piece.size = piece_size
      piece.texture = texture
      piece.image_offset = -Vector2(piece_size.x * i, piece_size.y * j)
      piece.position = Vector2((piece_size.x + margin) * i, (piece_size.y + margin) * j)
      piece.dimple_shape = dimple_shape
      piece.dimple = _create_dimple(i, j, split_dimension.x, split_dimension.y)
      _pieces.append(piece)
      $PieceHolder.add_child(piece)
