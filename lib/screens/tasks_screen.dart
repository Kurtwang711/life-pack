import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../constants/app_constants.dart';
import '../providers/task_provider.dart';
import '../widgets/task_card.dart';
import '../models/task.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Tasks'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Pending'),
            Tab(text: 'In Progress'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTaskList(context, (provider) => provider.tasks),
          _buildTaskList(context, (provider) => provider.pendingTasks),
          _buildTaskList(context, (provider) => provider.inProgressTasks),
          _buildTaskList(context, (provider) => provider.completedTasks),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(context),
        child: const FaIcon(FontAwesomeIcons.plus),
      ),
    );
  }

  Widget _buildTaskList(
    BuildContext context,
    List<Task> Function(TaskProvider) getTaskList,
  ) {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        final tasks = getTaskList(taskProvider);

        if (taskProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (tasks.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const FaIcon(
                  FontAwesomeIcons.listCheck,
                  color: AppColors.textDisabled,
                  size: 48,
                ),
                const SizedBox(height: AppSizes.paddingMD),
                Text(
                  AppStrings.noTasks,
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
          onRefresh: taskProvider.loadTasks,
          child: ListView.builder(
            padding: const EdgeInsets.all(AppSizes.paddingMD),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSizes.paddingSM),
                child: TaskCard(
                  task: task,
                  onTap: () => _showTaskDetails(context, task),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const AddTaskSheet(),
    );
  }

  void _showTaskDetails(BuildContext context, Task task) {
    // TODO: Implement task details screen
  }
}

class AddTaskSheet extends StatefulWidget {
  const AddTaskSheet({super.key});

  @override
  State<AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends State<AddTaskSheet> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  Priority _selectedPriority = Priority.medium;
  DateTime? _selectedDueDate;
  bool _isImportant = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: AppSizes.paddingMD,
        right: AppSizes.paddingMD,
        top: AppSizes.paddingMD,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSizes.paddingMD,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                AppStrings.newTask,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const FaIcon(FontAwesomeIcons.xmark),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.paddingMD),

          // Title input
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: AppStrings.taskTitle,
              hintText: 'Enter task title',
            ),
            autofocus: true,
          ),
          const SizedBox(height: AppSizes.paddingMD),

          // Description input
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: AppStrings.taskDescription,
              hintText: 'Enter task description (optional)',
            ),
            maxLines: 3,
          ),
          const SizedBox(height: AppSizes.paddingMD),

          // Priority and options
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.priority,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: AppSizes.paddingSM),
                    DropdownButton<Priority>(
                      value: _selectedPriority,
                      isExpanded: true,
                      onChanged: (Priority? value) {
                        if (value != null) {
                          setState(() {
                            _selectedPriority = value;
                          });
                        }
                      },
                      items: Priority.values.map((priority) {
                        return DropdownMenuItem<Priority>(
                          value: priority,
                          child: Text(_getPriorityText(priority)),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSizes.paddingMD),
              Column(
                children: [
                  Text(
                    'Important',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Switch(
                    value: _isImportant,
                    onChanged: (value) {
                      setState(() {
                        _isImportant = value;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSizes.paddingMD),

          // Due date
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const FaIcon(FontAwesomeIcons.calendar),
            title: Text(
              _selectedDueDate != null
                  ? 'Due: ${_selectedDueDate!.day}/${_selectedDueDate!.month}/${_selectedDueDate!.year}'
                  : 'Set due date',
            ),
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (date != null) {
                setState(() {
                  _selectedDueDate = date;
                });
              }
            },
            trailing: _selectedDueDate != null
                ? IconButton(
                    icon: const FaIcon(FontAwesomeIcons.xmark, size: 16),
                    onPressed: () {
                      setState(() {
                        _selectedDueDate = null;
                      });
                    },
                  )
                : null,
          ),
          const SizedBox(height: AppSizes.paddingMD),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(AppStrings.cancel),
                ),
              ),
              const SizedBox(width: AppSizes.paddingSM),
              Expanded(
                child: ElevatedButton(
                  onPressed: _titleController.text.trim().isEmpty
                      ? null
                      : () => _createTask(context),
                  child: const Text(AppStrings.save),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getPriorityText(Priority priority) {
    switch (priority) {
      case Priority.high:
        return AppStrings.highPriority;
      case Priority.medium:
        return AppStrings.mediumPriority;
      case Priority.low:
        return AppStrings.lowPriority;
    }
  }

  void _createTask(BuildContext context) {
    final task = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      priority: _selectedPriority,
      createdAt: DateTime.now(),
      dueDate: _selectedDueDate,
      isImportant: _isImportant,
    );

    context.read<TaskProvider>().addTask(task);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
