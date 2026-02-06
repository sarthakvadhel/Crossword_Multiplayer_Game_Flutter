import 'dart:async';

import 'package:flutter/material.dart';

import '../data/mock_board.dart';
import '../data/mock_clues.dart';
import '../models/board_cell.dart';
import '../models/clue.dart';
import '../models/game_snapshot.dart';
import '../models/player.dart';
import '../services/ai_service.dart';
import '../services/banner_service.dart';
import '../services/dictionary_service.dart';
import '../services/sound_service.dart';
import '../services/storage_service.dart';

class GameViewModel extends ChangeNotifier {
  GameViewModel({
    DictionaryService? dictionaryService,
    SoundService? soundService,
    AiService? aiService,
    StorageService? storageService,
    BannerService? bannerService,
  })  : _dictionary = dictionaryService ?? DictionaryService(),
        _soundService = soundService ?? SoundService(),
        _aiService = aiService ?? AiService(),
        _storageService = storageService ?? StorageService(),
        _bannerService = bannerService ?? BannerService() {
    _resetBoard();
    _clues = MockClues.all();
    _players = [
      Player(id: 'you', name: 'You'),
      Player(id: 'opponent', name: 'Opponent', isAi: true),
    ];
    rackLetters = _drawLetters(_rackSize);
    _loadSavedGame();
  }

  late List<List<BoardCell>> _board;
  late List<Clue> _clues;
  late List<Player> _players;
  int _currentPlayerIndex = 0;
  bool _showOverlay = false;
  String _overlayMessage = '';
  String _notification = '';
  String _selectedRackLetter = '';
  bool _hasSavedGame = false;
  int _longestWordLength = 0;
  int _streak = 0;

  final DictionaryService _dictionary;
  final SoundService _soundService;
  final AiService _aiService;
  final StorageService _storageService;
  final BannerService _bannerService;

  static const int _rackSize = 5;

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
  bool get hasSavedGame => _hasSavedGame;
  int get streak => _streak;

  Player get currentPlayer => _players[_currentPlayerIndex];

