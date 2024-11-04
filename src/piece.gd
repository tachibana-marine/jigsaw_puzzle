@tool
extends Node2D
class_name Piece

@export var texture: Texture2D = null:
    get: return texture
    set(value):
        texture = value
        $PieceShape/Sprite.texture = value

@export var region_rect: Rect2 = Rect2(0, 0, 0, 0):
    get: return region_rect
    set(value):
        region_rect = value
        $PieceShape.size = value.size

@export var frame_coords: Vector2i = Vector2i(0, 0):
    get: return frame_coords
    set(value):
        frame_coords = value
        var size = $PieceShape.size
        $PieceShape/Sprite.offset = Vector2(-value.x * size.x, -value.y * size.y)

var dimensions: Vector2i = Vector2i(1, 1):
    get: return dimensions
    set(value):
        dimensions = value
        if texture:
            $PieceShape.size = texture.get_size() / (value.x * value.y)

func _init():
    var piece_shape = PieceShape.new()
    piece_shape.name = "PieceShape"
    piece_shape.clip_children = CanvasItem.ClipChildrenMode.CLIP_CHILDREN_ONLY
    add_child(piece_shape)

    var sprite = Sprite2D.new()
    sprite.centered = false
    sprite.name = "Sprite"
    piece_shape.add_child(sprite)
