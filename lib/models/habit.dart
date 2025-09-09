enum HabitFrequency { daily, weekly, monthly }

enum HabitStatus { active, paused, archived }

class Habit {
  final String id;
  final String name;
  final String description;
  final HabitFrequency frequency;
  final HabitStatus status;
  final DateTime createdAt;
  final List<DateTime> completedDates;
  final int streak;
  final String icon;
  final int color; // Color value as integer

  Habit({
    required this.id,
    required this.name,
    this.description = '',
    this.frequency = HabitFrequency.daily,
    this.status = HabitStatus.active,
    required this.createdAt,
    this.completedDates = const [],
    this.streak = 0,
    this.icon = '✓',
    this.color = 0xFF2196F3, // Default blue
  });

  Habit copyWith({
    String? id,
    String? name,
    String? description,
    HabitFrequency? frequency,
    HabitStatus? status,
    DateTime? createdAt,
    List<DateTime>? completedDates,
    int? streak,
    String? icon,
    int? color,
  }) {
    return Habit(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      frequency: frequency ?? this.frequency,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      completedDates: completedDates ?? this.completedDates,
      streak: streak ?? this.streak,
      icon: icon ?? this.icon,
      color: color ?? this.color,
    );
  }

  bool isCompletedToday() {
    final today = DateTime.now();
    return completedDates.any(
      (date) =>
          date.year == today.year &&
          date.month == today.month &&
          date.day == today.day,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'frequency': frequency.index,
      'status': status.index,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'completedDates': completedDates
          .map((date) => date.millisecondsSinceEpoch)
          .toList(),
      'streak': streak,
      'icon': icon,
      'color': color,
    };
  }

  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      frequency: HabitFrequency.values[map['frequency'] ?? 0],
      status: HabitStatus.values[map['status'] ?? 0],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      completedDates:
          (map['completedDates'] as List<dynamic>?)
              ?.map(
                (timestamp) => DateTime.fromMillisecondsSinceEpoch(timestamp),
              )
              .toList() ??
          [],
      streak: map['streak'] ?? 0,
      icon: map['icon'] ?? '✓',
      color: map['color'] ?? 0xFF2196F3,
    );
  }

  @override
  String toString() {
    return 'Habit(id: $id, name: $name, frequency: $frequency, streak: $streak)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Habit && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
