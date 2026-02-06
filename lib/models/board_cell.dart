import 'package:flutter/material.dart';

class BoardCell {
  BoardCell({
    required this.row,
    required this.col,
    this.letter,
    this.isBlocked = false,
    this.isSelected = false,
    this.isClue = false,
    this.clueText,
    this.clueAsset,
    this.ownerColor,
  });

  final int row;
  final int col;
  String? letter;
  bool isBlocked;
  bool isSelected;
  bool isClue;
  String? clueText;
  String? clueAsset;
  Color? ownerColor;
}
