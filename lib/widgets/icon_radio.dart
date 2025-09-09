import 'package:flutter/material.dart';

class IconRadio extends StatefulWidget {
  const IconRadio({super.key});

  @override
  State<IconRadio> createState() => _IconRadioState();
}

class _IconRadioState extends State<IconRadio> {
  final List<Map<String, dynamic>> items = [
    {'key': 'share', 'icon': Icons.share, 'color': const Color(0xFFFFC0CB)},
    {
      'key': 'support',
      'icon': Icons.support_agent,
      'color': const Color(0xFFFFD700),
    },
    {'key': 'message', 'icon': Icons.message, 'color': const Color(0xFFFF8C00)},
    {'key': 'theme', 'icon': Icons.palette, 'color': const Color(0xFFADD8E6)},
  ];
  String? selected;

  Color seasonColor(String k) =>
      items.firstWhere((e) => e['key'] == k)['color'] as Color;

  IconData seasonIcon(String k) =>
      items.firstWhere((e) => e['key'] == k)['icon'] as IconData;

  @override
  Widget build(BuildContext context) {
    const double cardW = 100;
    const double cardH = 90; // 与寄语区高度保持一致

    return SizedBox(
      width: cardW,
      height: cardH,
      child: GridView.count(
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 50, // 增加间距，让下方按钮底部对齐寄语区
        crossAxisSpacing: 10, // 左右间距
        childAspectRatio: 1.0,
        children: items.map((e) => _iconCard(e)).toList(),
      ),
    );
  }

  Widget _iconCard(Map<String, dynamic> data) {
    final String key = data['key'];
    final IconData icon = data['icon'];
    final Color highlight = data['color'];
    final bool isSelected = selected == key;

    return GestureDetector(
      onTap: () => setState(() => selected = key),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: const Cubic(0.4, 0, 0.2, 1),
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isSelected
                ? [const Color(0xFF1D1D1D), const Color(0xFF1D1D1D)]
                : [const Color(0xFF333333), const Color(0xFF242323)],
          ),
          border: isSelected
              ? null
              : const Border(top: BorderSide(color: Color(0xFF4E4D4D))),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isSelected ? 0 : 0.2),
              blurRadius: 5,
              spreadRadius: 1,
              offset: isSelected ? const Offset(0, 17) : Offset.zero,
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Stack(
          children: [
            // 图标
            Center(
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 100),
                style: TextStyle(
                  fontSize: 16,
                  color: isSelected ? highlight : Colors.black,
                  shadows: isSelected
                      ? [
                          Shadow(
                            color: highlight.withOpacity(0.9),
                            blurRadius: 12,
                          ),
                          // 增加凹凸感阴影效果
                          const Shadow(
                            offset: Offset(-1, -1),
                            color: Color(0x1AE0E0E0),
                          ),
                          const Shadow(
                            offset: Offset(0, 2),
                            blurRadius: 3,
                            color: Color(0x4D000000),
                          ),
                        ]
                      : [
                          const Shadow(
                            offset: Offset(-1, -1),
                            color: Color(0x1AE0E0E0),
                          ),
                          const Shadow(
                            offset: Offset(0, 2),
                            blurRadius: 3,
                            color: Color(0x4D000000),
                          ),
                        ],
                ),
                child: Icon(icon, size: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
