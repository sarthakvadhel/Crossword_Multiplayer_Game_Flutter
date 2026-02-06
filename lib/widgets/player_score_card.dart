import 'package:flutter/material.dart';

import '../models/player.dart';

class PlayerScoreCard extends StatelessWidget {
  const PlayerScoreCard({
    super.key,
    required this.player,
    required this.isActive,
    required this.backgroundColor,
  });

  final Player player;
  final bool isActive;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            player.name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              '${player.score}',
              key: ValueKey(player.score),
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
