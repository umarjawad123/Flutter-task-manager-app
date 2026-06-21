import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/utils/app_colors.dart';

import '../providers/task_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.accentOrange,
                Color.fromARGB(255, 189, 113, 1),
              ],
            ),
          ),
        ),
        title: Padding(
          padding: EdgeInsets.only(left: 12.0),
          child: Text(
            'Stride',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: AppColors.primaryText,
            ),
          ).animate().fadeIn().slideY(begin: 0.3).scaleX(begin: 1.2, end: 1.0),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: IconButton(
              iconSize: 30,
              color: AppColors.primaryText,
              icon: const Icon(Icons.add),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) {
                    return TaskDialog(
                      onAdd: (title, description) {
                        context.read<TaskProvider>().addTask(
                          title,
                          description,
                        );
                      },
                    );
                  },
                );
              },
            ).animate().fadeIn().slideY(begin: 0.3).scaleX(begin: 0.8),
          ),
        ],
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
            child: Row(
              children: [
                Expanded(
                  child: buildStatCard(
                    "Total",
                    provider.totalTasks.toString(),
                  ).animate().fadeIn(delay: 50.ms).scale(),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: buildStatCard(
                    "Completed",
                    provider.completedTasks.toString(),
                  ).animate().fadeIn(delay: 150.ms).scale(),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: buildStatCard(
                    "Remaining",
                    provider.remainingTasks.toString(),
                  ).animate().fadeIn(delay: 250.ms).scale(),
                ),
              ].animate(interval: 300.ms).fadeIn().slideY(begin: 0.5),
            ),
          ),

          provider.tasks.isEmpty
              ? const Expanded(
                  child: Center(child: Text("No tasks to display")),
                )
              : Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: ListView.builder(
                      itemCount: provider.tasks.length,
                      itemBuilder: (context, index) {
                        final task = provider.tasks[index];
                        final hasDescription = task.description
                            .trim()
                            .isNotEmpty;

                        return Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1E1E1E),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: AppColors.accentOrange,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: AppColors.accentOrange,
                                    blurRadius: 3,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Checkbox(
                                    activeColor: AppColors.accentOrange,
                                    checkColor: Colors.white,
                                    value: task.isDone,
                                    onChanged: (value) {
                                      context.read<TaskProvider>().toggleTask(
                                        index,
                                        value ?? false,
                                      );
                                    },
                                  ),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          task.title,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            decoration: task.isDone
                                                ? TextDecoration.lineThrough
                                                : TextDecoration.none,
                                          ),
                                        ),

                                        if (hasDescription) ...[
                                          const SizedBox(height: 5),
                                          Text(
                                            task.description,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: TextStyle(
                                              color: Colors.grey[400],
                                              fontSize: 13,
                                              decoration: task.isDone
                                                  ? TextDecoration.lineThrough
                                                  : TextDecoration.none,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),

                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.edit,
                                          color: AppColors.accentOrange,
                                        ),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (_) {
                                              return TaskDialog(
                                                initialTitle: task.title,
                                                initialDescription:
                                                    task.description,
                                                onAdd:
                                                    (
                                                      updatedTitle,
                                                      updatedDescription,
                                                    ) {
                                                      context
                                                          .read<TaskProvider>()
                                                          .updateTask(
                                                            index,
                                                            updatedTitle,
                                                            updatedDescription,
                                                          );
                                                    },
                                              );
                                            },
                                          );
                                        },
                                      ),

                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {
                                          showDeleteDialog(context, () {
                                            context
                                                .read<TaskProvider>()
                                                .deleteTask(index);
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                            .animate()
                            .fadeIn(duration: 300.ms)
                            .scale(
                              begin: const Offset(0.8, 0.8),
                              end: const Offset(1.0, 1.0),
                            )
                            .slideY(begin: 0.2);
                      },
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}

class TaskDialog extends StatefulWidget {
  final String initialTitle;
  final String initialDescription;
  final Function(String title, String description) onAdd;

  const TaskDialog({
    super.key,
    required this.onAdd,
    this.initialTitle = "",
    this.initialDescription = "",
  });

  @override
  State<TaskDialog> createState() => _TaskDialogState();
}

class _TaskDialogState extends State<TaskDialog> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.initialTitle);
    descriptionController = TextEditingController(
      text: widget.initialDescription,
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialTitle.isNotEmpty;

    return AlertDialog(
      title: Text(isEditing ? "Edit Task" : "Add Task"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(
              labelText: "Title",
              labelStyle: TextStyle(color: Colors.grey[400]),
            ),
          ),
          SizedBox(height: 10),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(
              labelText: "Description (Optional)",
              labelStyle: TextStyle(color: Colors.grey[400]),
            ),
            maxLines: 3,
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            if (titleController.text.trim().isEmpty) return;

            widget.onAdd(
              titleController.text.trim(),
              descriptionController.text.trim(),
            );

            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accentOrange,
          ),
          child: Text(
            isEditing ? "Save" : "Add",
            style: TextStyle(color: Colors.white),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondaryBackground,
          ),
          child: const Text(
            'Cancel',
            style: TextStyle(color: AppColors.accentOrange),
          ),
        ),
      ],
    ).animate()
          .fadeIn()
          .slideY(begin: 0.3)
          .scale(begin: const Offset(0.8, 0.8), end: const Offset(1.0, 1.0));
  }
}

Widget buildStatCard(String title, String value) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: const Color(0xFF1E1E1E),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.orange),
      boxShadow: const [
        BoxShadow(color: Colors.orange, blurRadius: 3, offset: Offset(0, 4)),
      ],
    ),
    child: Column(
      children: [
        Text(title, style: const TextStyle(color: Colors.white)),
        const SizedBox(height: 10),
        Text(
          value,
          style: const TextStyle(
            color: Colors.orange,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}

void showDeleteDialog(BuildContext context, VoidCallback onDelete) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Delete Task"),
        content: const Text("Are you sure you want to delete this task?"),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              onDelete();
              Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.white)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondaryBackground,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              "Cancel",
              style: TextStyle(color: AppColors.accentOrange),
            ),
          ),
        ],
      ).animate()
          .fadeIn()
          .slideY(begin: 0.3)
          .scale(begin: const Offset(0.8, 0.8), end: const Offset(1.0, 1.0));
    },
  );
}
