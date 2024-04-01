import 'package:flutter/material.dart';

class MenuHomePage {
  static const String switchReadingMode = 'ReadingMode';
  static const String switchWatchMode = 'WatchMode';
  static const List<String> choice = <String>[
    switchReadingMode,
    switchWatchMode
  ];
  static const Map<String, IconData> choiceIcons = <String, IconData>{
    switchReadingMode: Icons.change_circle_rounded,
    switchWatchMode: Icons.dark_mode_outlined
  };
}
