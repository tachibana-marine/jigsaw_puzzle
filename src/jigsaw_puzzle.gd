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

var dimple_image = load("res://asset/piece_dimple.png")

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
    randi_range(20, width - 20) * get_sign.call(),
    randi_range(20, height - 20) * get_sign.call(),
    randi_range(20, width - 20) * get_sign.call(),
    randi_range(20, height - 20) * get_sign.call()
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


func _reset_pieces():
  for child in _pieces:
    child.queue_free()
  _pieces.clear()

  if texture == null:
    return
  var piece_width = texture.get_size().x / split_dimension.x
  var piece_height = texture.get_size().y / split_dimension.y

  for j in range(split_dimension.y):
    for i in range(split_dimension.x):
      var piece = Piece.new()
      piece.size = Vector2(piece_width, piece_height)
      piece.texture = texture
      piece.image_offset = -Vector2(piece_width * i, piece_height * j)
      piece.position = Vector2((piece_width + margin) * i, (piece_height + margin) * j)
      piece.dimple_image = dimple_image
      piece.dimple = _create_dimple(
        i,
        j,
        piece_width,
        piece_height,
      )
      _pieces.append(piece)
      $PieceHolder.add_child(piece)


func _init():
  var sprite = Sprite2D.new()
  sprite.name = "Sprite"
  sprite.hide()
  add_child(sprite)

  var piece_holder = Node2D.new()
  piece_holder.name = "PieceHolder"
  add_child(piece_holder)
