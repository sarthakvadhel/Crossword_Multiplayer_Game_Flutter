class GameSnapshot {
  GameSnapshot({
    required this.boardLetters,
    required this.boardOwners,
    required this.rackLetters,
    required this.playerScores,
    required this.currentPlayerIndex,
  });

  final List<String?> boardLetters;
  final List<int?> boardOwners;
  final List<String> rackLetters;
  final List<int> playerScores;
  final int currentPlayerIndex;
}
