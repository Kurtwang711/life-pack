import 'package:flutter/material.dart';
import '../../widgets/spring_card.dart';
import '../../widgets/radio_buttons.dart';
import '../../widgets/checkin_section.dart';
import '../../widgets/vault_section.dart';

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
              
              // 机要库区 - 在签到区下方，间距10px
              Positioned(
                top: 294,
                left: 14,
                child: const VaultSection(),
              ),
              
              // 右侧按钮组 - 与右边线保持8px间距
              Positioned(
                top: 294,
                right: 8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 年轮相册按钮 - 高度缩小至50px
                    _buildCustomButton('年轮相册', 140, 50),
                    SizedBox(height: 20),
                    // 真我录按钮
                    _buildCustomButton('真我录', 140, 50),
                    SizedBox(height: 18), // 继续向上提升1px，使许愿按钮底部黑色边线与机要库底部黑色边线对齐
                    // 许愿按钮
                    _buildCustomButton('许愿', 140, 50),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 构建自定义按钮的辅助方法
  Widget _buildCustomButton(String text, double width, double height) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(4),
      child: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF333333), Color(0xFF242323)],
          ),
          border: const Border(top: BorderSide(color: Color(0xFF4E4D4D))),
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 5,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: width > 100 ? 16 : 12, // 根据宽度调整字体大小
              fontWeight: FontWeight.w800,
              color: Colors.black,
              letterSpacing: 0.5,
              height: 0.8,
              shadows: const [
                Shadow(
                  offset: Offset(-1, -1),
                  color: Color(0x1AE0E0E0),
                ),
                Shadow(
                  offset: Offset(0, 2),
                  blurRadius: 3,
                  color: Color(0x4D000000),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
