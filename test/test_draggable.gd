extends GutTest

var draggable = null
var sender = InputSender.new(Input)


func before_each():
  draggable = add_child_autofree(Draggable.new())


func after_each():
  sender.release_all()
  sender.clear()


func test_emits_signal_on_click():
  draggable.position = Vector2.ZERO

  watch_signals(draggable)
  # have to wait 1f to prevent the button down state to carry over to the next test
  sender.mouse_left_button_down(Vector2(1, 1)).hold_for(.01).wait("1f")
  await (sender.idle)
  assert_signal_emitted(draggable, "mouse_down_detected")


func test_ignores_click_outside():
  draggable.position = Vector2.ZERO

  watch_signals(draggable)
  sender.mouse_left_button_down(Vector2(30, 30)).hold_for(.01).wait("1f")
  await (sender.idle)
  assert_signal_not_emitted(draggable, "mouse_down_detected")
