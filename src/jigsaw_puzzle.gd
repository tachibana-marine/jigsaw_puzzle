@tool

extends Node2D
class_name JigsawPuzzle

@export var texture: Texture2D = null:
    get:
        return texture
    set(value):
        texture = value
        $Sprite.texture = value
        _add_pieces(texture.get_size())

func _add_pieces(size: Vector2):
    var step_x = (int)(size.x / 2)
    var step_y = (int)(size.y / 2)
    print(size, step_x, step_y)
    for y in range(2):
        for x in range(2):
            var piece = Sprite2D.new()
            piece.centered = false
            piece.texture = texture
            piece.region_enabled = true
            piece.position = Vector2(x * step_x, y * step_y)
            #piece.size = Vector2(step_x, step_y)
            piece.region_rect = Rect2(x * step_x, y * step_y, (x + 1) * (step_x) - 1, (y + 1) * (step_y) - 1)
            $PieceHolder.add_child(piece)
func get_pieces():
    return $PieceHolder.get_children()


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
