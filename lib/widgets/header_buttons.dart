import 'package:flutter/material.dart';

class HeaderButtons extends StatefulWidget {
  const HeaderButtons({super.key});

  @override
  State<HeaderButtons> createState() => _HeaderButtonsState();
}

class _HeaderButtonsState extends State<HeaderButtons> {
  final List<Map<String, dynamic>> topRowButtons = [
    {'icon': Icons.notifications, 'id': 'notifications'},
    {'icon': Icons.settings, 'id': 'settings'},
  ];

  final List<Map<String, dynamic>> bottomRowButtons = [
    {'icon': Icons.favorite, 'id': 'favorite'},
    {'icon': Icons.share, 'id': 'share'},
  ];

  String? selectedButton;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 65, // 25px + 15px间距 + 25px = 65px
      height: 90, // 与寄语区高度一致
      child: Column(
        children: [
          // 第一排按钮
          Row(
            children: [
              _buildButton(topRowButtons[0]),
              const SizedBox(width: 15), // 按钮间间距
              _buildButton(topRowButtons[1]),
            ],
          ),
          const SizedBox(height: 15), // 行间距
          // 第二排按钮
          Row(
            children: [
              _buildButton(bottomRowButtons[0]),
              const SizedBox(width: 15), // 按钮间间距
              _buildButton(bottomRowButtons[1]),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButton(Map<String, dynamic> buttonData) {
    final IconData icon = buttonData['icon'];
    final String id = buttonData['id'];
    final bool isSelected = selectedButton == id;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedButton = selectedButton == id ? null : id;
        });
      },
      child: Container(
        width: 25,
        height: 25,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(6), // 方形圆角
          boxShadow: [
            // 与寄语区相似的阴影效果
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(2, 2),
            ),
            if (isSelected) ...[
              BoxShadow(
                color: Colors.blue.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ],
        ),
        child: Icon(
          icon,
          size: 14,
          color: isSelected ? Colors.blue : Colors.black54,
        ),
      ),
    );
  }
}
