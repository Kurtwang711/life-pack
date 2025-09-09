import 'package:flutter/material.dart';

class RadioButtons extends StatefulWidget {
  final String leftButtonText;
  final String rightButtonText;
  
  const RadioButtons({
    super.key,
    this.leftButtonText = 'PLAY',
    this.rightButtonText = 'STOP',
  });

  @override
  State<RadioButtons> createState() => _RadioButtonsState();
}

class _RadioButtonsState extends State<RadioButtons> {
  String selectedValue = ''; // 默认都不选中，保持黑色状态

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildRadioButton('play', widget.leftButtonText, true), // 第一个按钮，左圆角
          const SizedBox(width: 2), // 2px间距
          _buildRadioButton('stop', widget.rightButtonText, false), // 第二个按钮，右圆角
        ],
      ),
    );
  }

  Widget _buildRadioButton(String value, String text, bool isFirst) {
    final bool isSelected = selectedValue == value;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedValue = value;
        });
      },
      child: Stack(
        children: [
          // 主要按钮容器
          AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            curve: Curves.linear,
            width: 70,
            height: 40,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
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
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(isFirst ? 6 : 0),
                bottomLeft: Radius.circular(isFirst ? 6 : 0),
                topRight: Radius.circular(!isFirst ? 6 : 0),
                bottomRight: Radius.circular(!isFirst ? 6 : 0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isSelected ? 0 : 0.2),
                  blurRadius: 5,
                  spreadRadius: 1,
                  offset: isSelected ? const Offset(0, 17) : Offset.zero,
                ),
              ],
            ),
            child: Center(
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 100),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: isSelected ? const Color(0xFFCAE2FD) : Colors.black,
                  shadows: isSelected
                      ? [
                          Shadow(
                            color: const Color(0xFFCAE2FD).withOpacity(0.9),
                            blurRadius: 12,
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
                child: Text(
                  text,
                  style: const TextStyle(
                    letterSpacing: 0.5,
                    height: 0.8,
                  ),
                ),
              ),
            ),
          ),
          // 光晕效果层
          if (isSelected)
            Positioned.fill(
              child: Container(
                margin: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(isFirst ? 5 : 0),
                    bottomLeft: Radius.circular(isFirst ? 5 : 0),
                    topRight: Radius.circular(!isFirst ? 5 : 0),
                    bottomRight: Radius.circular(!isFirst ? 5 : 0),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      const Color(0xFFCAE2FD).withOpacity(0.4),
                      Colors.transparent,
                    ],
                    stops: const [0.1, 0.5, 0.9],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
