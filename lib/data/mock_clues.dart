import '../models/clue.dart';

class MockClues {
  static List<Clue> all() {
    return [
      Clue(
        id: 'sky',
        text: 'Above the clouds',
        answer: 'SKY',
        assetPath: 'assets/clues/sky.png',
      ),
      Clue(
        id: 'animal',
        text: 'Friendly pet',
        answer: 'DOG',
        assetPath: 'assets/clues/animal.png',
      ),
      Clue(
        id: 'word',
        text: 'Opposite of no',
        answer: 'YES',
      ),
    ];
  }
}
