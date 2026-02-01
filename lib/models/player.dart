class Player {
  Player({
    required this.id,
    required this.name,
    this.score = 0,
    this.isAi = false,
  });

  final String id;
  final String name;
  final bool isAi;
  int score;
}
