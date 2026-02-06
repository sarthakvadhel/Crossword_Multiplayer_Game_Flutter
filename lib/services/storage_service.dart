import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/game_snapshot.dart';

class StorageService {
  static const _gameKey = 'crossword_game_snapshot';

  Future<void> saveGame(GameSnapshot snapshot) async {
    final prefs = await SharedPreferences.getInstance();
    final data = jsonEncode({
      'boardLetters': snapshot.boardLetters,
      'boardOwners': snapshot.boardOwners,
      'rackLetters': snapshot.rackLetters,
      'playerScores': snapshot.playerScores,
      'currentPlayerIndex': snapshot.currentPlayerIndex,
    });
    await prefs.setString(_gameKey, data);
  }

  Future<GameSnapshot?> loadGame() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_gameKey);
    if (raw == null) {
      return null;
    }
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    final letters = (decoded['boardLetters'] as List<dynamic>)
        .map((value) => value as String?)
        .toList();
    final owners = (decoded['boardOwners'] as List<dynamic>)
        .map((value) => value as int?)
        .toList();
    final rack = (decoded['rackLetters'] as List<dynamic>)
        .map((value) => value as String)
        .toList();
    final scores = (decoded['playerScores'] as List<dynamic>)
        .map((value) => value as int)
        .toList();
    return GameSnapshot(
      boardLetters: letters,
      boardOwners: owners,
      rackLetters: rack,
      playerScores: scores,
      currentPlayerIndex: decoded['currentPlayerIndex'] as int,
    );
  }

  Future<void> clearGame() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_gameKey);
  }
}
