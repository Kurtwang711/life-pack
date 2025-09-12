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
      // 如果遇到黑屏问题，可以快速切换到稳定版本
      home: const HomeScreen(), // 正常版本
      // home: const StablePackageScreen(), // 稳定版本
    );
  }
}
