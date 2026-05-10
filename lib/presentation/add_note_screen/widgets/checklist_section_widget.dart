
import '../../../core/app_export.dart';
import '../../../models/note.dart';

class ChecklistSectionWidget extends StatefulWidget {
  final List<ChecklistItem> items;
  final VoidCallback onAddItem;
  final Function(int index) onRemoveItem;
  final Function(int index, String text) onUpdateItem;

  const ChecklistSectionWidget({
    super.key,
    required this.items,
    required this.onAddItem,
    required this.onRemoveItem,
    required this.onUpdateItem,
  });

  @override
  State<ChecklistSectionWidget> createState() => _ChecklistSectionWidgetState();
}

class _ChecklistSectionWidgetState extends State<ChecklistSectionWidget> {
  final List<TextEditingController> _controllers = [];

  @override
  void didUpdateWidget(covariant ChecklistSectionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    while (_controllers.length < widget.items.length) {
      _controllers.add(TextEditingController());
    }
    while (_controllers.length > widget.items.length) {
      _controllers.removeLast().dispose();
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    while (_controllers.length < widget.items.length) {
      _controllers.add(TextEditingController());
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'CHECKLIST',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: widget.onAddItem,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryContainer,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.add_rounded,
                        size: 16,
                        color: AppTheme.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Add item',
                        style: theme.textTheme.labelSmall?.copyWith(
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
          if (widget.items.isEmpty) ...[
            const SizedBox(height: 16),
            Center(
              child: Text(
                'No checklist items yet. Tap "Add item" to begin.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ] else ...[
            const SizedBox(height: 12),
            ...List.generate(widget.items.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppTheme.primary.withAlpha(102),
                          width: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _controllers[index],
                        onChanged: (v) => widget.onUpdateItem(index, v),
                        style: theme.textTheme.bodyMedium,
                        decoration: InputDecoration(
                          hintText: 'Task item ${index + 1}…',
                          hintStyle: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant.withAlpha(
                              153,
                            ),
                          ),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: theme.colorScheme.outline,
                              width: 1,
                            ),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: theme.colorScheme.outline,
                              width: 1,
                            ),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: AppTheme.primary,
                              width: 1.5,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 6,
                          ),
                        ),
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => widget.onRemoveItem(index),
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: AppTheme.error.withAlpha(20),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close_rounded,
                          size: 14,
                          color: AppTheme.error,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ],
      ),
    );
  }
}
