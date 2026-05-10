
import '../core/app_export.dart';

// Floating Pill Bottom Navigation — LOCKED from reference image
// Dark pill-shaped bar, 4 icons, active = filled circle highlight

class FloatingPillNavWidget extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const FloatingPillNavWidget({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;
    if (isTablet) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 0, 32, 24),
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          color: AppTheme.navBarDark,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(64),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _NavItem(
              iconName: 'home',
              iconNameOutlined: 'home_outlined',
              index: 0,
              currentIndex: currentIndex,
              onTap: onTap,
            ),
            _NavItem(
              iconName: 'calendar_today',
              iconNameOutlined: 'calendar_outlined',
              index: 1,
              currentIndex: currentIndex,
              onTap: onTap,
            ),
            _NavItem(
              iconName: 'note',
              iconNameOutlined: 'note_outlined',
              index: 2,
              currentIndex: currentIndex,
              onTap: onTap,
            ),
            _NavItem(
              iconName: 'person',
              iconNameOutlined: 'person_outlined',
              index: 3,
              currentIndex: currentIndex,
              onTap: onTap,
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String iconName;
  final String iconNameOutlined;
  final int index;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _NavItem({
    required this.iconName,
    required this.iconNameOutlined,
    required this.index,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = index == currentIndex;
    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: isActive ? Colors.white.withAlpha(38) : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: CustomIconWidget(
            iconName: isActive ? iconName : iconNameOutlined,
            color: isActive ? Colors.white : Colors.white.withAlpha(115),
            size: 22,
          ),
        ),
      ),
    );
  }
}

// Tablet Navigation Rail
class AppNavigationRail extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppNavigationRail({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return NavigationRail(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      backgroundColor: theme.colorScheme.surface,
      indicatorColor: AppTheme.primaryContainer,
      labelType: NavigationRailLabelType.selected,
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home_rounded),
          label: Text('Home'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.calendar_today_outlined),
          selectedIcon: Icon(Icons.calendar_today_rounded),
          label: Text('Calendar'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.note_outlined),
          selectedIcon: Icon(Icons.note_rounded),
          label: Text('Notes'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.person_outline_rounded),
          selectedIcon: Icon(Icons.person_rounded),
          label: Text('Profile'),
        ),
      ],
    );
  }
}
