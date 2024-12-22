class_name Draggable
extends Area2D

signal mouse_down_detected
signal mouse_up_detected

var _is_dragging = false


func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
  if event is InputEventMouseButton:
    if event.button_index == MOUSE_BUTTON_LEFT && event.is_pressed():
      mouse_down_detected.emit()
      _is_dragging = true
    elif event.button_index == MOUSE_BUTTON_LEFT && event.is_released():
      mouse_up_detected.emit()
      _is_dragging = false


func _process(_delta):
  if _is_dragging:
    var mouse_pos = get_viewport().get_mouse_position()
    print(mouse_pos, position)
    global_position = mouse_pos


func _init():
  self.input_pickable = true
