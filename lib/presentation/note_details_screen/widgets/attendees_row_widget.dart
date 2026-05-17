import '../../../core/app_export.dart';

// ANATOMY LOCKED: overlapping CircleAvatars + dark "+N" circle badge
class AttendeesRowWidget extends StatelessWidget {
  const AttendeesRowWidget({super.key});

  static final List<Map<String, String>> _attendees = [
    {
      'url':
          'https://img.rocket.new/generatedImages/rocket_gen_img_125809ed7-1763299658253.png',
      'label': 'Asian man in white shirt with professional expression',
    },
    {
      'url':
          'https://img.rocket.new/generatedImages/rocket_gen_img_1a7469234-1763294888180.png',
      'label': 'Black man with short hair in casual attire smiling confidently',
    },
    {
      'url':
          'https://img.rocket.new/generatedImages/rocket_gen_img_19106e4a5-1766497106346.png',
      'label': 'Woman with dark hair and bright smile in casual setting',
    },
  ];

  static const int _extraCount = 8;

  @override
  Widget build(BuildContext context) {
    // --- CRITICAL FIX: Changed + 40.0 to + 44.0 to prevent badge clipping ---
    final totalWidth = (_attendees.length * 28.0) + 44.0;
    
    return SizedBox(
      height: 44,
      width: totalWidth,
      child: Stack(
        children: [
          ..._attendees.asMap().entries.map((entry) {
            final index = entry.key;
            final member = entry.value;
            return Positioned(
              left: index * 28.0,
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(26),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: CustomImageWidget(
                    imageUrl: member['url']!,
                    width: 44,
                    height: 44,
                    fit: BoxFit.cover,
                    semanticLabel: member['label']!,
                  ),
                ),
              ),
            );
          }),
          Positioned(
            left: _attendees.length * 28.0,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppTheme.navBarDark,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2.5),
              ),
              child: Center(
                child: Text(
                  '+$_extraCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}