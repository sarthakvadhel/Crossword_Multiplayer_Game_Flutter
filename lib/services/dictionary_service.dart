class DictionaryService {
  DictionaryService({Set<String>? words})
      : _words = words ?? _defaultWords;

  final Set<String> _words;

  static final Set<String> _defaultWords = {
    'SKY',
    'DOG',
    'YES',
    'CAT',
    'SUN',
    'MOON',
    'STAR',
    'PLAY',
  };

  bool isValid(String word) {
    final normalized = word.trim().toUpperCase();
    return normalized.isNotEmpty && _words.contains(normalized);
  }
}
