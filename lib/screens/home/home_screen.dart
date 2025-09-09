import 'package:flutter/material.dart';
import '../../widgets/spring_card.dart';
import '../../widgets/radio_buttons.dart';
import '../../widgets/checkin_section.dart';

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
              // 第一排按钮 - 距离顶部4px，距离右侧4px
              Positioned(
                top: 4,
                right: 4,
                child: const RadioButtons(
                  leftButtonText: '分享',
                  rightButtonText: '消息',
                ),
              ),
              // 第二排按钮 - 底部与寄语区对齐，距离右侧4px
              Positioned(
                top: 46, // 寄语区底部(4+90=94) - 按钮高度(48) = 46
                right: 4,
                child: const RadioButtons(
                  leftButtonText: '客服',
                  rightButtonText: '主题',
                ),
              ),
              
              // 签到区 - 在寄语区下方，间距10px
              Positioned(
                top: 104, // 寄语区底部(4+90=94) + 间距10px = 104
                left: 4,
                right: 4,
                child: const CheckinSection(),
              ),
              // 其他内容可以在这里添加
            ],
          ),
        ),
      ),
    );
  }
}
