class_name CompositePuzzlePart
extends PuzzlePart

var _pieces: Array[Piece] = []


func get_pieces() -> Array[Piece]:
  return _pieces


func connect_puzzle_part(_puzzle_part: PuzzlePart) -> PuzzlePart:
  _pieces.append_array(_puzzle_part.get_pieces())
  return self
