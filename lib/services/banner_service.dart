import 'dart:math';

class BannerService {
  final Random _random = Random();

  String longestWordBanner() => 'Yey!! You formed the longest word!';

  String emptyHandBanner() => 'Empty Hand Master!';

  String streakBanner(int streak) {
    if (streak >= 10) return '10x Strike! Unstoppable!';
    if (streak >= 5) return '5x Strike! On Fire!';
    if (streak >= 3) return '3x Strike!';
    return 'Nice streak!';
  }

  String wordCompleteBanner() {
    const messages = [
      'Amazing!',
      'Excellent!',
      'Cool Move!',
      'Great Word!',
      'Brilliant!',
    ];
    return messages[_random.nextInt(messages.length)];
  }
}
