
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/app_export.dart';
import '../../database/database_helper.dart';
import '../../models/note.dart';
import './widgets/add_note_form_widget.dart';
import './widgets/checklist_section_widget.dart';
import './widgets/image_attachment_widget.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen>
    with SingleTickerProviderStateMixin {
  // TODO: Replace with Riverpod/Bloc for production
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _contentCtrl = TextEditingController();
  bool _isImportant = false;
  bool _isSaving = false;
  String? _imagePath;
  final List<ChecklistItem> _checklistItems = [];
  late AnimationController _enterCtrl;
  late Animation<Offset> _slideAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _enterCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _enterCtrl, curve: Curves.easeOutCubic));
    _fadeAnim = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _enterCtrl, curve: Curves.easeOut));
    _enterCtrl.forward();
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _contentCtrl.dispose();
    _enterCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: source, imageQuality: 80);
      if (picked != null && mounted) {
        setState(() => _imagePath = picked.path);
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Couldn't access photos. Check app permissions.",
        backgroundColor: AppTheme.error,
        textColor: Colors.white,
      );
    }
  }

  void _showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Add Photo',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              if (!kIsWeb)
                _SheetOption(
                  icon: Icons.photo_camera_rounded,
                  label: 'Take Photo',
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickImage(ImageSource.camera);
                  },
                ),
              const SizedBox(height: 8),
              _SheetOption(
                icon: Icons.photo_library_rounded,
                label: 'Choose from Library',
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addChecklistItem() {
    setState(() {
      _checklistItems.add(ChecklistItem(taskText: '', isDone: false));
    });
  }

  void _removeChecklistItem(int index) {
    setState(() => _checklistItems.removeAt(index));
  }

  void _updateChecklistItem(int index, String text) {
    _checklistItems[index] = _checklistItems[index].copyWith(taskText: text);
  }

  Future<void> _saveNote() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    final note = Note(
      title: _titleCtrl.text.trim(),
      content: _contentCtrl.text.trim(),
      imagePath: _imagePath,
      isImportant: _isImportant,
      createdAt: DateTime.now(),
      checklistItems: _checklistItems
          .where((c) => c.taskText.isNotEmpty)
          .toList(),
    );

    try {
      await DatabaseHelper.instance.insertNote(note);
      if (mounted) {
        Fluttertoast.showToast(
          msg: 'Note saved!',
          backgroundColor: AppTheme.success,
          textColor: Colors.white,
        );
        Navigator.pop(context);
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Couldn't save note. Please try again.",
        backgroundColor: AppTheme.error,
        textColor: Colors.white,
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isTablet = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundLight,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(18),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: CustomIconWidget(
              iconName: 'arrow_back',
              color: theme.colorScheme.onSurface,
              size: 18,
            ),
          ),
        ),
        title: Text(
          'New Note',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () => setState(() => _isImportant = !_isImportant),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _isImportant
                    ? AppTheme.accentOrange.withAlpha(31)
                    : Colors.white,
                borderRadius: BorderRadius.circular(40),
                border: Border.all(
                  color: _isImportant
                      ? AppTheme.accentOrange
                      : Colors.transparent,
                  width: 1.5,
                ),
                boxShadow: [
                  if (!_isImportant)
                    BoxShadow(
                      color: Colors.black.withAlpha(15),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _isImportant
                        ? Icons.push_pin_rounded
                        : Icons.push_pin_outlined,
                    size: 16,
                    color: _isImportant
                        ? AppTheme.accentOrange
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Pin',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: _isImportant
                          ? AppTheme.accentOrange
                          : theme.colorScheme.onSurfaceVariant,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SlideTransition(
          position: _slideAnim,
          child: FadeTransition(
            opacity: _fadeAnim,
            child: isTablet
                ? Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 560),
                      child: _buildFormBody(theme),
                    ),
                  )
                : _buildFormBody(theme),
          ),
        ),
      ),
    );
  }

  Widget _buildFormBody(ThemeData theme) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title & Content form
            AddNoteFormWidget(
              titleController: _titleCtrl,
              contentController: _contentCtrl,
            ),
            const SizedBox(height: 24),
            // Image attachment
            ImageAttachmentWidget(
              imagePath: _imagePath,
              onAddImage: _showImageSourceSheet,
              onRemoveImage: () => setState(() => _imagePath = null),
            ),
            const SizedBox(height: 24),
            // Checklist section
            ChecklistSectionWidget(
              items: _checklistItems,
              onAddItem: _addChecklistItem,
              onRemoveItem: _removeChecklistItem,
              onUpdateItem: _updateChecklistItem,
            ),
            const SizedBox(height: 32),
            // Save button
            SizedBox(
              width: double.infinity,
              height: 54,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: _isSaving
                    ? Container(
                        key: const ValueKey('loading'),
                        decoration: BoxDecoration(
                          color: AppTheme.primary,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: const Center(
                          child: SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    : FilledButton.icon(
                        key: const ValueKey('save'),
                        onPressed: _saveNote,
                        icon: const Icon(Icons.check_rounded, size: 20),
                        label: const Text('Save Note'),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppTheme.primary,
                          foregroundColor: Colors.white,
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SheetOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SheetOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppTheme.surfaceVariantLight,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppTheme.primary, size: 22),
            const SizedBox(width: 14),
            Text(
              label,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
