import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import '../../core/app_export.dart';
import '../../database/database_helper.dart';
import '../../models/note.dart';
import '../add_note_screen/widgets/image_attachment_widget.dart'; 

class EditNoteScreen extends StatefulWidget {
  const EditNoteScreen({super.key});

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _contentCtrl = TextEditingController();
  bool _isImportant = false;
  bool _isSaving = false;
  bool _isInitialized = false;
  String? _imagePath; 
  Note? _originalNote;
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _isInitialized = true;
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Note) {
        _originalNote = args;
        _titleCtrl.text = args.title;
        _contentCtrl.text = args.content;
        _isImportant = args.isImportant;
        _imagePath = args.imagePath; 
        _checklistItems.addAll(
          args.checklistItems.map((item) => item.copyWith()),
        );
      }
    }
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
        // --- CRITICAL FIX: Save to persistent storage ---
        final appDir = await getApplicationDocumentsDirectory();
        final fileName = p.basename(picked.path);
        final savedImage = await File(picked.path).copy('${appDir.path}/$fileName');
        
        setState(() => _imagePath = savedImage.path);
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

  void _toggleChecklistItem(int index) {
    setState(() {
      _checklistItems[index] = _checklistItems[index].copyWith(
        isDone: !_checklistItems[index].isDone,
      );
    });
  }

  Future<void> _saveNote() async {
    if (!_formKey.currentState!.validate()) return;
    if (_originalNote == null) return;
    setState(() => _isSaving = true);

    final updatedNote = Note(
      id: _originalNote!.id,
      title: _titleCtrl.text.trim(),
      content: _contentCtrl.text.trim(),
      imagePath: _imagePath,
      isImportant: _isImportant,
      createdAt: _originalNote!.createdAt,
      checklistItems: _checklistItems
          .where((c) => c.taskText.isNotEmpty)
          .toList(),
    );

    try {
      await DatabaseHelper.instance.updateNote(updatedNote);
      if (mounted) {
        Fluttertoast.showToast(
          msg: 'Note updated!',
          backgroundColor: AppTheme.success,
          textColor: Colors.white,
        );
        Navigator.pop(context, updatedNote);
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Couldn't update note. Please try again.",
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
          'Edit Note',
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
            TextFormField(
              controller: _titleCtrl,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              decoration: InputDecoration(
                hintText: 'Note title',
                hintStyle: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant.withAlpha(128),
                  fontWeight: FontWeight.w700,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Title is required' : null,
              textCapitalization: TextCapitalization.sentences,
            ),
            Divider(color: Colors.grey[200], height: 1),
            const SizedBox(height: 12),
            TextFormField(
              controller: _contentCtrl,
              style: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
              decoration: InputDecoration(
                hintText: 'Write your note here...',
                hintStyle: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant.withAlpha(128),
                  height: 1.6,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
              ),
              maxLines: null,
              minLines: 4,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 24),
            
            ImageAttachmentWidget(
              imagePath: _imagePath,
              onAddImage: _showImageSourceSheet,
              onRemoveImage: () => setState(() => _imagePath = null),
            ),
            const SizedBox(height: 24),

            Row(
              children: [
                Text(
                  'Checklist',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: _addChecklistItem,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withAlpha(20),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.add_rounded,
                          size: 16,
                          color: AppTheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Add item',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: AppTheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_checklistItems.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'No checklist items yet. Tap "Add item" to add one.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              )
            else
              ...List.generate(_checklistItems.length, (index) {
                final item = _checklistItems[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => _toggleChecklistItem(index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: item.isDone
                                ? AppTheme.primary
                                : Colors.transparent,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: item.isDone
                                  ? AppTheme.primary
                                  : Colors.grey[400]!,
                              width: 2,
                            ),
                          ),
                          child: item.isDone
                              ? const Icon(
                                  Icons.check_rounded,
                                  size: 14,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          initialValue: item.taskText,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            decoration: item.isDone
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            color: item.isDone
                                ? theme.colorScheme.onSurfaceVariant
                                : theme.colorScheme.onSurface,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Checklist item',
                            hintStyle: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant
                                  .withAlpha(128),
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                          onChanged: (val) => _updateChecklistItem(index, val),
                          textCapitalization: TextCapitalization.sentences,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _removeChecklistItem(index),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Icon(
                            Icons.close_rounded,
                            size: 18,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            const SizedBox(height: 32),
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
                        label: const Text('Update Note'),
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