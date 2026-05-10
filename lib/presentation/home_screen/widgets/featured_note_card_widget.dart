
import '../../../core/app_export.dart';
import '../../../models/note.dart';

// ANATOMY LOCKED: full-width colored card, title+subtitle left, avatar stack right,
// illustration/emoji center, arrow button bottom-right
class FeaturedNoteCardWidget extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;

  const FeaturedNoteCardWidget({
    super.key,
    required this.note,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 190,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF7C5CBF), Color(0xFF9B7DE0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primary.withAlpha(89),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background decorative circles
            Positioned(
              top: -20,
              right: 60,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withAlpha(18),
                ),
              ),
            ),
            Positioned(
              bottom: -30,
              right: 20,
              child: Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withAlpha(13),
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              note.title.isEmpty ? 'Untitled Note' : note.title,
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                height: 1.2,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              note.isImportant
                                  ? 'Important note'
                                  : 'Personal note',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.white.withAlpha(191),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Avatar stack
                      SizedBox(
                        width: 70,
                        height: 32,
                        child: Stack(
                          children: [
                            _miniAvatar(
                              'https://images.pexels.com/photos/2379004/pexels-photo-2379004.jpeg?w=100',
                              0,
                              'Team member avatar',
                            ),
                            _miniAvatar(
                              'https://images.pexels.com/photos/733872/pexels-photo-733872.jpeg?w=100',
                              20,
                              'Team member avatar',
                            ),
                            _miniAvatar(
                              'https://images.pexels.com/photos/1222271/pexels-photo-1222271.jpeg?w=100',
                              40,
                              'Team member avatar',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      // Emoji illustration area
                      const Text('📝✨', style: TextStyle(fontSize: 28)),
                      const Spacer(),
                      // Arrow button
                      GestureDetector(
                        onTap: onTap,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(38),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Color(0xFF7C5CBF),
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _miniAvatar(String url, double left, String label) {
    return Positioned(
      left: left,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFF7C5CBF), width: 2),
        ),
        child: ClipOval(
          child: CustomImageWidget(
            imageUrl: url,
            width: 32,
            height: 32,
            fit: BoxFit.cover,
            semanticLabel: label,
          ),
        ),
      ),
    );
  }
}
