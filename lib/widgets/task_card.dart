import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../constants/app_constants.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback? onTap;

  const TaskCard({super.key, required this.task, this.onTap});

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
                  // Status checkbox
                  GestureDetector(
                    onTap: () {
                      context.read<TaskProvider>().toggleTaskStatus(task);
                    },
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: _getStatusColor(),
                        borderRadius: BorderRadius.circular(6),
                        border: task.status == TaskStatus.pending
                            ? Border.all(color: AppColors.border, width: 2)
                            : null,
                      ),
                      child: task.status != TaskStatus.pending
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 16,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(width: AppSizes.paddingSM),

                  // Task title and content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                decoration: task.status == TaskStatus.completed
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: task.status == TaskStatus.completed
                                    ? AppColors.textSecondary
                                    : AppColors.textPrimary,
                              ),
                        ),
                        if (task.description.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            task.description,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: AppColors.textSecondary),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Priority indicator
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: _getPriorityColor(),
                      shape: BoxShape.circle,
                    ),
                  ),

                  // Important star
                  if (task.isImportant) ...[
                    const SizedBox(width: AppSizes.paddingSM),
                    GestureDetector(
                      onTap: () {
                        context.read<TaskProvider>().toggleTaskImportance(task);
                      },
                      child: const FaIcon(
                        FontAwesomeIcons.solidStar,
                        color: AppColors.accent,
                        size: 16,
                      ),
                    ),
                  ],
                ],
              ),

              // Due date and tags
              if (task.dueDate != null || task.tags.isNotEmpty) ...[
                const SizedBox(height: AppSizes.paddingSM),
                Row(
                  children: [
                    // Due date
                    if (task.dueDate != null) ...[
                      FaIcon(
                        FontAwesomeIcons.clock,
                        color: _getDueDateColor(),
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatDueDate(task.dueDate!),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: _getDueDateColor(),
                          fontSize: 11,
                        ),
                      ),
                    ],

                    const Spacer(),

                    // Tags
                    if (task.tags.isNotEmpty)
                      Wrap(
                        spacing: 4,
                        children: task.tags
                            .take(2)
                            .map(
                              (tag) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  tag,
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: AppColors.primary,
                                        fontSize: 10,
                                      ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor() {
    switch (task.status) {
      case TaskStatus.pending:
        return Colors.transparent;
      case TaskStatus.inProgress:
        return AppColors.statusInProgress;
      case TaskStatus.completed:
        return AppColors.statusCompleted;
    }
  }

  Color _getPriorityColor() {
    switch (task.priority) {
      case Priority.high:
        return AppColors.priorityHigh;
      case Priority.medium:
        return AppColors.priorityMedium;
      case Priority.low:
        return AppColors.priorityLow;
    }
  }

  Color _getDueDateColor() {
    if (task.dueDate == null) return AppColors.textSecondary;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dueDate = DateTime(
      task.dueDate!.year,
      task.dueDate!.month,
      task.dueDate!.day,
    );

    if (dueDate.isBefore(today)) {
      return AppColors.error; // Overdue
    } else if (dueDate.isAtSameMomentAs(today)) {
      return AppColors.accent; // Due today
    } else {
      return AppColors.textSecondary; // Future
    }
  }

  String _formatDueDate(DateTime dueDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final taskDate = DateTime(dueDate.year, dueDate.month, dueDate.day);

    if (taskDate.isAtSameMomentAs(today)) {
      return 'Today';
    } else if (taskDate.isAtSameMomentAs(today.add(const Duration(days: 1)))) {
      return 'Tomorrow';
    } else if (taskDate.isBefore(today)) {
      final daysDiff = today.difference(taskDate).inDays;
      return '$daysDiff days overdue';
    } else {
      return DateFormat('MMM d').format(dueDate);
    }
  }
}
