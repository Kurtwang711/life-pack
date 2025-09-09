enum NoteType { text, checklist, voice, image }

class Note {
  final String id;
  final String title;
  final String content;
  final NoteType type;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> tags;
  final bool isPinned;
  final bool isArchived;
  final String? imagePath;

  Note({
    required this.id,
    required this.title,
    required this.content,
    this.type = NoteType.text,
    required this.createdAt,
    required this.updatedAt,
    this.tags = const [],
    this.isPinned = false,
    this.isArchived = false,
    this.imagePath,
  });

  Note copyWith({
    String? id,
    String? title,
    String? content,
    NoteType? type,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? tags,
    bool? isPinned,
    bool? isArchived,
    String? imagePath,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      tags: tags ?? this.tags,
      isPinned: isPinned ?? this.isPinned,
      isArchived: isArchived ?? this.isArchived,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'type': type.index,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'tags': tags,
      'isPinned': isPinned,
      'isArchived': isArchived,
      'imagePath': imagePath,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      type: NoteType.values[map['type'] ?? 0],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt']),
      tags: List<String>.from(map['tags'] ?? []),
      isPinned: map['isPinned'] ?? false,
      isArchived: map['isArchived'] ?? false,
      imagePath: map['imagePath'],
    );
  }

  @override
  String toString() {
    return 'Note(id: $id, title: $title, type: $type, isPinned: $isPinned)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Note && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
