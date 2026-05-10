import 'package:flutter/material.dart';
import '../../../core/app_export.dart';

// ANATOMY LOCKED: Column [small text + large bold 2-line statement]
class HeroHeadlineWidget extends StatelessWidget {
  final int noteCount;
  final int totalCount;

  const HeroHeadlineWidget({
    super.key,
    required this.noteCount,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          noteCount == 0 ? 'No new notes today' : 'You have $noteCount',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        if (noteCount > 0)
          Text(
            noteCount == 1 ? 'note for today' : 'notes for today',
            style: theme.textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.w800,
              height: 1.15,
              color: theme.colorScheme.onSurface,
            ),
          )
        else
          Text(
            totalCount == 0
                ? 'Start capturing ideas!'
                : '$totalCount total notes',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
              height: 1.15,
              color: theme.colorScheme.onSurface,
            ),
          ),
      ],
    );
  }
}
