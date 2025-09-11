import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar>
    with TickerProviderStateMixin {
  late AnimationController _radarController;
  late AnimationController _hoverController;
  late Animation<double> _radarAnimation;
  late Animation<double> _hoverAnimation;

  @override
  void initState() {
    super.initState();

    // 雷达动画控制器 - 更慢的动画效果
    _radarController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    // 悬浮动画控制器
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _radarAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _radarController, curve: Curves.easeInOut),
    );

    _hoverAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );

    // 开始雷达动画
    _radarController.repeat();
  }

  @override
  void dispose() {
    _radarController.dispose();
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 32),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF191818).withOpacity(0.5),
              const Color(0xFF191818).withOpacity(0.3),
            ],
          ),
          border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavigationItem(
              icon: _buildCustomHomeIcon(),
              index: 0,
              hasAnimation: false,
            ),
            _buildNavigationItem(
              icon: _buildCustomRadarIcon(),
              index: 1,
              hasAnimation: true, // 守望按钮有雷达动画
            ),
            _buildNavigationItem(
              icon: _buildCustomPersonIcon(),
              index: 2,
              hasAnimation: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationItem({
    required Widget icon,
    required int index,
    required bool hasAnimation,
  }) {
    final isSelected = widget.currentIndex == index;

    return GestureDetector(
      onTap: () => widget.onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        transform: Matrix4.identity()
          ..translate(0.0, isSelected ? -20.0 : 0.0)
          ..scale(isSelected ? 1.25 : 1.0),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF191818),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
          ),
          child: hasAnimation && index == 1
              ? AnimatedBuilder(
                  animation: _radarAnimation,
                  builder: (context, child) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        // 外层雷达波纹效果
                        Container(
                          width: 24 + (20 * _radarAnimation.value),
                          height: 24 + (20 * _radarAnimation.value),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withOpacity(
                                0.3 * (1 - _radarAnimation.value),
                              ),
                              width: 1,
                            ),
                          ),
                        ),
                        // 内层雷达波纹
                        Container(
                          width: 24 + (10 * _radarAnimation.value),
                          height: 24 + (10 * _radarAnimation.value),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withOpacity(
                                0.5 * (1 - _radarAnimation.value),
                              ),
                              width: 0.5,
                            ),
                          ),
                        ),
                        // 中心图标
                        SizedBox(width: 24, height: 24, child: icon),
                      ],
                    );
                  },
                )
              : SizedBox(width: 24, height: 24, child: icon),
        ),
      ),
    );
  }

  // 自定义首页图标
  Widget _buildCustomHomeIcon() {
    return CustomPaint(size: const Size(24, 24), painter: HomeIconPainter());
  }

  // 自定义雷达图标
  Widget _buildCustomRadarIcon() {
    return CustomPaint(size: const Size(24, 24), painter: RadarIconPainter());
  }

  // 自定义个人图标
  Widget _buildCustomPersonIcon() {
    return CustomPaint(size: const Size(24, 24), painter: PersonIconPainter());
  }
}

// 首页图标绘制器
class HomeIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final path = Path();
    // 绘制房子的外形 - 根据附件设计
    path.moveTo(size.width * 0.1, size.height * 0.4);
    path.lineTo(size.width * 0.5, size.width * 0.1);
    path.lineTo(size.width * 0.9, size.height * 0.4);
    path.moveTo(size.width * 0.2, size.height * 0.5);
    path.lineTo(size.width * 0.2, size.height * 0.9);
    path.lineTo(size.width * 0.8, size.height * 0.9);
    path.lineTo(size.width * 0.8, size.height * 0.5);
    // 门
    path.moveTo(size.width * 0.4, size.height * 0.65);
    path.lineTo(size.width * 0.4, size.height * 0.9);
    path.lineTo(size.width * 0.6, size.height * 0.9);
    path.lineTo(size.width * 0.6, size.height * 0.65);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// 雷达图标绘制器
class RadarIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final center = Offset(size.width / 2, size.height / 2);

    // 绘制雷达圆圈
    canvas.drawCircle(center, size.width * 0.4, paint);
    canvas.drawCircle(center, size.width * 0.3, paint);
    canvas.drawCircle(center, size.width * 0.2, paint);
    canvas.drawCircle(center, size.width * 0.1, paint);

    // 绘制雷达扫描线
    canvas.drawLine(
      center,
      Offset(center.dx, center.dy - size.height * 0.4),
      paint,
    );
    canvas.drawLine(
      center,
      Offset(center.dx + size.width * 0.4, center.dy),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// 个人图标绘制器
class PersonIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final center = Offset(size.width / 2, size.height / 2);

    // 绘制头部
    canvas.drawCircle(
      Offset(center.dx, size.height * 0.3),
      size.width * 0.15,
      paint,
    );

    // 绘制身体
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(center.dx, size.height * 0.75),
        width: size.width * 0.6,
        height: size.height * 0.4,
      ),
      0,
      3.14159, // π
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
