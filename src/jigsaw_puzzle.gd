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
            _reset_pieces()

@export var margin: int = 2:
    get: return margin
    set(value):
        margin = value
        _reset_pieces()

var dimple_image = load("res://asset/piece_dimple.png")

var _pieces: Array[Piece] = []

func get_pieces():
    return _pieces

func _reset_pieces():
    for child in _pieces:
        child.queue_free()
    _pieces.clear()

    if (texture == null):
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
            var dimple = Vector4i(0, -30, 0, 39)
            var pieces = get_pieces()
            var current_index = i + split_dimension.x * j
            if (i > 0):
                var prev_dimple = pieces[current_index - 1].dimple.w
                print(prev_dimple, ",", piece_height)
                dimple.y = (piece_height - abs(prev_dimple))
                if (prev_dimple > 0):
                    dimple.y *= -1
            elif (i == 0):
                dimple.y = 0
            if (i == split_dimension.x - 1):
                dimple.w = 0

            if (j > 0 and j < split_dimension.y - 1):
                pass
            elif (j == 0):
                dimple.x = 0
            elif (j == split_dimension.y - 1):
                dimple.z = 0
            piece.dimple = dimple
            piece.dimple_image = dimple_image
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
