import 'package:flutter/material.dart';

class LetterRack extends StatelessWidget {
  const LetterRack({
    super.key,
    required this.letters,
    required this.selectedLetter,
    required this.onSelect,
  });

  final List<String> letters;
  final String selectedLetter;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final letter = letters[index];
          final isSelected = letter == selectedLetter;
          return LongPressDraggable<String>(
            data: letter,
            feedback: Material(
              color: Colors.transparent,
              child: _RackTile(letter: letter, isSelected: true),
            ),
            childWhenDragging: Opacity(
              opacity: 0.4,
              child: _RackTile(letter: letter, isSelected: isSelected),
            ),
            child: GestureDetector(
              onTap: () => onSelect(letter),
              child: _RackTile(letter: letter, isSelected: isSelected),
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemCount: letters.length,
      ),
    );
  }
}

class _RackTile extends StatelessWidget {
  const _RackTile({required this.letter, required this.isSelected});

  final String letter;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 54,
      decoration: BoxDecoration(
        color: isSelected
            ? Theme.of(context).colorScheme.primaryContainer
      : Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
        ),
      ),
      child: Center(
        child: Text(
          letter,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
