extends Node2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
  pass
  # pprint($JigsawPuzzle.get_children())


func _ready() -> void:
  # pass
  get_viewport().physics_object_picking_sort = true
  # $JigsawPuzzle.shuffle(0, 500)
