import 'package:flutter/material.dart';
import '../models/checkin_model.dart';

class ProgressBarWidget extends StatelessWidget {
  final CheckinManager checkinManager;

  const ProgressBarWidget({super.key, required this.checkinManager});

  @override
  Widget build(BuildContext context) {
    final todayIndex = checkinManager.getTodayIndex();

    return Container(
      height: 8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9999),
        color: const Color(0xFF1D1D1D),
      ),
      child: Row(
        children: List.generate(checkinManager.totalDays, (index) {
          final day = checkinManager.checkinData[index];
          Color segmentColor = const Color(0xFF333333); // 默认灰色（未来）

          if (day.status == CheckinStatus.signed) {
            segmentColor = const Color(0xFF8a2be2); // 紫色（已签到）
          } else if (day.status == CheckinStatus.madeUp) {
            segmentColor = const Color(0xFFff8c00); // 橙色（已补签）
          } else if (day.status == CheckinStatus.unsigned &&
              index < todayIndex) {
            segmentColor = Colors.black; // 黑色（已错过）
          }

          return Expanded(
            child: Container(
              margin: EdgeInsets.only(
                left: index == 0 ? 0 : 0.5,
                right: index == checkinManager.totalDays - 1 ? 0 : 0.5,
              ),
              decoration: BoxDecoration(
                color: segmentColor,
                borderRadius: BorderRadius.horizontal(
                  left: index == 0 ? const Radius.circular(9999) : Radius.zero,
                  right: index == checkinManager.totalDays - 1
                      ? const Radius.circular(9999)
                      : Radius.zero,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
