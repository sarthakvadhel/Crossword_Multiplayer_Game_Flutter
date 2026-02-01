class SoundService {
  bool soundEnabled = true;
  bool hapticsEnabled = true;

  void toggleSound() {
    soundEnabled = !soundEnabled;
  }

  void toggleHaptics() {
    hapticsEnabled = !hapticsEnabled;
  }
}
