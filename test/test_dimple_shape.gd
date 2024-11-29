extends GutTest


func test_dimple_shape_properies():
  var dimple_shape = DimpleShape.new()
  assert_property(dimple_shape, "dimple_root_width", 10, 20)
  assert_property(dimple_shape, "dimple_root_height", 10, 20)


func test_get_dimple_vertices():
  var dimple_shape = DimpleShape.new()
  var util = UtilTools.new()
  assert_eq(
    dimple_shape.get_shape(),
    util.float_array_to_packed2array([[0, 0], [-10, 0], [-10, -10], [-10, 0]])
  )
