import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/board_cell.dart';
import '../viewmodels/game_view_model.dart';
import '../widgets/action_button.dart';
import '../widgets/clue_tile.dart';
import '../widgets/letter_rack.dart';
import '../widgets/player_score_card.dart';
import '../widgets/turn_indicator.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<GameViewModel>();
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    final isPlayerTurn = viewModel.currentPlayerIndex == 0;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Crossword Master'),
        centerTitle: false,
        backgroundColor: const Color(0xFF516CF5),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: viewModel.toggleSound,
            icon: Icon(
              viewModel.soundEnabled ? Icons.volume_up : Icons.volume_off,
            ),
          ),
          IconButton(
            onPressed: viewModel.toggleHaptics,
            icon: Icon(
              viewModel.hapticsEnabled
                  ? Icons.vibration
                  : Icons.phone_android,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 90,
                  child: Stack(
                    children: [
                      const Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: EdgeInsets.only(top: 12),
                          child: Text(
                            'You vs Opponent',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16, top: 12),
                          child: PlayerScoreCard(
                            player: viewModel.players.first,
                            isActive: viewModel.currentPlayerIndex == 0,
                            backgroundColor: const Color(0xFFDDE6FF),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16, top: 12),
                          child: PlayerScoreCard(
                            player: viewModel.players.last,
                            isActive: viewModel.currentPlayerIndex == 1,
                            backgroundColor: const Color(0xFFFFDDE0),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: TurnIndicator(
                          isPlayerTurn: viewModel.currentPlayerIndex == 0,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 32 : 12,
                    ),
                    child: Center(
                      child: SizedBox(
                        width: isTablet ? 520 : 360,
                        height: isTablet ? 520 : 360,
                        child: _BoardGrid(
                          board: viewModel.board,
                          onTapCell: viewModel.selectCell,
                          onPlaceLetter: viewModel.placeLetter,
                          onDropLetter: viewModel.placeDraggedLetter,
                          hasSelectedLetter:
                              viewModel.selectedRackLetter.isNotEmpty,
                        ),
                      ),
                    ),
                  ),
                ),
                if (viewModel.notification.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Text(
                      viewModel.notification,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: LetterRack(
                    letters: viewModel.rackLetters,
                    selectedLetter: viewModel.selectedRackLetter,
                    onSelect: viewModel.selectRackLetter,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: [
                      ActionButton(
                        label: 'Swap',
                        icon: Icons.sync,
                        onPressed: isPlayerTurn ? viewModel.swapTiles : null,
                      ),
                      ActionButton(
                        label: 'Pass',
                        icon: Icons.pause_circle_filled,
                        onPressed: isPlayerTurn ? viewModel.passTurn : null,
                      ),
                      ActionButton(
                        label: 'Play',
                        icon: Icons.send,
                        onPressed: isPlayerTurn ? viewModel.finishTurn : null,
                      ),
                      ActionButton(
                        label: 'Word',
                        icon: Icons.menu_book,
                        onPressed: () => _showWordDialog(context, viewModel),
                      ),
                      ActionButton(
                        label: 'Hint',
                        icon: Icons.lightbulb,
                        onPressed: isPlayerTurn ? viewModel.showHint : null,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0E0E0),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Text('Ad Banner Placeholder'),
                  ),
                ),
              ],
            ),
            if (viewModel.showOverlay)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: AnimatedSlide(
                  offset: viewModel.showOverlay
                      ? Offset.zero
                      : const Offset(0, -1),
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOutBack,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xCC4F6CF6), Color(0xCC7B61FF)],
                      ),
                    ),
                    child: Text(
                      viewModel.overlayMessage,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showWordDialog(BuildContext context, GameViewModel viewModel) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remaining Words'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: viewModel.clues.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final clue = viewModel.clues[index];
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (clue.assetPath != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        clue.assetPath!,
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                      ),
                    )
                  else
                    const Icon(Icons.image_not_supported),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          clue.text,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        Text('Pattern: ${'•' * clue.answer.length}'),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class _BoardGrid extends StatelessWidget {
  const _BoardGrid({
    required this.board,
    required this.onTapCell,
    required this.onPlaceLetter,
    required this.onDropLetter,
    required this.hasSelectedLetter,
  });

  final List<List<BoardCell>> board;
  final void Function(BoardCell) onTapCell;
  final void Function(BoardCell) onPlaceLetter;
  final void Function(BoardCell, String) onDropLetter;
  final bool hasSelectedLetter;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: board.length * board.first.length,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: board.first.length,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
      ),
      itemBuilder: (context, index) {
        final row = index ~/ board.first.length;
        final col = index % board.first.length;
        final cell = board[row][col];
        if (cell.isClue) {
          return ClueTile(cell: cell);
        }
        return DragTarget<String>(
          onWillAcceptWithDetails: (details) =>
              !cell.isBlocked &&
              !cell.isClue &&
              cell.letter == null &&
              details.data.isNotEmpty,
          onAcceptWithDetails: (details) =>
              onDropLetter(cell, details.data),
          builder: (context, candidateData, rejectedData) {
            return GestureDetector(
              onTap: () =>
                  hasSelectedLetter ? onPlaceLetter(cell) : onTapCell(cell),
              onDoubleTap: () => onPlaceLetter(cell),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                decoration: BoxDecoration(
                  color: cell.isBlocked
                      ? Colors.grey.shade700
                      : cell.isHighlighted
                          ? const Color(0xFFFFF7CC)
                          : cell.isSelected
                              ? Theme.of(context).colorScheme.primaryContainer
                              : Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: candidateData.isNotEmpty
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.outline,
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    cell.letter ?? '',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: cell.ownerColor ??
                          Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
