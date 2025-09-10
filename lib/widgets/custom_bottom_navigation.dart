import 'package:flutter/material.dart';
import 'dart:math' as math;

class CustomBottomNavigation extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<CustomBottomNavigation> createState() => _CustomBottomNavigationState();
}

class _CustomBottomNavigationState extends State<CustomBottomNavigation>
    with TickerProviderStateMixin {
  late AnimationController _radarController;
  late Animation<double> _radarAnimation;

  @override
  void initState() {
    super.initState();
    
    // 雷达动画控制器
    _radarController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _radarAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(_radarController);
    
    // 开始循环动画
    _radarController.repeat();
  }

  @override
  void dispose() {
    _radarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240, // 设置固定宽度240px
      padding: const EdgeInsets.all(3),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.transparent, // 改为透明背景
        borderRadius: BorderRadius.circular(9999),
        // 移除边框和阴影，实现悬浮效果
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly, // 均匀分布
        children: [
          // 首页按钮
          _buildNavButton(
            index: 0,
            icon: Icons.home_outlined,
            label: '首页',
          ),
          
          const SizedBox(width: 32), // 2rem gap
          
          // 动态雷达
          _buildRadar(),
          
          const SizedBox(width: 32), // 2rem gap
          
          // 个人中心按钮
          _buildNavButton(
            index: 1,
            icon: Icons.person_outline,
            label: '个人中心',
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton({
    required int index,
    required IconData icon,
    required String label,
  }) {
    return GestureDetector(
      onTap: () => widget.onTap(index),
      child: Container(
        width: 44.8,
        height: 44.8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9999),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF333333), Color(0xFF242323)], // 灰底渐变
          ),
          border: Border.all(color: Colors.black, width: 1), // 黑边
          boxShadow: [
            // 立体感阴影效果
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 5,
              spreadRadius: 1,
              offset: const Offset(0, 2),
            ),
            // 内部高光
            BoxShadow(
              color: const Color(0x1AE0E0E0),
              blurRadius: 2,
              offset: const Offset(-1, -1),
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 19.2,
          color: Colors.white, // 白色图标
          shadows: [
            // 图标立体感阴影
            Shadow(
              offset: const Offset(-0.5, -0.5),
              color: const Color(0x1AE0E0E0),
            ),
            const Shadow(
              offset: Offset(0.5, 1),
              blurRadius: 2,
              color: Color(0x4D000000),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadar() {
    return GestureDetector(
      onTap: () => widget.onTap(1), // 守望服务在索引1位置
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: const Color(0xFF333333), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.55),
              blurRadius: 20,
              offset: const Offset(6.4, 6.4),
            ),
          ],
        ),
        child: Stack(
        children: [
          // 内圆虚线边框
          Positioned.fill(
            child: Container(
              margin: const EdgeInsets.all(5.2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: const Color(0xFF444444),
                  width: 1,
                  style: BorderStyle.solid, // Flutter不支持虚线，用实线代替
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 6.4,
                    offset: const Offset(-1.2, -1.2),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 9.6,
                    offset: const Offset(1.2, 1.2),
                  ),
                ],
              ),
            ),
          ),
          
          // 中心圆点
          Center(
            child: Container(
              width: 12.8,
              height: 12.8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: const Color(0xFF444444),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 6.4,
                    offset: const Offset(-1.2, -1.2),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 9.6,
                    offset: const Offset(1.2, 1.2),
                  ),
                ],
              ),
            ),
          ),
          
          // 雷达扫描线
          AnimatedBuilder(
            animation: _radarAnimation,
            builder: (context, child) {
              return CustomPaint(
                size: const Size(40, 40),
                painter: RadarPainter(
                  angle: _radarAnimation.value,
                ),
              );
            },
          ),
        ],
        ),
      ),
    );
  }
}

class RadarPainter extends CustomPainter {
  final double angle;

  RadarPainter({required this.angle});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 2; // 留出边框空间
    
    // 绘制雷达同心圆
    _drawRadarCircles(canvas, center, radius);
    
    // 绘制雷达十字线
    _drawRadarCrossLines(canvas, center, radius);
    
    // 绘制扫描扇形区域（发光效果）
    _drawScanArea(canvas, center, radius);
    
    // 绘制主扫描线
    _drawScanLine(canvas, center, radius);
    
