import '../../core/app_export.dart';
import '../../database/database_helper.dart';
import '../../models/note.dart';
import './widgets/checklist_plan_card_widget.dart';
import './widgets/time_pill_badge_widget.dart';

class NoteDetailsScreen extends StatefulWidget {
  const NoteDetailsScreen({super.key});

  @override
  State<NoteDetailsScreen> createState() => _NoteDetailsScreenState();
}

class _NoteDetailsScreenState extends State<NoteDetailsScreen>
    with SingleTickerProviderStateMixin {
  // TODO: Replace with Riverpod/Bloc for production
  Note? _note;
  late AnimationController _sheetCtrl;
  late Animation<Offset> _slideAnim;
  late Animation<double> _fadeAnim;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _sheetCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _sheetCtrl, curve: Curves.easeOutCubic));
    _fadeAnim = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _sheetCtrl, curve: Curves.easeOut));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _isInitialized = true;
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Note) {
        setState(() => _note = args);
        _sheetCtrl.forward();
      }
    }
  }

  @override
  void dispose() {
    _sheetCtrl.dispose();
    super.dispose();
  }

  Future<void> _toggleChecklistItem(int index) async {
    if (_note == null) return;
    final item = _note!.checklistItems[index];
    final updated = item.copyWith(isDone: !item.isDone);
    final updatedItems = List<ChecklistItem>.from(_note!.checklistItems);
    updatedItems[index] = updated;
    final updatedNote = _note!.copyWith(checklistItems: updatedItems);
    setState(() => _note = updatedNote);

    if (item.id != null) {
      await DatabaseHelper.instance.updateChecklistItem(updated);
    }
  }

  void _openEdit() {
    Navigator.pushNamed(
      context,
      AppRoutes.editNoteScreen,
      arguments: _note,
    ).then((result) {
      if (result is Note) {
        setState(() => _note = result);
      }
    });
  }

  String _formatDateTime(DateTime dt) {
    final hour = dt.hour;
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final h = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    final endHour = (hour + 1) > 12 ? (hour + 1) - 12 : (hour + 1);
    final endPeriod = (hour + 1) >= 12 ? 'PM' : 'AM';
    return '$h:$minute $period - $endHour:$minute $endPeriod';
  }

  String _formatDate(DateTime dt) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }

  static const List<Color> _planColors = [
    Color(0xFF7C5CBF), // purple
    Color(0xFFF5C842), // yellow
    Color(0xFFE91E8C), // pink
    Color(0xFF4FC3F7), // blue
    Color(0xFFF5A623), // orange
    Color(0xFF2D7A4F), // green
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isTablet = MediaQuery.of(context).size.width >= 600;

    if (_note == null) {
      return Scaffold(
        backgroundColor: AppTheme.backgroundLight,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.sticky_note_2_rounded,
                  size: 64,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: 16),
                Text('Note not found', style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Go back'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final note = _note!;

    Widget content = SlideTransition(
      position: _slideAnim,
      child: FadeTransition(
        opacity: _fadeAnim,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: isTablet
                ? BorderRadius.circular(24)
                : const BorderRadius.vertical(top: Radius.circular(28)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(31),
                blurRadius: 24,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Drag handle
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 4),
                child: Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
              // Header row — ANATOMY LOCKED: X close + edit pencil
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceVariantLight,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close_rounded,
                          size: 18,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: _openEdit,
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceVariantLight,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.edit_rounded,
                          size: 18,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Time pill badge — ANATOMY LOCKED
                      TimePillBadgeWidget(
                        timeText: _formatDateTime(note.createdAt),
                      ),
                      const SizedBox(height: 16),
                      // Title — large bold centered
                      Text(
                        note.title.isEmpty ? 'Untitled Note' : note.title,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: theme.colorScheme.onSurface,
                          height: 1.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      // Description/content — centered muted
                      if (note.content.isNotEmpty) ...[
                        Text(
                          note.content,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            height: 1.55,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                      ],
                      // Image if present
                      if (note.imagePath != null) ...[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Photo',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: CustomImageWidget(
                            imageUrl: note.imagePath!.startsWith('http')
                                ? note.imagePath
                                : null,
                            width: double.infinity,
                            height: 180,
                            fit: BoxFit.cover,
                            semanticLabel:
                                'Photo attached to note: ${note.title}',
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                      // Plan / Checklist section — ANATOMY LOCKED
                      if (note.checklistItems.isNotEmpty) ...[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Plan',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...List.generate(note.checklistItems.length, (index) {
                          final item = note.checklistItems[index];
                          final color = _planColors[index % _planColors.length];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: ChecklistPlanCardWidget(
                              item: item,
                              accentColor: color,
                              onToggle: () => _toggleChecklistItem(index),
                            ),
                          );
                        }),
                      ],
                      // Date footer
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceVariantLight,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.calendar_today_rounded,
                              size: 14,
                              color: AppTheme.primary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _formatDate(note.createdAt),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (isTablet) {
      return Scaffold(
        backgroundColor: Colors.black.withAlpha(77),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520, maxHeight: 700),
            child: content,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Dimmed background — tap to close
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(color: Colors.black.withAlpha(64)),
          ),
          // Bottom sheet panel
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.88,
              child: content,
            ),
          ),
        ],
      ),
    );
  }
}
