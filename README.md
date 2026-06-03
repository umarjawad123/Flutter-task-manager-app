# 🚀 Stride - Task Management App (Flutter)

A feature-rich Flutter Task Manager application developed during Week 3 of my internship. The app focuses on CRUD operations, real-time task tracking, persistent storage, and a clean productivity-oriented UI.

---

## 🎯 Project Overview

Stride is a productivity-based task manager app that helps users organize daily tasks efficiently.

It includes task creation, editing, deletion, completion tracking, and persistent storage using SharedPreferences, ensuring tasks remain saved even after closing the app.

The app also provides a real-time statistics dashboard showing:

* Total Tasks
* Completed Tasks
* Remaining Tasks

---

## 🚀 Features

* Splash screen with app branding ("Stride")
* Add new tasks with title and optional description
* Edit existing tasks
* Delete tasks with confirmation dialog
* Mark tasks as completed using checkbox
* Real-time task statistics counter
* Persistent storage using SharedPreferences
* Data remains saved after app restart
* Clean and responsive UI design
* Dialog-based task management system

---

## 📸 Screenshots

### 🚀 Splash Screen

<img src="screenshots/Splash Screen.jpeg" width="250"/>

---

### 🏠 Home Page (Task Dashboard)

<img src="screenshots/Home Page.jpeg" width="250"/>

> Shows task list with live counter (Total, Completed, Remaining tasks) and Add button in AppBar.

---

### ➕ Add Task Dialog

<img src="screenshots/Add Task Dialog.jpeg" width="250"/>

> Contains title & description fields with Add and Cancel buttons. Description is optional.

---

### ✏️ Edit Task Dialog

<img src="screenshots/Edit Task Dialog.jpeg" width="250"/>

> Pre-filled fields allowing users to update existing task details.

---

### ⚠️ Delete Confirmation Dialog

<img src="screenshots/Delete Task Confirmation.jpeg" width="250"/>

> Confirmation popup before deleting a task to prevent accidental removal.

---

### ☑️ Completed Tasks View

<img src="screenshots/Home Page with Checkboxes Tick.jpeg" width="250"/>

> Tasks marked as completed with updated counters reflecting changes.

---

## 🛠️ Tech Stack

* Flutter
* Dart
* Material Design
* SharedPreferences (Local Storage)
* Stateful Widgets
* Dialog-based UI interactions

---

## ⚙️ Functional Flow

1. App launches with Splash Screen
2. Tasks are loaded from SharedPreferences
3. Home Page displays stored tasks
4. User can add new tasks via dialog
5. Tasks are stored locally using SharedPreferences
6. User can edit, delete, or complete tasks
7. All changes are saved automatically
8. Counter updates in real time:

   * Total Tasks
   * Completed Tasks
   * Remaining Tasks

---

## 🧠 Key Concepts Used

* Stateful Widget management
* setState() for UI updates
* CRUD operations (Create, Read, Update, Delete)
* SharedPreferences for local persistence
* Dialogs (AlertDialog)
* Checkbox state handling
* Dynamic List rendering
* Navigation & Pop operations

---

## 📂 Project Structure

```text id="struct_w3_final"
lib/
├── main.dart
├── screens/
│   ├── splash_screen.dart
│   └── home_page.dart
└── utils/
    └── app_colors.dart
```

---

## 📱 How to Run

Clone the repository:

```bash id="run_w3_final_1"
git clone https://github.com/umarjawad123/stride-task-manager-app.git
```

Navigate to project:

```bash id="run_w3_final_2"
cd stride-task-manager-app
```

Install dependencies:

```bash id="run_w3_final_3"
flutter pub get
```

Run app:

```bash id="run_w3_final_4"
flutter run
```

---

## 🎯 Future Improvements

* Replace SharedPreferences with SQLite or Hive for scalability
* Add Firebase synchronization
* Add task categories and tags
* Add due dates and reminders
* Add animations for task transitions
* Add dark mode support

---

## 👨‍💻 Author

**Umar Jawad**
Flutter Developer | BSCS Student
