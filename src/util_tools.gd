class_name UtilTools
extends Object


func float_array_to_packed2array(pairs: Array[Array]):
  var res: PackedVector2Array = []
  for pair in pairs:
    res.append(Vector2(pair[0], pair[1]))
  return res
