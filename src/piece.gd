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