  List<String> rackLetters = [];

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
    _persistGame();
    notifyListeners();
  }

  void placeDraggedLetter(BoardCell cell, String letter) {
    if (!rackLetters.contains(letter)) {
      return;
    }
    _selectedRackLetter = letter;
    placeLetter(cell);
  }

  void finishTurn() {
    final completedWords = _detectCompletedWords();
    if (completedWords.isNotEmpty) {
      var turnScore = 0;
      for (final word in completedWords) {
        turnScore += word.length;
      }
      currentPlayer.score += turnScore;
      _streak += 1;

      // Longest word bonus
      for (final word in completedWords) {
        if (word.length > _longestWordLength) {
          _longestWordLength = word.length;
          currentPlayer.score += 6;
          _showOverlayBanner(_bannerService.longestWordBanner());
        }
      }

      _showStreakOrCompleteBanner();
    } else {
      // Check simple word from all placed letters
      final word = _currentWord();
      if (word.isNotEmpty && _dictionary.isValid(word)) {
        currentPlayer.score += word.length;
        _streak += 1;
        if (word.length > _longestWordLength) {
          _longestWordLength = word.length;
          currentPlayer.score += 6;
          _showOverlayBanner(_bannerService.longestWordBanner());
        }
        _showStreakOrCompleteBanner();
      } else if (word.isNotEmpty) {
        _streak = 0;
        _showNotification('Not a valid word');
      }
    }

    // Empty hand bonus
    if (rackLetters.isEmpty) {
      currentPlayer.score += 5;
      _showOverlayBanner(_bannerService.emptyHandBanner());
    }
    _selectedRackLetter = '';
    _nextTurn();
  }

  void _showStreakOrCompleteBanner() {
    if (_streak >= 3) {
      _showOverlayBanner(_bannerService.streakBanner(_streak));
    } else {
      _showOverlayBanner(_bannerService.wordCompleteBanner());
    }
  }

  /// Scans rows and columns for completed valid words.
  List<String> _detectCompletedWords() {
    final found = <String>{};
    // Scan rows
    for (final row in _board) {
      for (final word in _extractWordsFromCells(row)) {
        if (word.length >= 2 && _dictionary.isValid(word)) {
          found.add(word);
        }
      }
    }
    // Scan columns
    for (var col = 0; col < _board.first.length; col++) {
      final colCells = [for (var row = 0; row < _board.length; row++) _board[row][col]];
      for (final word in _extractWordsFromCells(colCells)) {
        if (word.length >= 2 && _dictionary.isValid(word)) {
          found.add(word);
        }
      }
    }
    return found.toList();
  }

  /// Extracts consecutive letter sequences separated by gaps, blocked cells, or clues.
  List<String> _extractWordsFromCells(List<BoardCell> cells) {
    final words = <String>[];
    final buf = StringBuffer();
    for (final cell in cells) {
      if (!cell.isBlocked && !cell.isClue && cell.letter != null) {
        buf.write(cell.letter);
      } else {
        if (buf.length >= 2) {
          words.add(buf.toString());
        }
        buf.clear();
      }
    }
    if (buf.length >= 2) {
      words.add(buf.toString());
    }
    return words;
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
    rackLetters = _drawLetters(_rackSize);
    _showNotification('Tiles swapped');
    _selectedRackLetter = '';
    _streak = 0;
    _nextTurn();
  }

  void passTurn() {
    _showNotification('Turn passed');
    _selectedRackLetter = '';
    _streak = 0;
    _nextTurn();
  }

  void showHint() {
    for (final row in _board) {
      for (final cell in row) {
        cell.isHighlighted =
            !cell.isBlocked && !cell.isClue && cell.letter == null;
      }
    }
    _showOverlayBanner('Highlighted valid placements');
    notifyListeners();
    Timer(const Duration(seconds: 2), () {
      for (final row in _board) {
        for (final cell in row) {
          cell.isHighlighted = false;
        }
      }
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
    _refillRackIfNeeded();
    _persistGame();
    notifyListeners();
    if (currentPlayer.isAi) {
      _runAiTurn();
    }
  }

  void _runAiTurn() {
    Timer(const Duration(milliseconds: 900), () {
      if (_aiService.shouldSwap()) {
        _showNotification('Opponent swapped tiles');
        _currentPlayerIndex = 0;
        _persistGame();
        notifyListeners();
        return;
      }

      final moves = _aiService.pickMoveCount();
      var placed = 0;
      for (var i = 0; i < moves; i++) {
        final cell = _aiService.pickRandomCell(_board);
        if (cell == null) {
          break;
        }
        cell.letter = _aiService.pickRandomLetter();
        cell.ownerColor = const Color(0xFFF47B6A);
        currentPlayer.score += 1;
        placed += 1;
      }
      if (placed == _rackSize) {
        currentPlayer.score += 5;
        _showOverlayBanner(_bannerService.emptyHandBanner());
      }
      _showNotification('Opponent played');
      _currentPlayerIndex = 0;
      _persistGame();
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

  void _showOverlayBanner(String message) {
    _overlayMessage = message;
    _showOverlay = true;
    notifyListeners();
    Timer(const Duration(seconds: 2), () {
      _showOverlay = false;
      notifyListeners();
    });
  }

  void _refillRackIfNeeded() {
    if (rackLetters.length < _rackSize) {
      rackLetters = [
        ...rackLetters,
        ..._drawLetters(_rackSize - rackLetters.length),
      ];
    }
  }

  void _resetBoard() {
    _board = MockBoard.build();
  }

  List<String> _drawLetters(int count) {
    return List.generate(count, (_) => _aiService.pickSmartLetter());
  }

  Future<void> _loadSavedGame() async {
    final snapshot = await _storageService.loadGame();
    if (snapshot == null) {
      _hasSavedGame = false;
      notifyListeners();
      return;
    }
    _applySnapshot(snapshot);
    _hasSavedGame = true;
    notifyListeners();
  }

  void _applySnapshot(GameSnapshot snapshot) {
    final flatBoard = _board.expand((row) => row).toList();
    for (var i = 0; i < flatBoard.length; i++) {
      flatBoard[i].letter = snapshot.boardLetters[i];
      final owner = snapshot.boardOwners[i];
      flatBoard[i].ownerColor = owner == null ? null : Color(owner);
    }
    rackLetters = snapshot.rackLetters;
    for (var i = 0; i < _players.length; i++) {
      _players[i].score = snapshot.playerScores[i];
    }
    _currentPlayerIndex = snapshot.currentPlayerIndex;
    _streak = snapshot.streak;
    _longestWordLength = snapshot.longestWordLength;
  }

  Future<void> resetGame() async {
    _resetBoard();
    rackLetters = _drawLetters(_rackSize);
    for (final player in _players) {
      player.score = 0;
    }
    _currentPlayerIndex = 0;
    _longestWordLength = 0;
    _streak = 0;
    _selectedRackLetter = '';
    _hasSavedGame = false;
    await _storageService.clearGame();
    notifyListeners();
  }

  Future<void> _persistGame() async {
    final flatBoard = _board.expand((row) => row).toList();
    final snapshot = GameSnapshot(
      boardLetters: flatBoard.map((cell) => cell.letter).toList(),
      boardOwners: flatBoard.map((cell) => cell.ownerColor?.value).toList(),
      rackLetters: rackLetters,
      playerScores: _players.map((player) => player.score).toList(),
      currentPlayerIndex: _currentPlayerIndex,
      streak: _streak,
      longestWordLength: _longestWordLength,
    );
    await _storageService.saveGame(snapshot);
    _hasSavedGame = true;
  }
}
