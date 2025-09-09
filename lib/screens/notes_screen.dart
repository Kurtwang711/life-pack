import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../constants/app_constants.dart';
import '../providers/note_provider.dart';
import '../models/note.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Notes'),
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.magnifyingGlass),
            onPressed: () {
              // TODO: Implement search
            },
          ),
        ],
      ),
      body: Consumer<NoteProvider>(
        builder: (context, noteProvider, child) {
          if (noteProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final notes = noteProvider.activeNotes;

          if (notes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const FaIcon(
                    FontAwesomeIcons.noteSticky,
                    color: AppColors.textDisabled,
                    size: 48,
                  ),
                  const SizedBox(height: AppSizes.paddingMD),
                  Text(
                    AppStrings.noNotes,
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
            onRefresh: noteProvider.loadNotes,
            child: ListView.builder(
              padding: const EdgeInsets.all(AppSizes.paddingMD),
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSizes.paddingSM),
                  child: _NoteCard(
                    note: note,
                    onTap: () => _editNote(context, note),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createNote(context),
        child: const FaIcon(FontAwesomeIcons.plus),
      ),
    );
  }

  void _createNote(BuildContext context) {
    final note = Note(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: '',
      content: '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _editNote(context, note, isNew: true);
  }

  void _editNote(BuildContext context, Note note, {bool isNew = false}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditNoteScreen(note: note, isNew: isNew),
      ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback? onTap;

  const _NoteCard({required this.note, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSizes.radiusMD),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingMD),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      note.title.isNotEmpty ? note.title : 'Untitled',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: note.title.isEmpty
                            ? AppColors.textSecondary
                            : AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (note.isPinned)
                    const FaIcon(
                      FontAwesomeIcons.thumbtack,
                      color: AppColors.accent,
                      size: 16,
                    ),
                ],
              ),
              if (note.content.isNotEmpty) ...[
                const SizedBox(height: AppSizes.paddingSM),
                Text(
                  note.content,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              if (note.tags.isNotEmpty) ...[
                const SizedBox(height: AppSizes.paddingSM),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: note.tags
                      .take(3)
                      .map(
                        (tag) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(
                              AppSizes.radiusSM,
                            ),
                          ),
                          child: Text(
                            tag,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: AppColors.primary,
                                  fontSize: 11,
                                ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
              const SizedBox(height: AppSizes.paddingSM),
              Text(
                _formatDate(note.updatedAt),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textDisabled,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final noteDate = DateTime(date.year, date.month, date.day);

    if (noteDate.isAtSameMomentAs(today)) {
      return 'Today ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (noteDate.isAtSameMomentAs(
      today.subtract(const Duration(days: 1)),
    )) {
      return 'Yesterday';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

class EditNoteScreen extends StatefulWidget {
  final Note note;
  final bool isNew;

  const EditNoteScreen({super.key, required this.note, this.isNew = false});

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late bool _isPinned;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note.title);
    _contentController = TextEditingController(text: widget.note.content);
    _isPinned = widget.note.isPinned;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isNew ? 'New Note' : 'Edit Note'),
        actions: [
          IconButton(
            icon: FaIcon(
              FontAwesomeIcons.thumbtack,
              color: _isPinned ? AppColors.accent : AppColors.textSecondary,
            ),
            onPressed: () {
              setState(() {
                _isPinned = !_isPinned;
              });
            },
          ),
          TextButton(onPressed: _saveNote, child: const Text('Save')),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMD),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'Enter note title',
                border: InputBorder.none,
              ),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const Divider(),
            Expanded(
              child: TextField(
                controller: _contentController,
                decoration: const InputDecoration(
                  hintText: 'Start typing...',
                  border: InputBorder.none,
                ),
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveNote() {
    final updatedNote = widget.note.copyWith(
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      isPinned: _isPinned,
      updatedAt: DateTime.now(),
    );

    if (widget.isNew) {
      context.read<NoteProvider>().addNote(updatedNote);
    } else {
      context.read<NoteProvider>().updateNote(updatedNote);
    }

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}
