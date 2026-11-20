import 'package:flutter/material.dart';
import 'task.dart';
import 'new_task_screen.dart';

void main() {
  runApp(const SimpleTaskApp());
}

/// Root widget configuring the app-wide theme and styling.
/// Satisfies Lab 5 Styling requirements:
/// 1. Custom two-way colour palette (Deep Teal primary + Warm Amber accent) instead of Flutter defaults.
/// 2. Additional custom styling via a custom font family ('SFCompact'), pill-shaped buttons, and rounded inputs.
class SimpleTaskApp extends StatelessWidget {
  const SimpleTaskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SimpleTask',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'SFCompact', // Custom font registered in pubspec.yaml
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00695C), // Deep Teal primary
          secondary: const Color(0xFFFF8F00), // Warm Amber accent
          surface: const Color(0xFFF6F8F7),
        ),
        scaffoldBackgroundColor: const Color(0xFFF6F8F7),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF00695C),
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 2,
          titleTextStyle: TextStyle(
            fontFamily: 'SFCompact',
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
            color: Colors.white,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.teal.shade200, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF00695C), width: 2.0),
          ),
        ),
        // Custom pill-shaped button styling
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00695C),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 3,
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFFF8F00),
          foregroundColor: Colors.white,
          shape: CircleBorder(),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

/// Home screen displaying the in-memory list of tasks, empty-state placeholder,
/// navigation to NewTaskScreen, and long-press task deletion.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Tasks are kept in app state only (cleared when the app is closed; no database used)
  final List<Task> _tasks = [];

  /// Formats a DateTime object as YYYY-MM-DD for clean display on task tiles.
  String _formatDate(DateTime date) {
    final year = date.year.toString();
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  /// Navigates to NewTaskScreen and awaits the created Task.
  /// If a valid task is returned (Done pressed with a title), adds it to state;
  /// if null is returned (back arrow pressed), nothing is added.
  Future<void> _navigateToNewTask() async {
    final Task? createdTask = await Navigator.push<Task>(
      context,
      MaterialPageRoute(builder: (context) => const NewTaskScreen()),
    );

    if (createdTask != null) {
      setState(() {
        _tasks.add(createdTask);
      });
    }
  }

  /// Displays an AlertDialog asking the user to confirm task deletion.
  /// Removes the task if Delete is tapped; keeps it if Cancel is tapped.
  Future<void> _confirmDeleteTask(int index) async {
    final taskToDelete = _tasks[index];

    final bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Delete Task'),
          content: Text(
            'Are you sure you want to delete "${taskToDelete.title}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              style: TextButton.styleFrom(foregroundColor: Colors.red.shade700),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      setState(() {
        _tasks.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar displaying the application's name
      appBar: AppBar(
        title: const Text('Simple Task'),
      ),
      // Show empty-state asset image and message when no tasks exist; otherwise render the task list
      body: _tasks.isEmpty
          ? Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/empty_tasks.png',
                width: 150,
                height: 150,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 16),
              Text(
                'No tasks here.',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          final task = _tasks[index];
          // Each task tile is styled with its chosen colour and displays its title and deadline
          return Card(
            color: task.color,
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(
                color: Colors.black.withValues(alpha: 0.08),
                width: 1,
              ),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 8,
              ),
              title: Text(
                task.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.event,
                      size: 16,
                      color: Colors.black54,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Due: ${_formatDate(task.deadline)}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              // Long-pressing triggers the delete confirmation AlertDialog
              onLongPress: () => _confirmDeleteTask(index),
            ),
          );
        },
      ),
      // Floating action button that opens the New Task screen
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToNewTask,
        tooltip: 'Add Task',
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }
}