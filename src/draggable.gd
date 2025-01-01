class_name Draggable
extends Area2D

signal drag_start
signal drag_moved
signal drag_end

var drag_offset = Vector2.ZERO:
  get:
    return drag_offset
  set(value):
    drag_offset = value
var _is_dragging = false


func _input(event: InputEvent) -> void:
  if event is InputEventMouseButton:
    if event.button_index == MOUSE_BUTTON_LEFT && event.is_released() && _is_dragging:
      drag_end.emit()
      _is_dragging = false


func _input_event(viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
  if event is InputEventMouseButton:
    if event.button_index == MOUSE_BUTTON_LEFT && event.is_pressed():
      drag_start.emit()
      viewport.set_input_as_handled()
      _is_dragging = true


func _process(_delta):
  if _is_dragging:
    var mouse_pos = get_viewport().get_mouse_position()
    drag_moved.emit(self, mouse_pos)
    global_position = mouse_pos + drag_offset


func _init():
  self.input_pickable = true
