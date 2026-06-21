import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/task_model.dart';

class TaskProvider extends ChangeNotifier {
  List<TaskModel> _tasks = [];

  late SharedPreferences prefs;

  List<TaskModel> get tasks => _tasks;

  TaskProvider() {
    _loadTasks();
  }

  // Load Tasks

  Future<void> _loadTasks() async {
    prefs = await SharedPreferences.getInstance();

    final String? tasksString = prefs.getString('saved_tasks');

    if (tasksString != null) {
      final List<dynamic> decodedList = jsonDecode(tasksString);

      _tasks = decodedList
          .map(
            (item) => TaskModel.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList();

      notifyListeners();
    }
  }

  // Save Tasks

  Future<void> _saveTasks() async {
    final List<Map<String, dynamic>> encodedList =
        _tasks.map((task) => task.toJson()).toList();

    final String jsonString = jsonEncode(encodedList);

    await prefs.setString(
      'saved_tasks',
      jsonString,
    );
  }

  // Add Task

  Future<void> addTask(
    String title,
    String description,
  ) async {
    _tasks.add(
      TaskModel(
        title: title,
        description: description,
        isDone: false,
      ),
    );

    await _saveTasks();

    notifyListeners();
  }

  // Delete Task

  Future<void> deleteTask(
    int index,
  ) async {
    _tasks.removeAt(index);

    await _saveTasks();

    notifyListeners();
  }

  // Update Task

  Future<void> updateTask(
    int index,
    String title,
    String description,
  ) async {
    _tasks[index].title = title;

    _tasks[index].description = description;

    await _saveTasks();

    notifyListeners();
  }

  // Toggle Task

  Future<void> toggleTask(
    int index,
    bool value,
  ) async {
    _tasks[index].isDone = value;

    await _saveTasks();

    notifyListeners();
  }

  // Statistics

  int get totalTasks => _tasks.length;

  int get completedTasks =>
      _tasks.where(
        (task) => task.isDone,
      ).length;

  int get remainingTasks =>
      totalTasks - completedTasks;
}