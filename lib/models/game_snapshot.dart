class GameSnapshot {
  GameSnapshot({
    required this.boardLetters,
    required this.boardOwners,
    required this.rackLetters,
    required this.playerScores,
    required this.currentPlayerIndex,
    this.streak = 0,
    this.longestWordLength = 0,
  });

  final List<String?> boardLetters;
  final List<int?> boardOwners;
  final List<String> rackLetters;
  final List<int> playerScores;
  final int currentPlayerIndex;
  final int streak;
  final int longestWordLength;
}
