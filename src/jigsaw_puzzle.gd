@tool
class_name JigsawPuzzle
extends Node2D

@export var texture: Texture2D = null:
  get:
    return texture
  set(value):
    texture = value

@export var split_dimension: Vector2i = Vector2i(1, 1):
  get:
    return split_dimension
  set(value):
    if value.x >= 1 && value.y >= 1:
      split_dimension = value
      _reset_pieces()

@export var margin: int = 2:
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

var dimple_magnification: Vector2 = Vector2.ONE:
  get:
    return dimple_magnification

var _pieces: Array[Piece] = []


func get_pieces():
  return _pieces


func _create_dimple(
  x: int,
  y: int,
  width: int,
  height: int,
):
  var get_sign = func():
    if randi() % 2 == 0:
      return -1
    return 1
  var dimple = Vector4i(
    randi_range(20, 40) * get_sign.call(),
    randi_range(20, 40) * get_sign.call(),
    randi_range(20, 40) * get_sign.call(),
    randi_range(20, 40) * get_sign.call()
  )
  if y == 0:
    dimple.x = 0
  if x == 0:
    dimple.y = 0
  if y + 1 == height:
    dimple.z = 0
  if x + 1 == width:
    dimple.w = 0
  return dimple


func _get_top_piece(x: int, y: int, width: int, _height: int):
  var index = y * width + x
  if y > 0:
    return _pieces[index - width]
  return null


func _get_left_piece(x: int, y: int, width: int, _height: int):
  var index = y * width + x
  if x > 0:
    return _pieces[index - 1]
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
  dimple_magnification = Vector2(
    (piece_size.x * dimple_ratio / 100) / bitmap_size.x,
    (piece_size.y * dimple_ratio / 100) / bitmap_size.y
  )
  print(dimple_magnification)
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


func _init():
  print(dimple_ratio)
  var sprite = Sprite2D.new()
  sprite.name = "Sprite"
  sprite.hide()
  add_child(sprite)

  var piece_holder = Node2D.new()
  piece_holder.name = "PieceHolder"
  add_child(piece_holder)
