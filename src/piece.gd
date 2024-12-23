@tool
class_name Piece
extends PieceShape

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


func get_pieces():
  return [self]


func connect_puzzle_part(puzzle_part: PuzzlePart):
  var ret = CompositePuzzlePart.new()
  ret.connect_puzzle_part(self)
  ret.connect_puzzle_part(puzzle_part)
  return ret


func _init():
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
