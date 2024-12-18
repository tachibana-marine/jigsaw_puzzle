class_name Draggable
extends Area2D

signal mouse_down_detected


func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
  print("hey", event)
  if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
    mouse_down_detected.emit()


func _init():
  self.input_pickable = true
  var collision = CollisionShape2D.new()
  var rect_shape = RectangleShape2D.new()
  rect_shape.size = Vector2(10, 10)
  collision.shape = rect_shape
  add_child(collision)
