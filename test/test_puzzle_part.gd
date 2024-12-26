extends GutTest

# test classes which inherit PuzzlePart namely
# Piece and CompositePuzzlePart


func test_pieces_stick_together():
  var piece1 = autofree(Piece.new())
  var piece2 = autofree(Piece.new())
  piece1.size = Vector2(20, 20)
  piece2.size = Vector2(20, 20)

  var puzzle_part = autofree(piece1.connect_puzzle_part(piece2))
  assert_eq(puzzle_part.get_pieces(), [piece1, piece2])


func test_composite_puzzle_part_can_connect_piece_to_puzzle_part():
  var piece1 = autofree(Piece.new())
  var piece2 = autofree(Piece.new())
  var piece3 = autofree(Piece.new())
  var composite = autofree(CompositePuzzlePart.new())
  composite.connect_puzzle_part(piece1)
  composite.connect_puzzle_part(piece2)
  composite.connect_puzzle_part(piece3)
  assert_eq(composite.get_pieces(), [piece1, piece2, piece3])
