import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'viewmodels/game_view_model.dart';
import 'views/game_page.dart';

void main() {
  runApp(const CrosswordGameApp());
}

class CrosswordGameApp extends StatelessWidget {
  const CrosswordGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GameViewModel()),
      ],
      child: MaterialApp(
        title: 'Crossword Multiplayer',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF4F6CF6),
            brightness: Brightness.light,
          ),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF4F6CF6),
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
        themeMode: ThemeMode.system,
        home: const GamePage(),
      ),
    );
  }
}