    // 绘制扫描点效果
    _drawScanDots(canvas, center, radius);
  }

  void _drawRadarCircles(Canvas canvas, Offset center, double radius) {
    final circlePaint = Paint()
      ..color = const Color(0xFF444444).withOpacity(0.3)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    // 绘制3个同心圆
    for (int i = 1; i <= 3; i++) {
      canvas.drawCircle(center, radius * i / 3, circlePaint);
    }
  }

  void _drawRadarCrossLines(Canvas canvas, Offset center, double radius) {
    final linePaint = Paint()
      ..color = const Color(0xFF444444).withOpacity(0.4)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    // 绘制水平线
    canvas.drawLine(
      Offset(center.dx - radius, center.dy),
      Offset(center.dx + radius, center.dy),
      linePaint,
    );

    // 绘制垂直线
    canvas.drawLine(
      Offset(center.dx, center.dy - radius),
      Offset(center.dx, center.dy + radius),
      linePaint,
    );
  }

  void _drawScanArea(Canvas canvas, Offset center, double radius) {
    // 扇形扫描区域 - 60度扇形
    final scanAngleRange = math.pi / 3; // 60度
    final startAngle = angle - scanAngleRange / 2;
    
    // 创建扇形渐变
    final sweepGradient = SweepGradient(
      center: Alignment.center,
      startAngle: startAngle,
      endAngle: startAngle + scanAngleRange,
      colors: [
        Colors.transparent,
        const Color(0xFFfc5185).withOpacity(0.1),
        const Color(0xFFfc5185).withOpacity(0.3),
        const Color(0xFFfc5185).withOpacity(0.6),
        const Color(0xFFfc5185).withOpacity(0.3),
        const Color(0xFFfc5185).withOpacity(0.1),
        Colors.transparent,
      ],
      stops: const [0.0, 0.2, 0.4, 0.5, 0.6, 0.8, 1.0],
    );

    final gradientPaint = Paint()
      ..shader = sweepGradient.createShader(
        Rect.fromCircle(center: center, radius: radius),
      )
      ..style = PaintingStyle.fill;

    // 绘制扇形区域
    final path = Path()
      ..moveTo(center.dx, center.dy)
      ..arcTo(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        scanAngleRange,
        false,
      )
      ..close();

    canvas.drawPath(path, gradientPaint);
  }

  void _drawScanLine(Canvas canvas, Offset center, double radius) {
    // 主扫描线 - 从中心到边缘的亮线
    final scanLinePaint = Paint()
      ..color = const Color(0xFFfc5185).withOpacity(0.9)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final endPoint = Offset(
      center.dx + radius * math.cos(angle),
      center.dy + radius * math.sin(angle),
    );

    canvas.drawLine(center, endPoint, scanLinePaint);

    // 扫描线发光效果
    final glowPaint = Paint()
      ..color = const Color(0xFFfc5185).withOpacity(0.4)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

    canvas.drawLine(center, endPoint, glowPaint);
  }

  void _drawScanDots(Canvas canvas, Offset center, double radius) {
    // 在扫描线上绘制移动的扫描点
    final dotPaint = Paint()
      ..color = const Color(0xFFfc5185)
      ..style = PaintingStyle.fill;

    // 绘制3个不同距离的扫描点
    for (int i = 1; i <= 3; i++) {
      final dotRadius = radius * (0.3 + 0.2 * i);
      final dotPosition = Offset(
        center.dx + dotRadius * math.cos(angle),
        center.dy + dotRadius * math.sin(angle),
      );

      // 主扫描点
      canvas.drawCircle(dotPosition, 1.5, dotPaint);

      // 扫描点发光效果
      final glowDotPaint = Paint()
        ..color = const Color(0xFFfc5185).withOpacity(0.6)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

      canvas.drawCircle(dotPosition, 3, glowDotPaint);
    }

    // 中心点发光
    final centerGlowPaint = Paint()
      ..color = const Color(0xFFfc5185).withOpacity(0.8)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    canvas.drawCircle(center, 2, centerGlowPaint);
    canvas.drawCircle(center, 1, dotPaint);
  }

  @override
  bool shouldRepaint(RadarPainter oldDelegate) {
    return oldDelegate.angle != angle;
  }
}
