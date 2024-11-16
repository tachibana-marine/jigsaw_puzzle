@tool
extends PieceShape
class_name Piece

func set_size(value):
    super.set_size(value)
    $Background.size = value * 2
    $Background.position = -size / 2

@export var texture: Texture2D = null:
    get: return texture
    set(value):
        texture = value
        $Sprite.texture = value
        $Background.size = texture.get_size()

@export var region_rect: Rect2 = Rect2(0, 0, 0, 0):
    get: return region_rect
    set(value):
        region_rect = value

@export var frame_coords: Vector2i = Vector2i(0, 0):
    get: return frame_coords
    set(value):
        frame_coords = value
        $Sprite.offset = Vector2(-value.x * size.x, -value.y * size.y)

@export var dimensions: Vector2i = Vector2i(1, 1):
    get: return dimensions
    set(value):
        dimensions = value
        if texture:
            size = texture.get_size() / (value.x * value.y)

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
