import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';
import '../models/habit.dart';
import '../models/note.dart';

class StorageService {
  static const String _tasksKey = 'tasks';
  static const String _habitsKey = 'habits';
  static const String _notesKey = 'notes';

  // Task operations
  Future<List<Task>> getTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tasksJson = prefs.getString(_tasksKey);
      if (tasksJson == null) return [];

      final List<dynamic> tasksList = jsonDecode(tasksJson);
      return tasksList.map((taskMap) => Task.fromMap(taskMap)).toList();
    } catch (e) {
      throw Exception('Failed to load tasks: $e');
    }
  }

  Future<void> saveTask(Task task) async {
    try {
      final tasks = await getTasks();
      final existingIndex = tasks.indexWhere((t) => t.id == task.id);

      if (existingIndex != -1) {
        tasks[existingIndex] = task;
      } else {
        tasks.add(task);
      }

      await _saveTasks(tasks);
    } catch (e) {
      throw Exception('Failed to save task: $e');
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      final tasks = await getTasks();
      tasks.removeWhere((task) => task.id == taskId);
      await _saveTasks(tasks);
    } catch (e) {
      throw Exception('Failed to delete task: $e');
    }
  }

  Future<void> _saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = jsonEncode(tasks.map((task) => task.toMap()).toList());
    await prefs.setString(_tasksKey, tasksJson);
  }

  // Habit operations
  Future<List<Habit>> getHabits() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final habitsJson = prefs.getString(_habitsKey);
      if (habitsJson == null) return [];

      final List<dynamic> habitsList = jsonDecode(habitsJson);
      return habitsList.map((habitMap) => Habit.fromMap(habitMap)).toList();
    } catch (e) {
      throw Exception('Failed to load habits: $e');
    }
  }

  Future<void> saveHabit(Habit habit) async {
    try {
      final habits = await getHabits();
      final existingIndex = habits.indexWhere((h) => h.id == habit.id);

      if (existingIndex != -1) {
        habits[existingIndex] = habit;
      } else {
        habits.add(habit);
      }

      await _saveHabits(habits);
    } catch (e) {
      throw Exception('Failed to save habit: $e');
    }
  }

  Future<void> deleteHabit(String habitId) async {
    try {
      final habits = await getHabits();
      habits.removeWhere((habit) => habit.id == habitId);
      await _saveHabits(habits);
    } catch (e) {
      throw Exception('Failed to delete habit: $e');
    }
  }

  Future<void> _saveHabits(List<Habit> habits) async {
    final prefs = await SharedPreferences.getInstance();
    final habitsJson = jsonEncode(
      habits.map((habit) => habit.toMap()).toList(),
    );
    await prefs.setString(_habitsKey, habitsJson);
  }

  // Note operations
  Future<List<Note>> getNotes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notesJson = prefs.getString(_notesKey);
      if (notesJson == null) return [];

      final List<dynamic> notesList = jsonDecode(notesJson);
      return notesList.map((noteMap) => Note.fromMap(noteMap)).toList();
    } catch (e) {
      throw Exception('Failed to load notes: $e');
    }
  }

  Future<void> saveNote(Note note) async {
    try {
      final notes = await getNotes();
      final existingIndex = notes.indexWhere((n) => n.id == note.id);

      if (existingIndex != -1) {
        notes[existingIndex] = note;
      } else {
        notes.add(note);
      }

      await _saveNotes(notes);
    } catch (e) {
      throw Exception('Failed to save note: $e');
    }
  }

  Future<void> deleteNote(String noteId) async {
    try {
      final notes = await getNotes();
      notes.removeWhere((note) => note.id == noteId);
      await _saveNotes(notes);
    } catch (e) {
      throw Exception('Failed to delete note: $e');
    }
  }

  Future<void> _saveNotes(List<Note> notes) async {
    final prefs = await SharedPreferences.getInstance();
    final notesJson = jsonEncode(notes.map((note) => note.toMap()).toList());
    await prefs.setString(_notesKey, notesJson);
  }

  // Clear all data
  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tasksKey);
    await prefs.remove(_habitsKey);
    await prefs.remove(_notesKey);
  }
}
