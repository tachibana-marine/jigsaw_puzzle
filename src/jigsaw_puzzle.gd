@tool

extends Node2D
class_name JigsawPuzzle

@export var texture: Texture2D = null:
    get:
        return texture
    set(value):
        texture = value
        $Sprite.texture = value
        _create_pieces(texture.get_size())
        randomize_pieces()

func _create_pieces(size: Vector2):
    var step_x = (int)(size.x / 2)
    var step_y = (int)(size.y / 2)
    for y in range(2):
        for x in range(2):
            var piece = Sprite2D.new()
            piece.vframes = 2
            piece.hframes = 2
            piece.frame_coords = Vector2(x, y)
            piece.centered = false
            piece.texture = texture
            piece.position = Vector2(x * step_x, y * step_y)
            $PieceHolder.add_child(piece)

func get_pieces():
    return $PieceHolder.get_children()

func randomize_pieces():
    var x = range(2)
    var y = range(2)
    x.shuffle()
    y.shuffle()
    var index = 0
    for j in range(2):
        for i in range(2):
            get_pieces()[index].frame_coords = Vector2i(x[i], y[j])
            index += 1

func _init():
    var sprite = Sprite2D.new()
    sprite.name = "Sprite"
    sprite.hide()
    # sprite.region_enabled = true
    # sprite.region_rect = Rect2(100, 100, 200, 200)
    add_child(sprite)

    var piece_holder = Node2D.new()
    piece_holder.name = "PieceHolder"
    add_child(piece_holder)
