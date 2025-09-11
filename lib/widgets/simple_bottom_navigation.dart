import 'package:flutter/material.dart';

/// 简化版的底部导航栏，去除复杂动画以避免闪退
class SimpleBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const SimpleBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFF333333), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // 首页按钮
          _buildNavButton(
            index: 0,
            icon: Icons.home_outlined,
            label: '首页',
            isActive: currentIndex == 0,
          ),
          // 个人中心按钮
          _buildNavButton(
            index: 1,
            icon: Icons.person_outline,
            label: '个人',
            isActive: currentIndex == 1,
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton({
    required int index,
    required IconData icon,
    required String label,
    required bool isActive,
  }) {
    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        width: 80,
        height: 50,
        decoration: BoxDecoration(
          color: isActive ? Colors.blue.withOpacity(0.3) : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isActive ? Colors.blue : Colors.white70,
              size: 20,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.blue : Colors.white70,
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
