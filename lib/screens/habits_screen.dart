import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../constants/app_constants.dart';
import '../providers/habit_provider.dart';
import '../widgets/habit_card.dart';
import '../models/habit.dart';

class HabitsScreen extends StatelessWidget {
  const HabitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Habits')),
      body: Consumer<HabitProvider>(
        builder: (context, habitProvider, child) {
          if (habitProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final habits = habitProvider.activeHabits;

          if (habits.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const FaIcon(
                    FontAwesomeIcons.bullseye,
                    color: AppColors.textDisabled,
                    size: 48,
                  ),
                  const SizedBox(height: AppSizes.paddingMD),
                  Text(
                    AppStrings.noHabits,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textDisabled,
                    ),
                  ),
                  const SizedBox(height: AppSizes.paddingSM),
                  Text(
                    AppStrings.createFirst,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: habitProvider.loadHabits,
            child: ListView.builder(
              padding: const EdgeInsets.all(AppSizes.paddingMD),
              itemCount: habits.length,
              itemBuilder: (context, index) {
                final habit = habits[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSizes.paddingSM),
                  child: HabitCard(habit: habit),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddHabitDialog(context),
        child: const FaIcon(FontAwesomeIcons.plus),
      ),
    );
  }

  void _showAddHabitDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const AddHabitSheet(),
    );
  }
}

class AddHabitSheet extends StatefulWidget {
  const AddHabitSheet({super.key});

  @override
  State<AddHabitSheet> createState() => _AddHabitSheetState();
}

class _AddHabitSheetState extends State<AddHabitSheet> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  HabitFrequency _selectedFrequency = HabitFrequency.daily;
  String _selectedIcon = '✓';
  int _selectedColor = 0xFF2196F3;

  final List<String> _icons = ['✓', '💪', '🏃', '📚', '💧', '🧘', '🥗', '😴'];
  final List<int> _colors = [
    0xFF2196F3, // Blue
    0xFF4CAF50, // Green
    0xFFFF9800, // Orange
    0xFF9C27B0, // Purple
    0xFFE91E63, // Pink
    0xFF00BCD4, // Cyan
    0xFFFF5722, // Deep Orange
    0xFF607D8B, // Blue Grey
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: AppSizes.paddingMD,
        right: AppSizes.paddingMD,
        top: AppSizes.paddingMD,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSizes.paddingMD,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                AppStrings.newHabit,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const FaIcon(FontAwesomeIcons.xmark),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.paddingMD),

          // Name input
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: AppStrings.habitName,
              hintText: 'Enter habit name',
            ),
            autofocus: true,
          ),
          const SizedBox(height: AppSizes.paddingMD),

          // Frequency
          DropdownButtonFormField<HabitFrequency>(
            value: _selectedFrequency,
            decoration: const InputDecoration(labelText: 'Frequency'),
            onChanged: (HabitFrequency? value) {
              if (value != null) {
                setState(() {
                  _selectedFrequency = value;
                });
              }
            },
            items: HabitFrequency.values.map((frequency) {
              return DropdownMenuItem<HabitFrequency>(
                value: frequency,
                child: Text(_getFrequencyText(frequency)),
              );
            }).toList(),
          ),
          const SizedBox(height: AppSizes.paddingMD),

          // Icon selection
          Text('Icon', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: AppSizes.paddingSM),
          Wrap(
            spacing: AppSizes.paddingSM,
            children: _icons.map((icon) {
              final isSelected = icon == _selectedIcon;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedIcon = icon;
                  });
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withOpacity(0.1)
                        : AppColors.surface,
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.border,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(AppSizes.radiusSM),
                  ),
                  child: Center(
                    child: Text(icon, style: const TextStyle(fontSize: 20)),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: AppSizes.paddingMD),

          // Color selection
          Text('Color', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: AppSizes.paddingSM),
          Wrap(
            spacing: AppSizes.paddingSM,
            children: _colors.map((color) {
              final isSelected = color == _selectedColor;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedColor = color;
                  });
                },
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Color(color),
                    shape: BoxShape.circle,
                    border: isSelected
                        ? Border.all(color: AppColors.textPrimary, width: 3)
                        : null,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: AppSizes.paddingMD),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(AppStrings.cancel),
                ),
              ),
              const SizedBox(width: AppSizes.paddingSM),
              Expanded(
                child: ElevatedButton(
                  onPressed: _nameController.text.trim().isEmpty
                      ? null
                      : () => _createHabit(context),
                  child: const Text(AppStrings.save),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getFrequencyText(HabitFrequency frequency) {
    switch (frequency) {
      case HabitFrequency.daily:
        return 'Daily';
      case HabitFrequency.weekly:
        return 'Weekly';
      case HabitFrequency.monthly:
        return 'Monthly';
    }
  }

  void _createHabit(BuildContext context) {
    final habit = Habit(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      frequency: _selectedFrequency,
      createdAt: DateTime.now(),
      icon: _selectedIcon,
      color: _selectedColor,
    );

    context.read<HabitProvider>().addHabit(habit);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
