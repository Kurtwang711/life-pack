import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF6366F1);
  static const Color primaryDark = Color(0xFF4F46E5);
  static const Color secondary = Color(0xFF10B981);
  static const Color accent = Color(0xFFF59E0B);

  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Colors.white;
  static const Color error = Color(0xFFEF4444);

  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textDisabled = Color(0xFF9CA3AF);

  static const Color border = Color(0xFFE5E7EB);
  static const Color divider = Color(0xFFF3F4F6);

  // Priority colors
  static const Color priorityHigh = Color(0xFFEF4444);
  static const Color priorityMedium = Color(0xFFF59E0B);
  static const Color priorityLow = Color(0xFF10B981);

  // Status colors
  static const Color statusCompleted = Color(0xFF10B981);
  static const Color statusInProgress = Color(0xFF3B82F6);
  static const Color statusPending = Color(0xFF6B7280);
}

class AppSizes {
  // Padding
  static const double paddingXS = 4.0;
  static const double paddingSM = 8.0;
  static const double paddingMD = 16.0;
  static const double paddingLG = 24.0;
  static const double paddingXL = 32.0;

  // Border radius
  static const double radiusSM = 6.0;
  static const double radiusMD = 12.0;
  static const double radiusLG = 16.0;

  // Icon sizes
  static const double iconSM = 16.0;
  static const double iconMD = 24.0;
  static const double iconLG = 32.0;

  // Button heights
  static const double buttonHeight = 48.0;
  static const double buttonHeightSM = 36.0;
}

class AppStrings {
  // App
  static const String appName = 'Lifepack';
  static const String appTagline = 'Organize your life, achieve your goals';

  // Navigation
  static const String home = 'Home';
  static const String tasks = 'Tasks';
  static const String habits = 'Habits';
  static const String notes = 'Notes';
  static const String profile = 'Profile';

  // Actions
  static const String add = 'Add';
  static const String edit = 'Edit';
  static const String delete = 'Delete';
  static const String save = 'Save';
  static const String cancel = 'Cancel';
  static const String done = 'Done';

  // Tasks
  static const String newTask = 'New Task';
  static const String taskTitle = 'Task Title';
  static const String taskDescription = 'Task Description';
  static const String dueDate = 'Due Date';
  static const String priority = 'Priority';
  static const String highPriority = 'High';
  static const String mediumPriority = 'Medium';
  static const String lowPriority = 'Low';

  // Habits
  static const String newHabit = 'New Habit';
  static const String habitName = 'Habit Name';
  static const String dailyGoal = 'Daily Goal';
  static const String streak = 'Streak';

  // Notes
  static const String newNote = 'New Note';
  static const String noteTitle = 'Note Title';
  static const String noteContent = 'Note Content';

  // Empty states
  static const String noTasks = 'No tasks yet';
  static const String noHabits = 'No habits tracked yet';
  static const String noNotes = 'No notes created yet';
  static const String createFirst = 'Create your first one!';
}

class AppAssets {
  static const String _images = 'assets/images/';
  static const String _icons = 'assets/icons/';

  // Images
  static const String logo = '${_images}logo.png';
  static const String onboarding1 = '${_images}onboarding_1.png';
  static const String onboarding2 = '${_images}onboarding_2.png';
  static const String onboarding3 = '${_images}onboarding_3.png';

  // Icons
  static const String taskIcon = '${_icons}task.png';
  static const String habitIcon = '${_icons}habit.png';
  static const String noteIcon = '${_icons}note.png';
}
