extends GutTest

var _sender = InputSender.new(Input)


func should_skip_script():
  if DisplayServer.get_name() == "headless":
    return "Skip Input tests when running headless"


func _get_draggable():
  var draggable = Draggable.new()
  var collision = CollisionShape2D.new()
  var rect_shape = RectangleShape2D.new()
  rect_shape.size = Vector2(10, 10)
  collision.shape = rect_shape
  draggable.add_child(collision)
  return draggable


func before_all():
  _sender.mouse_warp = true


func after_each():
  _sender.release_all()
  _sender.clear()


func test_emits_signal_on_mouse_button_up_and_down():
  var draggable = add_child_autofree(_get_draggable())
  draggable.position = Vector2.ZERO
  watch_signals(draggable)
  _sender.mouse_left_button_down(Vector2(1, 1), Vector2(1, 1)).wait(.2)
  await (_sender.idle)
  assert_signal_emit_count(draggable, "drag_start", 1)
  assert_signal_not_emitted(draggable, "drag_end")
  _sender.mouse_left_button_up(Vector2(1, 1), Vector2(1, 1)).wait(.01)
  await (_sender.idle)
  assert_signal_emit_count(draggable, "drag_end", 1)


func test_draggable_can_be_dragged():
  var draggable = add_child_autofree(_get_draggable())
  var mouse_init_pos = Vector2(1, 1)
  var mouse_final_pos = Vector2(20, 20)
  draggable.position = Vector2.ZERO

  (
    _sender
    . mouse_set_position(mouse_init_pos, mouse_init_pos)
    . mouse_left_button_down(mouse_init_pos, mouse_init_pos)
    . wait(.01)
    . mouse_motion(mouse_final_pos, mouse_final_pos)
    . wait(.01)
    . mouse_left_button_up(mouse_final_pos, mouse_final_pos)
    . wait(.01)
  )
  await (_sender.idle)
  assert_eq(draggable.position, mouse_final_pos)


func test_draggable_works_in_global_space():
  var parent = Node2D.new()
  parent.position = Vector2(20, 20)
  var draggable_child = _get_draggable()
  parent.add_child(draggable_child)
  watch_signals(draggable_child)
  add_child_autofree(parent)

  draggable_child.position = Vector2(10, 10)  # (30,30) in global space
  var mouse_init_pos = Vector2(31, 31)
  var mouse_final_pos = Vector2(50, 50)

  (
    _sender
    . mouse_set_position(mouse_init_pos, mouse_init_pos)
    . mouse_left_button_down(mouse_init_pos, mouse_init_pos)
    . wait(.01)
    . mouse_motion(mouse_final_pos, mouse_final_pos)
    . wait(.01)
    . mouse_left_button_up(mouse_final_pos, mouse_final_pos)
    . wait(.01)
  )
  await (_sender.idle)
  assert_signal_emitted(draggable_child, "drag_end")
  assert_eq(draggable_child.position, Vector2(30, 30))
  assert_eq(draggable_child.global_position, mouse_final_pos)


func test_ignores_click_outside():
  var draggable = add_child_autofree(_get_draggable())
  draggable.position = Vector2.ZERO

  watch_signals(draggable)
  _sender.mouse_left_button_down(Vector2(30, 30), Vector2(30, 30)).hold_for(.01).wait("1f")
  await (_sender.idle)
  assert_signal_not_emitted(draggable, "drag_start")
  assert_signal_not_emitted(draggable, "drag_end")


func test_draggable_follows_cursor_with_offset():
  var draggable = add_child_autofree(_get_draggable())
  var mouse_init_pos = Vector2(1, 1)
  var mouse_final_pos = Vector2(20, 20)
  draggable.drag_offset = Vector2(10, 10)
  draggable.position = Vector2.ZERO

  (
    _sender
    . mouse_set_position(mouse_init_pos, mouse_init_pos)
    . mouse_left_button_down(mouse_init_pos, mouse_init_pos)
    . wait(.01)
    . mouse_motion(mouse_final_pos, mouse_final_pos)
    . wait(.01)
    . mouse_left_button_up(mouse_final_pos, mouse_final_pos)
    . wait(.01)
  )
  await (_sender.idle)
  assert_eq(draggable.position, mouse_final_pos + draggable.drag_offset)


func test_only_draggable_on_top_can_be_draggable():
  var draggable_1st = add_child_autofree(_get_draggable())
  var draggable_2nd = add_child_autofree(_get_draggable())
  var mouse_init_pos = Vector2(1, 1)
  var mouse_final_pos = Vector2(20, 20)
  draggable_1st.position = Vector2.ZERO
  draggable_2nd.position = Vector2.ZERO

  (
    _sender
    . mouse_set_position(mouse_init_pos, mouse_init_pos)
    . mouse_left_button_down(mouse_init_pos, mouse_init_pos)
    . wait(.01)
    . mouse_motion(mouse_final_pos, mouse_final_pos)
    . wait(.01)
    . mouse_left_button_up(mouse_final_pos, mouse_final_pos)
    . wait(.01)
  )
  await (_sender.idle)
  assert_eq(draggable_1st.position, mouse_final_pos)
  assert_eq(draggable_2nd.position, Vector2.ZERO)


func test_mouse_up_signal_is_always_emitted_after_mouse_down():
  var draggable = add_child_autofree(_get_draggable())
  var mouse_init_pos = Vector2(1, 1)
  var mouse_move_to_pos = Vector2(20, 20)
  var mouse_release_pos = Vector2(40, 40)
  draggable.position = Vector2.ZERO
  watch_signals(draggable)
  (
    _sender
    . mouse_set_position(mouse_init_pos, mouse_init_pos)
    . mouse_left_button_down(mouse_init_pos, mouse_init_pos)
    . wait(.01)
    . mouse_motion(mouse_move_to_pos, mouse_move_to_pos)
    . wait(.01)
    . mouse_left_button_up(mouse_release_pos, mouse_release_pos)
    . wait_frames(1)
  )  # the wait is shorter than other tests to keep mouse move event from firing
  await (_sender.idle)
  assert_eq(draggable.position, mouse_move_to_pos)
  assert_signal_emitted(draggable, "drag_end")
