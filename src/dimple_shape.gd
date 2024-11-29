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
  return UtilTools.float_array_to_packed2array(
    [
      [0, 0],
      [0, -dimple_root_height],
      [-dimple_root_width, -dimple_root_height],
      [-dimple_root_width, 0]
    ]
  )
