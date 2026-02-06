import 'dart:math';

import '../models/board_cell.dart';

class AiService {
  final Random _random = Random();

  int pickMoveCount() {
    final roll = _random.nextInt(100);
    if (roll < 10) {
      return 3;
    }
    if (roll < 35) {
      return 2;
    }
    return 1;
  }

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

  String pickSmartLetter() {
    const vowels = 'AEIOU';
    const consonants = 'BCDFGHJKLMNPQRSTVWXYZ';
    final useVowel = _random.nextInt(100) < 40;
    final bucket = useVowel ? vowels : consonants;
    return bucket[_random.nextInt(bucket.length)];
  }
}
