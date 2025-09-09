import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/storage_service.dart';

class TaskProvider with ChangeNotifier {
  final StorageService _storageService = StorageService();
  List<Task> _tasks = [];
  bool _isLoading = false;
  String? _error;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Filtered tasks
  List<Task> get pendingTasks =>
      _tasks.where((task) => task.status == TaskStatus.pending).toList();
  List<Task> get inProgressTasks =>
      _tasks.where((task) => task.status == TaskStatus.inProgress).toList();
  List<Task> get completedTasks =>
      _tasks.where((task) => task.status == TaskStatus.completed).toList();
  List<Task> get importantTasks =>
      _tasks.where((task) => task.isImportant).toList();
  List<Task> get todayTasks => _tasks.where((task) {
    if (task.dueDate == null) return false;
    final today = DateTime.now();
    final dueDate = task.dueDate!;
    return dueDate.year == today.year &&
        dueDate.month == today.month &&
        dueDate.day == today.day;
  }).toList();

  // Statistics
  int get totalTasks => _tasks.length;
  int get completedTasksCount => completedTasks.length;
  int get pendingTasksCount => pendingTasks.length;
  double get completionRate =>
      totalTasks > 0 ? completedTasksCount / totalTasks : 0.0;

  TaskProvider() {
    loadTasks();
  }

  Future<void> loadTasks() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _tasks = await _storageService.getTasks();

      // Load sample data if no tasks exist
      if (_tasks.isEmpty) {
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
    final sampleTasks = [
      Task(
        id: '1',
        title: 'Welcome to Lifepack! 🎉',
        description:
            'This is a sample task. You can edit, complete, or delete it.',
        priority: Priority.high,
        status: TaskStatus.pending,
        createdAt: DateTime.now(),
        dueDate: DateTime.now().add(const Duration(days: 1)),
        tags: ['Welcome', 'Sample'],
        isImportant: true,
      ),
      Task(
        id: '2',
        title: 'Try creating a new task',
        description: 'Tap the + button to create your first task',
        priority: Priority.medium,
        status: TaskStatus.pending,
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        dueDate: DateTime.now().add(const Duration(hours: 8)),
        tags: ['Tutorial'],
        isImportant: false,
      ),
    ];

    for (final task in sampleTasks) {
      await _storageService.saveTask(task);
    }

    _tasks = sampleTasks;
  }

  Future<void> addTask(Task task) async {
    try {
      await _storageService.saveTask(task);
      _tasks.add(task);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateTask(Task task) async {
    try {
      await _storageService.saveTask(task);
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] = task;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await _storageService.deleteTask(taskId);
      _tasks.removeWhere((task) => task.id == taskId);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> toggleTaskStatus(Task task) async {
    TaskStatus newStatus;
    switch (task.status) {
      case TaskStatus.pending:
        newStatus = TaskStatus.inProgress;
        break;
      case TaskStatus.inProgress:
        newStatus = TaskStatus.completed;
        break;
      case TaskStatus.completed:
        newStatus = TaskStatus.pending;
        break;
    }

    final updatedTask = task.copyWith(status: newStatus);
    await updateTask(updatedTask);
  }

  Future<void> toggleTaskImportance(Task task) async {
    final updatedTask = task.copyWith(isImportant: !task.isImportant);
    await updateTask(updatedTask);
  }

  List<Task> getTasksByTag(String tag) {
    return _tasks.where((task) => task.tags.contains(tag)).toList();
  }

  List<Task> getTasksByPriority(Priority priority) {
    return _tasks.where((task) => task.priority == priority).toList();
  }

  List<String> getAllTags() {
    final tags = <String>{};
    for (final task in _tasks) {
      tags.addAll(task.tags);
    }
    return tags.toList()..sort();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
