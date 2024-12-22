class_name Draggable
extends Area2D

signal mouse_down_detected
signal mouse_up_detected

var drag_offset = Vector2.ZERO:
  get:
    return drag_offset
  set(value):
    drag_offset = value
var _is_dragging = false


func _input_event(viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
  if event is InputEventMouseButton:
    if event.button_index == MOUSE_BUTTON_LEFT && event.is_pressed():
      mouse_down_detected.emit()
      viewport.set_input_as_handled()
      _is_dragging = true
    elif event.button_index == MOUSE_BUTTON_LEFT && event.is_released():
      mouse_up_detected.emit()
      _is_dragging = false


func _process(_delta):
  if _is_dragging:
    var mouse_pos = get_viewport().get_mouse_position()
    global_position = mouse_pos + drag_offset


func _init():
  self.input_pickable = true
