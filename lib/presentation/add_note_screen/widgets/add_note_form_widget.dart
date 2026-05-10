
import '../../../core/app_export.dart';

class AddNoteFormWidget extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController contentController;

  const AddNoteFormWidget({
    super.key,
    required this.titleController,
    required this.contentController,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
          Text(
            'Note Details',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              letterSpacing: 0.8,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: titleController,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
            decoration: InputDecoration(
              labelText: 'Title',
              labelStyle: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              border: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: theme.colorScheme.outline,
                  width: 1.5,
                ),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: theme.colorScheme.outline,
                  width: 1.5,
                ),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppTheme.primary, width: 2),
              ),
              errorBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppTheme.error, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Please enter a title';
              return null;
            },
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: contentController,
            style: theme.textTheme.bodyLarge,
            maxLines: 5,
            minLines: 3,
            decoration: InputDecoration(
              labelText: 'Content',
              alignLabelWithHint: true,
              labelStyle: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              border: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: theme.colorScheme.outline,
                  width: 1.5,
                ),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: theme.colorScheme.outline,
                  width: 1.5,
                ),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppTheme.primary, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
            ),
            textInputAction: TextInputAction.newline,
          ),
        ],
      ),
    );
  }
}
