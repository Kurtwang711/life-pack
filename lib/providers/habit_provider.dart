import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../services/storage_service.dart';

class HabitProvider with ChangeNotifier {
  final StorageService _storageService = StorageService();
  List<Habit> _habits = [];
  bool _isLoading = false;
  String? _error;

  List<Habit> get habits => _habits;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Filtered habits
  List<Habit> get activeHabits =>
      _habits.where((habit) => habit.status == HabitStatus.active).toList();
  List<Habit> get pausedHabits =>
      _habits.where((habit) => habit.status == HabitStatus.paused).toList();
  List<Habit> get archivedHabits =>
      _habits.where((habit) => habit.status == HabitStatus.archived).toList();
  List<Habit> get dailyHabits => _habits
      .where((habit) => habit.frequency == HabitFrequency.daily)
      .toList();

  // Statistics
  int get totalHabits => _habits.length;
  int get activeHabitsCount => activeHabits.length;
  int get completedTodayCount =>
      _habits.where((habit) => habit.isCompletedToday()).length;
  double get todayCompletionRate =>
      activeHabitsCount > 0 ? completedTodayCount / activeHabitsCount : 0.0;

  HabitProvider() {
    loadHabits();
  }

  Future<void> loadHabits() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _habits = await _storageService.getHabits();

      // Load sample data if no habits exist
      if (_habits.isEmpty) {
        await _loadSampleData();
      }

      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadSampleData() async {
    final now = DateTime.now();
    final sampleHabits = [
      Habit(
        id: '1',
        name: 'Morning Exercise',
        description: '15 minutes of daily exercise',
        frequency: HabitFrequency.daily,
        createdAt: now.subtract(const Duration(days: 3)),
        completedDates: [
          now.subtract(const Duration(days: 1)),
          now.subtract(const Duration(days: 2)),
        ],
        streak: 2,
        icon: '💪',
        color: 0xFF4CAF50,
      ),
      Habit(
        id: '2',
        name: 'Read Daily',
        description: 'Read for 20 minutes each day',
        frequency: HabitFrequency.daily,
        createdAt: now.subtract(const Duration(days: 5)),
        completedDates: [now.subtract(const Duration(days: 1))],
        streak: 1,
        icon: '📚',
        color: 0xFF2196F3,
      ),
    ];

    for (final habit in sampleHabits) {
      await _storageService.saveHabit(habit);
    }

    _habits = sampleHabits;
  }

  Future<void> addHabit(Habit habit) async {
    try {
      await _storageService.saveHabit(habit);
      _habits.add(habit);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateHabit(Habit habit) async {
    try {
      await _storageService.saveHabit(habit);
      final index = _habits.indexWhere((h) => h.id == habit.id);
      if (index != -1) {
        _habits[index] = habit;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteHabit(String habitId) async {
    try {
      await _storageService.deleteHabit(habitId);
      _habits.removeWhere((habit) => habit.id == habitId);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> completeHabitToday(Habit habit) async {
    if (habit.isCompletedToday()) return;

    final today = DateTime.now();
    final newCompletedDates = List<DateTime>.from(habit.completedDates)
      ..add(today);

    // Calculate new streak
    int newStreak = 1;
    final sortedDates = newCompletedDates.toList()
      ..sort((a, b) => b.compareTo(a));

    for (int i = 1; i < sortedDates.length; i++) {
      final current = sortedDates[i];
      final previous = sortedDates[i - 1];

      if (previous.difference(current).inDays == 1) {
        newStreak++;
      } else {
        break;
      }
    }

    final updatedHabit = habit.copyWith(
      completedDates: newCompletedDates,
      streak: newStreak,
    );

    await updateHabit(updatedHabit);
  }

  Future<void> uncompleteHabitToday(Habit habit) async {
    if (!habit.isCompletedToday()) return;

    final today = DateTime.now();
    final newCompletedDates = habit.completedDates
        .where(
          (date) =>
              !(date.year == today.year &&
                  date.month == today.month &&
                  date.day == today.day),
        )
        .toList();

    // Recalculate streak
    int newStreak = 0;
    if (newCompletedDates.isNotEmpty) {
      final sortedDates = newCompletedDates.toList()
        ..sort((a, b) => b.compareTo(a));
      newStreak = 1;

      for (int i = 1; i < sortedDates.length; i++) {
        final current = sortedDates[i];
        final previous = sortedDates[i - 1];

        if (previous.difference(current).inDays == 1) {
          newStreak++;
        } else {
          break;
        }
      }
    }

    final updatedHabit = habit.copyWith(
      completedDates: newCompletedDates,
      streak: newStreak,
    );

    await updateHabit(updatedHabit);
  }

  Future<void> toggleHabitStatus(Habit habit) async {
    HabitStatus newStatus;
    switch (habit.status) {
      case HabitStatus.active:
        newStatus = HabitStatus.paused;
        break;
      case HabitStatus.paused:
        newStatus = HabitStatus.active;
        break;
      case HabitStatus.archived:
        newStatus = HabitStatus.active;
        break;
    }

    final updatedHabit = habit.copyWith(status: newStatus);
    await updateHabit(updatedHabit);
  }

  int getHabitCompletionCount(
    Habit habit,
    DateTime startDate,
    DateTime endDate,
  ) {
    return habit.completedDates
        .where(
          (date) =>
              date.isAfter(startDate.subtract(const Duration(days: 1))) &&
              date.isBefore(endDate.add(const Duration(days: 1))),
        )
        .length;
  }

  double getHabitCompletionRate(Habit habit, int days) {
    final endDate = DateTime.now();
    final startDate = endDate.subtract(Duration(days: days - 1));
    final completionCount = getHabitCompletionCount(habit, startDate, endDate);
    return completionCount / days;
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
