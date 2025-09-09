import '../models/task.dart';
import '../models/habit.dart';
import '../models/note.dart';

class SampleDataService {
  static List<Task> getSampleTasks() {
    final now = DateTime.now();
    return [
      Task(
        id: '1',
        title: 'Complete Flutter project',
        description: 'Build the Lifepack mobile app with all core features',
        priority: Priority.high,
        status: TaskStatus.inProgress,
        createdAt: now.subtract(const Duration(days: 2)),
        dueDate: now.add(const Duration(days: 1)),
        tags: ['Flutter', 'Development'],
        isImportant: true,
      ),
      Task(
        id: '2',
        title: 'Review design mockups',
        description: 'Go through the UI/UX designs for the new features',
        priority: Priority.medium,
        status: TaskStatus.pending,
        createdAt: now.subtract(const Duration(hours: 3)),
        dueDate: now,
        tags: ['Design', 'Review'],
        isImportant: false,
      ),
      Task(
        id: '3',
        title: 'Team meeting preparation',
        description: 'Prepare slides and agenda for tomorrow\'s team sync',
        priority: Priority.medium,
        status: TaskStatus.pending,
        createdAt: now.subtract(const Duration(hours: 1)),
        dueDate: now.add(const Duration(hours: 8)),
        tags: ['Meeting', 'Work'],
        isImportant: true,
      ),
      Task(
        id: '4',
        title: 'Grocery shopping',
        description: 'Buy ingredients for weekend cooking',
        priority: Priority.low,
        status: TaskStatus.completed,
        createdAt: now.subtract(const Duration(days: 1)),
        dueDate: now.subtract(const Duration(hours: 2)),
        tags: ['Personal', 'Shopping'],
        isImportant: false,
      ),
      Task(
        id: '5',
        title: 'Read Flutter documentation',
        description:
            'Study the latest Flutter 3.10+ features and best practices',
        priority: Priority.medium,
        status: TaskStatus.pending,
        createdAt: now.subtract(const Duration(minutes: 30)),
        dueDate: now.add(const Duration(days: 3)),
        tags: ['Learning', 'Flutter'],
        isImportant: false,
      ),
    ];
  }

  static List<Habit> getSampleHabits() {
    final now = DateTime.now();
    return [
      Habit(
        id: '1',
        name: 'Morning Exercise',
        description: '30 minutes of workout every morning',
        frequency: HabitFrequency.daily,
        createdAt: now.subtract(const Duration(days: 10)),
        completedDates: [
          now.subtract(const Duration(days: 1)),
          now.subtract(const Duration(days: 2)),
          now.subtract(const Duration(days: 4)),
          now.subtract(const Duration(days: 5)),
        ],
        streak: 2,
        icon: '💪',
        color: 0xFF4CAF50,
      ),
      Habit(
        id: '2',
        name: 'Read Books',
        description: 'Read for at least 20 minutes daily',
        frequency: HabitFrequency.daily,
        createdAt: now.subtract(const Duration(days: 15)),
        completedDates: [
          now.subtract(const Duration(days: 1)),
          now.subtract(const Duration(days: 3)),
          now.subtract(const Duration(days: 6)),
        ],
        streak: 1,
        icon: '📚',
        color: 0xFF2196F3,
      ),
      Habit(
        id: '3',
        name: 'Meditation',
        description: '10 minutes of mindfulness practice',
        frequency: HabitFrequency.daily,
        createdAt: now.subtract(const Duration(days: 7)),
        completedDates: [
          now.subtract(const Duration(days: 1)),
          now.subtract(const Duration(days: 2)),
          now.subtract(const Duration(days: 3)),
        ],
        streak: 3,
        icon: '🧘',
        color: 0xFF9C27B0,
      ),
      Habit(
        id: '4',
        name: 'Drink Water',
        description: 'Drink 8 glasses of water daily',
        frequency: HabitFrequency.daily,
        createdAt: now.subtract(const Duration(days: 5)),
        completedDates: [now.subtract(const Duration(days: 1))],
        streak: 1,
        icon: '💧',
        color: 0xFF00BCD4,
      ),
    ];
  }

  static List<Note> getSampleNotes() {
    final now = DateTime.now();
    return [
      Note(
        id: '1',
        title: 'Project Ideas',
        content:
            'List of mobile app ideas:\n• Habit tracker with AI insights\n• Personal finance manager\n• Recipe organizer with shopping lists\n• Language learning companion',
        createdAt: now.subtract(const Duration(days: 3)),
        updatedAt: now.subtract(const Duration(hours: 2)),
        tags: ['Ideas', 'Projects'],
        isPinned: true,
      ),
      Note(
        id: '2',
        title: 'Meeting Notes - Dec 8',
        content:
            'Team sync discussion points:\n\n• Sprint review went well\n• Need to focus on performance optimization\n• New features planned for next quarter\n• Code review process improvements',
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now.subtract(const Duration(hours: 5)),
        tags: ['Meeting', 'Work'],
        isPinned: false,
      ),
      Note(
        id: '3',
        title: 'Flutter Learning Path',
        content:
            'Topics to master:\n1. State Management (Provider, Riverpod, Bloc)\n2. Custom Animations\n3. Performance Optimization\n4. Testing Strategies\n5. CI/CD Setup',
        createdAt: now.subtract(const Duration(days: 2)),
        updatedAt: now.subtract(const Duration(days: 1)),
        tags: ['Learning', 'Flutter'],
        isPinned: true,
      ),
      Note(
        id: '4',
        title: 'Weekend Plans',
        content:
            'Things to do this weekend:\n• Visit the farmers market\n• Try the new restaurant downtown\n• Organize home office\n• Call family',
        createdAt: now.subtract(const Duration(hours: 8)),
        updatedAt: now.subtract(const Duration(hours: 4)),
        tags: ['Personal', 'Weekend'],
        isPinned: false,
      ),
      Note(
        id: '5',
        title: 'Book Recommendations',
        content:
            'Must-read books:\n• "Clean Code" by Robert Martin\n• "The Pragmatic Programmer"\n• "Flutter in Action"\n• "Design Patterns" by Gang of Four',
        createdAt: now.subtract(const Duration(days: 5)),
        updatedAt: now.subtract(const Duration(days: 4)),
        tags: ['Books', 'Learning'],
        isPinned: false,
      ),
    ];
  }
}
