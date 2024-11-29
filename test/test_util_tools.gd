extends GutTest


func test_float_array_to_packed2array():
  assert_eq(
    UtilTools.float_array_to_packed2array([[1, 2], [3, 4]]),
    PackedVector2Array([Vector2(1, 2), Vector2(3, 4)])
  )
