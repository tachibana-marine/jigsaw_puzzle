extends GutTest

var piece_shape = null


func before_each():
  piece_shape = add_child_autofree(PieceShape.new())


func build_packed2array(pairs: Array[Array]):
  var res: PackedVector2Array = []
  for pair in pairs:
    res.append(Vector2(pair[0], pair[1]))
  return res


func test_piece_dimple_properties():
  piece_shape.size = Vector2(100, 100)
  assert_property(piece_shape, "dimple", Vector4i(0, 0, 0, 0), Vector4i(25, -35, 45, -45))
  # 30x20

  assert_property(
    piece_shape,
    "dimple_shape",
    PackedVector2Array([]),
    build_packed2array([[0, 0], [0, -20], [-30, -20], [-30, 0]])
  )
  assert_eq(
    piece_shape.vertices,
    build_packed2array(
      [
        [100, 0],
        [90, 0],
        [90, -20],
        [60, -20],
        [60, 0],
        [0, 0],
        [0, 20],
        [20, 20],
        [20, 50],
        [0, 50],
        [0, 100],
        [30, 100],
        [30, 120],
        [60, 120],
        [60, 100],
        [100, 100],
        [100, 70],
        [80, 70],
        [80, 40],
        [100, 40]
      ]
    )
  )


func test_dimple_shape_starts_from_bottom_right():
  piece_shape.dimple_shape = build_packed2array([[10, -20], [0, 0], [20, 0]])
  assert_eq(
    piece_shape.dimple_shape,
    PackedVector2Array([Vector2(0, 0), Vector2(-10, -20), Vector2(-20, 0)])
  )


func test_dimple_shape_for_cavity_is_mirrored():
  piece_shape.size = Vector2(100, 100)
  piece_shape.dimple_shape = build_packed2array([[0, 0], [-10, -30], [-30, 0]])
  piece_shape.dimple = Vector4i(35, -35, 0, 0)
  assert_eq(
    piece_shape.vertices,
    build_packed2array(
      [
        [100, 0],
        [80, 0],
        [70, -30],
        [50, 0],
        [0, 0],
        [0, 20],
        [30, 40],
        [0, 50],
        [0, 100],
        [100, 100]
      ]
    )
  )


func test_set_empty_dimple_shape():
  piece_shape.dimple_shape = PackedVector2Array([])
  assert_eq(piece_shape.dimple_shape, PackedVector2Array([]))


func test_shape_changes_based_on_size():
  piece_shape.size = Vector2(200, 150)
  assert_eq(
    piece_shape.vertices,
    PackedVector2Array([Vector2(200, 0), Vector2(0, 0), Vector2(0, 150), Vector2(200, 150)])
  )


func test_dimple_accuracy_to_the_4th_digit():
  piece_shape.size = Vector2(100, 100)
  piece_shape.dimple_shape = PackedVector2Array(
    [Vector2(0, 0), Vector2(0, -12.345), Vector2(-23.456, -12.345), Vector2(-23.456, 0)]
  )
  var offset = 11.728
  piece_shape.dimple = Vector4i(0, 20, 0, 0)
  assert_eq(
    piece_shape.vertices,
    PackedVector2Array(
      [
        Vector2(100, 0),
        Vector2(0, 0),
        Vector2(0, 20 - offset),
        Vector2(-12.345, 20 - offset),
        Vector2(-12.345, 20 - offset + 23.456),
        Vector2(0, 20 - offset + 23.456),
        Vector2(0, 100),
        Vector2(100, 100)
      ]
    )
  )
