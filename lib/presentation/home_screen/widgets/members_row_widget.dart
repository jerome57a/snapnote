
import '../../../core/app_export.dart';

// ANATOMY LOCKED: Row[label + Spacer + "+" circle] then overlapping avatar row
class MembersRowWidget extends StatelessWidget {
  final VoidCallback onAddMember;

  const MembersRowWidget({super.key, required this.onAddMember});

  static final List<Map<String, String>> _members = [
    {
      'url':
          'https://img.rocket.new/generatedImages/rocket_gen_img_1a7469234-1763294888180.png',
      'label': 'Black man with short hair in casual attire smiling confidently',
    },
    {
      'url':
          'https://images.unsplash.com/photo-1579017331263-ef82f0bbc748',
      'label': 'Young woman with curly hair wearing a beanie, warm smile',
    },
    {
      'url':
          'https://img.rocket.new/generatedImages/rocket_gen_img_125809ed7-1763299658253.png',
      'label': 'Asian man in white shirt with professional expression',
    },
    {
      'url':
          'https://images.unsplash.com/photo-1605968052444-ba68b5816b2f',
      'label': 'Woman with blonde hair and glasses looking forward pleasantly',
    },
    {
      'url':
          'https://images.unsplash.com/photo-1656018158172-cea9e04be933',
      'label': 'Man with beard and brown hair in outdoor setting',
    },
    {
      'url':
          'https://img.rocket.new/generatedImages/rocket_gen_img_19106e4a5-1766497106346.png',
      'label': 'Woman with dark hair and bright smile in casual setting',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '${_members.length + 2} Members',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: onAddMember,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primary.withAlpha(77),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.add_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 40,
          child: Stack(
            children: List.generate(_members.length, (index) {
              return Positioned(
                left: index * 28.0,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.backgroundLight,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(20),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: CustomImageWidget(
                      imageUrl: _members[index]['url']!,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                      semanticLabel: _members[index]['label']!,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
