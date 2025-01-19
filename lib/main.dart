import 'package:flutter/material.dart';
import 'package:ruleta/local_storage.dart';
import 'package:ruleta/ruleta.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorage.configurePrefs();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const Ruleta(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.pink,
        ),
        useMaterial3: false,
      ),
    );
  }
}

