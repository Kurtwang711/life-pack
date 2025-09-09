import 'package:flutter/material.dart';
import '../../widgets/spring_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1B4332), // 墨绿偏暗色
              Color(0xFF2D5016), // 深绿色
              Color(0xFF081C15), // 更深的绿黑色
            ],
            stops: [0.0, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // 寄语区卡片 - 距离顶部4px，距离左侧4px
              Positioned(
                top: 4,
                left: 4,
                child: const SpringCard(),
              ),
              // 其他内容可以在这里添加
            ],
          ),
        ),
      ),
    );
  }
}
