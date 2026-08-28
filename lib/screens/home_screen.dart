import 'package:flutter/material.dart';

import '../constants.dart';
import 'newsfeed_screen.dart';
import 'notification_screen.dart';
import 'profile_screen.dart';

/// Main shell of the app once the user is authenticated.
/// Hosts the bottom navigation bar with Newsfeed, Notifications and
/// Profile tabs, styled to resemble the Facebook app. Colors are
/// pulled from the app's existing [ThemeProvider] / [AppColors] via
/// [_Palette.of], so this automatically follows light/dark mode.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _tabs = const [
    NewsfeedScreen(),
    NotificationScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final p = _Palette.of(context);

    return Scaffold(
      backgroundColor: p.background,
      // IndexedStack preserves the state of the tabs (e.g., scroll position)
      body: IndexedStack(index: _currentIndex, children: _tabs),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: p.surface,
          // Replaced harsh border with a soft, modern shadow that adapts to dark/light mode
          boxShadow: [
            BoxShadow(
              color: p.divider.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: NavigationBarTheme(
            data: NavigationBarThemeData(
              backgroundColor: Colors.transparent, // Let the Container handle the color
              indicatorColor: p.primary.withOpacity(0.12),
              // Modern rounded rectangle indicator instead of the default oval
              indicatorShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              height: 64, // Slightly taller for better breathing room and touch targets
              labelTextStyle: MaterialStateProperty.resolveWith((states) {
                final selected = states.contains(MaterialState.selected);
                return TextStyle(
                  fontSize: 12,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  color: selected ? p.primary : p.iconInactive,
                  letterSpacing: 0.2, // Slight tracking for cleaner typography
                );
              }),
              iconTheme: MaterialStateProperty.resolveWith((states) {
                final selected = states.contains(MaterialState.selected);
                return IconThemeData(
                  color: selected ? p.primary : p.iconInactive,
                  size: 26, // Slightly larger icons
                );
              }),
            ),
            // Functional: tapping a destination switches _currentIndex,
            // which drives the IndexedStack above — unchanged behavior.
            child: NavigationBar(
              selectedIndex: _currentIndex,
              onDestinationSelected: (i) => setState(() => _currentIndex = i),
              elevation: 0,
              // Prevents Material 3 from overriding your surface color with primary tints
              surfaceTintColor: Colors.transparent, 
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.notifications_outlined),
                  selectedIcon: Icon(Icons.notifications),
                  label: 'Notifications',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Small color bundle derived from the app's existing theme
/// (set up in ThemeProvider / AppColors) so every screen can pull
/// consistent light/dark colors without a separate theme file.
class _Palette {
  final Color background;
  final Color surface;
  final Color primary;
  final Color textPrimary;
  final Color textSecondary;
  final Color divider;
  final Color iconInactive;

  const _Palette({
    required this.background,
    required this.surface,
    required this.primary,
    required this.textPrimary,
    required this.textSecondary,
    required this.divider,
    required this.iconInactive,
  });

  factory _Palette.of(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    return _Palette(
      background: theme.scaffoldBackgroundColor,
      surface: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      // cs.primary is AppColors.primary in light mode and AppColors.secondary
      // in dark mode, matching the seeds ThemeProvider already uses.
      primary: cs.primary,
      textPrimary: cs.onSurface,
      textSecondary: cs.onSurfaceVariant,
      divider: cs.outlineVariant,
      iconInactive: cs.onSurfaceVariant,
    );
  }
}