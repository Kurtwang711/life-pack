import 'package:flutter/material.dart';
import 'screens/home/home_screen.dart';

void main() {
  runApp(const LifepodApp());
}

class LifepodApp extends StatelessWidget {
  const LifepodApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lifepod',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
