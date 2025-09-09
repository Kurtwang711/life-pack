import 'package:flutter/material.dart';
import '../models/checkin_model.dart';

class BlessingButton extends StatefulWidget {
  final CheckinManager checkinManager;
  final String? message;

  const BlessingButton({
    Key? key,
    required this.checkinManager,
    this.message,
  }) : super(key: key);

  @override
  _BlessingButtonState createState() => _BlessingButtonState();
}

class _BlessingButtonState extends State<BlessingButton>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    
    // 缩放动画
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTap() async {
    final todayIndex = widget.checkinManager.getTodayIndex();
    if (!widget.checkinManager.canCheckin(todayIndex)) return;
    
    // 播放动画
    await _animationController.forward();
    _animationController.reverse();
    
    // 执行签到
    widget.checkinManager.handleCheckin(todayIndex);
  }

  @override
  Widget build(BuildContext context) {
    final todayIndex = widget.checkinManager.getTodayIndex();
    bool canCheckin = widget.checkinManager.canCheckin(todayIndex);
    
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTapDown: (_) => _animationController.forward(),
        onTapUp: (_) => _animationController.reverse(),
        onTapCancel: () => _animationController.reverse(),
        onTap: _handleTap,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.linear,
                  width: 140,
                  height: 26,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: canCheckin
                          ? (_isHovering 
                              ? [const Color(0xFF1D1D1D), const Color(0xFF1D1D1D)]
                              : [const Color(0xFF333333), const Color(0xFF242323)])
                          : [Colors.grey.withOpacity(0.3), Colors.grey.withOpacity(0.5)],
                    ),
                    border: canCheckin
                        ? null
                        : const Border(top: BorderSide(color: Color(0xFF4E4D4D))),
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(canCheckin && !_isHovering ? 0.2 : 0),
                        blurRadius: 5,
                        spreadRadius: 1,
                        offset: canCheckin && !_isHovering ? Offset.zero : const Offset(0, 17),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      widget.message ?? (canCheckin ? '签到' : '已签到'),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: canCheckin ? Colors.white : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
