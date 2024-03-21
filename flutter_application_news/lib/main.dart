import 'package:flutter/material.dart';
import 'package:flutter_application_get_api_news/bottom_nav_bar.dart';
import 'package:flutter_application_get_api_news/provider/list_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (_) => ListProvider(),
    child: const MaterialApp(
      home: BottomNavBar(),
      debugShowCheckedModeBanner: false,
    ),
  ));
}
