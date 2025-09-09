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
      padding: const EdgeInsets.all(3),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9999),
        border: Border.all(color: Colors.grey, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
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
    final bool isActive = widget.currentIndex == index;
    
    return GestureDetector(
      onTap: () => widget.onTap(index),
      child: Container(
        width: 44.8,
        height: 44.8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9999),
          color: isActive ? Colors.grey.withOpacity(0.1) : Colors.transparent,
        ),
        child: Icon(
          icon,
          size: 19.2,
          color: isActive ? const Color(0xFF323232) : Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildRadar() {
    return Container(
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
    );
  }
}

class RadarPainter extends CustomPainter {
  final double angle;

  RadarPainter({required this.angle});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    
    // 绘制扫描线
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    
    // 从中心到边缘的扫描线
    final endPoint = Offset(
      center.dx + radius * math.cos(angle - math.pi / 2),
      center.dy + radius * math.sin(angle - math.pi / 2),
    );
    
    canvas.drawLine(center, endPoint, paint);
    
    // 绘制发光效果 - 扫描区域
    final gradientPaint = Paint()
      ..shader = RadialGradient(
        center: Alignment.center,
        radius: 0.5,
        colors: [
          const Color(0xFFfc5185).withOpacity(0.6),
          const Color(0xFFfc5185).withOpacity(0.2),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    
    // 绘制扫描扇形区域
    canvas.drawPath(
      Path()
        ..moveTo(center.dx, center.dy)
        ..arcTo(
          Rect.fromCircle(center: center, radius: radius),
          angle - math.pi / 2 - 0.3,
          0.6,
          false,
        )
        ..close(),
      gradientPaint,
    );
  }

  @override
  bool shouldRepaint(RadarPainter oldDelegate) {
    return oldDelegate.angle != angle;
  }
}
