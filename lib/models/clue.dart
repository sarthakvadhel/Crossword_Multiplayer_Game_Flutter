class Clue {
  Clue({
    required this.id,
    required this.text,
    required this.answer,
    this.assetPath,
  });

  final String id;
  final String text;
  final String answer;
  final String? assetPath;
}
