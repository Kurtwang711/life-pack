import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../constants/app_constants.dart';
import '../models/habit.dart';
import '../providers/habit_provider.dart';

class HabitCard extends StatelessWidget {
  final Habit habit;
  final VoidCallback? onTap;

  const HabitCard({super.key, required this.habit, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isCompletedToday = habit.isCompletedToday();

    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSizes.radiusMD),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingMD),
          child: Row(
            children: [
              // Habit completion button
              GestureDetector(
                onTap: () {
                  if (isCompletedToday) {
                    context.read<HabitProvider>().uncompleteHabitToday(habit);
                  } else {
                    context.read<HabitProvider>().completeHabitToday(habit);
                  }
                },
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isCompletedToday
                        ? Color(habit.color)
                        : Color(habit.color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppSizes.radiusSM),
                    border: !isCompletedToday
                        ? Border.all(color: Color(habit.color), width: 2)
                        : null,
                  ),
                  child: Center(
                    child: isCompletedToday
                        ? const FaIcon(
                            FontAwesomeIcons.check,
                            color: Colors.white,
                            size: 20,
                          )
                        : Text(
                            habit.icon,
                            style: TextStyle(
                              fontSize: 20,
                              color: Color(habit.color),
                            ),
                          ),
                  ),
                ),
              ),

              const SizedBox(width: AppSizes.paddingMD),

              // Habit info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      habit.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _getFrequencyText(),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              // Streak info
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const FaIcon(
                        FontAwesomeIcons.fire,
                        color: AppColors.accent,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${habit.streak}',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.accent,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'day streak',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getFrequencyText() {
    switch (habit.frequency) {
      case HabitFrequency.daily:
        return 'Daily';
      case HabitFrequency.weekly:
        return 'Weekly';
      case HabitFrequency.monthly:
        return 'Monthly';
    }
  }
}
