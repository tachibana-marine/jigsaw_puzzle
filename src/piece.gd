@tool
class_name Piece
extends PieceShape

signal piece_connected

@export var texture: Texture2D = null:
  get:
    return texture
  set(value):
    texture = value
    $Sprite.texture = value

@export var image_offset: Vector2 = Vector2.ZERO:
  get:
    return image_offset
  set(value):
    image_offset = value
    $Sprite.offset = value


func set_size(value):
  super.set_size(value)
  $Background.size = value * 2
  $Background.position = -size / 2
  $CollisionShape.shape.size = value
  $CollisionShape.position = size / 2
  drag_offset = -size / 2


func connect_piece(piece: Piece):
  piece_connected.emit(self, piece)


func _on_drag_end():
  for area in get_overlapping_areas():
    var piece := area as Piece
    if not piece:
      continue
    connect_piece(piece)


func _init():
  self.drag_end.connect(_on_drag_end)
  self.clip_children = CanvasItem.ClipChildrenMode.CLIP_CHILDREN_ONLY
  var background = Rectangle.new()
  background.color = Color.RED
  background.name = "Background"
  add_child(background)

  var sprite = Sprite2D.new()
  sprite.centered = false
  sprite.name = "Sprite"
  add_child(sprite)

  var collision = CollisionShape2D.new()
  var rectangle = RectangleShape2D.new()
  rectangle.size = size
  collision.shape = rectangle
  collision.name = "CollisionShape"
  add_child(collision)
