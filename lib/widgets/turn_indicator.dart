import 'package:flutter/material.dart';

class TurnIndicator extends StatelessWidget {
  const TurnIndicator({
    super.key,
    required this.isPlayerTurn,
  });

  final bool isPlayerTurn;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: isPlayerTurn
            ? const Color(0xFF4F6CF6)
            : const Color(0xFFF47B6A),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPlayerTurn ? Icons.person : Icons.smart_toy,
            color: Colors.white,
            size: 16,
          ),
          const SizedBox(width: 6),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              isPlayerTurn ? 'Your turn' : 'Opponent thinking...',
              key: ValueKey(isPlayerTurn),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
