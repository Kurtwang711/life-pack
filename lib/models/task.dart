enum Priority { low, medium, high }

enum TaskStatus { pending, inProgress, completed }

class Task {
  final String id;
  final String title;
  final String description;
  final Priority priority;
  final TaskStatus status;
  final DateTime createdAt;
  final DateTime? dueDate;
  final List<String> tags;
  final bool isImportant;

  Task({
    required this.id,
    required this.title,
    this.description = '',
    this.priority = Priority.medium,
    this.status = TaskStatus.pending,
    required this.createdAt,
    this.dueDate,
    this.tags = const [],
    this.isImportant = false,
  });

  Task copyWith({
    String? id,
    String? title,
    String? description,
    Priority? priority,
    TaskStatus? status,
    DateTime? createdAt,
    DateTime? dueDate,
    List<String>? tags,
    bool? isImportant,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
      tags: tags ?? this.tags,
      isImportant: isImportant ?? this.isImportant,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'priority': priority.index,
      'status': status.index,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'dueDate': dueDate?.millisecondsSinceEpoch,
      'tags': tags,
      'isImportant': isImportant,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      priority: Priority.values[map['priority'] ?? 1],
      status: TaskStatus.values[map['status'] ?? 0],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      dueDate: map['dueDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['dueDate'])
          : null,
      tags: List<String>.from(map['tags'] ?? []),
      isImportant: map['isImportant'] ?? false,
    );
  }

  @override
  String toString() {
    return 'Task(id: $id, title: $title, priority: $priority, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Task && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
