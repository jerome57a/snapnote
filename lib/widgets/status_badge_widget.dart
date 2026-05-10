import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum NoteStatus { normal, important, checklist, image }

class StatusBadgeWidget extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final double? fontSize;

  const StatusBadgeWidget({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    this.fontSize,
  });

  factory StatusBadgeWidget.important() => const StatusBadgeWidget(
    label: 'Important',
    backgroundColor: Color(0xFFFFF3E0),
    textColor: Color(0xFFB45309),
  );

  factory StatusBadgeWidget.checklist(int count) => StatusBadgeWidget(
    label: '$count tasks',
    backgroundColor: AppTheme.primaryContainer,
    textColor: AppTheme.primary,
  );

  factory StatusBadgeWidget.withImage() => const StatusBadgeWidget(
    label: 'Photo',
    backgroundColor: Color(0xFFE3F2FD),
    textColor: Color(0xFF1565C0),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: fontSize ?? 11,
          fontWeight: FontWeight.w600,
          color: textColor,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}
