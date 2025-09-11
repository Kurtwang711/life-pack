import 'package:flutter/material.dart';
import 'dart:math' as math;

class SpringCard extends StatefulWidget {
  const SpringCard({super.key});

  @override
  State<SpringCard> createState() => _SpringCardState();
}

class _SpringCardState extends State<SpringCard> {
  bool selected = true; // 固定为选中状态，取消点击切换

  @override
  Widget build(BuildContext context) {
    const double cardW = 260;
    const double cardH = 90;

    return SizedBox(
      width: cardW,
      height: cardH,
      child: Stack(
        children: [
          // 背景黑卡片
          Container(
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          // 中心小方块
          Center(
            child: Transform.rotate(
              angle: math.pi / 4,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 120),
                curve: Curves.linear,
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: const Color(0xFF333333),
                  borderRadius: BorderRadius.circular(2),
                  border: Border.all(color: const Color(0xFF4E4D4D), width: 1),
                  boxShadow: selected
                      ? [
                          BoxShadow(
                            color: const Color(0xFFFFC0CB).withOpacity(0.8),
                            offset: const Offset(-11, 0),
                            blurRadius: 10,
                            spreadRadius: -12,
                          ),
                        ]
                      : null,
                ),
              ),
            ),
          ),
          // 文字区域
          Padding(
            padding: const EdgeInsets.all(6),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF1D1D1D), Color(0xFF1D1D1D)],
                ),
              ),
              child: Stack(
                children: [
                  // 取消外圈光晕
                  // 文字内容
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // 第一行：大吉大利，天天顺利！
                        const Text(
                          '大吉大利，天天顺利！',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                offset: Offset(-1, -1),
                                color: Color(0x1AE0E0E0),
                              ),
                              Shadow(
                                offset: Offset(0, 2),
                                blurRadius: 3,
                                color: Color(0x4D000000),
                              ),
                              Shadow(color: Colors.white, blurRadius: 12),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        // 第二行：--爱笑的苦瓜（靠右显示）
                        const Text(
                          '--爱笑的苦瓜',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 11, // 比第一行小2个字号
                            fontWeight: FontWeight.w400, // 比第一行轻3号粗度
                            color: Colors.white, // 白色
                            shadows: [
                              Shadow(
                                offset: Offset(-1, -1),
                                color: Color(0x1AE0E0E0),
                              ),
                              Shadow(
                                offset: Offset(0, 1),
                                blurRadius: 2,
                                color: Color(0x4D000000),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
