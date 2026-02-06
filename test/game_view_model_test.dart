import 'package:flutter_test/flutter_test.dart';

import 'package:crossword_multiplayer_game/viewmodels/game_view_model.dart';

void main() {
  test('placing a letter updates score and rack', () {
    final viewModel = GameViewModel();
    final cell = viewModel.board.first.firstWhere(
      (cell) => !cell.isBlocked && !cell.isClue,
    );
    viewModel.selectRackLetter(viewModel.rackLetters.first);
    viewModel.placeLetter(cell);
    expect(cell.letter, isNotNull);
    expect(viewModel.players.first.score, 1);
    expect(viewModel.rackLetters.length, 6);
  });

  test('dictionary validates mock word', () {
    final viewModel = GameViewModel();
    viewModel.rackLetters = ['S', 'K', 'Y'];
    viewModel.selectRackLetter('S');
    viewModel.placeLetter(viewModel.board[0][2]);
    viewModel.selectRackLetter('K');
    viewModel.placeLetter(viewModel.board[0][3]);
    viewModel.selectRackLetter('Y');
    viewModel.placeLetter(viewModel.board[0][4]);
    viewModel.submitWord();
    expect(viewModel.notification, contains('Word'));
  });
}
