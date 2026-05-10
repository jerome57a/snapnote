import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../models/note.dart';

// ANATOMY LOCKED: full-width colored card, task text left (wraps) + time/checkbox right,
// each card different accent color
class ChecklistPlanCardWidget extends StatelessWidget {
  final ChecklistItem item;
  final Color accentColor;
  final VoidCallback onToggle;

  const ChecklistPlanCardWidget({
    super.key,
    required this.item,
    required this.accentColor,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onToggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: item.isDone
              ? accentColor.withAlpha(89)
              : accentColor.withAlpha(217),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: accentColor.withAlpha(51),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                item.taskText.isEmpty ? 'Checklist item' : item.taskText,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                  decoration: item.isDone ? TextDecoration.lineThrough : null,
                  decorationColor: Colors.white.withAlpha(179),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Completion toggle
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: item.isDone
                  ? Container(
                      key: const ValueKey('done'),
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(26),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.check_rounded,
                        size: 16,
                        color: accentColor,
                      ),
                    )
                  : Container(
                      key: const ValueKey('undone'),
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withAlpha(179),
                          width: 2,
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
