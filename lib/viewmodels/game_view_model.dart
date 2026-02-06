import 'dart:async';

import 'package:flutter/material.dart';

import '../data/mock_board.dart';
import '../data/mock_clues.dart';
import '../models/board_cell.dart';
import '../models/clue.dart';
import '../models/player.dart';
import '../services/ai_service.dart';
import '../services/dictionary_service.dart';
import '../services/sound_service.dart';

class GameViewModel extends ChangeNotifier {
  GameViewModel({
    DictionaryService? dictionaryService,
    SoundService? soundService,
    AiService? aiService,
  })  : _dictionary = dictionaryService ?? DictionaryService(),
        _soundService = soundService ?? SoundService(),
        _aiService = aiService ?? AiService() {
    _board = MockBoard.build();
    _clues = MockClues.all();
    _players = [
      Player(id: 'you', name: 'You'),
      Player(id: 'opponent', name: 'Opponent', isAi: true),
    ];
  }

  late List<List<BoardCell>> _board;
  late List<Clue> _clues;
  late List<Player> _players;
  int _currentPlayerIndex = 0;
  bool _showOverlay = false;
  String _overlayMessage = '';
  String _notification = '';
  String _selectedRackLetter = '';

  final DictionaryService _dictionary;
  final SoundService _soundService;
  final AiService _aiService;

  List<List<BoardCell>> get board => _board;
  List<Clue> get clues => _clues;
  List<Player> get players => _players;
  int get currentPlayerIndex => _currentPlayerIndex;
  bool get showOverlay => _showOverlay;
  String get overlayMessage => _overlayMessage;
  String get notification => _notification;
  String get selectedRackLetter => _selectedRackLetter;
  bool get soundEnabled => _soundService.soundEnabled;
  bool get hapticsEnabled => _soundService.hapticsEnabled;

  Player get currentPlayer => _players[_currentPlayerIndex];

  List<String> rackLetters = ['S', 'A', 'T', 'R', 'E', 'L', 'P'];

  void selectCell(BoardCell cell) {
    for (final row in _board) {
      for (final entry in row) {
        entry.isSelected = false;
      }
    }
    if (!cell.isBlocked && !cell.isClue) {
      cell.isSelected = true;
    }
    notifyListeners();
  }

  void selectRackLetter(String letter) {
    _selectedRackLetter = letter;
    notifyListeners();
  }

  void placeLetter(BoardCell cell) {
    if (_selectedRackLetter.isEmpty ||
        cell.isBlocked ||
        cell.isClue ||
        cell.letter != null) {
      return;
    }
    if (!rackLetters.contains(_selectedRackLetter)) {
      return;
    }
    cell.letter = _selectedRackLetter;
    cell.ownerColor = currentPlayerIndex == 0
        ? const Color(0xFF4F6CF6)
        : const Color(0xFFF47B6A);
    rackLetters.remove(_selectedRackLetter);
    _selectedRackLetter = '';
    currentPlayer.score += 1;
    notifyListeners();
  }

  void placeDraggedLetter(BoardCell cell, String letter) {
    if (!rackLetters.contains(letter)) {
      return;
    }
    _selectedRackLetter = letter;
    placeLetter(cell);
  }

  void submitWord() {
    final word = _currentWord();
    if (_dictionary.isValid(word)) {
      _showNotification('Word accepted!');
      currentPlayer.score += 5;
      _nextTurn();
    } else {
      _showNotification('Not a valid word');
    }
  }

  String _currentWord() {
    final letters = <String>[];
    for (final row in _board) {
      for (final cell in row) {
        if (cell.letter != null) {
          letters.add(cell.letter!);
        }
      }
    }
    return letters.join();
  }

  void swapTiles() {
    rackLetters = ['N', 'O', 'P', 'E', 'T', 'R', 'Y'];
    _showNotification('Tiles swapped');
    _nextTurn();
  }

  void passTurn() {
    _showNotification('Turn passed');
    _nextTurn();
  }

  void showBackTapWarning() {
    _overlayMessage = 'Back tap detected';
    _showOverlay = true;
    notifyListeners();
    Timer(const Duration(seconds: 2), () {
      _showOverlay = false;
      notifyListeners();
    });
  }

  void toggleSound() {
    _soundService.toggleSound();
    notifyListeners();
  }

  void toggleHaptics() {
    _soundService.toggleHaptics();
    notifyListeners();
  }

  void _nextTurn() {
    _currentPlayerIndex = (_currentPlayerIndex + 1) % _players.length;
    notifyListeners();
    if (currentPlayer.isAi) {
      _runAiTurn();
    }
  }

  void _runAiTurn() {
    Timer(const Duration(milliseconds: 600), () {
      final cell = _aiService.pickRandomCell(_board);
      if (cell != null) {
        cell.letter = _aiService.pickRandomLetter();
        cell.ownerColor = const Color(0xFFF47B6A);
        currentPlayer.score += 1;
      }
      _showNotification('Opponent played');
      _currentPlayerIndex = 0;
      notifyListeners();
    });
  }

  void _showNotification(String message) {
    _notification = message;
    notifyListeners();
    Timer(const Duration(seconds: 2), () {
      _notification = '';
      notifyListeners();
    });
  }
}
