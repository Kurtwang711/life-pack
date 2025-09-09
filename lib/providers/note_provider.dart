import 'package:flutter/material.dart';
import '../models/note.dart';
import '../services/storage_service.dart';

class NoteProvider with ChangeNotifier {
  final StorageService _storageService = StorageService();
  List<Note> _notes = [];
  bool _isLoading = false;
  String? _error;

  List<Note> get notes => _notes;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Filtered notes
  List<Note> get pinnedNotes =>
      _notes.where((note) => note.isPinned && !note.isArchived).toList();
  List<Note> get regularNotes =>
      _notes.where((note) => !note.isPinned && !note.isArchived).toList();
  List<Note> get archivedNotes =>
      _notes.where((note) => note.isArchived).toList();
  List<Note> get activeNotes =>
      _notes.where((note) => !note.isArchived).toList();

  // Notes by type
  List<Note> get textNotes =>
      _notes.where((note) => note.type == NoteType.text).toList();
  List<Note> get checklistNotes =>
      _notes.where((note) => note.type == NoteType.checklist).toList();
  List<Note> get voiceNotes =>
      _notes.where((note) => note.type == NoteType.voice).toList();
  List<Note> get imageNotes =>
      _notes.where((note) => note.type == NoteType.image).toList();

  // Statistics
  int get totalNotes => _notes.length;
  int get activeNotesCount => activeNotes.length;
  int get archivedNotesCount => archivedNotes.length;
  int get pinnedNotesCount => pinnedNotes.length;

  NoteProvider() {
    loadNotes();
  }

  Future<void> loadNotes() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _notes = await _storageService.getNotes();

      // Load sample data if no notes exist
      if (_notes.isEmpty) {
        await _loadSampleData();
      }

      // Sort notes: pinned first, then by updated date
      _notes.sort((a, b) {
        if (a.isPinned && !b.isPinned) return -1;
        if (!a.isPinned && b.isPinned) return 1;
        return b.updatedAt.compareTo(a.updatedAt);
      });
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
    final sampleNotes = [
      Note(
        id: '1',
        title: 'Welcome to Lifepack Notes! 📝',
        content:
            'This is your first note. You can:\n\n• Create new notes\n• Pin important ones\n• Add tags for organization\n• Edit and delete as needed\n\nTry creating your own note!',
        createdAt: now.subtract(const Duration(hours: 2)),
        updatedAt: now.subtract(const Duration(hours: 1)),
        tags: ['Welcome', 'Tutorial'],
        isPinned: true,
      ),
      Note(
        id: '2',
        title: 'Quick Ideas',
        content:
            'Jot down your thoughts and ideas here. This is a great place for brainstorming!',
        createdAt: now.subtract(const Duration(minutes: 30)),
        updatedAt: now.subtract(const Duration(minutes: 30)),
        tags: ['Ideas'],
        isPinned: false,
      ),
    ];

    for (final note in sampleNotes) {
      await _storageService.saveNote(note);
    }

    _notes = sampleNotes;
  }

  Future<void> addNote(Note note) async {
    try {
      await _storageService.saveNote(note);
      _notes.insert(0, note); // Add to beginning of list
      _sortNotes();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateNote(Note note) async {
    try {
      final updatedNote = note.copyWith(updatedAt: DateTime.now());
      await _storageService.saveNote(updatedNote);
      final index = _notes.indexWhere((n) => n.id == note.id);
      if (index != -1) {
        _notes[index] = updatedNote;
        _sortNotes();
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteNote(String noteId) async {
    try {
      await _storageService.deleteNote(noteId);
      _notes.removeWhere((note) => note.id == noteId);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> toggleNotePinned(Note note) async {
    final updatedNote = note.copyWith(
      isPinned: !note.isPinned,
      updatedAt: DateTime.now(),
    );
    await updateNote(updatedNote);
  }

  Future<void> toggleNoteArchived(Note note) async {
    final updatedNote = note.copyWith(
      isArchived: !note.isArchived,
      updatedAt: DateTime.now(),
    );
    await updateNote(updatedNote);
  }

  Future<void> duplicateNote(Note note) async {
    final newNote = Note(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: '${note.title} (Copy)',
      content: note.content,
      type: note.type,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      tags: List.from(note.tags),
      isPinned: false,
      isArchived: false,
      imagePath: note.imagePath,
    );
    await addNote(newNote);
  }

  List<Note> searchNotes(String query) {
    if (query.isEmpty) return activeNotes;

    final lowercaseQuery = query.toLowerCase();
    return activeNotes
        .where(
          (note) =>
              note.title.toLowerCase().contains(lowercaseQuery) ||
              note.content.toLowerCase().contains(lowercaseQuery) ||
              note.tags.any(
                (tag) => tag.toLowerCase().contains(lowercaseQuery),
              ),
        )
        .toList();
  }

  List<Note> getNotesByTag(String tag) {
    return _notes
        .where((note) => note.tags.contains(tag) && !note.isArchived)
        .toList();
  }

  List<Note> getNotesByType(NoteType type) {
    return _notes
        .where((note) => note.type == type && !note.isArchived)
        .toList();
  }

  List<String> getAllTags() {
    final tags = <String>{};
    for (final note in activeNotes) {
      tags.addAll(note.tags);
    }
    return tags.toList()..sort();
  }

  void _sortNotes() {
    _notes.sort((a, b) {
      if (a.isPinned && !b.isPinned) return -1;
      if (!a.isPinned && b.isPinned) return 1;
      return b.updatedAt.compareTo(a.updatedAt);
    });
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
