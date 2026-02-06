import '../models/board_cell.dart';

class MockBoard {
  static const int rows = 9;
  static const int cols = 9;

  static List<List<BoardCell>> build() {
    final board = List.generate(
      rows,
      (row) => List.generate(
        cols,
        (col) => BoardCell(row: row, col: col),
      ),
    );

    for (var row = 0; row < rows; row++) {
      for (var col = 0; col < cols; col++) {
        if ((row == 0 && col == 0) || (row == 0 && col == 1)) {
          board[row][col]
            ..isClue = true
            ..clueText = 'Sky'
            ..clueAsset = 'assets/clues/sky.png';
        } else if (row == 1 && col == 0) {
          board[row][col]
            ..isClue = true
            ..clueText = 'Animal'
            ..clueAsset = 'assets/clues/animal.png';
        } else if ((row == 4 && col == 4) || (row == 5 && col == 4)) {
          board[row][col].isBlocked = true;
        }
      }
    }

    return board;
  }
}
