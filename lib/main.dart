import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// ─────────────────────────────────────────────
//  Color Palette (Centralized)
//  Theme: Calm Teal + Warm Slate
//  • Teal primary  — modern, trustworthy, fresh
//  • Slate neutrals — warm, readable, minimal
//  • Rose error    — clear intent, not harsh
// ─────────────────────────────────────────────
class AppColors {
  AppColors._();

  // Primary — deep teal
  static const Color primary          = Color(0xFF0F766E); // teal-700
  static const Color primaryLight     = Color(0xFF14B8A6); // teal-500 (accents)
  static const Color primaryContainer = Color(0xFFCCFBF1); // teal-100 (soft bg)
  static const Color onPrimaryContainer = Color(0xFF0D4B45); // teal-900

  // Secondary — soft indigo (complements teal)
  static const Color secondaryContainer   = Color(0xFFE0E7FF); // indigo-100
  static const Color onSecondaryContainer = Color(0xFF3730A3); // indigo-800

  // Neutrals — warm slate (avoids cold greys)
  static const Color surface                = Color(0xFFFFFFFF);
  static const Color surfaceContainerLowest = Color(0xFFF8FAFC); // page background
  static const Color surfaceContainerHigh   = Color(0xFFEEF2F7); // input fill
  static const Color onSurface             = Color(0xFF1E293B); // slate-800 main text
  static const Color onSurfaceVariant      = Color(0xFF64748B); // slate-500 hint text

  // Error / Destructive — muted rose (not aggressive red)
  static const Color error          = Color(0xFFBE123C); // rose-700
  static const Color errorContainer = Color(0xFFFFE4E6); // rose-100
}

// ─────────────────────────────────────────────
//  App Root
// ─────────────────────────────────────────────
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Tasks',
      theme: _buildTheme(),
      home: const TodoPage(),
    );
  }

  ThemeData _buildTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
        // Override generated M3 tones with our curated palette
        primary:              AppColors.primary,
        primaryContainer:     AppColors.primaryContainer,
        onPrimaryContainer:   AppColors.onPrimaryContainer,
        secondaryContainer:   AppColors.secondaryContainer,
        onSecondaryContainer: AppColors.onSecondaryContainer,
        surface:              AppColors.surface,
        onSurface:            AppColors.onSurface,
        onSurfaceVariant:     AppColors.onSurfaceVariant,
        error:                AppColors.error,
        errorContainer:       AppColors.errorContainer,
      ),
      fontFamily: 'Roboto',

      // Input fields: filled with warm slate, teal focus ring
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceContainerHigh,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),

      // Button: solid deep teal, white label, no shadow
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Cards: white fill, hairline slate border (no shadow)
      cardTheme: CardThemeData(
        elevation: 0,
        color: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFFE2E8F0), width: 1),
        ),
        margin: const EdgeInsets.symmetric(vertical: 6),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Page (Stateful) — logic unchanged
// ─────────────────────────────────────────────
class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _tasks = [];

  void _addTask() {
    if (_controller.text.trim().isNotEmpty) {
      setState(() {
        _tasks.add(_controller.text.trim());
        _controller.clear();
      });
    }
  }

  void _removeTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: AppColors.surfaceContainerLowest,
      appBar: _buildAppBar(scheme),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TaskSummaryHeader(taskCount: _tasks.length),
              const SizedBox(height: 24),
              _TaskInputField(controller: _controller, onAdd: _addTask),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _addTask,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_rounded, size: 20),
                    SizedBox(width: 8),
                    Text('Add Task'),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              _SectionLabel(
                label: 'Your Tasks',
                count: _tasks.length,
              ),
              const SizedBox(height: 8),
              Expanded(
                child: _tasks.isEmpty
                    ? const _EmptyState()
                    : _TaskList(
                        tasks: _tasks,
                        onRemove: _removeTask,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(ColorScheme scheme) {
    return AppBar(
      backgroundColor: AppColors.surfaceContainerLowest,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      title: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.check_rounded,
              color: AppColors.onPrimaryContainer,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'My Tasks',
            style: TextStyle(
              color: AppColors.onSurface,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Modular Sub-Widgets — structure unchanged
// ─────────────────────────────────────────────

/// Greeting + task count summary
class _TaskSummaryHeader extends StatelessWidget {
  final int taskCount;
  const _TaskSummaryHeader({required this.taskCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        // Teal → indigo gradient: calming, cohesive with palette
        gradient: const LinearGradient(
          colors: [AppColors.primaryContainer, AppColors.secondaryContainer],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Color(0x40B2F5EA), // teal-200 at 25% opacity
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hello there 👋',
            style: TextStyle(
              color: AppColors.onPrimaryContainer.withOpacity(0.7),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            taskCount == 0
                ? 'No tasks yet. Add one!'
                : '$taskCount task${taskCount == 1 ? '' : 's'} waiting',
            style: const TextStyle(
              color: AppColors.onPrimaryContainer,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

/// Input field for entering a new task
class _TaskInputField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onAdd;

  const _TaskInputField({required this.controller, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textInputAction: TextInputAction.done,
      onSubmitted: (_) => onAdd(),
      style: const TextStyle(color: AppColors.onSurface, fontSize: 15),
      decoration: const InputDecoration(
        fillColor: AppColors.surfaceContainerHigh,
        hintText: 'What needs to be done?',
        hintStyle: TextStyle(color: AppColors.onSurfaceVariant),
        // Teal icon reinforces primary color
        prefixIcon: Icon(Icons.edit_outlined, color: AppColors.primary, size: 20),
      ),
    );
  }
}

/// Section label with count badge
class _SectionLabel extends StatelessWidget {
  final String label;
  final int count;

  const _SectionLabel({required this.label, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          'Your Tasks',
          style: TextStyle(
            color: AppColors.onSurface,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(width: 8),
        if (count > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$count',
              style: const TextStyle(
                color: AppColors.onPrimaryContainer,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
      ],
    );
  }
}

/// Scrollable list of task cards
class _TaskList extends StatelessWidget {
  final List<String> tasks;
  final void Function(int) onRemove;

  const _TaskList({required this.tasks, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        return _TaskCard(
          title: tasks[index],
          index: index,
          onRemove: () => onRemove(index),
        );
      },
    );
  }
}

/// Individual task card
class _TaskCard extends StatelessWidget {
  final String title;
  final int index;
  final VoidCallback onRemove;

  const _TaskCard({
    required this.title,
    required this.index,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      // Styling from CardThemeData (white + hairline border)
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            // Number badge — teal-100 bg, teal-900 text
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Text(
                '${index + 1}',
                style: const TextStyle(
                  color: AppColors.onPrimaryContainer,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 14),
            // Task title — dark slate for readability
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: AppColors.onSurface,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            // Delete — muted rose, not alarming red
            IconButton(
              onPressed: onRemove,
              icon: const Icon(Icons.delete_outline_rounded,
                  color: AppColors.error, size: 22),
              style: IconButton.styleFrom(
                backgroundColor: AppColors.errorContainer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shown when the task list is empty
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: AppColors.primaryContainer,
            child: Icon(
              Icons.task_alt_rounded,
              size: 40,
              color: AppColors.onPrimaryContainer,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'All clear!',
            style: TextStyle(
              color: AppColors.onSurface,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Add a task above to get started.',
            style: TextStyle(
              color: AppColors.onSurfaceVariant,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}