@tool
extends Node2D
class_name JigsawPuzzle

@export var texture: Texture2D = null:
    get:
        return texture
    set(value):
        texture = value

@export var split_dimension: Vector2i = Vector2i(1, 1):
    get: return split_dimension
    set(value):
        if (value.x >= 1 && value.y >= 1):
            split_dimension = value
            _create_pieces()

func get_pieces():
    return $PieceHolder.get_children()

func _create_pieces():
    var piece_width = texture.get_size().x / split_dimension.x
    var piece_height = texture.get_size().y / split_dimension.y
    for child in $PieceHolder.get_children():
        child.queue_free()
    for j in range(split_dimension.y):
        for i in range(split_dimension.x):
            var piece = Piece.new()
            piece.size = Vector2(piece_width, piece_height)
            piece.texture = texture
            piece.image_offset = -Vector2(piece_width * i, piece_height * j)
            piece.position = Vector2((piece_width + 2) * i, (piece_height + 2) * j)
            $PieceHolder.add_child(piece)

func _init():
    var sprite = Sprite2D.new()
    sprite.name = "Sprite"
    sprite.hide()
    add_child(sprite)

    var piece_holder = Node2D.new()
    piece_holder.name = "PieceHolder"
    add_child(piece_holder)
