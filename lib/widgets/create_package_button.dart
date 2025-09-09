import 'package:flutter/material.dart';

class CreatePackageButton extends StatefulWidget {
  const CreatePackageButton({super.key});

  @override
  State<CreatePackageButton> createState() => _CreatePackageButtonState();
}

class _CreatePackageButtonState extends State<CreatePackageButton> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('创建包裹 pressed');
      },
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovering = true),
        onExit: (_) => setState(() => _isHovering = false),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(4),
          child: Container(
            width: 128, // 8rem * 16 = 128px
            height: 38.4, // 2.4rem * 16 = 38.4px
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: _isHovering 
                    ? [const Color(0xFF1D1D1D), const Color(0xFF1D1D1D)]
                    : [const Color(0xFF333333), const Color(0xFF242323)],
              ),
              border: const Border(top: BorderSide(color: Color(0xFF4E4D4D))),
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(_isHovering ? 0 : 0.2),
                  blurRadius: 5,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Center(
              child: Text(
                '创建包裹',
                style: TextStyle(
                  fontSize: 12.8, // 0.8rem * 16 = 12.8px
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF51A5FF), // 亮蓝色
                  letterSpacing: 0.5,
                  height: 0.8,
                  shadows: const [
                    // 凹凸感阴影效果 - 高光
                    Shadow(
                      offset: Offset(-1, -1),
                      color: Color(0x4AE0E0E0),
                    ),
                    // 凹凸感阴影效果 - 深色阴影
                    Shadow(
                      offset: Offset(1, 1),
                      blurRadius: 2,
                      color: Color(0x80000000),
                    ),
                    // 蓝色发光效果
                    Shadow(
                      color: Color(0xFF51A5FF),
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


