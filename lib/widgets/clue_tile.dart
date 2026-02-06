import 'package:flutter/material.dart';

import '../models/board_cell.dart';

class ClueTile extends StatelessWidget {
  const ClueTile({super.key, required this.cell});

  final BoardCell cell;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (cell.clueAsset != null)
            Expanded(
              child: Image.asset(
                cell.clueAsset!,
                fit: BoxFit.contain,
              ),
            ),
          if (cell.clueText != null)
            Text(
              cell.clueText!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 10),
            ),
        ],
      ),
    );
  }
}
