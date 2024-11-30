class_name DimpleShape
extends Object

var dimple_root_width: float = 10:
  get():
    return dimple_root_width
  set(value):
    dimple_root_width = value

var dimple_root_height: float = 10:
  get():
    return dimple_root_height
  set(value):
    dimple_root_height = value


func get_shape():
  # var curve = Curve2D.new()
  # var offset = 3
  # var start = Vector2(0, -dimple_root_height)
  # var middle = Vector2(offset, -dimple_root_height - offset)
  # var middle2 = Vector2(-dimple_root_width, -dimple_root_height - offset)
  # var middle3 = Vector2(-dimple_root_width - offset, -dimple_root_height - offset)
  # var end = Vector2(-dimple_root_width, -dimple_root_height)
  # curve.add_point(start)
  # curve.add_point(middle, start, middle2)
  # curve.add_point(middle2, middle, middle3)
  # curve.add_point(middle3, middle2, end)
  # curve.add_point(end, middle3)
  # print(curve.get_baked_points())
  # return curve.get_baked_points()

  return UtilTools.float_array_to_packed2array(
    [
      [0, 0],
      [0, -dimple_root_height],
      [-dimple_root_width, -dimple_root_height],
      [-dimple_root_width, 0]
    ]
  )
