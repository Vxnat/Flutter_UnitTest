import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_get_api_news/auth/auth_gate.dart';
import 'package:flutter_application_get_api_news/firebase_options.dart';
import 'package:flutter_application_get_api_news/provider/list_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ChangeNotifierProvider(
      create: (_) => ListProvider(),
      child: const MaterialApp(
        home: AuthGate(),
        debugShowCheckedModeBanner: false,
      )));
}
