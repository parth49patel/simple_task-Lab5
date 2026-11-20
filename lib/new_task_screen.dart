import 'package:flutter/material.dart';
import 'task.dart';

/// Screen for creating a new task with title validation, multi-line description,
/// a date-picker deadline, and a selectable task colour.
class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  String? _titleError;

  // Four selectable task colours (satisfies the requirement for at least three colours)
  final List<Color> _availableColors = const [
    Color(0xFFD6EADF), // Soft Sage Green
    Color(0xFFFCE1E4), // Soft Rose Pink
    Color(0xFFDAEAF6), // Soft Sky Blue
    Color(0xFFFFF3CD), // Soft Amber Yellow
  ];

  late Color _selectedColor;

  @override
  void initState() {
    super.initState();
    _selectedColor = _availableColors[0];
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  /// Opens Flutter's built-in date picker dialog so the user can choose a task deadline.
  Future<void> _pickDeadline() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  /// Formats the selected deadline DateTime as YYYY-MM-DD.
  String _formatDate(DateTime date) {
    final year = date.year.toString();
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  /// Validates the task title when Done is tapped:
  /// - If empty, displays an inline error message and stays on this screen without adding a task.
  /// - Otherwise, pops back to HomeScreen and returns the newly constructed Task object.
  void _onDonePressed() {
    final titleText = _titleController.text.trim();

    if (titleText.isEmpty) {
      setState(() {
        _titleError = 'Task title cannot be empty.';
      });
      return;
    }

    final newTask = Task(
      title: titleText,
      description: _descriptionController.text.trim(),
      deadline: _selectedDate,
      color: _selectedColor,
    );

    Navigator.pop(context, newTask);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar titled "New Task" with a default back arrow that returns Home without adding a task
      appBar: AppBar(
        title: const Text('New Task'),
      ),
      // SingleChildScrollView ensures the screen scrolls so no input field is cut off when the keyboard opens
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Required single-line task title input with validation error support
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Task Title *',
                hintText: 'e.g., Submit SOFE4640U Lab 5',
                errorText: _titleError,
                prefixIcon: const Icon(Icons.title),
              ),
              onChanged: (_) {
                if (_titleError != null) {
                  setState(() {
                    _titleError = null;
                  });
                }
              },
            ),
            const SizedBox(height: 18),

            // Multi-line task description input
            TextField(
              controller: _descriptionController,
              maxLines: 4,
              minLines: 3,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Enter task details or notes...',
                alignLabelWithHint: true,
                prefixIcon: Padding(
                  padding: EdgeInsets.only(bottom: 48.0),
                  child: Icon(Icons.notes),
                ),
              ),
            ),
            const SizedBox(height: 22),

            // Deadline picker selector
            Text(
              'Deadline',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: _pickDeadline,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.teal.shade300, width: 1.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.calendar_today, color: Colors.teal.shade700),
                        const SizedBox(width: 12),
                        Text(
                          _formatDate(_selectedDate),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Change',
                      style: TextStyle(
                        color: Colors.teal.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 22),

            // Task colour picker row
            Text(
              'Task Colour',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _availableColors.map((color) {
                final bool isSelected = _selectedColor == color;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedColor = color;
                    });
                  },
                  child: Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? Colors.teal.shade900 : Colors.grey.shade400,
                        width: isSelected ? 3.5 : 1.5,
                      ),
                      boxShadow: isSelected
                          ? [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.18),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        )
                      ]
                          : [],
                    ),
                    child: isSelected
                        ? Icon(Icons.check, color: Colors.teal.shade900, size: 28)
                        : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),

            // Done button triggering title validation and returning the new task to HomeScreen
            ElevatedButton.icon(
              onPressed: _onDonePressed,
              icon: const Icon(Icons.check_circle_outline),
              label: const Text('Done'),
            ),
          ],
        ),
      ),
    );
  }
}