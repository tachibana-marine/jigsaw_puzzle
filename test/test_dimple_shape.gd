extends GutTest

var dimple_shape = null


func before_each():
  dimple_shape = autofree(DimpleShape.new())


func test_dimple_shape_properies():
  assert_property(dimple_shape, "dimple_root_width", 10, 20)
  assert_property(dimple_shape, "dimple_root_height", 10, 20)


func test_get_dimple_vertices():
  assert_eq(
    dimple_shape.get_shape(),
    UtilTools.float_array_to_packed2array([[0, 0], [0, -10], [-10, -10], [-10, 0]])
  )
