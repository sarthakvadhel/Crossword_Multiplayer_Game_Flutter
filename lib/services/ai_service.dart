import 'dart:math';

import '../models/board_cell.dart';

class AiService {
  final Random _random = Random();

  BoardCell? pickRandomCell(List<List<BoardCell>> board) {
    final openCells = <BoardCell>[];
    for (final row in board) {
      for (final cell in row) {
        if (!cell.isBlocked && !cell.isClue && cell.letter == null) {
          openCells.add(cell);
        }
      }
    }
    if (openCells.isEmpty) {
      return null;
    }
    return openCells[_random.nextInt(openCells.length)];
  }

  String pickRandomLetter() {
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    return letters[_random.nextInt(letters.length)];
  }
}
