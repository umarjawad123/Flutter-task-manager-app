import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/utils/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> tasks = [];
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  // Shared Preferences Functionality 
  Future<void> _loadTasks() async {
    prefs = await SharedPreferences.getInstance();
    final String? tasksString = prefs.getString('saved_tasks');
    if (tasksString != null) {
      final List<dynamic> decodedList = jsonDecode(tasksString);
      setState(() {
        tasks = decodedList
            .map((item) => Map<String, dynamic>.from(item))
            .toList();
      });
    }
  }

  Future<void> _saveTasks() async {
    final String encodedList = jsonEncode(tasks);
    await prefs.setString('saved_tasks', encodedList);
  }

  @override
  Widget build(BuildContext context) {
    int totalTasks = tasks.length;
    int completedTasks = tasks.where((t) => t["isDone"] == true).length;
    int remainingTasks = totalTasks - completedTasks;

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
        title: const Padding(
          padding: EdgeInsets.only(left: 12.0),
          child: Text(
            'Stride',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: AppColors.primaryText,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return TaskDialog(
                      onAdd: ((title, description) {
                        setState(() {
                          tasks.add({
                            "title": title,
                            "description": description,
                            "isDone": false,
                          });
                        });
                        _saveTasks(); 
                      }),
                    );
                  },
                );
              },
              iconSize: 30,
              color: AppColors.primaryText,
              icon: const Icon(Icons.add),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30.0, left: 10, right: 10),
            child: Row(
              children: [
                Expanded(child: buildStatCard("Total", totalTasks.toString())),
                const SizedBox(width: 12),
                Expanded(
                  child: buildStatCard("Completed", completedTasks.toString()),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: buildStatCard("Remaining", remainingTasks.toString()),
                ),
              ],
            ),
          ),
          tasks.isEmpty
              ? const Expanded(
                  child: Center(child: Text("No tasks to display")),
                )
              : Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: ((context, index) {
                        final hasDescription =
                            tasks[index]["description"] != null &&
                            tasks[index]["description"]
                                .toString()
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
                              width: 0.8,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: AppColors.accentOrange,
                                blurRadius: 1,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Theme(
                                data: ThemeData(
                                  unselectedWidgetColor: AppColors.accentOrange,
                                ),
                                child: Checkbox(
                                  activeColor: AppColors.accentOrange,
                                  checkColor: Colors.white,
                                  value: tasks[index]["isDone"] ?? false,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      tasks[index]["isDone"] = value;
                                    });
                                    _saveTasks();
                                  },
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      tasks[index]["title"],
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        decoration:
                                            tasks[index]["isDone"] == true
                                            ? TextDecoration.lineThrough
                                            : TextDecoration.none,
                                      ),
                                    ),
                                    if (hasDescription) ...[
                                      const SizedBox(height: 5),
                                      Text(
                                        tasks[index]["description"],
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: TextStyle(
                                          color: Colors.grey[400],
                                          fontSize: 13,
                                          decoration:
                                              tasks[index]["isDone"] == true
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
                                        builder: (context) {
                                          return TaskDialog(
                                            initialTitle: tasks[index]["title"],
                                            initialDescription:
                                                tasks[index]["description"],
                                            onAdd:
                                                (
                                                  updatedTitle,
                                                  updatedDescription,
                                                ) {
                                                  setState(() {
                                                    tasks[index]["title"] =
                                                        updatedTitle;
                                                    tasks[index]["description"] =
                                                        updatedDescription;
                                                  });
                                                  _saveTasks();
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
                                        setState(() {
                                          tasks.removeAt(index);
                                        });
                                        _saveTasks();
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
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
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                label: Text(
                  "Title *",
                  style: TextStyle(color: AppColors.secondaryText),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                label: Text(
                  "Description (Optional)",
                  style: TextStyle(color: AppColors.secondaryText),
                ),
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            if (titleController.text.trim().isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    "Title is required!",
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.redAccent,
                ),
              );
              return;
            }

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
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.primaryText,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondaryBackground,
          ),
          child: const Text("Cancel"),
        ),
      ],
    );
  }
}

Widget buildStatCard(String title, String value) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFF1E1E1E), Color(0xFF121212)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.accentOrange, width: 1.0),
      boxShadow: const [
        BoxShadow(
          color: AppColors.accentOrange,
          blurRadius: 5,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.primaryText,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.accentOrange,
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
            onPressed: () {
              onDelete();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text(
              "Delete",
              style: TextStyle(
                color: AppColors.primaryText,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondaryBackground,
            ),
            child: const Text("Cancel"),
          ),
        ],
      );
    },
  );
}
